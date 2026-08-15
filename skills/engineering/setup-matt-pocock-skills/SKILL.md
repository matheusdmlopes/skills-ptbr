---
name: setup-matt-pocock-skills
description: Configure este repositório para as engineering skills — defina seu issue tracker, o vocabulário de labels de triagem e a estrutura de documentos de domínio. Execute uma vez antes do primeiro uso das outras engineering skills.
disable-model-invocation: true
---

# Configurar as Skills do Matt Pocock (Setup Matt Pocock's Skills)

Gere a estrutura de configuração por repositório que as engineering skills pressupõem:

- **Issue tracker** — onde as issues residem (GitHub por padrão; markdown local também tem suporte nativo)
- **Labels de triagem** — as strings usadas para os cinco papéis canônicos de triagem
- **Documentos de domínio** — onde `CONTEXT.md` e ADRs residem, e as regras de consumo para lê-los

Esta é uma skill orientada por prompts, não um script determinístico. Explore, apresente o que encontrou, confirme com o usuário e então escreva.

## Processo

### 1. Explorar

Analise o repositório atual para entender seu estado inicial. Leia o que quer que exista; não faça suposições:

- `git remote -v` e `.git/config` — este é um repositório do GitHub? Qual deles?
- `AGENTS.md` e `CLAUDE.md` na raiz do repo — algum deles existe? Já existe uma seção `## Agent skills` em algum deles?
- `CONTEXT.md` e `CONTEXT-MAP.md` na raiz do repo
- `docs/adr/` e quaisquer diretórios `src/*/docs/adr/`
- `docs/agents/` — a saída anterior desta skill já existe?
- `.scratch/` — sinal de que uma convenção de issue tracker em markdown local já está em uso
- A skill `triage` está instalada? (uma pasta de skill `triage` ao lado desta, ou `triage` nas suas skills disponíveis.) Isso decide se a Seção B é executada ou não.
- Sinais de monorepo — um `pnpm-workspace.yaml`, um campo `workspaces` em `package.json`, ou um `packages/*` preenchido com seu próprio `src/`. Presentes apenas em um repositório genuinamente grande de múltiplos pacotes; a ausência deles significa contexto único (single-context), que é o caso de quase todo repositório.

### 2. Apresentar achados e perguntar

Resuma o que está presente e o que está ausente. Em seguida, percorra as seções em ordem — uma seção, uma resposta, e depois a próxima.

Abra cada seção com a resposta recomendada para que o usuário possa aceitá-la com uma única palavra. Forneça uma explicação de uma linha apenas quando a escolha realmente se ramificar; pule a seção inteiramente quando a exploração já a tiver resolvido (Seção B quando `triage` não estiver instalada, Seção C quando não houver monorepo).

**Seção A — Issue tracker.**

> Explicação: O "issue tracker" é onde as issues residem para este repo. Skills como `to-tickets`, `triage` e `to-spec` leem dele e escrevem nele — elas precisam saber se devem chamar `gh issue create`, escrever um arquivo markdown sob `.scratch/` ou seguir algum outro fluxo de trabalho que você descrever. Escolha o local onde você realmente acompanha o trabalho deste repo.

Postura padrão: estas skills foram projetadas para o GitHub. Se um `git remote` apontar para o GitHub, proponha essa opção. Se um `git remote` apontar para o GitLab (`gitlab.com` ou um host auto-hospedado), proponha o GitLab. Caso contrário (ou se o usuário preferir), ofereça:

- **GitHub** — as issues residem no GitHub Issues do repo (usa a CLI `gh`)
- **GitLab** — as issues residem no GitLab Issues do repo (usa a CLI [`glab`](https://gitlab.com/gitlab-org/cli))
- **Markdown local** — as issues residem como arquivos sob `.scratch/<feature>/` neste repo (bom para projetos solo ou repos sem remote)
- **Outro** (Jira, Linear, etc.) — peça ao usuário para descrever o fluxo de trabalho em um parágrafo; a skill o registrará como prosa livre

Registre a escolha em `docs/agents/issue-tracker.md`. Os templates do GitHub e GitLab trazem uma flag "PRs como superfície de requisição", definida por padrão como **não** (desativada) — deixe-a desativada e não mencione; um usuário que desejar PRs externos na fila de triagem poderá alterar a flag no arquivo mais tarde.

**Seção B — Vocabulário de labels de triagem.** Pule esta seção inteiramente se a skill `triage` não estiver instalada (a exploração indicou isso) — uma skill não instalada não precisa de labels.

Se estiver instalada, faça exatamente uma pergunta:

> Deseja manter as labels de triagem padrão? (recomendado: **sim**)

Os padrões são os cinco papéis canônicos, cada string de label igual ao seu nome: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. Com **sim**, escreva-os como estão. Apenas se o usuário disser não — normalmente porque seu tracker já usa outros nomes (ex.: `bug:triage` para `needs-triage`) —, colete as substituições para que `triage` aplique labels existentes em vez de criar duplicatas.

**Seção C — Documentos de domínio.** O padrão é **contexto único (single-context)** — um único `CONTEXT.md` + `docs/adr/` na raiz do repo. Isso se adequa a quase todo repositório; escreva sem perguntar.

Ofereça **múltiplos contextos (multi-context)** — um `CONTEXT-MAP.md` na raiz apontando para arquivos `CONTEXT.md` por contexto — apenas quando a exploração encontrar sinais de monorepo. Então confirme qual estrutura o usuário deseja.

### 3. Confirmar e editar

Mostre ao usuário um rascunho de:

- O bloco `## Agent skills` a ser adicionado ao arquivo (`CLAUDE.md` / `AGENTS.md`) que estiver sendo editado (veja o passo 4 para as regras de seleção)
- O conteúdo de `docs/agents/issue-tracker.md`, `docs/agents/domain.md` e `docs/agents/triage-labels.md` (o último apenas quando `triage` estiver instalada)

Deixe-o editar antes de escrever.

### 4. Escrever

**Escolha o arquivo para editar:**

- Se `CLAUDE.md` existir, edite-o.
- Senão, se `AGENTS.md` existir, edite-o.
- Se nenhum existir, pergunte ao usuário qual criar — não escolha por ele.

Nunca crie `AGENTS.md` quando `CLAUDE.md` já existir (ou vice-versa) — sempre edite aquele que já está lá.

Se um bloco `## Agent skills` já existir no arquivo escolhido, atualize seu conteúdo no próprio local em vez de anexar uma duplicata. Não sobrescreva as edições do usuário nas seções ao redor.

O bloco:

```markdown
## Agent skills

### Issue tracker

[resumo de uma linha de onde as issues são rastreadas]. Veja `docs/agents/issue-tracker.md`.

### Triage labels

[resumo de uma linha do vocabulário de labels]. Veja `docs/agents/triage-labels.md`.

### Domain docs

[resumo de uma linha da estrutura — "single-context" ou "multi-context"]. Veja `docs/agents/domain.md`.
```

Inclua o sub-bloco `### Triage labels`, e escreva `docs/agents/triage-labels.md`, apenas quando `triage` estiver instalada e a Seção B for executada. Quando não estiver, ambos são omitidos.

Em seguida, escreva os arquivos de documentação usando os templates iniciais nesta pasta de skill como ponto de partida:

- [issue-tracker-github.md](./issue-tracker-github.md) — issue tracker do GitHub
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md) — issue tracker do GitLab
- [issue-tracker-local.md](./issue-tracker-local.md) — issue tracker de markdown local
- [triage-labels.md](./triage-labels.md) — mapeamento de labels (apenas se `triage` estiver instalada)
- [domain.md](./domain.md) — regras de consumo de documentos de domínio + estrutura

Para "outros" issue trackers, escreva `docs/agents/issue-tracker.md` do zero usando a descrição do usuário.

### 5. Concluído

Informe ao usuário que a configuração está concluída e quais engineering skills agora lerão a partir desses arquivos. Mencione que ele pode editar `docs/agents/*.md` diretamente mais tarde — reexecutar esta skill só é necessário se ele desejar trocar de issue tracker ou recomeçar do zero.
