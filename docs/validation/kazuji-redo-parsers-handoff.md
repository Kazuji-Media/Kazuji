# Handoff — parsers Redo no Kazuji

Atualizado em 2026-11-10 (America/Sao_Paulo).

**Status da correção: implementada e publicada; validação funcional parcial.**

## Continuação remota

O trabalho está salvo nas branches abaixo. O pin do app permanece no commit de correção
`be2b54c3daedbb88a084973e34868ecc5d450e92`, cuja dependência remota foi compilada e testada.
O snapshot completo do Redo também salva mudanças anteriores de BorutoExplorer, HuntersScan e NinjaScan.

```bash
git clone --branch agent/nexusmangas-actions-test https://github.com/Kazuji-Media/Kazuji.git Kazuji
git clone --branch agent/issue-8-chapter-batches https://github.com/Kazuji-Media/kotatsu-parsers-redo.git kotatsu-parsers-redo
cd Kazuji
# Com JDK 17 e Android SDK configurados:
./gradlew testDebugUnitTest assembleDebug --no-configuration-cache
```

- [Branch do Kazuji](https://github.com/Kazuji-Media/Kazuji/tree/agent/nexusmangas-actions-test).
- [Branch do Redo](https://github.com/Kazuji-Media/kotatsu-parsers-redo/tree/agent/issue-8-chapter-batches).
- [Status resumido dos parsers](https://github.com/Kazuji-Media/kotatsu-parsers-redo/blob/agent/issue-8-chapter-batches/docs/STATUS-LEITORDEMANGA-MANGASBRASUKAS.md).
- O workflow de validação pendente no worktree auxiliar foi preparado para a branch
  `agent/fontes-pt-br-apk` do Kazuji. Ela preserva o trabalho de planejamento/lote anterior separadamente.
- Os worktrees auxiliares limpos também estão no remoto: `agent/issue-8-parser-pin` no Kazuji (`ad68716dc`)
  e `agent/issue-8-chapter-batches-pr` no Redo (`6dec796c`). São snapshots anteriores; a continuação atual usa
  as duas branches principais indicadas nos comandos de clone.

Worktrees locais e anexos temporários da conversa são ignorados pelo Git. O handoff e a captura relevante
estão versionados em `docs/validation`, acessíveis sem esses diretórios locais.

## Resultado e critério de conclusão

O objetivo continua incompleto: falta comprovar imagens reais de Dandadan no leitor do Kazuji para
**Leitor de Mangás** e **Mangas Brasukas**. Compilação, fixtures e catálogo não comprovam leitura.
O APK permanece candidato de validação; entregar como concluído somente depois dessa comprovação nas duas fontes.

## Repositórios e commits

- Kazuji: `C:/Users/gabri/Documents/João/projetos-desenvolvimento/Kazuji`, branch
  `agent/nexusmangas-actions-test`, HEAD inicial `4b766f993`.
- Redo: `C:/Users/gabri/Documents/João/projetos-desenvolvimento/kotatsu-parsers-redo`, branch
  `agent/issue-8-chapter-batches`.
- Novo commit Redo: **`be2b54c3daedbb88a084973e34868ecc5d450e92`**, `fix(pt): wait for hydrated catalog content`.
  Push concluído e ref remoto confirmado pelo conector GitHub.
- Snapshot completo do Redo: **`b88f5754cc7f6b66042e3cceee0e5ef8bedaa752`**,
  `chore: save parser sources, automation and validation status`.
- Snapshot do worktree auxiliar do Kazuji: **`2dc1f5a3bb7d55528502434298a13d0346b9726d`**,
  na branch `agent/fontes-pt-br-apk`.
- O repositório remoto mudou para [Kazuji-Media/kotatsu-parsers-redo](https://github.com/Kazuji-Media/kotatsu-parsers-redo).
  O origin local antigo redirecionou o push corretamente. Não foi alterado.
- Commits anteriores preservados: `acfb6b6f` (fixtures) e `b25bc199` (detecção de barreira de AdBlock).

O commit novo inclui somente `LeitorDeManga.kt` e `MangaCatalogParserSearchTest.kt`.
Alterações anteriores em BorutoExplorer, HuntersScan, NinjaScan, workflows e outros arquivos foram preservadas.
O conflito preexistente de stash em `.github/workflows/nightly.yml` foi resolvido para o snapshot solicitado:
mantiveram-se os pacotes explícitos do SDK 36 e a preparação validada de assinatura. Não havia merge/rebase ativo.
As outras mudanças de app, workflows, assinatura Dev, links e documentação foram incluídas a pedido do usuário.
Os workflows foram verificados sintaticamente; os fluxos de assinatura Dev/release e publicação não foram executados.

## Correções comprovadas nesta retomada

1. **Busca antes da renderização:** o JavaScript concluía a primeira página mesmo sem cards.
   Agora aguarda links de obras ou indicação explícita de busca vazia.
2. **Capa opcional:** cards sem `data-kotatsu-cover` derrubavam a busca. A capa agora usa leitura nullable.
3. **Zero capítulos inicial:** o JavaScript aceitava `Capítulos (0)` antes da hidratação.
   Agora só encerra imediatamente por contagem coincidente quando o total é positivo.
   Uma lista que permaneça realmente vazia usa o limite de espera já existente.

Reprodução no Android antes das correções:

```text
searchWaitsForHydrationBeforeReturningFirstPage:
  LEITORDEMANGA expected:<[Dandadan]> but was:<[]>
Após a primeira correção:
  Cannot get relative url for data-kotatsu-cover: ""
detailsWaitsForHydrationBeforeAcceptingZeroChapters:
  expected:<[1.0, 2.0]> but was:<[]>
```

Após as três correções, as três regressões instrumentadas passaram. Os testes executam o JavaScript
de produção em Android WebView com HTML local e renderização atrasada, sem depender dos sites.
O fixture fornece ao script a URL da fonte para reproduzir `location.pathname` sem acesso à rede.

## Estado local do Kazuji

- `gradle/libs.versions.toml`: pin atualizado para o SHA completo `be2b54c3daedbb88a084973e34868ecc5d450e92`;
  Material `1.14.0` estável, conforme alteração herdada.
- `themes.xml`: mantém `Theme.Material3Expressive.DayNight.NoActionBar`, que corrigiu o crash herdado.
- `AdBlock.kt`: mantém a exceção autorizada somente para `leitordemangas.com`, `mangasbrasuka.org`
  e seus subdomínios. Os dois unit tests de domínio passaram. A liberação do capítulo em runtime continua pendente.
- Novos arquivos locais desta retomada:
  - `app/src/androidTest/kotlin/io/github/kazuji/core/parser/MangaCatalogRenderingTest.kt`;
  - `app/src/androidTest/kotlin/io/github/kazuji/core/parser/MangaCatalogLiveTest.kt`.
- O teste ao vivo exige `liveCatalogValidation=true`; normalmente é ignorado. Busca Dandadan, exige capítulos e
  páginas não vazios, abre `ReaderActivity` em modo anônimo e aguarda uma imagem visível pronta para exibição.
  As capturas, quando o teste chega ao leitor, ficam no diretório externo do app como `live-catalog-<fonte>.png`.
- `gradle.properties` foi preservado. O override de caminho com acentos foi fornecido pelo ambiente dos comandos.

## Validações

| Verificação | Resultado |
| --- | --- |
| Fixtures Redo: busca, completude, ação manual | **18 testes, zero falhas** (6 + 5 + 7) |
| Fixtures do snapshot completo: inclui Nexus, BorutoExplorer, HuntersScan e NinjaScan | **41 testes, zero falhas** |
| Unit tests Kazuji | **45 testes, zero falhas, 1 ignorado** |
| Android WebView: busca atrasada nas duas fontes, detalhes atrasados, busca vazia | **3 testes passaram** |
| Build Kazuji com `-PuseLocalParsers=true` | **assembleDebug passou** |
| Testes ao vivo exigindo imagem no leitor | **2 falharam em barreira Cloudflare; leitura não comprovada** |
| Build padrão com pin remoto, sem checkout local | **testDebugUnitTest + assembleDebug passaram com JDK 17** |
| Workflows publicados | **10 arquivos YAML e 39 passos shell verificados sintaticamente** |

A execução conjunta tem status Gradle `FAILED` por causa dos dois testes ao vivo. Os unit tests e
`assembleDebug` terminaram com sucesso nessa mesma execução; não apresentar a suíte inteira como aprovada.

A build padrão também foi verificada separadamente com o artefato do JitPack fixado no SHA completo, sem
`useLocalParsers`. Terminou com `BUILD SUCCESSFUL` em 1 min 19 s, com 45 testes, zero falhas e um ignorado.
A primeira tentativa expirou no POM; após o JitPack disponibilizá-lo com HTTP 200, uma tentativa com JDK 21
compilou o código, mas falhou no executor ao carregar todas as classes de testes. Repetir com JDK 17 passou.
Isso registra uma diferença de ambiente; a causa dessa falha do executor não foi investigada nesta tarefa.

APK candidato dessa build padrão: `app/build/outputs/apk/debug/app-debug.apk`, 51.896.947 bytes,
SHA-256 `1d5cbcfa6acd648c809c1330f62ecd9564bd4081246f5a9c814fe16e84bdffb0`.
Esse arquivo não foi entregue como leitura validada.

O handoff anterior registrava 21 testes instrumentados gerais, com 6 falhas em Room/migrações, histórico/shortcuts,
workers e backup/tags. Essas falhas não foram corrigidas nem comparadas com baseline nesta retomada.

## Evidência ao vivo e bloqueio atual

- Mangas Brasukas: uma execução encontrou Dandadan e extraiu **256 capítulos**, incluindo `/manga/dandadan/1`.
  A chamada de páginas falhou com `No chapter pages found`; a abertura do capítulo no navegador integrado
  mostrou Cloudflare. Nenhuma imagem foi validada.
- Leitor de Mangás: catálogo e busca por Dandadan chegaram a carregar na interface do app depois de aguardar.
  Uma abertura de detalhes terminou com “No chapters”; esse resultado não confirma uma lista realmente vazia.
- Na última rodada instrumentada conjunta, **as duas buscas** retornaram página `Just a moment...`,
  `Performing security verification`, sem imagens; o parser levantou `InteractiveActionRequiredException`.
- A página também exibia “Verification successful. Waiting for ... to respond”, mas continuava sendo
  documento de verificação. Isso não foi considerado acesso liberado.
- Um retry direto pelo runner instalado também falhou nas duas fontes, conforme `kazuji-live-retry.log`.
- O fluxo real **Continue → BrowserActivity → Feito** foi exercitado no catálogo do Leitor de Mangás:
  o catálogo estava visível e o retorno por Feito recarregou os resultados no app.
- Depois, a navegação da página da obra pelo botão **Começar a ler** chegou ao capítulo 1. O site mostrou
  **“Um passo para ler / Bloqueador detectado / Verificar novamente”**, mesmo com anúncio visível e com a
  exceção de domínio no APK. **Verificar novamente** manteve a barreira. Não foi iniciado anúncio nem assinatura.
- A captura desse estado está em [leitor-dandadan-adblock-gate.png](leitor-dandadan-adblock-gate.png).
  Foi solicitada ajuda humana para concluir o acesso no emulador; nenhuma liberação foi confirmada.

Preservar a exigência de ação humana para desafios e anúncios. Nenhuma extensão de navegador foi alterada;
não contornar o bloqueio de acesso a `chrome://extensions` por comandos ou outra interface.
O usuário já autorizou a exceção de AdBlock limitada aos dois domínios; não repetir essa solicitação.

## Comandos e ambiente que funcionaram

No PowerShell, para builds locais com o checkout do Redo:

```powershell
$env:JAVA_HOME = 'C:/Program Files/Microsoft/jdk-17.0.18.8-hotspot'
$env:ANDROID_HOME = 'C:/Users/gabri/AppData/Local/Android/Sdk'
${env:ORG_GRADLE_PROJECT_android.overridePathCheck} = 'true'
.\gradlew.bat testDebugUnitTest assembleDebug -PuseLocalParsers=true --no-configuration-cache --offline
.\gradlew.bat connectedDebugAndroidTest -PuseLocalParsers=true `
  '-Pandroid.testInstrumentationRunnerArguments.class=io.github.kazuji.core.parser.MangaCatalogRenderingTest' `
  --no-configuration-cache --offline
```

O Redo e seu buildSrc exigem JDK 17. Informar `JAVA_HOME` funcionou; o JDK 21 padrão sozinho não foi descoberto
como toolchain compatível. A variável Gradle com ponto precisa de `${env:...}` no PowerShell.

Para repetir a leitura sem recompilar, com os APKs de teste já instalados:

```powershell
& 'C:/Users/gabri/AppData/Local/Android/Sdk/platform-tools/adb.exe' shell am instrument -w -r `
  -e class io.github.kazuji.core.parser.MangaCatalogLiveTest `
  -e liveCatalogValidation true io.github.kazuji.debug.test/io.github.kazuji.HiltTestRunner
```

Um exit code zero do comando ADB não prova aprovação: conferir `FAILURES!!!`, códigos de status e resultados.
Logs `LIVE_CATALOG` registram URL/etapa, contagens, texto público retornado e `readerImageLoaded=true` se aprovado.

Evitar builds simultâneas de Kazuji e Redo: o daemon do build composto manteve o JAR do Redo aberto no Windows.
Após a build terminar, `.\gradlew.bat --stop` no Kazuji liberou o arquivo; a repetição das fixtures passou.

As evidências necessárias para continuar remotamente estão versionadas em [evidence/](evidence/):

- [Build padrão e unit tests aprovados](evidence/kazuji-pinned-jdk17-build.txt).
- [41 fixtures do snapshot completo](evidence/redo-snapshot-fixtures.txt).
- [Regressões instrumentadas e falhas live](evidence/kazuji-catalog-all-fixed.txt).
- [Retry live](evidence/kazuji-live-retry.txt).
- XMLs completos em `evidence/unit-tests/`, `evidence/parser-fixtures/` e `evidence/instrumented/`.
- As reproduções anteriores e a falha do executor padrão também estão nesse diretório como arquivos `.txt`.

Os logs originais desta sessão continuam em `C:/Users/gabri/AppData/Local/Temp/`:

- `kazuji-catalog-rendering.log`: reprodução original da busca vazia;
- `kazuji-catalog-rendering-cover-fixed.log`: busca corrigida, reprodução de zero capítulos;
- `kazuji-catalog-all-fixed.log`: 3 regressões aprovadas, unit tests/assemble aprovados, 2 testes live bloqueados;
- `redo-final-fixtures.log`: 18 fixtures aprovadas;
- `redo-snapshot-fixtures.log`: 41 fixtures das sete classes de fontes alteradas aprovadas;
- `kazuji-live-retry.log`: repetição direta dos testes live;
- `kazuji-pinned-build.log`: build com dependência remota, sem checkout local.
- `kazuji-pinned-jdk17-build.log`: build padrão e unit tests aprovados com JDK 17.

## Próximo passo

1. No navegador integrado do Kazuji, concluir manualmente a verificação necessária do site.
   No fluxo assistido, retornar por **Feito** para permitir o retry; Voltar/fechar significa cancelamento.
2. Repetir a leitura ao vivo nas duas fontes. Exigir busca, detalhes completos, páginas e imagem real no leitor.
3. Se o site estiver comprovadamente liberado e ainda falhar, registrar a resposta real e criar uma regressão
   correspondente antes de modificar novamente o parser. “No chapters” ou “No chapter pages found” não são sucesso.
4. Somente após leitura confirmada nas duas fontes, identificar SHA-256/build do APK final e entregá-lo.
