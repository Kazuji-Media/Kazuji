# Revisão inicial do backlog para a spec guarda-chuva

Data: 2026-10-02 (America/Sao_Paulo).

## Destino

Revisar as issues, consolidar uma spec guarda-chuva e executá-la para resolver o máximo de issues com evidência de conclusão.

## Decisão pendente

O mantenedor ainda precisa definir quais repositórios compõem o esforço. A revisão de corpo, comentários, reprodução, redundância e critérios por issue será feita após essa definição. As tabelas dos projetos de origem são um inventário de candidatos, não uma classificação de prontidão nem uma confirmação de bugs no Kazuji.

## Inventário remoto observado

Consultas via conector GitHub: `repo:<owner>/<repo> is:issue is:open`, limite 100; todas as respostas ficaram abaixo desse limite. Pull requests não estão incluídos.

| Repositório | Issues abertas retornadas | Situação |
| --- | ---: | --- |
| Kazuji-Reader/Kazuji | 1 | Corpo, critérios e comentários revisados |
| Kazuji-Reader/kotatsu-parsers-redo | 0 | Sem issues abertas retornadas |
| Kazuji-Reader/kazuji-reader.github.io | 0 | Sem issues abertas retornadas |
| AppFuton/Futon | 14 | Candidatos de origem; escopo pendente |
| Kotatsu-Redo/kotatsu-parsers-redo | 21 | Candidatos de origem; escopo pendente |

## Issue da fork

[Inventário e validação das fontes PT-BR no Kazuji](https://github.com/Kazuji-Reader/Kazuji/issues/2): aberta, sem comentários, sem responsável; labels atuais `type:task`, `area:mobile`, `area:docs`.

Contém 123 registros com teste no app pendente. A coleta HTTP de 29/09/2026 não comprova funcionamento de busca/leitura. Critérios de encerramento incluem domínio/identidade/idioma, busca, detalhes e paginação, imagens em ordem, data, versão de APK e identificação do Android/aparelho. Barreiras de anúncio/CAPTCHA exigem ação manual. Nenhum critério foi considerado cumprido nesta revisão inicial.

Fronteiras possíveis: consolidar registros e evidências, validar fixtures existentes remotamente, testar o APK no aparelho, corrigir falhas reproduzidas e atualizar cada fonte. Isso pode resolver tarefas dentro da issue; não equivale a encerrar várias issues existentes.

## Candidatos do Futon

| Issue | Estado da revisão |
| --- | --- |
| [disabled source appear on search suggestion](https://github.com/AppFuton/Futon/issues/117) | Inventariada; verificar pertinência ao Kazuji |
| [Auto sync status to trackers](https://github.com/AppFuton/Futon/issues/116) | Inventariada; verificar pertinência ao Kazuji |
| [Better blacklist handling, ability to blacklist a tag found under a manga](https://github.com/AppFuton/Futon/issues/113) | Inventariada; verificar pertinência ao Kazuji |
| [Next-previous chapter scroll switching issue](https://github.com/AppFuton/Futon/issues/107) | Inventariada; verificar pertinência ao Kazuji |
| [reading progress percentage calculation](https://github.com/AppFuton/Futon/issues/102) | Inventariada; verificar pertinência ao Kazuji |
| [keiyoushi扩展设置添加](https://github.com/AppFuton/Futon/issues/98) | Inventariada; verificar pertinência ao Kazuji |
| [Importing Kotatsu backups not working properly](https://github.com/AppFuton/Futon/issues/53) | Inventariada; verificar pertinência ao Kazuji |
| [MangaFire still not working](https://github.com/AppFuton/Futon/issues/99) | Inventariada; verificar pertinência ao Kazuji |
| [extension manager improvements and more repositories](https://github.com/AppFuton/Futon/issues/93) | Inventariada; verificar pertinência ao Kazuji |
| [Download intervals customization](https://github.com/AppFuton/Futon/issues/87) | Inventariada; verificar pertinência ao Kazuji |
| [without CBZ format](https://github.com/AppFuton/Futon/issues/33) | Inventariada; verificar pertinência ao Kazuji |
| [Option to disable metadata look up for unsupported sources](https://github.com/AppFuton/Futon/issues/70) | Inventariada; verificar pertinência ao Kazuji |
| [Favorites Tab Grid View](https://github.com/AppFuton/Futon/issues/48) | Inventariada; verificar pertinência ao Kazuji |
| [Memory leaks when enabling all sources](https://github.com/AppFuton/Futon/issues/27) | Inventariada; verificar pertinência ao Kazuji |

## Candidatos de parsers Kotatsu-Redo

| Issue | Estado da revisão |
| --- | --- |
| [Voratoon 403](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/201) | Inventariada; verificar pertinência à fork |
| [BatCave (batcave.biz, English)](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/199) | Inventariada; verificar pertinência à fork |
| [WAF Challenge on comix](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/198) | Inventariada; verificar pertinência à fork |
| [Problem with the HentaiEnvy source.](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/194) | Inventariada; verificar pertinência à fork |
| [issue with the 3Hentai parser](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/190) | Inventariada; verificar pertinência à fork |
| [No value for image error in HentaiNexus parser](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/145) | Inventariada; verificar pertinência à fork |
| [nhentai broken](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/46) | Inventariada; verificar pertinência à fork |
| [Add support for komga server](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/138) | Inventariada; verificar pertinência à fork |
| [Mangatr Doesnt work](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/36) | Inventariada; verificar pertinência à fork |
| [Mangahub Source Request](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/75) | Inventariada; verificar pertinência à fork |
| [Xomanga source request](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/77) | Inventariada; verificar pertinência à fork |
| [kappabeast Translation source request](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/78) | Inventariada; verificar pertinência à fork |
| [Qtoon Source Request](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/62) | Inventariada; verificar pertinência à fork |
| [Sana Scans Source Request](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/61) | Inventariada; verificar pertinência à fork |
| [Mangahere source request](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/50) | Inventariada; verificar pertinência à fork |
| [Newtoki Source request](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/43) | Inventariada; verificar pertinência à fork |
| [hotcomics captcha doesn't work](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/39) | Inventariada; verificar pertinência à fork |
| [Site for fan translation of Twokinds into Russian](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/33) | Inventariada; verificar pertinência à fork |
| [Official website of the Twokinds webcomic](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/32) | Inventariada; verificar pertinência à fork |
| [Sadscans Doesnt Working](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/29) | Inventariada; verificar pertinência à fork |
| [TheBlank Doesnt Working](https://github.com/Kotatsu-Redo/kotatsu-parsers-redo/issues/26) | Inventariada; verificar pertinência à fork |

## Evidência local e limites

- App na branch `agent/nexusmangas-actions-test`, HEAD `4b766f993` no início da revisão.
- Há alterações existentes nos workflows e conflito de índice em `.github/workflows/nightly.yml`, com marcadores de aplicação de stash. Não é seguro assumir que se trata de merge/rebase em andamento. Nenhuma alteração existente foi resolvida ou descartada.
- Parsers na branch `agent/parser-work`, com alteração existente em `.github/workflows/discord.yml`.
- O app usa scripts Gradle Groovy e pin de parser `a4108617`, apesar do guia descrever Kotlin DSL. Não propor migração do build apenas por essa divergência.
- Existem testes fixture `NexusMangasWebViewTest` e `LeitorDeMangaBrowserActionTest`; presença de testes não confirma sua execução atual.
- O workflow debug local compila o APK e publica artefato; esse fluxo observado não executa os testes fixture dos parsers.
- `TAREFAS-PARSERS-KOTATSU.md` registra a instrução anterior de não executar builds, testes ou emulação localmente. Preservar esse limite até orientação nova; usar validação remota.
- O CLI `gh` falhou na consulta por proxy indisponível. O conector GitHub respondeu com sucesso e é o canal operacional disponível.

## Critérios para a futura spec

1. Cada issue incluída mantém link para sua origem e critérios verificáveis.
2. Agrupar correções por causa comum e dependências; priorizar desbloqueios e correções com validação disponível.
3. Distinguir implementado, validado, integrado e encerrado. Não usar a criação de novos tickets para inflar a contagem de issues resolvidas.
4. Issues de origem corrigidas na fork não são automaticamente resolvidas no projeto de origem; precisam de contribuição aceita lá para encerramento naquele repositório.
5. Manter decisões de produto em aberto explicitamente; não inventar requisitos de pedidos ambíguos.
6. Associar cada encerramento a evidência apropriada; builds não substituem teste funcional.
7. Preservar alterações existentes e isolar a execução quando o checkout não estiver limpo.

## Próximo passo

Definir escopo, revisar integralmente os itens incluídos e produzir a spec com histórias numeradas, dependências, decisões de implementação/teste e critérios por issue. Ainda não há spec completa nem execução de código iniciada.
