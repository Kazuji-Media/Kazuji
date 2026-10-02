# Capacidades do Kazuji e padrão para parsers PT-BR

Data: 2026-10-02. Escopo: issue Kazuji #2, com 123 fontes brasileiras.

Este mapa foi conferido no código local do Kazuji e de `kotatsu-parsers-redo`. É uma auditoria estática do contrato e de seus consumidores. Não declara os sites funcionando nem substitui a inspeção de cada fonte no navegador, a CI remota e a validação no APK. Nenhum build, teste ou emulador local foi executado nesta auditoria.

## Objetivo e divisão de responsabilidades

Cada fonte deve preencher todas as capacidades que seu site realmente oferece. O padrão comum é de identidade, contrato, qualidade e evidência; os filtros disponíveis variam conforme a fonte. Uma capacidade ausente no site deve ficar ausente na declaração do parser e constar na ficha de validação.

O parser entrega catálogo, metadados, capítulos e imagens. Kazuji implementa interface, leitura, favoritos, histórico, marcadores, download, atualização de capítulos, biblioteca local, sincronização, backup, estatísticas e integração com serviços externos. Esses recursos aproveitam dados do parser, sem exigir implementações próprias por site.

Referências centrais:

- [Contrato MangaParser](../../../kotatsu-parsers-redo/src/main/kotlin/org/koitharu/kotatsu/parsers/MangaParser.kt).
- [Adaptador do app ParserMangaRepository](../../app/src/main/kotlin/io/github/kazuji/core/parser/ParserMangaRepository.kt).
- [Fábrica e interface MangaRepository](../../app/src/main/kotlin/io/github/kazuji/core/parser/MangaRepository.kt).
- [Contexto Android MangaLoaderContextImpl](../../app/src/main/kotlin/io/github/kazuji/core/parser/MangaLoaderContextImpl.kt).

## Matriz de capacidades por fonte

| Capacidade | O parser fornece | O Kazuji consome ou executa | Evidência exigida por fonte |
| --- | --- | --- | --- |
| Registro e nome pesquisável | `@MangaSourceParser(name, title, locale, type)`; identificador estável e exclusivo | Registro gerado, seletor de fontes, agrupamento por idioma/tipo e busca pelo título da fonte | Nome exato a procurar no APK e idioma `pt`; não criar aliases duplicados para o mesmo catálogo |
| Domínio e mirrors | `ConfigKey.Domain`, `domain` e URLs relativas quando aplicável | Preferência de domínio, seleção/tentativa de mirrors | Domínio atual, aliases verificados e troca de domínio sem mudança de IDs |
| Catálogo | `getList(offset, order, filter)` com lista de `Manga` | Listas/grades, pesquisa por fonte e pesquisa global | Lista real, títulos/capas válidos e IDs únicos |
| Paginação | Offset convertido para paginação real pelo parser/base | Scroll e busca incremental | Pelo menos duas páginas diferentes; término retorna vazio; tamanho real de catálogo e busca |
| Busca textual | `isSearchSupported`, `filter.query` e endpoint equivalente | Campo de busca, busca global, resolução de links e procura de alternativas | Obra conhecida encontrada por nome; consulta inexistente termina vazia |
| Busca com filtros | `isSearchWithFiltersSupported` e combinação implementada | Mantém ou limpa filtros ao pesquisar | Busca + gênero/estado devem alterar os resultados como no site |
| Ordenação | `availableSortOrders`, conjunto não vazio | Opções de ordenar e preferência persistida | Cada ordem anunciada chega ao endpoint correto; não confundir atualizações com adições |
| Tags/gêneros | `availableTags`, `Manga.tags`, chaves de tag estáveis | Filtro, ficha de detalhes, pesquisa por tag e sugestões locais | Tags da fonte, nomes legíveis e uma consulta de tag que realmente filtra |
| Inclusão de múltiplas tags | `isMultipleTagsSupported` e serialização correta | Seleção múltipla | Documentar se o site usa união ou interseção; verificar duas tags |
| Exclusão de tags | `isTagsExclusionSupported` e `tagsExclude` | Controle de exclusão na interface | Uma tag excluída realmente desaparece; não herdar suporte só pela aparência do tema |
| Estado | `Manga.state` e `availableStates` quando filtrável | Estado na ficha e filtro por estado | Traduzir estados reais para `ONGOING`, `FINISHED`, `ABANDONED`, `PAUSED`, `UPCOMING`, `RESTRICTED`; desconhecido é `null` |
| Classificação de conteúdo | `Manga.contentRating`, `availableContentRating`, tipo da fonte | Restrição de conteúdo adulto e filtro | Separar `SAFE`, `SUGGESTIVE`, `ADULT`; fonte predominantemente adulta usa `ContentType.HENTAI` |
| Tipo e demografia | `availableContentTypes`, `availableDemographics`, `filter.types/demographics` | Filtros dinâmicos | Só anunciar valores filtráveis no site; `Manga` não possui campos próprios de tipo/demografia por obra |
| Idioma disponível | `availableLocales`, `filter.locale`; `locale` da anotação | Filtro de idiomas e classificação da fonte | Fontes multilíngues retornam idiomas reais; `pt` não significa que existe um filtro de idioma |
| Idioma original | `isOriginalLocaleSupported`, `filter.originalLocale` | Filtro de idioma original | Endpoint aceita idioma original e responde de modo distinto |
| Ano ou intervalo | `isYearSupported/isYearRangeSupported`, `year/yearFrom/yearTo` | Filtros de ano/intervalo | Ano simples não implica suporte a intervalo; `Manga` não tem campo de ano de publicação |
| Autor | `Manga.authors` e opcionalmente `isAuthorSearchSupported`, `filter.author` | Ficha, sugestões de autores e pesquisa global | Extrair todos os autores presentes; filtro por autor só se efetivo |
| Títulos alternativos | `Manga.altTitles` | Persistência e parte da busca/relevância | Extrair títulos reais sem misturar rótulos; observar limitação do app descrita abaixo |
| Nota da obra | `Manga.rating`, normalizado para 0..1, ou `RATING_UNKNOWN` | Exibição e dados persistidos | Conhecer a escala original; nota 4/5 vira 0,8; não inventar nota ausente |
| Capas | `coverUrl`, `largeCoverUrl` absolutos | Coil, ficha, grades, cache, biblioteca local | Imagem pequena e grande carregam com os headers da fonte; sem placeholder de lazy loading |
| Sinopse | `description`, HTML aceito | `DetailsLoadUseCase` converte HTML para exibição | Texto da obra sem anúncios/intersticiais; evitar requisições de imagens decorativas |
| Detalhes | `getDetails(manga)` retorna cópia preservando `id`, `url`, `source` | Cache, ficha, biblioteca e tracking | Atualiza título/metadados e lista completa de capítulos sem trocar identidade |
| Capítulos | `Manga.chapters`, IDs/URLs estáveis, ordem cronológica | Lista, leitura sequencial, histórico, marcadores, download e tracking | Primeiro, intermediário e último capítulos; lista completa, sem truncamento e sem duplicatas |
| Número de capítulo | `MangaChapter.number: Float` | Numeração, busca de capítulo e progresso | Número real, incluindo decimais como 10,5; `0` quando desconhecido |
| Título do capítulo | `MangaChapter.title` | Nome exibido junto à numeração | Somente título adicional quando identificável; não repetir título da obra e número |
| Volume | `MangaChapter.volume` | Separadores e busca por volume | Número real quando presente; `0` quando não há informação |
| Scanlator | `MangaChapter.scanlator` | Metadados da linha de capítulo | Equipe real quando o site informa; `null` para desconhecido |
| Branches/traduções | `MangaChapter.branch` | Escolha de versão, leitura e tracking por branch | Agrupar capítulos que se sobrepõem; não fundir capítulos de versões diferentes nem usar labels instáveis |
| Datas | `MangaChapter.uploadDate` em milissegundos | Datas visíveis, tracking e notificações | Parse conforme localidade/fuso; datas relativas quando existem; `0L` se desconhecido |
| Páginas | `getPages(chapter)` na ordem de leitura; `id/url/preview/source` | Miniaturas, leitor e prefetch | Primeira, intermediária e última imagem; nenhuma publicidade/thumbnail confundida com página |
| URL final da imagem | `getPageUrl(page)` quando precisa resolver HTML/token | Leitura e download usam o mesmo contrato | URL efetivamente de imagem, com token/cookie válido; não devolver HTML de desafio |
| Headers e hotlink | `getRequestHeaders()` e `intercept(chain)` quando necessário | Adiciona headers por fonte, Referer padrão e chama interceptor | Leitura e download funcionam; se exige Referer de capítulo, implementar regra específica |
| Cookies e login | `context.cookieJar`, opcional `MangaParserAuthProvider` | Sessão compartilhada e fluxo de autenticação | Separar catálogo público, login necessário e sessão expirada; não embutir credenciais |
| JavaScript | `context.evaluateJs(baseUrl, script, timeout)` | Executa em WebView Android | Usar só quando HTML/API não bastam; verificar timeouts e resultado completo |
| Captura de requests | `interceptWebViewRequests` / `captureWebViewUrls` | WebView captura URL, método, headers e timestamp | Testar seletor e ordem; limites do body/filtro abaixo |
| Ação interativa | `context.requestBrowserAction(parser, url)` | Lança BrowserActivity por `InteractiveActionRequiredException` e permite retomar | Challenge/intersticial reconhecido; URL correta da etapa; distinguir de lista vazia |
| Imagem embaralhada | Interceptor + `context.redrawImageResponse` / `createBitmap` | Decodificação Android e carregamento da imagem reconstruída | Somente quando a fonte exige; mesmas páginas no leitor e download |
| Favicon | `getFavicons()`; base possui implementação | Ícone da fonte | Favicon encontrado ou fallback do app |
| Relacionados | `getRelatedManga(seed)`; base usa `RelatedMangaFinder` | Lista de relacionados via `RelatedMangaUseCase` | Preferir relacionados reais da fonte; registrar se é descoberta por tags da base |
| Link público | `Manga.publicUrl`, domínios registrados, `resolveLink` se necessário | Abrir site, compartilhar, importar/resolver links | Link de obra resolve mesma identidade do catálogo; capítulo precisa estratégia explícita |

Modelos: [Manga](../../../kotatsu-parsers-redo/src/main/kotlin/org/koitharu/kotatsu/parsers/model/Manga.kt), [MangaChapter](../../../kotatsu-parsers-redo/src/main/kotlin/org/koitharu/kotatsu/parsers/model/MangaChapter.kt), [MangaPage](../../../kotatsu-parsers-redo/src/main/kotlin/org/koitharu/kotatsu/parsers/model/MangaPage.kt), [MangaTag](../../../kotatsu-parsers-redo/src/main/kotlin/org/koitharu/kotatsu/parsers/model/MangaTag.kt).

Filtros: [MangaListFilter](../../../kotatsu-parsers-redo/src/main/kotlin/org/koitharu/kotatsu/parsers/model/MangaListFilter.kt), [capabilities](../../../kotatsu-parsers-redo/src/main/kotlin/org/koitharu/kotatsu/parsers/model/MangaListFilterCapabilities.kt), [options](../../../kotatsu-parsers-redo/src/main/kotlin/org/koitharu/kotatsu/parsers/model/MangaListFilterOptions.kt), [FilterCoordinator](../../app/src/main/kotlin/io/github/kazuji/filter/ui/FilterCoordinator.kt), [FilterSheetFragment](../../app/src/main/kotlin/io/github/kazuji/filter/ui/sheet/FilterSheetFragment.kt).

## Funções que pertencem ao app

| Função do Kazuji | Dependência necessária do parser | Implementação do app |
| --- | --- | --- |
| Modos de leitura, zoom, orientação, recorte, cor e prefetch | Páginas/imagens na ordem correta | `reader/`, especialmente [PageLoader](../../app/src/main/kotlin/io/github/kazuji/reader/domain/PageLoader.kt) e [ChaptersLoader](../../app/src/main/kotlin/io/github/kazuji/reader/domain/ChaptersLoader.kt) |
| Download, fila, recomeço, ZIP/CBZ e leitura offline | Capítulos/páginas completos, IDs estáveis, imagens acessíveis | [DownloadWorker](../../app/src/main/kotlin/io/github/kazuji/download/ui/worker/DownloadWorker.kt), `local/` |
| Favoritos/categorias, histórico, marcadores, retomar leitura | Identidade de obra/capítulo/página preservada entre atualizações | `favourites/`, `history/`, `bookmarks/`, `core/db/` |
| Detectar novos capítulos e notificar | Lista completa em ordem antiga→nova, por branch e com IDs estáveis | [CheckNewChaptersUseCase](../../app/src/main/kotlin/io/github/kazuji/tracker/domain/CheckNewChaptersUseCase.kt), `tracker/work/` |
| Scrobbling e progresso em serviços externos | Título/autores confiáveis e número real do capítulo | `scrobbling/`, [DetailsViewModel](../../app/src/main/kotlin/io/github/kazuji/details/ui/DetailsViewModel.kt); o parser não sincroniza contas da fonte |
| Busca global e sugestões | Busca por título e capacidades declaradas; autores/tags completos | [SearchV2Helper](../../app/src/main/kotlin/io/github/kazuji/search/domain/SearchV2Helper.kt), [MangaSearchRepository](../../app/src/main/kotlin/io/github/kazuji/search/domain/MangaSearchRepository.kt) |
| Alternativas/migração de fonte | Título/aliases/autor, pesquisa funcional e identidade dentro da fonte | `alternatives/`, `explore/domain/RecoverMangaUseCase.kt` |
| Backup/restauração, sync, estatísticas, widgets | IDs e URLs que sobrevivem às mudanças de domínio | `backups/`, `sync/`, `stats/`, `widget/` |
| Filtros salvos e configuração da fonte | Filtros honestos e ConfigKeys realmente usados | `filter/data/`, [SourceSettingsExt](../../app/src/main/kotlin/io/github/kazuji/settings/sources/SourceSettingsExt.kt) |
| Abrir/share/importar link | `publicUrl` e resolução da biblioteca | [MangaLinkResolver](../../app/src/main/kotlin/io/github/kazuji/core/parser/MangaLinkResolver.kt), [LinkResolver da biblioteca](../../../kotatsu-parsers-redo/src/main/kotlin/org/koitharu/kotatsu/parsers/util/LinkResolver.kt) |
| Captcha/autenticação/browser action | Erro/ação explícita e domínio correto | `browser/`, [ExceptionResolver](../../app/src/main/kotlin/io/github/kazuji/core/exceptions/resolve/ExceptionResolver.kt) |
| Conteúdo adulto/incógnito | Tipo e classificação corretos | `explore/`, `search/`, `core/prefs/` |
| Extensões Mihon/fontes externas | Nenhuma implementação Mihon para um parser nativo | `mihon/` e `core/parser/external/`, adaptadores independentes |

Não existem métodos de parser para comentário, avaliações pessoais, favoritos no servidor da scan, pagamento, criação de conta ou envio de capítulo. O contrato de leitura entrega imagens; anunciar `ContentType.NOVEL` não introduz um contrato para leitura de texto estruturado.

## Padrão técnico recomendado

### 1. Escolher a base após conferir o site

Priorizar HTML/API públicos estáveis que já sustentam a navegação do site. Usar a família existente quando estrutura e endpoints conferidos correspondem:

- Madara: [MadaraParser](../../../kotatsu-parsers-redo/src/main/kotlin/org/koitharu/kotatsu/parsers/site/madara/MadaraParser.kt); exemplo de subclass pequena [FlowerManga](../../../kotatsu-parsers-redo/src/main/kotlin/org/koitharu/kotatsu/parsers/site/madara/pt/FlowerManga.kt).
- MangaReader: [Tsundoku](../../../kotatsu-parsers-redo/src/main/kotlin/org/koitharu/kotatsu/parsers/site/mangareader/pt/Tsundoku.kt) mostra ajuste das capabilities herdadas.
- Blogger/Zeist: [TemakiMangas](../../../kotatsu-parsers-redo/src/main/kotlin/org/koitharu/kotatsu/parsers/site/zeistmanga/pt/TemakiMangas.kt) ajusta seleção de páginas/detalhes e remove opções indisponíveis.
- Site próprio paginado: [PagedMangaParser](../../../kotatsu-parsers-redo/src/main/kotlin/org/koitharu/kotatsu/parsers/core/PagedMangaParser.kt), com tamanho e primeira página reais; há paginator separado de busca.
- Catálogo único finito: [SinglePageMangaParser](../../../kotatsu-parsers-redo/src/main/kotlin/org/koitharu/kotatsu/parsers/core/SinglePageMangaParser.kt), que encerra quando `offset > 0`.
- JavaScript inevitável: implementar usando o contexto do app, com ficha indicando dependência de WebView. O código existente [NexusMangas](../../../kotatsu-parsers-redo/src/main/kotlin/org/koitharu/kotatsu/parsers/site/pt/NexusMangas.kt) demonstra verificação de captura incompleta de capítulos; existência desse código não é comprovação de saúde do site.

Tema visual parecido não basta para reutilizar um parser. Não usar fontes `@Broken` como referência de funcionamento; [OnePieceEx](../../../kotatsu-parsers-redo/src/main/kotlin/org/koitharu/kotatsu/parsers/site/pt/OnePieceEx.kt) é exemplo existente marcado como quebrado.

### 2. Preservar identidade e preencher dados reais

- Manter `source.name` para fontes existentes. Criar nome UPPER_CASE exclusivo nas novas.
- Usar `generateUid` com caminho relativo ou ID interno estável, conforme convenção já usada pela fonte. Não mudar algoritmo/chave de uma fonte existente sem estratégia de compatibilidade.
- URLs de CDN podem ser absolutas; identidade de capítulo/obra não deve depender de token temporário, mirror ou posição na lista.
- `getDetails` preserva `id`, `url`, `source`; títulos, capas e metadados podem ser enriquecidos. Se o site redirecionar para um canonical path diferente, resolver sem quebrar a identidade já armazenada.
- Usar o construtor atual de `Manga`: `altTitles`, `authors`, `contentRating`. Evitar os campos/constructores legados `altTitle`, `author`, `isNsfw` em novos parsers.
- Retornar `null`/coleção vazia/constante de desconhecido conforme o modelo quando não há evidência. Não criar autor vazio, estado presumido, nota ou data sintética.
- Número de capítulo é o publicado, não o índice da lista. Volume/scanlator/branch só quando identificáveis. Especiais sem numeração podem usar `number = 0f` com título legível.
- Retornar capítulos antigos→novos dentro de cada branch. [mapChapters](../../../kotatsu-parsers-redo/src/main/kotlin/org/koitharu/kotatsu/parsers/util/Chapters.kt) remove IDs duplicados, mas não descobre numeração nem ordena por si só.
- Seletores de imagens devem considerar lazy loading e URL absoluta, preservando ordem e separando conteúdo editorial de anúncios.

### 3. Declarar filtros conforme resultados verificados

`filterCapabilities` controla a interface; `getFilterOptions` preenche as opções. São partes diferentes do mesmo compromisso. Declarar busca textual se efetiva; não ativar todos os flags como padrão.

Manter `availableSortOrders` não vazio, com semântica real. A ordem inicial usada pelo `ParserMangaRepository` é a preferência salva ou a primeira ordem do conjunto, não diretamente o `defaultSortOrder` declarado pela subclass. Para uma nova fonte com preferência específica, a ordem do conjunto também precisa refletir a escolha.

Sem filtros remotos, retornar options vazias. Filtrar apenas a página corrente localmente pode produzir término prematuro da paginação; não apresentar esse comportamento como suporte completo a busca/filtros do catálogo.

### 4. Rede, sessão e erros

- Usar `domain` nas URLs da fonte e configurar aliases só quando verificados.
- Usar `webClient` e o contexto fornecido; não instanciar cliente paralelo que perca tagging da fonte/cookies.
- O app combina `getRequestHeaders` sem substituir headers explícitos e aplica Referer raiz quando ausente. Implementar Referer/Origin específico se comprovadamente necessário para CDN/reader, cobrindo download e leitor.
- Preferir HTTP/HTML e JSON; WebView é uma dependência de runtime Android e deve constar na ficha.
- Captcha/intersticial/login deve produzir a exceção/ação adequada, não lista vazia que sugira ausência de capítulos.
- Preservar cancelamento. Usar `runCatchingCancellable` para recuperação, timeouts limitados e erro de parse com URL/contexto útil.
- `requestBrowserAction` representa uma etapa do usuário no browser do app. [LeitorDeMangaBrowserActionTest](../../../kotatsu-parsers-redo/src/test/kotlin/org/koitharu/kotatsu/parsers/site/pt/LeitorDeMangaBrowserActionTest.kt) é referência de regressão de intersticiais/challenges e páginas pré-carregadas.
- Só aplicar descrambling quando o formato exige, via interceptor compartilhado, para leitor e download receberem a mesma imagem.

### 5. Configuração da fonte

| ConfigKey | Uso no app | Regra para o parser |
| --- | --- | --- |
| `Domain` | Campo de domínio/aliases | Sempre declarar; nunca ignorar domínio configurado |
| `UserAgent` | Campo configurável | Registrar se usa `userAgentKey` e configuração tem efeito |
| `ShowSuspiciousContent` | Switch | Só declarar se altera requests/resultados |
| `SplitByTranslations` | Switch | Só declarar se modifica branches/traduções corretamente |
| `PreferredImageServer` | Lista e controle no leitor | Só declarar servidores reais e usar seleção no carregamento |
| `DisableUpdateChecking` | Oculto na UI; tracker lê `defaultValue` | Flag controlada pelo parser; marcar true quando checagem automática não é viável, documentando limitação |
| `InterceptCloudflare` | Oculto na UI; CloudFlareActivity lê `defaultValue` | Opta pelo caminho de interceptação do app; a flag sozinha não garante resolver challenge |

Referências: [ConfigKey](../../../kotatsu-parsers-redo/src/main/kotlin/org/koitharu/kotatsu/parsers/config/ConfigKey.kt), [SourceSettings](../../app/src/main/kotlin/io/github/kazuji/core/prefs/SourceSettings.kt), [TrackingRepository](../../app/src/main/kotlin/io/github/kazuji/tracker/domain/TrackingRepository.kt), [CloudFlareActivity](../../app/src/main/kotlin/io/github/kazuji/browser/cloudflare/CloudFlareActivity.kt).

## Gaps reais observados no código

Estas observações são estáticas. Não foram transformadas em mudanças abrangentes fora do escopo das fontes.

1. **Madara usa índice como número e perde metadados de capítulo.** `getChapters` e `loadChapters` atribuem `number = i + 1f`, `volume = 0`, `scanlator = null`, `branch = null`. Uma obra que comece no 50, tenha extras/decimais ou equipe/volume publicados perde informação. O padrão PT-BR deve enriquecer onde a fonte informa e manter IDs. Mudança na base mundial exige regressões além de PT-BR.
2. **Madara altera URL em detalhes.** `getDetails` usa `og:url` e faz `manga.copy(url = href)`, enquanto `MangaParser` proíbe alterar `id/url/source`. URLs canônicas divergentes podem quebrar cache/resolução. É preciso normalizar na entrada ou preservar o valor recebido ao adaptar uma fonte.
3. **Madara não enriquece vários campos em detalhes.** A implementação base auditada não atualiza `authors`, `rating`, `coverUrl`, `largeCoverUrl` ao abrir a ficha. Se o catálogo omití-los, seguem ausentes apesar de existirem na página de detalhes.
4. **Capabilities herdadas não comprovam suporte.** Madara anuncia ano, busca+filtros, estados e classificação para subclasses; em AJAX, o código de filtro de autor está comentado. Há bug documentado no caminho sem AJAX que pode retornar o catálogo inteiro quando uma tag não encontra obras. Cada site precisa prova individual antes de anunciar suporte.
5. **Captura WebView não é execução arbitrária do filterScript.** O app interpreta padrões `url.includes(...)` com combinações simples `&&`/`||` em Kotlin. Regex, comparação de método, código JS genérico e negação não são suporte contratual confiável nesse caminho. Usar `urlPattern` ou predicado compatível e validar no APK.
6. **Body de POST não é capturado pelo WebViewClient atual.** `RequestInterceptorWebViewClient` cria `InterceptedRequest` com URL/método/headers/timestamp; não atribui body. A presença do campo na biblioteca não significa que o app entregue payload/response. Parsers devem obter parâmetros pela URL/página ou endpoint conhecido; se exigirem body/response capturados, há trabalho de app adicional.
7. **Busca/relevância ainda usa só um alias em alguns caminhos.** `SearchV2Helper.matches` e sua ordenação usam a propriedade legada `altTitle` (primeiro elemento de `altTitles`), embora autores múltiplos sejam usados e o banco persista aliases múltiplos. Preencher todos os aliases continua correto; não prometer busca global por todos eles sem mudança no app.
8. **Modelos não expõem tudo que o site pode mostrar.** `Manga` não possui ano, idioma original, tipo por obra ou demografia dedicados; esses valores podem ser filtráveis sem aparecer como campos de detalhe. Comentários, contas da scan e favoritos remotos não fazem parte do contrato. Registrar essas limitações sem inventar APIs.
9. **ConfigKeys especiais são controladas pelo parser.** `DisableUpdateChecking` é omitida da tela, não é escrita por `SourceSettings.set`, e tracker usa o default da chave. `InterceptCloudflare` também é omitida e CloudFlareActivity usa defaultValue. Não instruir o usuário a ativar switches inexistentes.
10. **Default sort pode não ser o escolhido pelo parser.** `ParserMangaRepository.defaultSortOrder` escolhe preferência ou `sortOrders.first()`. A subclass declarar `defaultSortOrder` isoladamente não altera a ordem padrão do catálogo do app.
11. **Deep links dependem de domínio registrado.** `LinkResolver` compara host/topPrivateDomain aos `presetValues`; domínio personalizado ausente da lista não é descoberto por essa rotina. Links de capítulo não têm um método separado no contrato e podem precisar de `resolveLink` específico.
12. **Lista vazia pode ativar troca de mirror.** `ParserMangaRepository.withMirrors` considera coleção vazia resultado não válido para tentar mirrors. Parser deve distinguir acesso negado de catálogo/consulta vazios; validar busca sem resultados quando houver mirrors.

Referências adicionais: [CommonHeadersInterceptor](../../app/src/main/kotlin/io/github/kazuji/core/network/CommonHeadersInterceptor.kt), [WebViewRequestInterceptorExecutor](../../app/src/main/kotlin/io/github/kazuji/core/network/webview/WebViewRequestInterceptorExecutor.kt), [RequestInterceptorWebViewClient](../../app/src/main/kotlin/io/github/kazuji/core/network/webview/RequestInterceptorWebViewClient.kt), [EntityMapping](../../app/src/main/kotlin/io/github/kazuji/core/db/entity/EntityMapping.kt).

## Ficha obrigatória de cada fonte

Usar os estados `verificado no navegador`, `implementado`, `CI aprovada`, `validado no APK`, `ausente no site`, `bloqueado` e `não verificado`. Existência de classe não equivale a fonte concluída.

```text
Issue/lista: Kazuji #2, item ...
Nome a procurar no APK / source.name:
Domínio atual / aliases:
Família / parser existente ou novo:
Obra de catálogo / URL pública:
Consulta de busca positiva / negativa:
Página 1 / página 2 / término:
Ordenações verificadas:
Filtros: tag, multitag, exclusão, estado, classificação, tipo,
         demografia, idioma, idioma original, ano/intervalo, autor:
Metadados: título, aliases, autores, rating, classificação,
           capa/grande capa, estado, sinopse:
Capítulos: total / primeiro / intermediário / último,
           números reais, especiais/decimais, volumes,
           datas, equipe, branches:
Reader: capítulo / total de páginas / primeira e última imagem:
Rede: Referer/Origin/UA/cookies/login/WebView/browser action:
Relacionados / favicon / links externos:
Configurações e limitações:
Commit parser / CI / commit app / APK:
Resultado de download offline e retomar leitura:
Pendências concretas e evidência:
```

## Portão de entrega por lote e roteiro do APK

1. Conferir o site no navegador: catálogo, busca, detalhe, lista completa de capítulos e leitor. Guardar URLs e exemplos da ficha.
2. Implementar/revisar parser no repositório próprio. Registros/seletores/normalização/numeração/erros devem estar cobertos por regressões úteis quando houver lógica nova.
3. Executar compilação e testes pertinentes remotamente, respeitando a decisão de não rodar builds/testes/emuladores neste computador. Testes com fixtures comprovam parsing; não comprovam disponibilidade real do site. Os testes genéricos da biblioteca também contêm expectativas de tags/paginação que não servem a toda fonte finita ou sem filtros.
4. Registrar commit publicado da biblioteca e atualizar a dependência do app para esse commit no fluxo de integração autorizado. No checkout auditado, [libs.versions.toml](../../gradle/libs.versions.toml) usa `parsers = "a4108617"`; [app/build.gradle](../../app/build.gradle) aceita `-DparsersVersionOverride`. [settings.gradle](../../settings.gradle) substitui pela biblioteca irmã somente com `-PuseLocalParsers=true`. Uma build remota precisa verificar qual dependência efetivamente usou.
5. Produzir APK em CI remota com commit app/parser identificáveis; não considerar APK antigo como contendo novas fontes.
6. Entregar ao usuário a lista dos **títulos exatos** das fontes do lote, obra/consulta/capítulo indicados e limitações de login/captcha. O teste no APK deve cobrir ativar fonte, abrir lista, paginar, buscar, usar um filtro realmente suportado, abrir ficha, ler início/meio/fim, trocar capítulo, baixar e ler offline, favoritar e retomar após fechar o app.
7. Quando aplicável, validar volume/branch/decimais e importar a URL pública. Confirmar que refresh não duplica capítulos nem perde histórico; tracking exige confirmação em ambiente com uma atualização observável, não apenas abrir o catálogo.

Para priorizar rapidez, comparar sites já existentes e acessíveis primeiro, depois novos da família comprovada, APIs/HTML próprios, e por fim JS/intersticiais/autenticação. Classificar por evidência e estimativa de trabalho; um domínio inacessível continua pendente, não vira parser concluído com seletores presumidos.
