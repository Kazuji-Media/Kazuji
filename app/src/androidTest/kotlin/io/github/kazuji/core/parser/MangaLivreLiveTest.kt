package io.github.kazuji.core.parser

import androidx.test.ext.junit.runners.AndroidJUnit4
import dagger.hilt.android.testing.HiltAndroidRule
import dagger.hilt.android.testing.HiltAndroidTest
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.runBlocking
import okhttp3.Request
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Rule
import org.junit.Test
import org.junit.runner.RunWith
import org.koitharu.kotatsu.parsers.MangaLoaderContext
import org.koitharu.kotatsu.parsers.MangaParser
import org.koitharu.kotatsu.parsers.model.MangaListFilter
import org.koitharu.kotatsu.parsers.model.MangaParserSource
import org.koitharu.kotatsu.parsers.model.MangaSource
import org.koitharu.kotatsu.parsers.model.SortOrder
import javax.inject.Inject

/** Live smoke test for Manga Livre using Kazuji's Android network and WebView context. */
@HiltAndroidTest
@RunWith(AndroidJUnit4::class)
class MangaLivreLiveTest {

	@get:Rule
	val hiltRule = HiltAndroidRule(this)

	@Inject
	lateinit var loaderContext: MangaLoaderContext

	@Before
	fun setUp() {
		hiltRule.inject()
	}

	@Test
	fun onePieceSearchDetailsAndChapterPagesAreAvailable() = runBlocking(Dispatchers.IO) {
		val source = MangaParserSource.MANGALIVRE
		val parser = loaderContext.newParserInstance(source)
		val results = parser.getList(0, SortOrder.POPULARITY, MangaListFilter(query = TITLE_QUERY))
		val manga = requireNotNull(results.firstOrNull { it.title.equals(TITLE_QUERY, ignoreCase = true) }
			?: results.firstOrNull { it.title.contains(TITLE_QUERY, ignoreCase = true) }) {
			"Manga Livre search for '$TITLE_QUERY' returned ${results.size} results without a matching title"
		}
		println("MANGALIVRE search=${results.size} title=${manga.title} url=${manga.publicUrl}")

		val details = parser.getDetails(manga)
		val chapters = details.chapters.orEmpty()
		assertTrue("Manga Livre returned no chapters for ${details.publicUrl}", chapters.isNotEmpty())
		println(
			"MANGALIVRE details title=${details.title} state=${details.state} " +
				"authors=${details.authors} tags=${details.tags.map { it.title }} chapters=${chapters.size}",
		)

		val chapter = requireNotNull(chapters.firstOrNull { it.number == CHAPTER_NUMBER }) {
			"Manga Livre did not extract chapter $CHAPTER_NUMBER for ${details.title}"
		}
		val pages = parser.getPages(chapter)
		assertTrue("Manga Livre chapter $CHAPTER_NUMBER returned no pages", pages.isNotEmpty())
		assertTrue("Manga Livre chapter $CHAPTER_NUMBER returned duplicate pages", pages.map { it.id }.distinct().size == pages.size)
		println("MANGALIVRE chapter=${chapter.title} number=${chapter.number} pages=${pages.size}")

		val pageIndexes = listOf(0, pages.lastIndex / 2, pages.lastIndex).distinct()
		pageIndexes.forEach { index ->
			val page = pages[index]
			val imageUrl = parser.getPageUrl(page)
			checkImageResponse(parser, source, imageUrl)
			println("MANGALIVRE image[$index]=$imageUrl")
		}
	}

	private fun checkImageResponse(parser: MangaParser, source: MangaSource, url: String) {
		val request = Request.Builder()
			.url(url)
			.headers(parser.getRequestHeaders())
			.tag(MangaSource::class.java, source)
			.get()
			.build()
		loaderContext.httpClient.newCall(request).execute().use { response ->
			check(response.isSuccessful) { "Image request failed with HTTP ${response.code}: $url" }
			val mediaType = response.body?.contentType()
			check(mediaType?.type == "image") { "Expected image/* response, got $mediaType: $url" }
		}
	}

	private companion object {
		const val TITLE_QUERY = "One Piece"
		const val CHAPTER_NUMBER = 1f
	}
}
