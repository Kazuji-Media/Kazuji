package io.github.kazuji.core.parser

import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class MangaLinkResolverTest {

	@Test
	fun acceptsCustomSchemeMangaHost() {
		assertTrue(isMangaAppLinkEndpoint("kazuji", "manga", emptyList()))
	}

	@Test
	fun rejectsOtherCustomSchemeHost() {
		assertFalse(isMangaAppLinkEndpoint("kazuji", "other", listOf("manga")))
	}

	@Test
	fun acceptsHttpsMangaPath() {
		assertTrue(isMangaAppLinkEndpoint("https", "kazuji-reader.github.io", listOf("manga")))
	}

	@Test
	fun rejectsOtherEndpoint() {
		assertFalse(isMangaAppLinkEndpoint("https", "kazuji-reader.github.io", listOf("other")))
	}
}
