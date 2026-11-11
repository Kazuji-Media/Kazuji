# Fila de fontes PT-BR — issue Kazuji #2

Inventário estruturado em 2026-10-02 a partir de [RELATORIO-LATENCIA-FONTES-PT-BR-2026-09-29.md](../../RELATORIO-LATENCIA-FONTES-PT-BR-2026-09-29.md). Escopo: [Kazuji-Reader/Kazuji #2](https://github.com/Kazuji-Reader/Kazuji/issues/2). Dados completos e estados por etapa: [fontes-pt-br.csv](fontes-pt-br.csv).

São 123 registros: 45 na fila com mediana HTTP histórica utilizável e 78 na fila de revalidação. A lista representa 119 URLs iniciais únicas e quatro registros sem URL direta. As fontes leitoras continuam PENDENTE para validação no Kazuji; Manga Night foi classificada como não aplicável ao parser leitor pela inspeção do navegador em 2026-10-02.

## Ordem e limites da evidência

A prioridade usa somente as 45 respostas OK de 2026-09-29 com três amostras, em TTFB mediano crescente. A coleta leu até 8 KiB da página inicial no host do Codex; não mediu busca, capítulos, imagens, dispositivo Android ou a rede do usuário. Não existe medida nova nesta fila. O navegador deve confirmar catálogo e identidade antes de implementar cada fonte.

Respostas de suspensão, manutenção e login ficam em revalidação mesmo quando têm três amostras e HTTP 200. Primeira resposta isolada, bloqueios, erros, desafios e redirects não entram na ordenação de rapidez. Os tempos históricos são preservados no CSV, com o campo de mediana para a fila vazio quando a evidência não permite a comparação.

Existência de arquivo, ausência de @Broken e sucesso HTTP não aprovam a fonte. O CSV registra correspondência física no checkout de parsers consultado em 2026-10-02; nomes e domínios legados precisam de confirmação. Mudanças de template podem tornar o diretório Madara apenas uma localização histórica.

## Etapas e critérios por fonte

1. V0: confirmar identidade, domínio atual e idioma PT-BR. Resolver aliases e preservar IDs já usados antes de criar nova fonte.
2. V1: explorar no navegador catálogo, busca, detalhe de obra e capítulo. Registrar URLs públicas e evidência de conteúdo real; telas de desafio/login precisam do fluxo suportado pelo app.
3. V2: mapear contrato e capacidades reais: paginação, ordenações, filtros, busca combinada, tags, estados, tipo, classificação, nomes alternativos, autores, descrição, capas e idioma. Marcar não suportado quando o site não oferecer uma função.
4. V3: verificar catálogo e busca com resultados e sem resultados; páginas seguintes sem repetir itens; detalhes e capítulos ordenados com número, volume, data, ramo e scanlator quando disponíveis.
5. V4: validar páginas completas na ordem correta, URL da imagem, resolução, headers/cookies/CDN e imagem efetivamente decodificável; testar pelo menos dois capítulos, incluindo um antigo e um recente.
6. V5: testar cada ordenação/filtro declarado. Validar capabilities para que o app ofereça apenas operações que o parser executa.
7. V6: compilar parsers e app, executar verificações pertinentes e registrar commit, build e evidências antes de entregar APK.
8. V7: usuário valida APK: ativar fonte, listar, pesquisar, abrir detalhes, ler dois capítulos, baixar e abrir offline, retomar leitura, favorito/histórico/bookmark, atualização da biblioteca e abrir link externo quando suportado. Funções locais do app usam dados do parser; não exigem inventar capacidades do site.

Uma fonte só passa para APROVADA_APK depois de evidência funcional do parser e confirmação no APK. Falhas devem registrar etapa, URL e mensagem. Fonte indisponível pode receber conclusão documentada com evidência atual; não é considerada implementada nem encerrada por uma coleta HTTP histórica.

## Lotes propostos

Lotes de até cinco fontes preservam a ordem de mediana e permitem commit, atualização da biblioteca de parsers e APK intermediário por lote. Subagentes trabalham em arquivos separados; correções nas bases compartilhadas são coordenadas antes de integrar. Antecipar uma fonte só deve ocorrer com motivo registrado, como revalidação bloqueada da anterior. O tamanho do lote pode diminuir quando uma fonte exigir API ou template específico.

| Prioridade | Lote | Registro | Fonte | Domínio/URL | TTFB mediano (ms) | Parser atual | Estado |
|---:|---|---:|---|---|---:|---|---|
| 1 | L1 | 6 | BorutoExplorer | https://leitor.borutoexplorer.com.br | 61.2 | BORUTOEXPLORER | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 2 | L1 | 33 | HuntersScan | https://readhunters.xyz | 65.7 | HUNTERSSCAN | EXISTE_BROKEN; APK pendente |
| 3 | L1 | 61 | Manga Night | https://manganight.com.br | 65.8 | não aplicável | Agregador de links; fora da implementação de leitor |
| 4 | L1 | 83 | NinjaComics | https://ninjacomics.xyz | 85.8 | NINJASCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 5 | L1 | 10 | CafecomYaoi | https://cafecomyaoi.com.br | 130.2 | CAFECOMYAOI | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 6 | L2 | 52 | LuratoonScan | https://luratoons.net | 180.3 | RANDOMSCANS | EXISTE_BROKEN; APK pendente |
| 7 | L2 | 21 | EuphoriaScan | https://euphoriascan.com | 189.8 | EUPHORIASCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 8 | L2 | 82 | Nexus Mangás | https://nexusmangas.com | 196.3 | NEXUSMANGAS_PTBR | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 9 | L2 | 86 | NoindexScan | https://noindexscan.com | 291.6 | NOINDEXSCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 10 | L2 | 48 | LimboScan | https://limboscan.com.br | 390.9 | LIMBOSCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 11 | L3 | 45 | LerManga | https://lermanga.org | 440.7 | LERMANGA | EXISTE_BROKEN; APK pendente |
| 12 | L3 | 84 | NirvanaScan | https://nirvanascan.com | 478.1 | NIRVANASCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 13 | L3 | 23 | FbSquads | https://fbsquadx.com | 491.5 | FBSQUADS | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 14 | L3 | 43 | LeitorKamisama | https://leitor.kamisama.com.br | 496.5 | LEITORKAMISAMA | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 15 | L3 | 4 | ArthurScan | https://arthurscan.xyz | 511.1 | ARTHUR_SCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 16 | L4 | 107 | TemakiMangas | https://temakimangas.blogspot.com | 569.6 | TEMAKIMANGAS | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 17 | L4 | 46 | LerMangaOnline | https://lermangaonline.com.br | 570.9 | LERMANGAONLINE | EXISTE_BROKEN; APK pendente |
| 18 | L4 | 121 | ZScanlation | https://zscanlation.blogspot.com | 593.2 | ZSCANLATION | EXISTE_BROKEN; APK pendente |
| 19 | L4 | 44 | Ler999 | https://ler999.blogspot.com | 600.0 | LER999 | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 20 | L4 | 28 | Geass Comics | https://geasscomics.xyz | 609.2 | GEASSCOMICS | EXISTE_BROKEN; APK pendente |
| 21 | L5 | 36 | ImperioScans | https://risentoons.xyz | 667.7 | IMPERIOSCANS | EXISTE_BROKEN; APK pendente |
| 22 | L5 | 38 | KakuseiProject | https://kakuseiproject.com | 691.5 | KAKUSEIPROJECT | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 23 | L5 | 88 | NoxManga / NoxToons | https://noxtoons.com | 795.4 | não encontrado | NAO_ENCONTRADO; APK pendente |
| 24 | L5 | 39 | Kalango | https://kalango.org | 797.4 | KALANGO | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 25 | L5 | 78 | MrBenne | https://mrbenne.com | 849.6 | MRBENNE | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 26 | L6 | 122 | MANGA Plus PT-BR | https://mangaplus.shueisha.co.jp | 853.2 | MANGAPLUSPARSER_PTBR | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 27 | L6 | 85 | NocturneSummer | https://nocfsb.com | 855.3 | NOCSUMMER | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 28 | L6 | 113 | WolfScanBr | https://wolfscanbr.blogspot.com | 867.2 | WOLFSCANBR | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 29 | L6 | 111 | WickedWitchScan | https://wicked-witch-scan.com | 899.8 | WICKEDWITCHSCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 30 | L6 | 93 | PointZero Toons | https://pointzerotoons.com | 946.7 | POINTZEROTOONS | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 31 | L7 | 12 | Comikey Brasil | https://br.comikey.com | 954.9 | não encontrado | NAO_ENCONTRADO; APK pendente |
| 32 | L7 | 94 | ProjetoScanlator | https://projetoscanlator.com | 1003.9 | PROJETOSCANLATOR | EXISTE_BROKEN; APK pendente |
| 33 | L7 | 102 | SinensisScans | https://sinensis.leitorweb.com | 1055.9 | SINENSISSCANS | EXISTE_BROKEN; APK pendente |
| 34 | L7 | 56 | MangaClub PT-BR | https://mangaclub.net/pt-br | 1126.8 | MANGACLUB_PTBR | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 35 | L7 | 103 | SolooScan | https://solooscan.blogspot.com | 1154.6 | SOLOOSCAN | EXISTE_BROKEN; APK pendente |
| 36 | L8 | 11 | CeriseScans | https://cerise.leitorweb.com | 1255.4 | CERISE_SCANS | EXISTE_BROKEN; APK pendente |
| 37 | L8 | 70 | MangaTanko PT-BR | https://mangatanko.com/pt_br | 1455.2 | não encontrado | NAO_ENCONTRADO; APK pendente |
| 38 | L8 | 31 | HeckScans | https://heckscans.blogspot.com | 1733.4 | HECKSCANS | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 39 | L8 | 64 | Manganex PT | https://manganex.com/pt | 1749.8 | MANGANEX_PT | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 40 | L8 | 19 | DuoScanlators | https://duoscanlators.blogspot.com | 1761.5 | DUOSCANLATORS | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 41 | L9 | 27 | GalaxScanlator | https://galaxscanlator.blogspot.com | 1770.8 | GALAXSCANS | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 42 | L9 | 3 | ArcticScan | https://arcticscan.top | 1777.2 | ARCTICSCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 43 | L9 | 2 | Apenasmaisum Yaoi | https://apenasmaisumyaoi.com | 1896.7 | APENASMAISUMYAOI | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 44 | L9 | 14 | CvnScan | https://covendasbruxonas.com | 2010.9 | CVNSCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 45 | L9 | 8 | BrMangasTop | https://brmangas.top | 5786.0 | BRMANGASTOP | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |

## Revalidação — sem posição por rapidez

A ordem abaixo preserva o número do registro da issue. Reconfirmar no navegador, identificar domínio/template atual e medir novamente antes de inserir na fila por rapidez. HTTP de erro rápido não representa uma fonte rápida.

| Registro | Fonte | Domínio/URL informado | Observação HTTP histórica | Parser atual | Estado |
|---:|---|---|---|---|---|
| 1 | AloneScanlator | https://alonescanlator.com.br | HTTP 401 | ALONESCANLATOR | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 5 | Atemporal | https://atemporal.cloud | NETWORK/TLS ERROR | ATEMPORAL | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 7 | BrMangas | https://www.brmangas.net | REDIRECT HOST CHANGE | BRMANGAS | EXISTE_BROKEN; APK pendente |
| 9 | BurningScans | https://burningscans.com | NETWORK/TLS ERROR | BURNINGSCANS | EXISTE_BROKEN; APK pendente |
| 13 | CrystalComics | https://crystalcomics.com | REDIRECT HOST CHANGE | CRYSTALSCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 15 | DemonSect | https://seitacelestial.com | NETWORK/TLS ERROR | DEMONSECT | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 16 | DessertScan / Cabaré do Watame | https://cabaredowatame.site | NETWORK/TLS ERROR | CABAREDOWATAME | EXISTE_BROKEN; APK pendente |
| 17 | DianxiaTrads | https://dianxiatrads.com | REDIRECT HOST CHANGE | DIANXIATRADS | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 18 | DreamScan | https://fairydream.com.br | NETWORK/TLS ERROR | DREAMSCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 20 | ElevenScanlator | https://elevenscanlator.blogspot.com | HTTP 404 | ELEVENSCANLATOR | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 22 | FayScans | https://fayscans.net | NETWORK/TLS ERROR | FAYSCANS | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 24 | FenixProject | https://fenixproject.site | REDIRECT HOST CHANGE | FENIXPROJECT | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 25 | FlowerManga | https://flowermangas.net | TIMEOUT | FLOWERMANGA | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 26 | FoxWhite | https://foxwhite.com.br | NETWORK/TLS ERROR | FOXWHITE | EXISTE_BROKEN; APK pendente |
| 29 | GekkouScans | https://gekkou.site | NETWORK/TLS ERROR | GEKKOUSCANS | EXISTE_BROKEN; APK pendente |
| 30 | GhostScan | https://ghostscan.xyz | NETWORK/TLS ERROR | GHOSTSCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 32 | HikariScan | https://hikariscan.org | NETWORK/TLS ERROR | HIKARISCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 34 | IllusionScan | https://illusionscan.com | REDIRECT HOST CHANGE | ILLUSIONSCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 35 | Império da Britannia | fonte própria | NO DIRECT URL | IMPERIODABRITANNIA | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 37 | IrisScanlator | https://irisscanlator.com.br | NETWORK/TLS ERROR | IRISSCANLATOR | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 40 | KuroMangas | https://kuromangas.com | CHALLENGE | não encontrado | NAO_ENCONTRADO; APK pendente |
| 41 | LadyEstelarScan | https://ladyestelarscan.com.br | NETWORK/TLS ERROR | LADYESTELARSCAN | EXISTE_BROKEN; APK pendente |
| 42 | LeitorDeManga | https://leitordemangas.com | CHALLENGE | LEITORDEMANGA | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 47 | LichMangas | https://lichmangas.com | NETWORK/TLS ERROR | LICHMANGAS | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 49 | LimitedTimeProject | https://limitedtimeproject.com | NETWORK/TLS ERROR | LIMITEDTIMEPOJECT | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 50 | LinkStartScan | https://www.linkstartscan.xyz | REDIRECT HOST CHANGE | LINKSTARTSCAN | EXISTE_BROKEN; APK pendente |
| 51 | LoversToon | https://loverstoon.net | HTTP 523 | não encontrado | NAO_ENCONTRADO; APK pendente |
| 53 | MaidScan | https://empreguetes.xyz | REDIRECT HOST CHANGE | MAIDSCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 54 | MaidSecret | https://maidsecret.com | NETWORK/TLS ERROR | MAIDSECRET | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 55 | MangaBr | https://mangabr.net | NETWORK/TLS ERROR | MANGABR | EXISTE_BROKEN; APK pendente |
| 57 | MangaDex PT-BR | https://mangadex.org | CHALLENGE | MANGADEX | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 58 | MangaFire PT-BR | https://mangafire.to | CHALLENGE | MANGAFIRE_PTBR | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 59 | Manga Livre | parser atual aponta para domínio legado | NO DIRECT URL | MANGALIVRE | EXISTE_BROKEN; APK pendente |
| 60 | MangaLivre.org | https://mangalivre.org | REDIRECT HOST CHANGE | não encontrado | NAO_ENCONTRADO; APK pendente |
| 62 | MangaNanquim | https://mangananquim.site | NETWORK/TLS ERROR | MANGANANQUIM | EXISTE_BROKEN; APK pendente |
| 63 | MangaNinja | https://manganinja.com | NETWORK/TLS ERROR | MANGANINJA | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 65 | Mangas Brasuka | https://mangasbrasuka.org | CHALLENGE | MANGASBRASUKAS | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 66 | MangasChan | https://mangaschan.net | NETWORK/TLS ERROR | MANGASCHAN | EXISTE_BROKEN; APK pendente |
| 67 | MangasOnline | https://mangasonline.cc | NETWORK/TLS ERROR | MANGASONLINE | EXISTE_BROKEN; APK pendente |
| 68 | MangaOnline | https://mangaonline.blog | NETWORK/TLS ERROR | MANGAONLINE_BLOG | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 69 | MangaOnline.biz | https://mangaonline.biz | TIMEOUT | MANGAONLINE | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 71 | MangaTerra | https://manga-terra.com | NETWORK/TLS ERROR | MANGATERRA | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 72 | Manhastro | https://manhastro.net | CHALLENGE | MANHASTRO | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 73 | MediocreToons | https://mediocretoons.com | NETWORK/TLS ERROR | MEDIOCRETOONS | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 74 | MiniTwoScan | https://minitwoscan.com | CHALLENGE | MINITWOSCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 75 | MomonohanaScan | https://momonohanascan.com | REDIRECT HOST CHANGE | MOMONOHANASCAN | EXISTE_BROKEN; APK pendente |
| 76 | MoonLoversScan | https://moonloversscan.com.br | NETWORK/TLS ERROR | MOONLOVERSSCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 77 | MoonWitchinScan | https://moonwitchscan.com.br | NETWORK/TLS ERROR | MOONWITCHINLOVESCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 79 | MugiwarasOficial | https://mugiwarasoficial.com | CHALLENGE | MUGIWARASOFICIAL | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 80 | NeoxScans | domínio legado ligado ao Manga Livre | NO DIRECT URL | NEOX_SCANS | EXISTE_BROKEN; APK pendente |
| 81 | Neroxus | https://neroxus.com.br | NETWORK/TLS ERROR | NEROXUS | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 87 | Norterose | https://norterose.com.br | NETWORK/TLS ERROR | NORTEROSE | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 89 | Origami Orpheans | https://origami-orpheans.com | HTTP 200 · página de suspensão | ORIGAMIORPHEANS | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 90 | PassamaoScan | https://passamaoscan.com | NETWORK/TLS ERROR | PASSAMAOSCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 91 | PirulitoRosa | https://pirulitorosa.site | NETWORK/TLS ERROR | PIRULITOROSA | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 92 | PlumaComics | https://plumacomics.cloud | HTTP 200 · página de manutenção | PLUMACOMICS | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 95 | PsUnicorn | https://psunicorn.com | HTTP 200 · tela de login protegida | PSUNICORN | EXISTE_BROKEN; APK pendente |
| 96 | RainbowFairyScan | https://rainbowfairyscan.com | NETWORK/TLS ERROR | RAINBOWFAIRYSCAN | EXISTE_BROKEN; APK pendente |
| 97 | RaysScan | https://raysscan.blogspot.com | HTTP 404 | RAYSSCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 98 | ReMangas / WiComix | https://remangas.net | NETWORK/TLS ERROR | REMANGAS | EXISTE_BROKEN; APK pendente |
| 99 | RogMangas | https://rogmangas.com | NETWORK/TLS ERROR | ROGMANGAS | EXISTE_BROKEN; APK pendente |
| 100 | Sakura Mangás | https://sakuramangas.org | CHALLENGE | não encontrado | NAO_ENCONTRADO; APK pendente |
| 101 | SilenceScan | https://silencescan.com.br | NETWORK/TLS ERROR | SILENCESCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 104 | SsReading | https://ssreading.com.br | NETWORK/TLS ERROR | SSREADING | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 105 | SussyScan | https://sussytoons.wtf | NETWORK/TLS ERROR | SUSSYSCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 106 | TatakaeScans | https://tatakaescan.com | REDIRECT HOST CHANGE | TATAKAE_SCANS | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 108 | Tsundoku | https://tsundoku.com.br | NETWORK/TLS ERROR | TSUNDOKU | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 109 | TyrantScans | https://www.tyrantscans.com | NETWORK/TLS ERROR | TYRANTSCANS | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 110 | ValkyrieScan | https://valkyriescan.com | NETWORK/TLS ERROR | VALKYRIESCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 112 | WinterScan | https://winterscan.com | NETWORK/TLS ERROR | WINTERSCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 114 | WonderlandScan | https://wonderlandscan.com | NETWORK/TLS ERROR | WONDERLANDSCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 115 | XsScan | https://xsscan.xyz | REDIRECT HOST CHANGE | XSSCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 116 | YanpFansub | https://trisalyanp.com | NETWORK/TLS ERROR | YANPFANSUB | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 117 | YcScan | https://ycscan.com | TIMEOUT | YCSCAN | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 118 | Yomu Comics | https://yomucomics.com | NETWORK/TLS ERROR | SSSSCANLATOR | EXISTE_BROKEN; APK pendente |
| 119 | Yomu Mangas | https://yomumangas.com | CHALLENGE | YOMUMANGAS | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 120 | YugenApp | https://yugenmangasbr.voblog.xyz | NETWORK/TLS ERROR | YUGENMANGAS | EXISTE_SEM_VALIDACAO_ATUAL; APK pendente |
| 123 | JBC Digital | distribuição via Kindle/Kobo/Google Play/Apple Books | NO DIRECT URL | não encontrado | NAO_ENCONTRADO; APK pendente |

## Correspondências e possíveis duplicações

- O relatório inicial marcava Nexus Mangás, MangaClub PT-BR, Manganex PT e Mangas Brasuka sem parser. O checkout atual contém NEXUSMANGAS_PTBR, MANGACLUB_PTBR, MANGANEX_PT e MANGASBRASUKAS. Essa diferença exige revisão dos parsers existentes, em vez de duplicá-los.
- LeitorDeManga e Mangas Brasukas têm IDs diferentes definidos no mesmo arquivo LeitorDeManga.kt. Compartilhar arquivo/base não torna as duas fontes duplicadas.
- MangaOnline (mangaonline.blog, MANGAONLINE_BLOG) e MangaOnline.biz (MANGAONLINE) são fontes distintas; não deduplicar apenas pelo nome da classe.
- Manga Livre, MangaLivre.org, NeoxScans e NoxManga/NoxToons constituem um grupo de identidade/migração a investigar. Os parsers físicos legados apontam para mangalivre.tv e mangalivre.net; o relatório observou mangalivre.org redirecionando para noxmangas.org, enquanto noxtoons.com respondeu diretamente. Não presumir equivalência nem sobrescrever IDs sem confirmar a continuidade.
- CeriseScans/LoversToon: relação de migração informada na issue, sem confirmação funcional atual; manter os dois registros até investigar identidade e catálogo.
- ReMangas/WiComix e DessertScan/Cabaré do Watame já são aliases dentro de um mesmo registro. Não criar dois parsers apenas por esses nomes.
- MaidScan e SussyScan têm parsers separados e referências ao mesmo ecossistema. Comparar scanId e catálogos; compartilhamento de API/CDN não prova duplicação.
- Os quatro registros sem URL direta (Império da Britannia, Manga Livre, NeoxScans, JBC Digital) não são duplicatas de URL. JBC descreve distribuição por lojas; identificar eventual leitor público antes de propor um parser.
- Nenhuma URL inicial HTTPS foi deduplicada ou descartada: os 119 endereços pertencem a 119 registros distintos.

## Ausência física de parser correspondente

A busca examinou parsers PT e os parsers multilíngues relevantes por hostname no código ou nome de classe. Não encontrar correspondência é uma indicação de implementação/investigação, sem confirmar que o site ofereça um leitor compatível.

| Registro | Fonte | Próximo trabalho |
|---:|---|---|
| 12 | Comikey Brasil | HTTP_HISTORICO_VALIDO_RECONFIRMAR_CATALOGO |
| 40 | KuroMangas | VALIDAR_DESAFIO_NO_NAVEGADOR_E_FLUXO_DO_APP |
| 51 | LoversToon | REPETIR_HTTP_NAVEGADOR_E_CONFIRMAR_DOMINIO |
| 60 | MangaLivre.org | CONFIRMAR_IDENTIDADE_DESTINO_SEM_ASSUMIR_MIGRACAO |
| 61 | Manga Night | Agregador de links confirmado: sem capítulos/imagens próprios; parser leitor não aplicável |
| 70 | MangaTanko PT-BR | HTTP_HISTORICO_VALIDO_RECONFIRMAR_CATALOGO |
| 88 | NoxManga / NoxToons | HTTP_HISTORICO_VALIDO_RECONFIRMAR_CATALOGO |
| 100 | Sakura Mangás | VALIDAR_DESAFIO_NO_NAVEGADOR_E_FLUXO_DO_APP |
| 123 | JBC Digital | IDENTIFICAR_URL_ATUAL_E_LEITOR_WEB |

## Como procurar fontes no APK

Usar o campo nome_para_procurar_no_app do CSV. Aliases podem diferir da issue: NinjaComics aparece pelo nome declarado no parser; Yomu Comics está registrado em SssScanlator.kt; GalaxScanlator em GalaxScans.kt. O APK deve incluir o commit dos parsers antes de presumir que esses nomes estarão disponíveis. A cada entrega, registrar nesta fila quais fontes foram incluídas e quais validações o usuário deve realizar.

A primeira entrega candidata segue L1: BorutoExplorer, HuntersScan, Manga Night, NinjaComics e CafecomYaoi. L2 segue LuratoonScan, EuphoriaScan, Nexus Mangás, NoindexScan e LimboScan. São propostas de sequência; a fonte só deve constar como pronta na entrega após passar pelas etapas.

## Manutenção do inventário

Atualizar primeiro o CSV ao obter novas evidências; sincronizar tabelas desta fila. Preservar resultado e data históricos e registrar medições novas separadamente, com amostras e origem. Não substituir PENDENTE por APROVADA apenas porque o navegador abre a página ou a compilação passou. Referenciar o commit e o APK correspondente no registro da entrega.

## Evidência nova do navegador — 2026-10-02

- Manga Night: [ficha de One Piece](https://manganight.com.br/manga/one-piece-30013) declara que oferece links para plataformas de leitura e não hospeda conteúdo. A página contém links para MangaDex, MANGA Plus e VIZ. O registro 61 permanece no inventário com a mediana histórica; não é elegível à implementação de parser leitor nem à validação de leitura no APK. A tarefa é concluída com essa evidência, sem contabilizar parser implementado.
- BorutoExplorer: a inspeção de Naruto versão colorida encontrou 187 capítulos em 21 volumes; capítulo 187 apresentou 20 imagens no seletor .reading-content img.wp-manga-chapter-img. Isso fundamenta o trabalho do parser, mas não confirma downloads, decodificação de todas as imagens ou funcionamento no APK.

- NinjaComics: [Príncipe Dragão Sagrado](https://ninjacomics.xyz/manga/principe-dragao-sagrado/) apresentou 1305 elementos de capítulo após AJAX, incluindo 652.5 (Final), 652 e 651.5, data 29 de novembro de 2024 e status Completed. Metadados observados: Yuan Zun, Dragon Prince Yuan, 元尊; autor Tian Can Tou Du; artista Dr. Da Ji; nota 4.6/5. O leitor abriu #google_vignette com anúncio modal; páginas/imagens permanecem pendentes. NinjaScan.kt foi corrigido com numeração real e atualização dos metadados; três fixtures offline NinjaScanTest foram escritos, ainda sem execução confirmada. Não há aprovação funcional/APK.
