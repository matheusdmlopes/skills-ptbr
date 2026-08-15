# Issue tracker: GitLab

Issues e specs para este repo vivem como issues do GitLab. Use a CLI [`glab`](https://gitlab.com/gitlab-org/cli) para todas as operações.

## Convenções

- **Criar uma issue**: `glab issue create --title "..." --description "..."`. Use um heredoc para descrições de múltiplas linhas. Passe `--description -` para abrir um editor.
- **Ler uma issue**: `glab issue view <number> --comments`. Use `-F json` para saída legível por máquina.
- **Listar issues**: `glab issue list -F json` com os filtros apropriados de `--label`.
- **Comentar em uma issue**: `glab issue note <number> --message "..."`. O GitLab chama comentários de "notes".
- **Aplicar / remover labels**: `glab issue update <number> --label "..."` / `--unlabel "..."`. Múltiplas labels podem ser separadas por vírgula ou repetindo a flag.
- **Fechar**: `glab issue close <number>`. `glab issue close` não aceita um comentário de encerramento, então publique a explicação primeiro com `glab issue note <number> --message "..."` e depois feche.
- **Merge requests**: O GitLab chama PRs de "merge requests". Use `glab mr create`, `glab mr view`, `glab mr note`, etc. — o mesmo formato de `gh pr ...` com `mr` no lugar de `pr` e `note`/`--message` no lugar de `comment`/`--body`.

Infira o repositório a partir de `git remote -v` — o `glab` faz isso automaticamente quando executado dentro de um clone.

## Merge requests como superfície de triagem

**MRs como superfície de requisição: não.** _(Defina como `yes` se este repo tratar merge requests externos como solicitações de funcionalidades; `/triage` lê essa flag.)_

Quando definido como `yes`, os MRs passam pelas mesmas labels e estados das issues, usando os equivalentes do `glab mr`:

- **Ler um MR**: `glab mr view <number> --comments` e `glab mr diff <number>` para o diff.
- **Listar MRs externos para triagem**: `glab mr list -F json`, mantendo apenas MRs cujo autor não seja membro/proprietário do projeto (o MR de um contribuidor, não o trabalho em andamento de um mantenedor).
- **Comentar / aplicar label / fechar**: `glab mr note`, `glab mr update --label`/`--unlabel`, `glab mr close`.

Diferente do GitHub, o GitLab numera issues e MRs separadamente, portanto `#42` é inequívoco uma vez que você saiba a qual superfície o mantenedor se refere.

## Quando uma skill disser "publique no issue tracker"

Crie uma issue no GitLab.

## Quando uma skill disser "busque o ticket relevante"

Execute `glab issue view <number> --comments`.

## Operações de wayfinding

Usado por `/wayfinder`. O **mapa** é uma única issue com issues **filhas** como tickets.

- **Mapa**: uma única issue rotulada como `wayfinder:map`, contendo o corpo de Notas / Decisões até o momento / Névoa. `glab issue create --label wayfinder:map`. (Em camadas do GitLab com epics nativos, um epic pode conter o mapa em vez de uma issue; uma issue rotulada funciona em qualquer lugar.)
- **Ticket filho**: uma issue contendo `Parte de #<map>` no topo de sua descrição e as labels `wayfinder:<type>` (`research`/`prototype`/`grilling`/`task`). Uma vez reivindicado, o ticket é atribuído ao dev responsável.
- **Bloqueio**: **link nativo de bloqueio** do GitLab — a representação canônica e visível na UI. Adicione-o com a ação rápida `/blocked_by #<n>`, publicada como uma nota (`glab issue note <child> --message "/blocked_by #<blocker>"`). Links nativos de bloqueio são um recurso Premium/Ultimate; no plano gratuito (ou onde não estiverem disponíveis), recorra a uma linha `Bloqueado por: #<n>, #<n>` no topo da descrição. Um ticket é desbloqueado quando todos os bloqueadores estiverem fechados.
- **Consulta de fronteira**: `glab issue list -F json` com escopo restrito às filhas do mapa, descarte qualquer uma com um bloqueador aberto — um link nativo `blocked_by` para uma issue aberta (`glab api projects/:id/issues/:iid/links`), ou uma issue aberta na linha `Bloqueado por` — ou um responsável (assignee); a primeira na ordem do mapa é escolhida.
- **Reivindicar (claim)**: `glab issue update <n> --assignee @me` — a primeira escrita da sessão.
- **Resolver**: `glab issue note <n> --message "<answer>"`, depois `glab issue close <n>`, e então anexe um ponteiro de contexto (resumo + link) às Decisões até o momento do mapa.
