package io.github.kazuji.core.parser

import android.net.Uri
import coil3.request.CachePolicy
import dagger.Reusable
import io.github.kazuji.BuildConfig
import io.github.kazuji.core.model.MangaSource
import io.github.kazuji.core.model.UnknownMangaSource
import io.github.kazuji.core.model.isNsfw
import io.github.kazuji.core.util.ext.isHttpUrl
import org.koitharu.kotatsu.parsers.MangaLoaderContext
import org.koitharu.kotatsu.parsers.exception.NotFoundException
import org.koitharu.kotatsu.parsers.model.Manga
import org.koitharu.kotatsu.parsers.model.MangaListFilter
import org.koitharu.kotatsu.parsers.model.MangaSource
import org.koitharu.kotatsu.parsers.util.almostEquals

import org.koitharu.kotatsu.parsers.util.ifNullOrEmpty
import org.koitharu.kotatsu.parsers.util.levenshteinDistance
import org.koitharu.kotatsu.parsers.util.runCatchingCancellable
import javax.inject.Inject

private val APP_DEEP_LINK_SCHEMES = setOf("kazuji", "futon", "kotatsu")
private val LEGACY_APP_DEEP_LINK_HOSTS = setOf("kazuji-reader.github.io", "futon.app", "futonapp.pages.dev")
private val APP_DEEP_LINK_HOSTS = LEGACY_APP_DEEP_LINK_HOSTS + BuildConfig.MANGA_SHARE_HOST
private val APP_DEEP_LINK_PATHS = BuildConfig.MANGA_SHARE_PAGE_PATH
	.trim('/')
	.split('/')
	.filter(String::isNotEmpty)

internal fun isMangaAppLinkEndpoint(scheme: String?, host: String?, pathSegments: List<String>): Boolean =
	if (APP_DEEP_LINK_SCHEMES.any { scheme.equals(it, ignoreCase = true) }) {
		host.equals("manga", ignoreCase = true)
	} else {
		(
			host.equals(BuildConfig.MANGA_SHARE_HOST, ignoreCase = true) && pathSegments == APP_DEEP_LINK_PATHS
		) || (
			LEGACY_APP_DEEP_LINK_HOSTS.any { host.equals(it, ignoreCase = true) } && pathSegments == listOf("manga")
		)
	}

@Reusable
class MangaLinkResolver @Inject constructor(
	private val repositoryFactory: MangaRepository.Factory,
	private val dataRepository: MangaDataRepository,
	private val context: MangaLoaderContext,
) {

	suspend fun resolve(uri: Uri): Manga {
		return if (
			APP_DEEP_LINK_SCHEMES.any { uri.scheme.equals(it, ignoreCase = true) } ||
			APP_DEEP_LINK_HOSTS.any { uri.host.equals(it, ignoreCase = true) }
		) {
			resolveAppLink(uri)
		} else {
			resolveExternalLink(uri.toString())
		} ?: throw NotFoundException("Cannot resolve link", uri.toString())
	}

	private suspend fun resolveAppLink(uri: Uri): Manga? {
		require(isMangaAppLinkEndpoint(uri.scheme, uri.host, uri.pathSegments)) { "Invalid url" }
		uri.getQueryParameter("id")?.let { mangaId ->
			// short url
			return dataRepository.findMangaById(mangaId.toLong(), withChapters = false)
		}
		val sourceName = requireNotNull(uri.getQueryParameter("source")) { "Source is not specified" }
		val source = MangaSource(sourceName)
		require(source != UnknownMangaSource) { "Manga source $sourceName is not supported" }
		val repo = repositoryFactory.create(source)
		return repo.findExact(
			url = uri.getQueryParameter("url"),
			title = uri.getQueryParameter("name"),
		)
	}

	private suspend fun resolveExternalLink(uri: String): Manga? {
		dataRepository.findMangaByPublicUrl(uri)?.let {
			return it
		}
		return context.newLinkResolver(uri).getManga()
	}

	private suspend fun MangaRepository.findExact(url: String?, title: String?): Manga? {
		if (!title.isNullOrEmpty()) {
			val list = getList(0, null, MangaListFilter(query = title))
			if (url != null) {
				list.find { it.url == url }?.let {
					return it
				}
			}
			list.minByOrNull { it.title.levenshteinDistance(title) }
				?.takeIf { it.title.almostEquals(title, 0.2f) }
				?.let { return it }
		}
		val seed = getDetailsNoCache(
			getSeedManga(source, url ?: return null, title),
		)
		return runCatchingCancellable {
			val seedTitle = seed.title.ifEmpty {
				seed.altTitle
			}.ifNullOrEmpty {
				seed.author
			} ?: return@runCatchingCancellable null
			val seedList = getList(0, null, MangaListFilter(query = seedTitle))
			seedList.first { x -> x.url == url }
		}.getOrThrow()
	}

	private suspend fun MangaRepository.getDetailsNoCache(manga: Manga): Manga = if (this is CachingMangaRepository) {
		getDetails(manga, CachePolicy.READ_ONLY)
	} else {
		getDetails(manga)
	}

	private fun getSeedManga(source: MangaSource, url: String, title: String?) = Manga(
		id = run {
			var h = 1125899906842597L
			source.name.forEach { c ->
				h = 31 * h + c.code
			}
			url.forEach { c ->
				h = 31 * h + c.code
			}
			h
		},
		title = title.orEmpty(),
		altTitle = null,
		url = url,
		publicUrl = "",
		rating = 0.0f,
		isNsfw = source.isNsfw(),
		coverUrl = "",
		tags = emptySet(),
		state = null,
		author = null,
		largeCoverUrl = null,
		description = null,
		chapters = null,
		source = source,
	)

	companion object {

		fun isValidLink(str: String): Boolean {
			return str.isHttpUrl() || APP_DEEP_LINK_SCHEMES.any {
				str.startsWith("$it://", ignoreCase = true)
			}
		}
	}
}
