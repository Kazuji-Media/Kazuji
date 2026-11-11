package io.github.kazuji.core.network.webview.adblock

import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class AdBlockDomainExceptionTest {

	@Test
	fun exemptsOnlyTheConfiguredDomainsAndTheirSubdomains() {
		assertTrue(isAdBlockExemptDomain("leitordemangas.com"))
		assertTrue(isAdBlockExemptDomain("www.leitordemangas.com"))
		assertTrue(isAdBlockExemptDomain("mangasbrasuka.org"))
		assertTrue(isAdBlockExemptDomain("cdn.mangasbrasuka.org"))

		assertFalse(isAdBlockExemptDomain("example.com"))
		assertFalse(isAdBlockExemptDomain("leitordemangas.com.example.com"))
		assertFalse(isAdBlockExemptDomain("mangasbrasuka.org.example.com"))
	}

	@Test
	fun domainMatchingIsCaseInsensitive() {
		assertTrue(isAdBlockExemptDomain("WWW.LeitorDeMangas.com"))
		assertTrue(isAdBlockExemptDomain("CDN.MangasBrasuka.org"))
	}
}
