# Spec — Atualização automática de parsers e pré-release do Kazuji

**Status:** rascunho para revisão do mantenedor
**Escopo inicial:** acompanhar o parser mantido pela Kazuji e atualizar o app por pull request.

## Problem Statement

O Kazuji fixa a versão do parser em um commit para que cada build seja reproduzível. Quando a branch principal do repositório de parsers avança, o app continua usando o commit antigo até alguém atualizar manualmente o pin. O build de pull request compila um APK de validação, mas a publicação de uma pré-release ainda exige disparo manual.

Esse fluxo deixa correções e novas fontes disponíveis no parser sem chegar ao app, além de exigir que o mantenedor repita a descoberta do commit, a alteração da versão, o build e a publicação.

## Solution

Adicionar automação no repositório do Kazuji que verifique periodicamente o commit mais recente da branch principal do repositório de parsers da Kazuji. Quando o commit for diferente do pin atual, a automação prepara uma atualização isolada e abre ou atualiza um único pull request para `devel`.

O pull request deve compilar o APK de debug e permanecer sujeito à revisão humana. Depois que a atualização for aprovada e integrada em `devel`, uma execução bem-sucedida deve publicar uma pré-release de debug com o APK e a identificação dos commits usados.

Nenhuma atualização é integrada automaticamente, e nenhuma versão estável é publicada por esse fluxo.

## User Stories / Histórias de usuário

1. Como leitor, quero receber no Kazuji as correções e fontes novas já integradas ao parser, sem depender de uma atualização manual do pin.
2. Como mantenedor, quero que cada atualização proposta mostre o SHA completo do parser, para identificar exatamente o código que será incluído.
3. Como mantenedor, quero revisar a atualização em um pull request separado, para decidir quando o parser entra em `devel`.
4. Como mantenedor, quero receber um build de debug ligado ao pull request, para confirmar que a combinação do app e do parser compila.
5. Como testador, quero uma pré-release depois da integração aprovada, para instalar e verificar o app com o parser atualizado.
6. Como mantenedor, quero que a automação não abra um pull request quando o pin já aponta para o commit mais recente.
7. Como mantenedor, quero que indisponibilidade do repositório ou falha no build impeça a publicação e mostre uma causa acionável.
8. Como mantenedor, quero poder disparar a verificação manualmente, para atualizar o parser fora do calendário ou repetir uma execução.
9. Como mantenedor, quero que cada pré-release registre o SHA do app e do parser, para reproduzir e diagnosticar o APK publicado.

## Implementation Decisions

- **Repositório de origem:** usar `Kazuji-Media/kotatsu-parsers-redo`, mantido pela Kazuji, e consultar sua branch padrão `master`. Não seguir commits apenas locais ou branches não integradas.
- **Versão:** gravar o SHA completo de 40 caracteres do commit do parser, mantendo os builds reproduzíveis.
- **Cadência proposta:** verificar semanalmente e permitir execução manual. A frequência exata fica pendente de confirmação.
- **Pull request:** direcionar para `devel`, alterar somente o pin do parser e manter no máximo um PR de atualização automática aberto. Se já existir um, atualizar a mesma branch/PR.
- **Integração:** exigir aprovação humana; não habilitar auto-merge.
- **Validação:** compilar `assembleDebug` para a versão proposta antes de considerar a atualização válida. Incluir uma nova tentativa para falhas transitórias de rede ao resolver dependências no JitPack; se persistir, falhar sem publicar.
- **Pré-release:** após merge em `devel`, publicar um APK de debug somente quando o pin do parser tiver mudado e o build tiver sucesso. Incluir no nome ou corpo da release os SHAs do app e do parser.
- **Versão estável:** manter o fluxo de release estável separado, acionado por tags de versão. A automação do parser não cria nem move tags estáveis.
- **Credenciais:** usar permissões mínimas para atualizar a branch e criar/atualizar o pull request. Se o token padrão não disparar as verificações de PR, usar uma GitHub App com escopo restrito ou executar a validação no próprio workflow de atualização antes de abrir o PR.
- **Idempotência:** uma segunda execução com o mesmo SHA não deve criar commits vazios, releases ou PRs duplicados.

## Testing Decisions

1. Com o SHA remoto igual ao pin atual, a execução termina sem alterar arquivos, abrir PR ou publicar release.
2. Com um SHA remoto diferente, a execução atualiza somente a versão do parser, usa o SHA completo e cria exatamente um PR para `devel`.
3. Com um PR de atualização aberto, uma nova execução atualiza o PR existente em vez de abrir outro.
4. O build do PR deve compilar o APK com o parser escolhido. Uma falha de compilação mantém o PR sem aprovação e não gera pré-release.
5. Um timeout transitório de JitPack deve ser repetido uma vez; falha persistente deve encerrar a execução sem publicar APK.
6. Ao integrar uma atualização aprovada em `devel`, uma execução bem-sucedida publica exatamente uma pré-release com o APK e os SHAs correspondentes.
7. Alterações que não mudam o pin do parser não publicam pré-release por este fluxo.
8. O workflow deve continuar permitindo execução manual e não deve alterar o fluxo da versão estável.

## Out of Scope

- Integrar automaticamente commits do parser no app ou aprovar o próprio pull request.
- Publicar uma versão estável, alterar tags `v*` ou distribuir APK por outra loja.
- Modificar o repositório de parsers, reescrever parsers ou decidir quais commits devem entrar no `master`.
- Usar alterações locais ainda não commitadas ou branches pessoais como origem de release.
- Automatizar atualização do site leitor ou dos links de compartilhamento.

## Further Notes

- **Linha de base observada em 2026-11-09:** o Kazuji usava `a4108617`; o `master` do parser da Kazuji apontava para `ab2d76c2c94d3eac7cef72b5f8659f167565395f`.
- A atualização manual dessa linha de base está proposta no [PR #4](https://github.com/Kazuji-Media/Kazuji/pull/4). A pré-release de validação foi publicada como [Kazuji Debug #16.1](https://github.com/Kazuji-Media/Kazuji/releases/tag/debug-16-1-d9ae8b0cde7b343c4dc6f0d01e524c69f2906e2f).
- A verificação semanal é uma proposta inicial. Confirmar a cadência antes de publicar esta spec como issue de implementação.
- As regras locais de contribuição pedem salvar o rascunho em `docs/plans` e publicar a spec no GitHub Issues depois de consolidar o escopo.
