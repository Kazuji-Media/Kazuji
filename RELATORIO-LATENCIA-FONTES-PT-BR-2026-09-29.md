# Latência e disponibilidade das fontes PT-BR

- Início: 2026-09-29T16:48:37+00:00
- Fim: 2026-09-29T16:49:56+00:00
- Origem: host do Codex nesta sessão; egress geográfico não foi medido independentemente.
- Escopo: 123 registros; 119 URLs HTTPS únicas; uma URL por domínio informado.
- User-agent: Android Chrome; sem proxy.

## Método

Requisições HTTPS GET diretas, seguindo redirecionamentos. Cada conexão lê no máximo 8192 bytes da página inicial antes de fechar. TTFB é o tempo entre o início da requisição e os cabeçalhos da resposta final; a segunda medida é o tempo até obter o prefixo limitado. Timeout: 8 s; até 4 hosts simultâneos. Respostas 2xx/3xx, no host listado e sem marcador óbvio de desafio recebem até 3 amostras com pequeno intervalo. Falhas, bloqueios, desafios e redirecionamentos para outro host param após a primeira amostra.

Este teste mede somente a resposta inicial da página inicial. Não mede carregamento completo, imagens, busca/capítulos no parser, desempenho do app, nem a rota de rede de um aparelho Android. HTTP rápido com status fora de 2xx, desafio, redirect para outro host ou destino de suspensão/manutenção/login não conta como fonte pronta. Os tempos são uma amostra desta rede e horário; variam com região, cache, CDN e momento.

## Resultado

Registros: 123; 119 URLs HTTPS únicas. Lista 1 (resposta 2xx direta sem erro aparente): 45. Lista 2 (fontes depreciadas nesta coleta ou sem resposta válida): 78. A classificação é um retrato desta coleta e não confirma encerramento permanente.

| Resultado | Quantidade |
|---|---:|
| HTTP 2xx direto, sem erro aparente (Lista 1) | 45 |
| HTTP 200 em página de suspensão/manutenção/login (Lista 2) | 3 |
| NETWORK/TLS ERROR | 43 |
| REDIRECT HOST CHANGE | 11 |
| CHALLENGE | 10 |
| NO DIRECT URL | 4 |
| TIMEOUT | 3 |
| HTTP 404 | 2 |
| HTTP 401 | 1 |
| HTTP 523 | 1 |

## Menores medianas de TTFB entre URLs da Lista 1

| Posição | Fonte | URL inicial | HTTP | TTFB mediano (ms) | Até 8 KiB mediano (ms) | Amostras |
|---:|---|---|---:|---:|---:|---:|
| 1 | BorutoExplorer | [https://leitor.borutoexplorer.com.br](https://leitor.borutoexplorer.com.br) | 200 | 61.2 | 64.6 | 3 |
| 2 | HuntersScan | [https://readhunters.xyz](https://readhunters.xyz) | 200 | 65.7 | 82.8 | 3 |
| 3 | Manga Night | [https://manganight.com.br](https://manganight.com.br) | 200 | 65.8 | 65.8 | 3 |
| 4 | NinjaComics | [https://ninjacomics.xyz](https://ninjacomics.xyz) | 200 | 85.8 | 86.4 | 3 |
| 5 | CafecomYaoi | [https://cafecomyaoi.com.br](https://cafecomyaoi.com.br) | 200 | 130.2 | 130.8 | 3 |
| 6 | LuratoonScan | [https://luratoons.net](https://luratoons.net) | 200 | 180.3 | 180.3 | 3 |
| 7 | EuphoriaScan | [https://euphoriascan.com](https://euphoriascan.com) | 200 | 189.8 | 189.8 | 3 |
| 8 | Nexus Mangás | [https://nexusmangas.com](https://nexusmangas.com) | 200 | 196.3 | 196.3 | 3 |
| 9 | NoindexScan | [https://noindexscan.com](https://noindexscan.com) | 200 | 291.6 | 291.8 | 3 |
| 10 | LimboScan | [https://limboscan.com.br](https://limboscan.com.br) | 200 | 390.9 | 391.6 | 3 |
| 11 | LerManga | [https://lermanga.org](https://lermanga.org) | 200 | 440.7 | 440.8 | 3 |
| 12 | NirvanaScan | [https://nirvanascan.com](https://nirvanascan.com) | 200 | 478.1 | 478.3 | 3 |
| 13 | FbSquads | [https://fbsquadx.com](https://fbsquadx.com) | 200 | 491.5 | 491.8 | 3 |
| 14 | LeitorKamisama | [https://leitor.kamisama.com.br](https://leitor.kamisama.com.br) | 200 | 496.5 | 496.5 | 3 |
| 15 | ArthurScan | [https://arthurscan.xyz](https://arthurscan.xyz) | 200 | 511.1 | 511.2 | 3 |
| 16 | TemakiMangas | [https://temakimangas.blogspot.com](https://temakimangas.blogspot.com) | 200 | 569.6 | 571.6 | 3 |
| 17 | LerMangaOnline | [https://lermangaonline.com.br](https://lermangaonline.com.br) | 200 | 570.9 | 571.1 | 3 |
| 18 | ZScanlation | [https://zscanlation.blogspot.com](https://zscanlation.blogspot.com) | 200 | 593.2 | 594.7 | 3 |
| 19 | Ler999 | [https://ler999.blogspot.com](https://ler999.blogspot.com) | 200 | 600.0 | 601.9 | 3 |
| 20 | Geass Comics | [https://geasscomics.xyz](https://geasscomics.xyz) | 200 | 609.2 | 609.3 | 3 |

## Inventário completo

| # | Fonte | Categoria | Domínio informado | Kotatsu informado | Tag informada | Resultado | HTTP | 1ª resposta (ms) | TTFB mediano utilizável (ms) | Até 8 KiB mediano (ms) | Amostras | URL final / erro | Teste no Kazuji |
|---:|---|---|---|---|---|---|---:|---:|---:|---:|---:|---|---|
| 1 | AloneScanlator | Web com parser indicado no inventário | [alonescanlator.com.br](https://alonescanlator.com.br) | SIM | KOTATSU-VERIFICAR | HTTP 401 | 401 | 79.2 | — | — | 1 | [https://alonescanlator.com.br](https://alonescanlator.com.br) | PENDENTE |
| 2 | Apenasmaisum Yaoi | Web com parser indicado no inventário | [apenasmaisumyaoi.com](https://apenasmaisumyaoi.com) | SIM | KOTATSU-VERIFICAR | OK | 200 | 3729.0 | 1896.7 | 1896.7 | 3 | [https://www.apenasmaisumyaoi.com/](https://www.apenasmaisumyaoi.com/) | PENDENTE |
| 3 | ArcticScan | Web com parser indicado no inventário | [arcticscan.top](https://arcticscan.top) | SIM | KOTATSU-VERIFICAR | OK | 200 | 11587.2 | 1777.2 | 1777.3 | 3 | [https://arcticscan.top](https://arcticscan.top) | PENDENTE |
| 4 | ArthurScan | Web com parser indicado no inventário | [arthurscan.xyz](https://arthurscan.xyz) | SIM | KOTATSU-VERIFICAR | OK | 200 | 511.1 | 511.1 | 511.2 | 3 | [https://arthurscan.xyz](https://arthurscan.xyz) | PENDENTE |
| 5 | Atemporal | Web com parser indicado no inventário | [atemporal.cloud](https://atemporal.cloud) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to ge... | PENDENTE |
| 6 | BorutoExplorer | Web com parser indicado no inventário | [leitor.borutoexplorer.com.br](https://leitor.borutoexplorer.com.br) | SIM | KOTATSU-VERIFICAR | OK | 200 | 61.2 | 61.2 | 64.6 | 3 | [https://leitor.borutoexplorer.com.br](https://leitor.borutoexplorer.com.br) | PENDENTE |
| 7 | BrMangas | Web com parser indicado no inventário | [www.brmangas.net](https://www.brmangas.net) | SIM | KOTATSU-BROKEN | REDIRECT HOST CHANGE | 200 | 2024.2 | — | — | 1 | [https://getechnologies.net/](https://getechnologies.net/) | PENDENTE |
| 8 | BrMangasTop | Web com parser indicado no inventário | [brmangas.top](https://brmangas.top) | SIM | KOTATSU-VERIFICAR | OK | 200 | 11569.0 | 5786.0 | 5786.2 | 3 | [https://brmangas.top](https://brmangas.top) | PENDENTE |
| 9 | BurningScans | Web com parser indicado no inventário | [burningscans.com](https://burningscans.com) | SIM | KOTATSU-BROKEN | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 10 | CafecomYaoi | Web com parser indicado no inventário | [cafecomyaoi.com.br](https://cafecomyaoi.com.br) | SIM | KOTATSU-VERIFICAR | OK | 200 | 556.7 | 130.2 | 130.8 | 3 | [https://cafecomyaoi.com.br](https://cafecomyaoi.com.br) | PENDENTE |
| 11 | CeriseScans | Migração/legado a revalidar | [cerise.leitorweb.com](https://cerise.leitorweb.com) | SIM | KOTATSU-MIGROU / BROKEN -> LoversToon | OK | 200 | 1255.4 | 1255.4 | 1255.5 | 3 | [https://cerise.leitorweb.com](https://cerise.leitorweb.com) | PENDENTE |
| 12 | Comikey Brasil | Oficial/distribuição | [br.comikey.com](https://br.comikey.com) | NAO | NAO-KOTATSU / OFICIAL | OK | 200 | 870.5 | 954.9 | 955.3 | 3 | [https://br.comikey.com](https://br.comikey.com) | PENDENTE |
| 13 | CrystalComics | Web com parser indicado no inventário | [crystalcomics.com](https://crystalcomics.com) | SIM | KOTATSU-VERIFICAR | REDIRECT HOST CHANGE | 200 | 3699.8 | — | — | 1 | [http://ww38.crystalcomics.com/](http://ww38.crystalcomics.com/) | PENDENTE |
| 14 | CvnScan | Web com parser indicado no inventário | [covendasbruxonas.com](https://covendasbruxonas.com) | SIM | KOTATSU-VERIFICAR | OK | 200 | 2010.9 | 2010.9 | 2011.0 | 3 | [https://covendasbruxonas.com/bruxonas/](https://covendasbruxonas.com/bruxonas/) | PENDENTE |
| 15 | DemonSect | Web com parser indicado no inventário | [seitacelestial.com](https://seitacelestial.com) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [WinError 10061] Nenhuma conexão pôde ser feita porque a máquina de dest... | PENDENTE |
| 16 | DessertScan / Cabaré do Watame | Web com parser indicado no inventário | [cabaredowatame.site](https://cabaredowatame.site) | SIM | KOTATSU-BROKEN | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 17 | DianxiaTrads | Web com parser indicado no inventário | [dianxiatrads.com](https://dianxiatrads.com) | SIM | KOTATSU-VERIFICAR | REDIRECT HOST CHANGE | 200 | 3909.6 | — | — | 1 | [http://ww38.dianxiatrads.com/](http://ww38.dianxiatrads.com/) | PENDENTE |
| 18 | DreamScan | Web com parser indicado no inventário | [fairydream.com.br](https://fairydream.com.br) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 19 | DuoScanlators | Web com parser indicado no inventário | [duoscanlators.blogspot.com](https://duoscanlators.blogspot.com) | SIM | KOTATSU-VERIFICAR | OK | 200 | 1850.9 | 1761.5 | 1763.5 | 3 | [https://duoscanlators.blogspot.com/?m=1](https://duoscanlators.blogspot.com/?m=1) | PENDENTE |
| 20 | ElevenScanlator | Web com parser indicado no inventário | [elevenscanlator.blogspot.com](https://elevenscanlator.blogspot.com) | SIM | KOTATSU-VERIFICAR | HTTP 404 | 404 | 1138.0 | — | — | 1 | [https://elevenscanlator.blogspot.com/?m=1](https://elevenscanlator.blogspot.com/?m=1) | PENDENTE |
| 21 | EuphoriaScan | Web com parser indicado no inventário | [euphoriascan.com](https://euphoriascan.com) | SIM | KOTATSU-VERIFICAR | OK | 200 | 546.1 | 189.8 | 189.8 | 3 | [https://euphoriascan.com](https://euphoriascan.com) | PENDENTE |
| 22 | FayScans | Web com parser indicado no inventário | [fayscans.net](https://fayscans.net) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to ge... | PENDENTE |
| 23 | FbSquads | Web com parser indicado no inventário | [fbsquadx.com](https://fbsquadx.com) | SIM | KOTATSU-VERIFICAR | OK | 200 | 491.5 | 491.5 | 491.8 | 3 | [https://fbsquadx.com](https://fbsquadx.com) | PENDENTE |
| 24 | FenixProject | Web com parser indicado no inventário | [fenixproject.site](https://fenixproject.site) | SIM | KOTATSU-VERIFICAR | REDIRECT HOST CHANGE | 200 | 2163.7 | — | — | 1 | [https://fenixproject.website/](https://fenixproject.website/) | PENDENTE |
| 25 | FlowerManga | Web com parser indicado no inventário | [flowermangas.net](https://flowermangas.net) | SIM | KOTATSU-VERIFICAR | TIMEOUT | — | — | — | — | 1 | TimeoutError: The read operation timed out | PENDENTE |
| 26 | FoxWhite | Web com parser indicado no inventário | [foxwhite.com.br](https://foxwhite.com.br) | SIM | KOTATSU-BROKEN | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 27 | GalaxScanlator | Web com parser indicado no inventário | [galaxscanlator.blogspot.com](https://galaxscanlator.blogspot.com) | SIM | KOTATSU-VERIFICAR | OK | 200 | 1839.5 | 1770.8 | 1772.6 | 3 | [https://galaxscanlator.blogspot.com/?m=1](https://galaxscanlator.blogspot.com/?m=1) | PENDENTE |
| 28 | Geass Comics | Web com parser indicado no inventário | [geasscomics.xyz](https://geasscomics.xyz) | SIM | KOTATSU-VERIFICAR | OK | 200 | 609.2 | 609.2 | 609.3 | 3 | [https://geasscomics.xyz](https://geasscomics.xyz) | PENDENTE |
| 29 | GekkouScans | Web com parser indicado no inventário | [gekkou.site](https://gekkou.site) | SIM | KOTATSU-BROKEN | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to ge... | PENDENTE |
| 30 | GhostScan | Web com parser indicado no inventário | [ghostscan.xyz](https://ghostscan.xyz) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11002] getaddrinfo failed> | PENDENTE |
| 31 | HeckScans | Web com parser indicado no inventário | [heckscans.blogspot.com](https://heckscans.blogspot.com) | SIM | KOTATSU-VERIFICAR | OK | 200 | 1798.1 | 1733.4 | 1735.2 | 3 | [https://heckscans.blogspot.com/?m=1](https://heckscans.blogspot.com/?m=1) | PENDENTE |
| 32 | HikariScan | Web com parser indicado no inventário | [hikariscan.org](https://hikariscan.org) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 33 | HuntersScan | Web com parser indicado no inventário | [readhunters.xyz](https://readhunters.xyz) | SIM | KOTATSU-BROKEN | OK | 200 | 82.8 | 65.7 | 82.8 | 3 | [https://readhunters.xyz](https://readhunters.xyz) | PENDENTE |
| 34 | IllusionScan | Web com parser indicado no inventário | [illusionscan.com](https://illusionscan.com) | SIM | KOTATSU-VERIFICAR | REDIRECT HOST CHANGE | 200 | 1660.6 | — | — | 1 | [http://ww17.illusionscan.com/](http://ww17.illusionscan.com/) | PENDENTE |
| 35 | Império da Britannia | Web com parser indicado no inventário | fonte própria | SIM | KOTATSU-VERIFICAR | NO DIRECT URL | — | — | — | — | 0 | — | PENDENTE |
| 36 | ImperioScans | Web com parser indicado no inventário | [risentoons.xyz](https://risentoons.xyz) | SIM | KOTATSU-BROKEN | OK | 200 | 890.0 | 667.7 | 667.9 | 3 | [https://risentoons.xyz](https://risentoons.xyz) | PENDENTE |
| 37 | IrisScanlator | Web com parser indicado no inventário | [irisscanlator.com.br](https://irisscanlator.com.br) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: Hostname mis... | PENDENTE |
| 38 | KakuseiProject | Web com parser indicado no inventário | [kakuseiproject.com](https://kakuseiproject.com) | SIM | KOTATSU-VERIFICAR | OK | 200 | 1196.8 | 691.5 | 691.6 | 3 | [https://kakuseiproject.com](https://kakuseiproject.com) | PENDENTE |
| 39 | Kalango | Web com parser indicado no inventário | [kalango.org](https://kalango.org) | SIM | KOTATSU-VERIFICAR | OK | 200 | 1331.8 | 797.4 | 797.5 | 3 | [https://kalango.org/home/](https://kalango.org/home/) | PENDENTE |
| 40 | KuroMangas | Migração/legado a revalidar | [kuromangas.com](https://kuromangas.com) | NAO | NAO-KOTATSU / REVALIDAR | CHALLENGE | 200 | 418.9 | — | — | 1 | [https://kuromangas.com](https://kuromangas.com) | PENDENTE |
| 41 | LadyEstelarScan | Web com parser indicado no inventário | [ladyestelarscan.com.br](https://ladyestelarscan.com.br) | SIM | KOTATSU-BROKEN | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 42 | LeitorDeManga | Web com parser indicado no inventário | [leitordemangas.com](https://leitordemangas.com) | SIM | KOTATSU-VERIFICAR / PRIORIDADE | CHALLENGE | 403 | 85.2 | — | — | 1 | [https://leitordemangas.com](https://leitordemangas.com) | PENDENTE |
| 43 | LeitorKamisama | Web com parser indicado no inventário | [leitor.kamisama.com.br](https://leitor.kamisama.com.br) | SIM | KOTATSU-VERIFICAR | OK | 200 | 945.4 | 496.5 | 496.5 | 3 | [https://leitor.kamisama.com.br](https://leitor.kamisama.com.br) | PENDENTE |
| 44 | Ler999 | Web com parser indicado no inventário | [ler999.blogspot.com](https://ler999.blogspot.com) | SIM | KOTATSU-VERIFICAR | OK | 200 | 615.8 | 600.0 | 601.9 | 3 | [https://ler999.blogspot.com/?m=1](https://ler999.blogspot.com/?m=1) | PENDENTE |
| 45 | LerManga | Web com parser indicado no inventário | [lermanga.org](https://lermanga.org) | SIM | KOTATSU-BROKEN | OK | 200 | 933.2 | 440.7 | 440.8 | 3 | [https://lermanga.org](https://lermanga.org) | PENDENTE |
| 46 | LerMangaOnline | Web com parser indicado no inventário | [lermangaonline.com.br](https://lermangaonline.com.br) | SIM | KOTATSU-BROKEN | OK | 200 | 1009.1 | 570.9 | 571.1 | 3 | [https://lermangaonline.com.br](https://lermangaonline.com.br) | PENDENTE |
| 47 | LichMangas | Web com parser indicado no inventário | [lichmangas.com](https://lichmangas.com) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to ge... | PENDENTE |
| 48 | LimboScan | Web com parser indicado no inventário | [limboscan.com.br](https://limboscan.com.br) | SIM | KOTATSU-VERIFICAR | OK | 200 | 825.5 | 390.9 | 391.6 | 3 | [https://limboscan.com.br](https://limboscan.com.br) | PENDENTE |
| 49 | LimitedTimeProject | Web com parser indicado no inventário | [limitedtimeproject.com](https://limitedtimeproject.com) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to ge... | PENDENTE |
| 50 | LinkStartScan | Web com parser indicado no inventário | [www.linkstartscan.xyz](https://www.linkstartscan.xyz) | SIM | KOTATSU-BROKEN | REDIRECT HOST CHANGE | 200 | 4082.7 | — | — | 1 | [http://ww38.linkstartscan.xyz/](http://ww38.linkstartscan.xyz/) | PENDENTE |
| 51 | LoversToon | Migração/legado a revalidar | [loverstoon.net](https://loverstoon.net) | NAO COMO LOVERS TOON | KOTATSU-MIGROU DE CERISE / PRIORIDADE | HTTP 523 | 523 | 5805.9 | — | — | 1 | [https://loverstoon.net](https://loverstoon.net) | PENDENTE |
| 52 | LuratoonScan | Migração/legado a revalidar | [luratoons.net](https://luratoons.net) | SIM | KOTATSU-BROKEN / TEMPLATE ALTERADO | OK | 200 | 201.0 | 180.3 | 180.3 | 3 | [https://luratoons.net](https://luratoons.net) | PENDENTE |
| 53 | MaidScan | Web com parser indicado no inventário | [empreguetes.xyz](https://empreguetes.xyz) | SIM | KOTATSU-VERIFICAR | REDIRECT HOST CHANGE | 200 | 968.9 | — | — | 1 | [https://empreguetes.wtf/](https://empreguetes.wtf/) | PENDENTE |
| 54 | MaidSecret | Web com parser indicado no inventário | [maidsecret.com](https://maidsecret.com) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to ge... | PENDENTE |
| 55 | MangaBr | Web com parser indicado no inventário | [mangabr.net](https://mangabr.net) | SIM | KOTATSU-BROKEN | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 56 | MangaClub PT-BR | Web sem parser indicado no inventário | [mangaclub.net/pt-br](https://mangaclub.net/pt-br) | NAO | NAO-KOTATSU | OK | 200 | 1126.8 | 1126.8 | 1127.2 | 3 | [https://www.mangaclub.net/pt-br](https://www.mangaclub.net/pt-br) | PENDENTE |
| 57 | MangaDex PT-BR | Web com parser indicado no inventário | [mangadex.org](https://mangadex.org) | SIM | KOTATSU-VERIFICAR / MULTI-PTBR | CHALLENGE | 200 | 364.2 | — | — | 1 | [https://mangadex.org](https://mangadex.org) | PENDENTE |
| 58 | MangaFire PT-BR | Web com parser indicado no inventário | [mangafire.to](https://mangafire.to) | SIM | KOTATSU-VERIFICAR / MULTI-PTBR | CHALLENGE | 200 | 321.9 | — | — | 1 | [https://mangafire.to](https://mangafire.to) | PENDENTE |
| 59 | Manga Livre | Migração/legado a revalidar | parser atual aponta para domínio legado | SIM | KOTATSU-VERIFICAR / REVALIDAR DOMÍNIO / PRIORIDADE | NO DIRECT URL | — | — | — | — | 0 | — | PENDENTE |
| 60 | MangaLivre.org | Migração/legado a revalidar | [mangalivre.org](https://mangalivre.org) | NAO COMO FONTE ATUAL | NAO-KOTATSU / NOME COLIDE COM PARSER ANTIGO | REDIRECT HOST CHANGE | 200 | 820.4 | — | — | 1 | [https://noxmangas.org/?utm_source=mangalivre](https://noxmangas.org/?utm_source=mangalivre) | PENDENTE |
| 61 | Manga Night | Web sem parser indicado no inventário | [manganight.com.br](https://manganight.com.br) | NAO | NAO-KOTATSU / PRIORIDADE | OK | 200 | 269.1 | 65.8 | 65.8 | 3 | [https://manganight.com.br](https://manganight.com.br) | PENDENTE |
| 62 | MangaNanquim | Web com parser indicado no inventário | [mangananquim.site](https://mangananquim.site) | SIM | KOTATSU-BROKEN | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 63 | MangaNinja | Web com parser indicado no inventário | [manganinja.com](https://manganinja.com) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [SSL: TLSV1_ALERT_INTERNAL_ERROR] tlsv1 alert internal error (_ssl.c:1081)> | PENDENTE |
| 64 | Manganex PT | Web sem parser indicado no inventário | [manganex.com/pt](https://manganex.com/pt) | NAO | NAO-KOTATSU / PRIORIDADE | OK | 200 | 2257.8 | 1749.8 | 1749.9 | 3 | [https://www.manganex.com/pt/](https://www.manganex.com/pt/) | PENDENTE |
| 65 | Mangas Brasuka | Web sem parser indicado no inventário | [mangasbrasuka.org](https://mangasbrasuka.org) | NAO | NAO-KOTATSU / PRIORIDADE | CHALLENGE | 403 | 263.6 | — | — | 1 | [https://mangasbrasuka.org](https://mangasbrasuka.org) | PENDENTE |
| 66 | MangasChan | Migração/legado a revalidar | [mangaschan.net](https://mangaschan.net) | SIM | KOTATSU-BROKEN / SITE ANTIGO | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 67 | MangasOnline | Web com parser indicado no inventário | [mangasonline.cc](https://mangasonline.cc) | SIM | KOTATSU-BROKEN | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 68 | MangaOnline | Web com parser indicado no inventário | [mangaonline.blog](https://mangaonline.blog) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 69 | MangaOnline.biz | Web com parser indicado no inventário | [mangaonline.biz](https://mangaonline.biz) | SIM | KOTATSU-VERIFICAR | TIMEOUT | — | — | — | — | 1 | URLError: <urlopen error timed out> | PENDENTE |
| 70 | MangaTanko PT-BR | Web sem parser indicado no inventário | [mangatanko.com/pt_br](https://mangatanko.com/pt_br) | NAO | NAO-KOTATSU | OK | 200 | 1626.3 | 1455.2 | 1455.2 | 3 | [https://www.mangatanko.com/pt_br/](https://www.mangatanko.com/pt_br/) | PENDENTE |
| 71 | MangaTerra | Web com parser indicado no inventário | [manga-terra.com](https://manga-terra.com) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 72 | Manhastro | Web com parser indicado no inventário | [manhastro.net](https://manhastro.net) | SIM | KOTATSU-VERIFICAR | CHALLENGE | 200 | 488.4 | — | — | 1 | [https://manhastro.net](https://manhastro.net) | PENDENTE |
| 73 | MediocreToons | Web com parser indicado no inventário | [mediocretoons.com](https://mediocretoons.com) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 74 | MiniTwoScan | Web com parser indicado no inventário | [minitwoscan.com](https://minitwoscan.com) | SIM | KOTATSU-VERIFICAR | CHALLENGE | 403 | 598.0 | — | — | 1 | [https://minitwoscan.com](https://minitwoscan.com) | PENDENTE |
| 75 | MomonohanaScan | Web com parser indicado no inventário | [momonohanascan.com](https://momonohanascan.com) | SIM | KOTATSU-BROKEN | REDIRECT HOST CHANGE | 200 | 3733.0 | — | — | 1 | [http://ww38.momonohanascan.com/](http://ww38.momonohanascan.com/) | PENDENTE |
| 76 | MoonLoversScan | Web com parser indicado no inventário | [moonloversscan.com.br](https://moonloversscan.com.br) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 77 | MoonWitchinScan | Web com parser indicado no inventário | [moonwitchscan.com.br](https://moonwitchscan.com.br) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 78 | MrBenne | Web com parser indicado no inventário | [mrbenne.com](https://mrbenne.com) | SIM | KOTATSU-VERIFICAR | OK | 200 | 1084.1 | 849.6 | 849.7 | 3 | [https://www.mrbenne.com/](https://www.mrbenne.com/) | PENDENTE |
| 79 | MugiwarasOficial | Web com parser indicado no inventário | [mugiwarasoficial.com](https://mugiwarasoficial.com) | SIM | KOTATSU-VERIFICAR | CHALLENGE | 403 | 282.9 | — | — | 1 | [https://mugiwarasoficial.com](https://mugiwarasoficial.com) | PENDENTE |
| 80 | NeoxScans | Migração/legado a revalidar | domínio legado ligado ao Manga Livre | SIM | KOTATSU-BROKEN | NO DIRECT URL | — | — | — | — | 0 | — | PENDENTE |
| 81 | Neroxus | Web com parser indicado no inventário | [neroxus.com.br](https://neroxus.com.br) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 82 | Nexus Mangás | Web sem parser indicado no inventário | [nexusmangas.com](https://nexusmangas.com) | NAO | NAO-KOTATSU / PRIORIDADE | OK | 200 | 210.8 | 196.3 | 196.3 | 3 | [https://www.nexusmangas.com/](https://www.nexusmangas.com/) | PENDENTE |
| 83 | NinjaComics | Web com parser indicado no inventário | [ninjacomics.xyz](https://ninjacomics.xyz) | SIM | KOTATSU-VERIFICAR | OK | 200 | 79.5 | 85.8 | 86.4 | 3 | [https://ninjacomics.xyz](https://ninjacomics.xyz) | PENDENTE |
| 84 | NirvanaScan | Web com parser indicado no inventário | [nirvanascan.com](https://nirvanascan.com) | SIM | KOTATSU-VERIFICAR | OK | 200 | 7799.7 | 478.1 | 478.3 | 3 | [https://nirvanascan.com](https://nirvanascan.com) | PENDENTE |
| 85 | NocturneSummer | Web com parser indicado no inventário | [nocfsb.com](https://nocfsb.com) | SIM | KOTATSU-VERIFICAR | OK | 200 | 864.1 | 855.3 | 877.3 | 3 | [https://nocfsb.com](https://nocfsb.com) | PENDENTE |
| 86 | NoindexScan | Web com parser indicado no inventário | [noindexscan.com](https://noindexscan.com) | SIM | KOTATSU-VERIFICAR | OK | 200 | 309.9 | 291.6 | 291.8 | 3 | [https://noindexscan.com](https://noindexscan.com) | PENDENTE |
| 87 | Norterose | Web com parser indicado no inventário | [norterose.com.br](https://norterose.com.br) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 88 | NoxManga / NoxToons | Migração/legado a revalidar | [noxtoons.com / domínio atual a validar](https://noxtoons.com) | NAO | NAO-KOTATSU / MIGROU / PRIORIDADE | OK | 200 | 1048.6 | 795.4 | 795.6 | 3 | [https://noxtoons.com](https://noxtoons.com) | PENDENTE |
| 89 | Origami Orpheans | Web com parser indicado no inventário | [origami-orpheans.com](https://origami-orpheans.com) | SIM | KOTATSU-VERIFICAR | HTTP 200 · página de suspensão | 200 | 943.6 | 1762.4 | 1803.3 | 3 | [https://origami-orpheans.com/cgi-sys/suspendedpage.cgi](https://origami-orpheans.com/cgi-sys/suspendedpage.cgi) | PENDENTE |
| 90 | PassamaoScan | Web com parser indicado no inventário | [passamaoscan.com](https://passamaoscan.com) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 91 | PirulitoRosa | Migração/legado a revalidar | [pirulitorosa.site](https://pirulitorosa.site) | SIM | KOTATSU-VERIFICAR / REVALIDAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [SSL: TLSV1_ALERT_INTERNAL_ERROR] tlsv1 alert internal error (_ssl.c:1081)> | PENDENTE |
| 92 | PlumaComics | Web com parser indicado no inventário | [plumacomics.cloud](https://plumacomics.cloud) | SIM | KOTATSU-VERIFICAR | HTTP 200 · página de manutenção | 200 | 463.3 | 415.0 | 415.0 | 3 | [https://plumacomics.cloud/manutencao](https://plumacomics.cloud/manutencao) | PENDENTE |
| 93 | PointZero Toons | Web com parser indicado no inventário | [pointzerotoons.com](https://pointzerotoons.com) | SIM | KOTATSU-VERIFICAR | OK | 200 | 1044.0 | 946.7 | 946.8 | 3 | [https://pointzerotoons.com](https://pointzerotoons.com) | PENDENTE |
| 94 | ProjetoScanlator | Web com parser indicado no inventário | [projetoscanlator.com](https://projetoscanlator.com) | SIM | KOTATSU-BROKEN | OK | 200 | 1276.2 | 1003.9 | 1004.0 | 3 | [https://projetoscanlator.com](https://projetoscanlator.com) | PENDENTE |
| 95 | PsUnicorn | Web com parser indicado no inventário | [psunicorn.com](https://psunicorn.com) | SIM | KOTATSU-BROKEN | HTTP 200 · tela de login protegida | 200 | 656.1 | 413.9 | 414.2 | 3 | [https://psunicorn.com/?password-protected=login&redirect_to=https%3A%2F%2Fpsunicorn.com%2F](https://psunicorn.com/?password-protected=login&redirect_to=https%3A%2F%2Fpsunicorn.com%2F) | PENDENTE |
| 96 | RainbowFairyScan | Web com parser indicado no inventário | [rainbowfairyscan.com](https://rainbowfairyscan.com) | SIM | KOTATSU-BROKEN | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 97 | RaysScan | Web com parser indicado no inventário | [raysscan.blogspot.com](https://raysscan.blogspot.com) | SIM | KOTATSU-VERIFICAR | HTTP 404 | 404 | 1308.6 | — | — | 1 | [https://raysscan.blogspot.com/?m=1](https://raysscan.blogspot.com/?m=1) | PENDENTE |
| 98 | ReMangas / WiComix | Migração/legado a revalidar | [remangas.net / WiComix](https://remangas.net) | SIM | KOTATSU-BROKEN / MIGROU-ECOSSISTEMA | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 99 | RogMangas | Web com parser indicado no inventário | [rogmangas.com](https://rogmangas.com) | SIM | KOTATSU-BROKEN | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 100 | Sakura Mangás | Web sem parser indicado no inventário | [sakuramangas.org](https://sakuramangas.org) | NAO | NAO-KOTATSU / PRIORIDADE / PARSER COMPLEXO | CHALLENGE | 403 | 77.1 | — | — | 1 | [https://sakuramangas.org](https://sakuramangas.org) | PENDENTE |
| 101 | SilenceScan | Web com parser indicado no inventário | [silencescan.com.br](https://silencescan.com.br) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 102 | SinensisScans | Migração/legado a revalidar | [sinensis.leitorweb.com](https://sinensis.leitorweb.com) | SIM | KOTATSU-BROKEN / TEMPLATE ALTERADO | OK | 200 | 1157.2 | 1055.9 | 1056.0 | 3 | [https://sinensis.leitorweb.com](https://sinensis.leitorweb.com) | PENDENTE |
| 103 | SolooScan | Web com parser indicado no inventário | [solooscan.blogspot.com](https://solooscan.blogspot.com) | SIM | KOTATSU-BROKEN | OK | 200 | 973.9 | 1154.6 | 1170.5 | 3 | [https://solooscan.blogspot.com/?m=1](https://solooscan.blogspot.com/?m=1) | PENDENTE |
| 104 | SsReading | Web com parser indicado no inventário | [ssreading.com.br](https://ssreading.com.br) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 105 | SussyScan | Web com parser indicado no inventário | [sussytoons.wtf](https://sussytoons.wtf) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 106 | TatakaeScans | Web com parser indicado no inventário | [tatakaescan.com](https://tatakaescan.com) | SIM | KOTATSU-VERIFICAR | REDIRECT HOST CHANGE | 200 | 531.5 | — | — | 1 | [https://mega288mae.com/](https://mega288mae.com/) | PENDENTE |
| 107 | TemakiMangas | Web com parser indicado no inventário | [temakimangas.blogspot.com](https://temakimangas.blogspot.com) | SIM | KOTATSU-VERIFICAR | OK | 200 | 1187.2 | 569.6 | 571.6 | 3 | [https://temakimangas.blogspot.com/?m=1](https://temakimangas.blogspot.com/?m=1) | PENDENTE |
| 108 | Tsundoku | Web com parser indicado no inventário | [tsundoku.com.br](https://tsundoku.com.br) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 109 | TyrantScans | Web com parser indicado no inventário | [www.tyrantscans.com](https://www.tyrantscans.com) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 110 | ValkyrieScan | Web com parser indicado no inventário | [valkyriescan.com](https://valkyriescan.com) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to ge... | PENDENTE |
| 111 | WickedWitchScan | Web com parser indicado no inventário | [wicked-witch-scan.com](https://wicked-witch-scan.com) | SIM | KOTATSU-VERIFICAR | OK | 200 | 899.8 | 899.8 | 899.8 | 3 | [https://wicked-witch-scan.com](https://wicked-witch-scan.com) | PENDENTE |
| 112 | WinterScan | Web com parser indicado no inventário | [winterscan.com](https://winterscan.com) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 113 | WolfScanBr | Web com parser indicado no inventário | [wolfscanbr.blogspot.com](https://wolfscanbr.blogspot.com) | SIM | KOTATSU-VERIFICAR | OK | 200 | 1101.0 | 867.2 | 869.1 | 3 | [https://wolfscanbr.blogspot.com/?m=1](https://wolfscanbr.blogspot.com/?m=1) | PENDENTE |
| 114 | WonderlandScan | Web com parser indicado no inventário | [wonderlandscan.com](https://wonderlandscan.com) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to ge... | PENDENTE |
| 115 | XsScan | Web com parser indicado no inventário | [xsscan.xyz](https://xsscan.xyz) | SIM | KOTATSU-VERIFICAR | REDIRECT HOST CHANGE | 200 | 10292.8 | — | — | 1 | [https://hemihydro.com/r/uapAdCMrq3rWvmQf7tuPzIoCgYMBW2WkekVPN_u_nxI_n2ooPCHPRKAZ_xN5592UD596os0rjwLsxHwHk9uUC_jQdQKZKAmfkgoBhdmkB4AB05nzUdpeW7P0qer_nnAaRaOR2_1cCPrIM4eFMop2I18yCXwEGu1Ifyvl_mmqepATa3egLeDqTSBDrkK0tx7CP23zrvZq5dPWfYYsz6i44rWpbz16ZtaNOBoq_G8oEOUX0ssLKU2FlRGYdGF4vghng3Cxp4vLN96Ihhd4pf1WigZ0J85it42AigVSokE2lOYnpMvEAkAalob92XHZtodX2psdwgkFCWWXDVlqRFXpcQ2k5qA77e1jXZpEAGeNXi590HVPErekCAox4disrZb4JE2716ACrtGv7azhXHeRHyZl5KVg_45BasXZrxsz1eFhKh5cclRrhDM2FGl-EIX5HDwfB7YAQOchOYETdQ07gNtohoLoWqRh_43dJdjYanG6X0MVvaDg-QE7EoI87X4d0FILf357VLiW68hXs-OSgAvorE2XB4dc6EfvLGXC1mkvqOScuZ1wIEdCM_3gms7XeYrUD9KLlItO-kHFQjjKFqmle-4LCBBb-tpNTFrI6biZ02N02UWSBW5IWvifLtnoaFFV7Svx5Vy5ETQQgKsDQ3r7RISO8YHzVDc1rZmnCMSTJVKueo3p3xQ38A6rhUEmmFsofuOXIsHAzyltazRFjDuW-8bWGfB1JHCBSjTxDAh8-R9hkKlUPA?ds=4c2cdc6ecf24d64366eb784cd5e010ea](https://hemihydro.com/r/uapAdCMrq3rWvmQf7tuPzIoCgYMBW2WkekVPN_u_nxI_n2ooPCHPRKAZ_xN5592UD596os0rjwLsxHwHk9uUC_jQdQKZKAmfkgoBhdmkB4AB05nzUdpeW7P0qer_nnAaRaOR2_1cCPrIM4eFMop2I18yCXwEGu1Ifyvl_mmqepATa3egLeDqTSBDrkK0tx7CP23zrvZq5dPWfYYsz6i44rWpbz16ZtaNOBoq_G8oEOUX0ssLKU2FlRGYdGF4vghng3Cxp4vLN96Ihhd4pf1WigZ0J85it42AigVSokE2lOYnpMvEAkAalob92XHZtodX2psdwgkFCWWXDVlqRFXpcQ2k5qA77e1jXZpEAGeNXi590HVPErekCAox4disrZb4JE2716ACrtGv7azhXHeRHyZl5KVg_45BasXZrxsz1eFhKh5cclRrhDM2FGl-EIX5HDwfB7YAQOchOYETdQ07gNtohoLoWqRh_43dJdjYanG6X0MVvaDg-QE7EoI87X4d0FILf357VLiW68hXs-OSgAvorE2XB4dc6EfvLGXC1mkvqOScuZ1wIEdCM_3gms7XeYrUD9KLlItO-kHFQjjKFqmle-4LCBBb-tpNTFrI6biZ02N02UWSBW5IWvifLtnoaFFV7Svx5Vy5ETQQgKsDQ3r7RISO8YHzVDc1rZmnCMSTJVKueo3p3xQ38A6rhUEmmFsofuOXIsHAzyltazRFjDuW-8bWGfB1JHCBSjTxDAh8-R9hkKlUPA?ds=4c2cdc6ecf24d64366eb784cd5e010ea) | PENDENTE |
| 116 | YanpFansub | Web com parser indicado no inventário | [trisalyanp.com](https://trisalyanp.com) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to ge... | PENDENTE |
| 117 | YcScan | Web com parser indicado no inventário | [ycscan.com](https://ycscan.com) | SIM | KOTATSU-VERIFICAR | TIMEOUT | — | — | — | — | 1 | TimeoutError: The read operation timed out | PENDENTE |
| 118 | Yomu Comics | Web com parser indicado no inventário | [yomucomics.com](https://yomucomics.com) | SIM | KOTATSU-BROKEN / PRIORIDADE | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [Errno 11001] getaddrinfo failed> | PENDENTE |
| 119 | Yomu Mangas | Web com parser indicado no inventário | [yomumangas.com](https://yomumangas.com) | SIM | KOTATSU-VERIFICAR | CHALLENGE | 403 | 61.3 | — | — | 1 | [https://yomumangas.com](https://yomumangas.com) | PENDENTE |
| 120 | YugenApp | Web com parser indicado no inventário | [yugenmangasbr.voblog.xyz](https://yugenmangasbr.voblog.xyz) | SIM | KOTATSU-VERIFICAR | NETWORK/TLS ERROR | — | — | — | — | 1 | URLError: <urlopen error [WinError 10061] Nenhuma conexão pôde ser feita porque a máquina de dest... | PENDENTE |
| 121 | ZScanlation | Web com parser indicado no inventário | [zscanlation.blogspot.com](https://zscanlation.blogspot.com) | SIM | KOTATSU-BROKEN | OK | 200 | 976.2 | 593.2 | 594.7 | 3 | [https://zscanlation.blogspot.com/?m=1](https://zscanlation.blogspot.com/?m=1) | PENDENTE |
| 122 | MANGA Plus PT-BR | Oficial/distribuição | [mangaplus.shueisha.co.jp](https://mangaplus.shueisha.co.jp) | SIM | KOTATSU-VERIFICAR / OFICIAL / PRIORIDADE | OK | 200 | 900.9 | 853.2 | 853.3 | 3 | [https://mangaplus.shueisha.co.jp](https://mangaplus.shueisha.co.jp) | PENDENTE |
| 123 | JBC Digital | Oficial/distribuição | distribuição via Kindle/Kobo/Google Play/Apple Books | NAO | OFICIAL / NÃO É FONTE WEB TRADICIONAL | NO DIRECT URL | — | — | — | — | 0 | — | PENDENTE |

## Notas

- “Sem URL direta” cobre referências como fonte própria, domínio legado descrito sem hostname ou distribuição por lojas sem página única.
- Redirecionamento para outro host exige confirmar que é a identidade/domínio atual da fonte; não foi presumido como migração válida.
- Os marcadores de CAPTCHA/desafio são heurísticos e foram procurados apenas nos primeiros 8 KiB; um HTTP 200 ainda pode servir conteúdo bloqueado ou incompleto.
- As categorias e tags do inventário original foram preservadas. A checagem HTTP não confirma conteúdo PT-BR, catálogo, capítulos, páginas, parser ou funcionalidade no app.
- Todas as linhas permanecem PENDENTE para validação no Kazuji.
