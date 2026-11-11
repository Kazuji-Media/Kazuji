package io.github.kazuji.core.parser

import android.util.Base64
import androidx.test.ext.junit.runners.AndroidJUnit4
import dagger.hilt.android.testing.HiltAndroidRule
import dagger.hilt.android.testing.HiltAndroidTest
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.runBlocking
import okhttp3.Response
import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.koitharu.kotatsu.parsers.MangaLoaderContext
import org.koitharu.kotatsu.parsers.bitmap.Bitmap
import org.koitharu.kotatsu.parsers.config.MangaSourceConfig
import org.koitharu.kotatsu.parsers.model.MangaListFilter
import org.koitharu.kotatsu.parsers.model.MangaParserSource
import org.koitharu.kotatsu.parsers.model.MangaSource
import org.koitharu.kotatsu.parsers.model.SortOrder
import io.github.kazuji.core.network.webview.WebViewExecutor
import javax.inject.Inject

/** Runs the production catalog scripts in Android WebView, including delayed client rendering. */
@HiltAndroidTest
@RunWith(AndroidJUnit4::class)
class MangaCatalogRenderingTest {

    @get:Rule
    val hiltRule = HiltAndroidRule(this)

    @Inject
    lateinit var loaderContext: MangaLoaderContext

    @Inject
    lateinit var webViewExecutor: WebViewExecutor

    @Before
    fun setUp() {
        hiltRule.inject()
    }

    @Test
    fun searchWaitsForHydrationBeforeReturningFirstPage() = runBlocking(Dispatchers.Default) {
        for (source in listOf(MangaParserSource.LEITORDEMANGA, MangaParserSource.MANGASBRASUKAS)) {
            val context = RenderingContext(DELAYED_SEARCH)
            val parser = context.newParserInstance(source)

            val results = parser.getList(0, SortOrder.POPULARITY, MangaListFilter(query = "Dandadan"))

            assertEquals(source.name, listOf("Dandadan"), results.map { it.title })
            assertEquals(listOf("/manga/dandadan"), results.map { it.url })
        }
    }

    @Test
    fun searchReturnsEmptyAfterExplicitNoResults() = runBlocking(Dispatchers.Default) {
        val context = RenderingContext("<html><body><main>Nenhum resultado</main></body></html>")
        val parser = context.newParserInstance(MangaParserSource.LEITORDEMANGA)

        assertEquals(emptyList<Any>(), parser.getList(0, SortOrder.POPULARITY, MangaListFilter(query = "missing")))
    }

    @Test
    fun detailsWaitsForHydrationBeforeAcceptingZeroChapters() = runBlocking(Dispatchers.Default) {
        val context = RenderingContext(DELAYED_DETAILS)
        val parser = context.newParserInstance(MangaParserSource.LEITORDEMANGA)
        val manga = parser.getList(0, SortOrder.POPULARITY, MangaListFilter(query = "Dandadan")).single()

        val details = parser.getDetails(manga)

        assertEquals(listOf(1f, 2f), details.chapters.orEmpty().map { it.number })
    }

    private inner class RenderingContext(html: String) : MangaLoaderContext() {
        private val pageUrl = "data:text/html;base64," +
            Base64.encodeToString(html.toByteArray(Charsets.UTF_8), Base64.NO_WRAP)

        override val httpClient get() = loaderContext.httpClient
        override val cookieJar get() = loaderContext.cookieJar

        @Deprecated("Provide a base url")
        override suspend fun evaluateJs(script: String): String? = evaluateJs("", script, 10_000L)

        override suspend fun evaluateJs(baseUrl: String, script: String, timeout: Long): String? =
            // Keep the production page URL available to scripts while serving the fixture without network access.
            webViewExecutor.evaluateJs(pageUrl, "((location) => $script)(new URL(${JSONObject.quote(baseUrl)}))", timeout)

        override fun getConfig(source: MangaSource): MangaSourceConfig = loaderContext.getConfig(source)
        override fun getDefaultUserAgent(): String = loaderContext.getDefaultUserAgent()
        override fun createBitmap(width: Int, height: Int): Bitmap = loaderContext.createBitmap(width, height)
        override fun redrawImageResponse(response: Response, redraw: (Bitmap) -> Bitmap): Response =
            loaderContext.redrawImageResponse(response, redraw)
    }

    private companion object {
        val DELAYED_DETAILS = """
            <html><head><base href="https://leitordemangas.com/manga/dandadan"></head><body>
                <main><h1>Dandadan</h1><a href="/manga/dandadan"><h3>Dandadan</h3></a>
                    <section id="chapters"><h2>Capítulos (0)</h2><ul></ul></section>
                </main>
                <script>
                    setTimeout(() => {
                        document.getElementById('chapters').innerHTML = '<h2>Capítulos (2)</h2><ul>' +
                            '<li><a href="/manga/dandadan/2">Capítulo 2</a></li>' +
                            '<li><a href="/manga/dandadan/1">Capítulo 1</a></li></ul>';
                    }, 1600);
                </script>
            </body></html>
        """.trimIndent()

        val DELAYED_SEARCH = """
            <html><head><base href="https://leitordemangas.com/"></head><body>
                <main id="catalog">Carregando...</main>
                <script>
                    setTimeout(() => {
                        document.getElementById('catalog').innerHTML =
                            '<a href="/manga/dandadan"><h3>Dandadan</h3></a>';
                    }, 1600);
                </script>
            </body></html>
        """.trimIndent()
    }
}
