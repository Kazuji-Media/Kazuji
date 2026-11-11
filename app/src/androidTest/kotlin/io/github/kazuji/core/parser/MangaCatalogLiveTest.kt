package io.github.kazuji.core.parser

import android.graphics.Bitmap
import android.view.View
import android.view.ViewGroup
import androidx.test.core.app.ActivityScenario
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.platform.app.InstrumentationRegistry
import com.davemorrissey.labs.subscaleview.SubsamplingScaleImageView
import dagger.hilt.android.testing.HiltAndroidRule
import dagger.hilt.android.testing.HiltAndroidTest
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withTimeout
import okhttp3.Response
import org.json.JSONTokener
import org.jsoup.Jsoup
import org.junit.Assert.assertTrue
import org.junit.Assume.assumeTrue
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.koitharu.kotatsu.parsers.MangaLoaderContext
import org.koitharu.kotatsu.parsers.MangaParser
import org.koitharu.kotatsu.parsers.bitmap.Bitmap as ParserBitmap
import org.koitharu.kotatsu.parsers.config.MangaSourceConfig
import org.koitharu.kotatsu.parsers.model.MangaListFilter
import org.koitharu.kotatsu.parsers.model.MangaParserSource
import org.koitharu.kotatsu.parsers.model.MangaSource
import org.koitharu.kotatsu.parsers.model.SortOrder
import io.github.kazuji.core.cache.MemoryContentCache
import io.github.kazuji.core.cache.SafeDeferred
import io.github.kazuji.core.nav.ReaderIntent
import io.github.kazuji.reader.initializeReaderTestWorkManager
import io.github.kazuji.reader.ui.ReaderActivity
import io.github.kazuji.reader.ui.ReaderState
import java.io.File
import javax.inject.Inject

/** Opt-in network validation. Never treats an access gate or an empty chapter list as successful reading. */
@HiltAndroidTest
@RunWith(AndroidJUnit4::class)
class MangaCatalogLiveTest {

    @get:Rule
    val hiltRule = HiltAndroidRule(this)

    @Inject
    lateinit var loaderContext: MangaLoaderContext

    @Inject
    lateinit var cache: MemoryContentCache

    private val instrumentation = InstrumentationRegistry.getInstrumentation()

    @Before
    fun setUp() {
        assumeTrue(
            "Enable explicitly with -Pandroid.testInstrumentationRunnerArguments.liveCatalogValidation=true",
            InstrumentationRegistry.getArguments().getString("liveCatalogValidation") == "true",
        )
        initializeReaderTestWorkManager(instrumentation.targetContext)
        hiltRule.inject()
    }

    @Test
    fun leitorDandadanChapterDisplaysRealImage() = validate(MangaParserSource.LEITORDEMANGA)

    @Test
    fun brasukasDandadanChapterDisplaysRealImage() = validate(MangaParserSource.MANGASBRASUKAS)

    private fun validate(source: MangaParserSource) = runBlocking(Dispatchers.IO) {
        val parser = TracingContext().newParserInstance(source)
        val results = parser.getList(0, SortOrder.POPULARITY, MangaListFilter(query = "Dandadan"))
        val manga = requireNotNull(results.find { it.title.equals("Dandadan", ignoreCase = true) }) {
            "$source search did not find Dandadan (${results.size} results)"
        }
        println("LIVE_CATALOG $source search=${results.size} url=${manga.publicUrl}")
        val details = parser.getDetails(manga)
        val chapters = details.chapters.orEmpty()
        assertTrue("$source returned no chapters", chapters.isNotEmpty())
        val chapter = requireNotNull(chapters.find { it.number == 1f }) { "$source is missing chapter 1" }
        println("LIVE_CATALOG $source chapters=${chapters.size} chapter=${chapter.url}")
        val pages = parser.getPages(chapter)
        assertTrue("$source returned no pages", pages.isNotEmpty())
        assertTrue("$source returned duplicate pages", pages.map { it.url }.distinct().size == pages.size)
        println("LIVE_CATALOG $source pages=${pages.size} first=${parser.getPageUrl(pages.first())}")

        // These are real responses from the source; only reuse them to avoid repeating WebView extraction.
        cache.putDetails(source, details.url, SafeDeferred(CompletableDeferred(Result.success(details))))
        cache.putPages(source, chapter.url, SafeDeferred(CompletableDeferred(Result.success(pages))))
        val intent = ReaderIntent.Builder(instrumentation.targetContext)
            .manga(details)
            .state(ReaderState(chapter.id, 0, 0))
            .incognito()
            .build().intent
        ActivityScenario.launch<ReaderActivity>(intent).use { scenario ->
            try {
                withTimeout(60_000L) {
                    var loaded = false
                    while (!loaded) {
                        scenario.onActivity { activity ->
                            loaded = hasLoadedImage(activity.window.decorView)
                        }
                        if (!loaded) delay(250L)
                    }
                }
                println("LIVE_CATALOG $source readerImageLoaded=true")
            } finally {
                val image = instrumentation.uiAutomation.takeScreenshot()
                if (image != null) {
                    val output = File(
                        instrumentation.targetContext.getExternalFilesDir(null),
                        "live-catalog-${source.name.lowercase()}.png",
                    )
                    output.outputStream().use { image.compress(Bitmap.CompressFormat.PNG, 100, it) }
                    image.recycle()
                }
            }
        }
    }

    private fun hasLoadedImage(view: View): Boolean {
        if (view is SubsamplingScaleImageView && view.isShown && view.isReady) return true
        if (view is ViewGroup) {
            for (index in 0 until view.childCount) {
                if (hasLoadedImage(view.getChildAt(index))) return true
            }
        }
        return false
    }

    private inner class TracingContext : MangaLoaderContext() {
        override val httpClient get() = loaderContext.httpClient
        override val cookieJar get() = loaderContext.cookieJar

        @Deprecated("Provide a base url")
        override suspend fun evaluateJs(script: String): String? = loaderContext.evaluateJs(script)

        override suspend fun evaluateJs(baseUrl: String, script: String, timeout: Long): String? {
            val result = loaderContext.evaluateJs(baseUrl, script, timeout) ?: return null
            val html = JSONTokener(result).nextValue() as? String ?: result
            val document = Jsoup.parse(html, baseUrl)
            println("LIVE_CATALOG rendered=$baseUrl title=${document.title()} " +
                "images=${document.select("img[data-kotatsu-page-url]").size} " +
                "text=${document.body()?.text().orEmpty().take(900)}")
            return result
        }

        override fun getConfig(source: MangaSource): MangaSourceConfig = loaderContext.getConfig(source)
        override fun getDefaultUserAgent(): String = loaderContext.getDefaultUserAgent()
        override fun createBitmap(width: Int, height: Int): ParserBitmap = loaderContext.createBitmap(width, height)
        override fun redrawImageResponse(response: Response, redraw: (ParserBitmap) -> ParserBitmap): Response =
            loaderContext.redrawImageResponse(response, redraw)

        override fun requestBrowserAction(parser: MangaParser, url: String): Nothing =
            loaderContext.requestBrowserAction(parser, url)
    }
}
