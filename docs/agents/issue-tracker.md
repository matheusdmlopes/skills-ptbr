# Issue tracker: GitHub

Issues e specs para este repo vivem como issues do GitHub. Use a CLI `gh` para todas as operações.

## Convenções

- **Criar uma issue**: `gh issue create --title "..." --body "..."`. Use um heredoc para corpos de múltiplas linhas.
- **Ler uma issue**: `gh issue view <number> --comments`, filtrando comentários por `jq` e também buscando labels.
- **Listar issues**: `gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'` com os filtros apropriados de `--label` e `--state`.
- **Comentar em uma issue**: `gh issue comment <number> --body "..."`
- **Aplicar / remover labels**: `gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **Fechar**: `gh issue close <number> --comment "..."`

Infira o repositório a partir de `git remote -v` — a `gh` faz isso automaticamente quando executada dentro de um clone.

## Pull requests como superfície de triagem

**PRs como superfície de requisição: não.** _(Defina como `yes` se este repo tratar PRs externos como solicitações de funcionalidades; `/triage` lê essa flag.)_

Quando definido como `yes`, os PRs passam pelas mesmas labels e estados das issues, usando os equivalentes do `gh pr`:

- **Ler um PR**: `gh pr view <number> --comments` e `gh pr diff <number>` para o diff.
- **Listar PRs externos para triagem**: `gh pr list --state open --json number,title,body,labels,author,authorAssociation,comments`, mantendo apenas `authorAssociation` igual a `CONTRIBUTOR`, `FIRST_TIME_CONTRIBUTOR` ou `NONE` (descarte `OWNER`/`MEMBER`/`COLLABORATOR`).
- **Comentar / aplicar label / fechar**: `gh pr comment`, `gh pr edit --add-label`/`--remove-label`, `gh pr close`.

O GitHub compartilha um único espaço numérico entre issues e PRs, portanto um `#42` puro pode ser qualquer um dos dois — resolva com `gh pr view 42` e use `gh issue view 42` como fallback.

## Quando uma skill disser "publique no issue tracker"

Crie uma issue no GitHub.

## Quando uma skill disser "busque o ticket relevante"

Execute `gh issue view <number> --comments`.

## Operações de wayfinding

Usado por `/wayfinder`. O **mapa** é uma única issue com issues **filhas** como tickets.

- **Mapa**: uma única issue rotulada como `wayfinder:map`, contendo o corpo de Notas / Decisões até o momento / Névoa. `gh issue create --label wayfinder:map`.
- **Ticket filho**: uma issue vinculada ao mapa como uma sub-issue do GitHub (`gh api` no endpoint de sub-issues). Onde sub-issues não estiverem habilitadas, adicione a filha a uma task list no corpo do mapa e coloque `Parte de #<map>` no topo do corpo da filha. Labels: `wayfinder:<type>` (`research`/`prototype`/`grilling`/`task`). Uma vez reivindicado, o ticket é atribuído ao dev responsável.
- **Bloqueio**: **dependências nativas de issue** do GitHub — a representação canônica e visível na UI. Adicione uma aresta com `gh api --method POST repos/<owner>/<repo>/issues/<child>/dependencies/blocked_by -F issue_id=<blocker-db-id>`, onde `<blocker-db-id>` é o **id de banco de dados** numérico do bloqueador (`gh api repos/<owner>/<repo>/issues/<n> --jq .id`, _não_ o `#number` ou `node_id`). O GitHub relata `issue_dependencies_summary.blocked_by` (apenas bloqueadores abertos — a trava em tempo real). Onde dependências não estiverem disponíveis, recorra a uma linha `Bloqueado por: #<n>, #<n>` no topo do corpo da filha. Um ticket é desbloqueado quando todos os bloqueadores estiverem fechados.
- **Consulta de fronteira**: liste as filhas abertas do mapa (`gh issue list --state open`, com escopo restrito às sub-issues / task list do mapa), descarte qualquer uma com um bloqueador aberto (`issue_dependencies_summary.blocked_by > 0`, ou uma issue aberta na linha `Bloqueado por`) ou um responsável (assignee); a primeira na ordem do mapa é escolhida.
- **Reivindicar (claim)**: `gh issue edit <n> --add-assignee @me` — a primeira escrita da sessão.
- **Resolver**: `gh issue comment <n> --body "<answer>"`, depois `gh issue close <n>`, e então anexe um ponteiro de contexto (resumo + link) às Decisões até o momento do mapa.
