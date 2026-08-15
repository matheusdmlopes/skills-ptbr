# Escopo: 27 skills e o README, sem as páginas de `docs/`

Traduzimos as 25 **Skills promovidas** de `.claude-plugin/plugin.json`, mais `claude-handoff` e `loop-me`, que permanecem em `skills/in-progress/`. Junto vão os `agents/openai.yaml` de cada skill e o `README.md` da raiz. As páginas sob `docs/` ficam em inglês.

As três fronteiras têm motivos distintos:

- **`plugin.json` em vez do que o instalador lista.** `npx skills add mattpocock/skills` varre todo `SKILL.md` do repositório e oferece 35, incluindo `in-progress/` e `misc/`; o skills.sh chega a listar 51, arrastando skills já removidas ou renomeadas (`to-prd`, `to-issues`, `zoom-out`). A única lista curada pelo autor é o `plugin.json`.
- **Duas betas incluídas, mas no lugar delas.** `claude-handoff` e `loop-me` somam 624 palavras, cerca de 2% do volume, e são as mais consolidadas do `in-progress/`. Ficam nessa pasta de propósito: o `README` do bucket avisa que podem mudar ou desaparecer sem aviso, e promovê-las na tradução enganaria o leitor. `misc/` fica de fora por ser ferramenta interna do curso do autor (`migrate-to-shoehorn`, `scaffold-exercises`).
- **`docs/` fora.** São as ~39.000 palavras do site aihero.dev, que dobrariam o volume do projeto para produzir páginas que ninguém lê a partir deste repositório. As skills são o produto: é o texto que o modelo lê em tempo de execução, onde a tradução de fato reduz fricção.

## Consequência: a pontuação do original é preservada

A tradução mantém os 587 travessões do original. Eles são traço estilístico do autor e parte do ritmo com que o texto foi calibrado para leitura por LLM. Isso suspende, apenas neste repositório, a regra pessoal do tradutor de não usar travessão em texto próprio: aqui o contrato é fidelidade a obra alheia, não voz própria.

## `CONTEXT.md` é um caso à parte, não uma quarta fronteira

`CONTEXT.md` da raiz não está nas 27 skills nem é o `README.md`, mas também não é fora de escopo: é o artefato que a própria skill `domain-modeling` mantém para este repositório, então este projeto de tradução — como qualquer outro trabalho conduzido aqui — o atualiza normalmente. As entradas herdadas do `CONTEXT.md` original (o domínio das skills: Issue tracker, Issue, Decision ticket, Triage role) seguem a mesma fidelidade do resto — só a prosa muda, valores de exemplo e travessões são preservados. As entradas novas (o domínio do próprio projeto de tradução: Upstream, Sync, Lote, Sabatina) não têm equivalente a preservar, e são conteúdo original deste repositório.
