# Tarefas — fontes PT-BR no Kazuji/Kotatsu

Backlog mantido neste arquivo local, conforme solicitado. Nenhuma issue foi criada.

## Prioridade 1 — Nexus Mangás

- [ ] Validar no APK real a busca por **One Piece**, conferindo título, capa e URL dos resultados.
- [ ] Abrir os detalhes e confirmar que todos os capítulos são extraídos, inclusive os itens carregados pela lista virtualizada; comparar com o total anunciado no site.
- [ ] Abrir um capítulo e conferir quantidade, ordem e URL das páginas, sem placeholders ou imagens da interface.
- [ ] Exercitar a barreira de acesso por anúncio e eventuais desafios/CAPTCHA pela BrowserActivity. Após a ação humana, repetir a operação do parser e confirmar a sessão/cookies.
- [x] Se a barreira continuar ativa, mostrar uma falha recuperável em vez de sucesso com lista vazia. O parser reconhece a tela de anúncio; capítulo sem imagens agora gera `ParseException`. Não clicar nem contornar anúncios automaticamente.
- [ ] Registrar modelo do aparelho, versão do APK e resultados observados; transformar falhas reproduzíveis em testes.

## Prioridade 2 — fluxo de navegador, CAPTCHA e anúncios

- [x] Fazer a BrowserActivity distinguir conclusão bem-sucedida de cancelamento/fechamento; só tentar novamente como sucesso quando a ação terminou.
- [x] Garantir que cookies da WebView estejam persistidos e disponíveis antes de repetir uma requisição do parser.
- [x] Na BrowserActivity, explicar que o AdBlock pode bloquear conteúdo necessário sem alterar a configuração automaticamente. Teste com AdBlock ligado/desligado ainda pendente no aparelho.
- [x] Usar o fluxo Cloudflare existente como referência para desafios reconhecidos; manter separada a barreira de anúncio recompensado do Nexus.
- [ ] Confirmar o comportamento de retry em uma nova chamada do parser, inclusive quando a barreira não foi resolvida.

## Prioridade 3 — novas fontes e parsers PT-BR

- [ ] Validar busca, detalhes, capítulos e páginas no **MangaClub PT-BR** e no **Manganex PT**.
- [ ] Revalidar o domínio e a extração de busca/capítulos/páginas de **LeitorDeManga** e **Mangas Brasukas**.
- [ ] Conferir no app o handoff manual do intersticial do LeitorDeManga e confirmar se a leitura continua após a ação do usuário; o parser foi ajustado para pedir a WebView em vez de tratar a tela como capítulo vazio.
- [ ] Confirmar o domínio atual do **Manga Livre** e de fontes migradas antes de remover ou reativar marcações `@Broken`.
- [ ] Para cada parser novo ou alterado, registrar seletores e respostas reais em fixtures e cobrir os casos de paginação e conteúdo vazio.

## Prioridade 4 — integração e distribuição

- [x] O workflow **Debug Build (PR)** no PR [joaovpimenta/Kazuji#1](https://github.com/joaovpimenta/Kazuji/pull/1) concluiu com sucesso para o commit `413fa19bd` e produziu `debug-apk` na [execução #6](https://github.com/joaovpimenta/Kazuji/actions/runs/36558153849). O artefato está disponível até 2026-10-06.
- [ ] Instalar o APK em aparelho/emulador e confirmar busca, detalhes, capítulos, páginas e fluxo de navegador no app.
- [ ] Depois de aceitar/mesclar as alterações do parser, manter `gradle/libs.versions.toml` apontando para o commit validado e retirar o uso do checkout local de desenvolvimento.

## Prioridade 5 — inventário de fontes

- [ ] Revalidar cada linha da lista original de fontes PT-BR: domínio atual, parser disponível no Kotatsu, idioma, busca, capítulos, páginas e estado `@Broken`.
- [ ] Para fontes migradas, registrar a relação entre nome antigo, domínio novo e parser substituto; evitar duplicatas por nomes colidentes.
- [ ] Para fontes oficiais ou sem parser, confirmar se oferecem uma fonte web compatível com o contrato dos parsers antes de implementar.
- [ ] Atualizar a tabela de inventário com resultado, data, versão do APK e prioridade; não marcar uma fonte como funcional sem teste no Kazuji.

## Execução em 2026-09-29

### Feito localmente

- `BrowserActivity.Contract` agora retorna `true` somente após o usuário tocar em **Feito**. Voltar/fechar a WebView retorna cancelamento e não repete a chamada como sucesso.
- Antes de concluir, o app chama `CookieManager.flush()`; o retry segue pelo resultado `true` já consumido por `ExceptionResolver`.
- A WebView interativa informa que o AdBlock pode impedir conteúdo necessário e aponta as configurações, sem mudar a preferência.
- No parser Nexus, páginas sem imagens válidas agora geram `ParseException`; o script escolhe uma URL real de imagem e ignora placeholders `data:`. O teste fixture também confirma que imagens de anúncio não entram na lista de páginas.
- Os parsers para MangaClub PT-BR, Manganex PT, LeitorDeManga, Mangas Brasukas e Manga Livre já existem no checkout local `kotatsu-parsers-redo`. MangaClub usa `www.mangaclub.net`; LeitorDeManga e Mangas Brasukas usam os domínios observados. Manga Livre segue marcado `@Broken`.
- `:app:assembleDebug` passou com o pin anterior `84c4eb78c9` e com `-PuseLocalParsers=true`, incluindo as alterações locais de Nexus. A compilação padrão local com o novo pin `8ad91f876f68` teve timeout lendo o POM do JitPack.
- A [execução GitHub Actions #6](https://github.com/joaovpimenta/Kazuji/actions/runs/36558153849) passou usando o pin `8ad91f876f68`. O artefato `debug-apk` (ID `11029366739`, SHA-256 do ZIP `f3186c8916e3b754f42b692099d304be81eb804ffee0e6fb73174a26182c7863`) pode ser baixado [aqui](https://github.com/joaovpimenta/Kazuji/actions/runs/36558153849/artifacts/11029366739) até 2026-10-06.
- A suíte focada `NexusMangasWebViewTest` passou após incluir os testes para páginas e resposta vazia.

### Verificações ao vivo e limites

- [Nexus One Piece](https://www.nexusmangas.com/obra/one-piece) mostra uma barreira que pede para assistir a um anúncio e promete acesso ao site por 24 horas. A validação foi interrompida nesse ponto; nenhum anúncio foi iniciado ou contornado.
- [MangaClub PT-BR](https://www.mangaclub.net/pt-br/) responde no domínio atual. A busca por One Piece encontra **One Piece PT-BR**; o detalhe lista 412 capítulos, inicialmente 10, e o controle do site carrega mais 10 por vez. O capítulo 412 exibe 19 imagens do leitor. Isso confirma o fluxo visível do site, não a extração pelo parser dentro do Kazuji.
- [Manganex PT](https://www.manganex.com/pt/) responde e exibe obras. A página de Dandadan indica 240 capítulos, carrega uma janela inicial de 10 e oferece **Carregar mais capítulos**. O capítulo 238 expõe imagens de leitura e publicidade de terceiros. Isso valida a estrutura visível do site, não o resultado do parser dentro do Kazuji.
- [Leitor de Mangás](https://leitordemangas.com/) responde no domínio atual. One Piece mostra 1193 capítulos, 10 carregados inicialmente e **Carregar mais 1183 restantes**. A página de capítulo mostra uma etapa de acesso (“Acesse aqui para continuar”) e uma oferta Premium; a ação não foi acionada.
- [Mangas Brasukas](https://mangasbrasuka.org/) responde no domínio atual. Blue Lock mostra 366 capítulos, 10 carregados inicialmente e **Carregar mais 356 restantes**. O resultado também é inspeção do site, ainda sem validação dentro do Kazuji.
- A tentativa anterior de consulta HTTP ao MangaClub retornou 403, mas a navegação pelo navegador funcionou e revelou o domínio atual `mangaclub.net`. O host legado `mangalivre.tv` não resolveu no navegador; `mangalivre.net` agora se identifica como portal para continuar leitura nas plataformas oficiais, sem catálogo/leitor próprio. O parser antigo de Manga Livre continua `@Broken`; não reativá-lo apontando para o portal.
- No Manganex, um anúncio flutuante de terceiros cobre parte do botão **Carregar mais capítulos** na janela observada. Nenhum anúncio foi acionado.
- Não havia dispositivo conectado. O AVD disponível não chegou a aparecer em `adb devices -l` e foi encerrado a pedido; por isso busca, detalhes, capítulos, páginas e AdBlock ainda não foram conferidos no APK instalado.
- O teste unitário Android do app compilou, mas o Gradle não conseguiu carregar nem o teste novo nem o teste existente `VersionIdTest` (`ClassNotFoundException` no executor). O build Debug, incluindo `compileDebugKotlin`, passou.
- A rodada completa do repositório de parsers foi interrompida após dezenas de falhas de conectividade/hosts em outros parsers; o escopo específico do Nexus passou. Não atribuí essas falhas ao Nexus nem considero a suíte global aprovada.

### Continuação em 2026-09-29

- Ajustei o parser compartilhado de LeitorDeManga/Mangas Brasukas para reconhecer o intersticial visível “Um passo para ler” e desafios de CAPTCHA/Cloudflare reconhecíveis, pedindo uma ação manual pela BrowserActivity. O parser não segue o link de continuação nem aciona anúncios automaticamente.
- Adicionei fixtures para intersticial, desafio Cloudflare e extração normal de imagens. A execução local do teste focado foi interrompida a pedido do usuário; esse ajuste ainda precisa de validação remota e no app.
- O commit `a4108617` foi publicado em `feature/nexusmangas-kotatsu` e o pin do Kazuji aponta para ele. Na execução remota [Debug Build #7](https://github.com/Kazuji-Reader/Kazuji/actions/runs/36562411113), para o commit `642b17250`, a tentativa #1 falhou com `SocketTimeoutException: Read timed out` ao baixar dependências; a tentativa #2 concluiu com sucesso. O artefato [debug-apk (ID `11031270287`)](https://github.com/Kazuji-Reader/Kazuji/actions/runs/36562411113/artifacts/11031270287) tem 38,9 MB, SHA-256 `12b69af3a7ccb48d5ce1edf7c18120d2dd91fbd13de27184cda843e9a3334380` e fica disponível até 2026-10-06.
- O repositório de parsers não executou essas fixtures no Actions: os workflows disponíveis são Discord Commit Webhook e Governance; o run de webhook após `a4108617` falhou em 9 s e não é um teste de código. As três fixtures continuam sem execução confirmada.
- A pedido do usuário, não executar novas builds APK, testes locais ou emulação. Usar GitHub Actions para a compilação e deixar a validação em aparelho para quando houver APK/dispositivo disponível.

### Ainda necessário para fechar o backlog

- Instalar o APK atualizado em aparelho/emulador; liberar manualmente a barreira do Nexus se quiser testar esse site; conferir os resultados dentro do Kazuji e com AdBlock ligado/desligado.
- Validar MangaClub, Manganex, LeitorDeManga, Mangas Brasukas e Manga Livre por busca, detalhes, capítulos e páginas no app. Confirmar domínio e conteúdo antes de alterar tags `@Broken`.
- Revalidar o inventário completo da lista original. Nenhuma fonte foi marcada como funcional apenas com base na inspeção do site.
- O commit `8ad91f876f68` e a execução #6 são a validação anterior do parser Nexus. O pin atual `a4108617` entrou no APK cuja compilação remota passou na execução #7. Esse workflow confirma que o APK compila, mas não executa as novas fixtures do parser nem substitui a validação de busca/leitura dentro do app. `useLocalParsers` continua disponível; a pedido do usuário, não executar builds, testes ou emulação localmente.

### Publicação do APK de validação

- O workflow **Debug Build (PR)** agora publica o APK de debug como pré-lançamento quando disparado manualmente com a opção habilitada. A execução [#11](https://github.com/Kazuji-Reader/Kazuji/actions/runs/36568740614) passou e publicou o [Kazuji Debug #11.1](https://github.com/Kazuji-Reader/Kazuji/releases/tag/debug-11-1-fbf99a356847f61fac74ab48cf6f50694614cdd6), asset `app-debug.apk` (42,3 MB; SHA-256 `d892faf115423dac2c5033372ed9970fdd04d8e160cb2b43e0d0a621b8705a76`). A correção da etapa de comentário foi enviada no commit `fbf99a356`.