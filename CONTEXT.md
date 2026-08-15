# Skills do Matt Pocock, em português

Tradução para pt-BR da coleção de agent skills de [mattpocock/skills](https://github.com/mattpocock/skills). Obra derivada sob licença MIT, não oficial. O repositório mantém a estrutura, os nomes e o comportamento do original: o que muda é a língua do texto que o agente lê.

## Linguagem

### O projeto de tradução

**Obra derivada**:
Este repositório. Mantém o histórico git do original como ancestral comum, o que torna `git merge upstream/main` o mecanismo de sincronização.
_Evitar_: fork (não é um fork do GitHub), cópia, port

**Upstream**:
O repositório original, `mattpocock/skills`, registrado como remote `upstream`. É a única fonte de verdade sobre o que a skill deve dizer.
_Evitar_: origem, repo do Matt

**Sync**:
O ato de trazer mudanças do **Upstream** com `git merge upstream/main`. Os conflitos de merge são o rastreador: cada um aponta uma linha em inglês que mudou sob uma tradução existente.
_Evitar_: atualização, pull, rebase

**Termo invariante**:
Palavra que **não** se traduz, por ser interface e não prosa: nome de skill, nome de comando, nome de artefato gerado (`CONTEXT.md`, `docs/adr/`) e label de issue (`needs-triage`). Traduzir um termo invariante quebra a interoperabilidade com quem usa as skills originais no mesmo repositório.
_Evitar_: termo fixo, palavra reservada

**Lote**:
Conjunto de skills de uma mesma família semântica, traduzido por um único worker para que o vocabulário não derive dentro da família.
_Evitar_: batch, grupo, família

**Skill promovida**:
Skill em `skills/engineering/` ou `skills/productivity/`, listada em `.claude-plugin/plugin.json`. É o conjunto que o **Upstream** trata como lançado, em oposição a `in-progress/` (beta) e `misc/` (uso interno).
_Evitar_: skill oficial, skill estável

### O domínio das skills

**Issue tracker**:
A ferramenta que hospeda as issues de um repositório — GitHub Issues, Linear, a convenção de markdown local em `.scratch/`, ou similar. Skills como `to-tickets`, `to-spec` e `triage` leem e escrevem nela.
_Evitar_: gerenciador de backlog, backlog backend, issue host

**Issue**:
Uma unidade de trabalho rastreada dentro de um **Issue tracker** — um bug, uma tarefa, uma spec, ou uma fatia produzida por `to-tickets`.
_Evitar_: ticket (usar apenas ao citar sistemas externos que os chamam de tickets, ou para um **Decision ticket** — veja abaixo)

**Decision ticket**:
Unidade do `wayfinder` — uma **Issue** filha de um `wayfinder:map` que carrega uma *pergunta* cuja resolução é uma decisão, não uma fatia de build a executar. O qualificador **decisão** é o que a distingue de um ticket de implementação; o `wayfinder` introduz o termo, e depois usa apenas "ticket".

**Triage role**:
Label canônica de máquina de estados aplicada a uma **Issue** durante a triagem (ex.: `needs-triage`, `ready-for-afk`). Cada papel mapeia para uma label real do **Issue tracker** via `docs/agents/triage-labels.md`.

**Sabatina**:
A entrevista implacável conduzida por `/grilling`: rodadas de perguntas, cada uma com resposta recomendada, até que a **fronteira** esteja vazia. O método se chama *grilling* (nome de comando, invariante); a atividade, em português, é sabatinar.
_Evitar_: grelhar, interrogatório, entrevista

**Fronteira**:
No `/grilling`, o conjunto de decisões cujos pré-requisitos já foram resolvidos, ou seja, as perguntas que podem ser feitas agora sem chutar respostas ainda não ouvidas.
_Evitar_: divisa, limite, borda

**Divisa de fase**:
O ponto entre duas fases de trabalho de uma sessão, onde se escolhe entre continuar, `/clear`, `/handoff`, subagente ou `/compact`.
_Evitar_: fronteira de fase (reservado para **Fronteira**), limite de fase

## Glossário de tradução

Aplicado a todos os **Lotes**. A coluna da esquerda é o termo do **Upstream**.

| Original | Em pt-BR | Observação |
|---|---|---|
| grilling (o método) | `grilling` | **Termo invariante**: é o comando `/grilling` |
| to grill / a grilling session | sabatinar / sabatina | Ver **Sabatina** |
| frontier | fronteira | Ver **Fronteira** |
| phase boundary | divisa de fase | Ver **Divisa de fase** |
| design tree | árvore de decisões | |
| deep module | `deep module` | Nome próprio de conceito (Ousterhout) |
| seam | costura | |
| tracer bullet | bala traçante | Consagrado pela tradução do *Pragmatic Programmer* |
| smart zone | `smart zone` | Jargão do autor, preserva a busca pelo artigo |
| deepening opportunity | oportunidade de aprofundamento | |
| primary source | fonte primária | |
| fog / push back the fog | névoa / dissipar a névoa | |
| spec | spec | Também é o comando `/to-spec` |
| ticket | ticket | |
| issue | issue | É o objeto do GitHub |
| handoff | `handoff` | **Termo invariante**: é o comando `/handoff` |
| red-green-refactor | red-green-refactor | Consagrado |
| working directory | diretório de trabalho | |

## Relações

- Um **Issue tracker** hospeda muitas **Issues**
- Uma **Issue** carrega uma **Triage role** por vez
- Um **Decision ticket** é uma **Issue** (filha de um `wayfinder:map`)
- Um **Lote** agrupa **Skills promovidas** de uma mesma família
- Um **Sync** traz mudanças do **Upstream** para a **Obra derivada**

## Ambiguidades sinalizadas

- "backlog" era usado anteriormente tanto para a *ferramenta* que hospeda as issues quanto para o *corpo de trabalho* dentro dela — resolvido: a ferramenta é o **Issue tracker**; "backlog" deixou de ser usado como termo de domínio.
- "backlog backend" / "backlog manager" — resolvido: unificados em **Issue tracker**.
- *frontier* e *boundary* aparecem os dois no **Upstream** e ambos cairiam em "fronteira", fundindo dois conceitos distintos. Resolvido: *frontier* é **Fronteira**, *boundary* é **Divisa**.
- "fork" foi evitado como termo do projeto: descreveria mal a relação com o **Upstream**, que é de histórico compartilhado sem fork do GitHub. Ver ADR 0004.
