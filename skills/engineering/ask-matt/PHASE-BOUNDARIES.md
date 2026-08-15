# Divisas de fase

Uma **fase** é um bloco de trabalho dentro de uma sessão — a sabatina, a implementação, o QA. A definição é propositalmente flexível: uma fase termina quando você pensa *"ok, terminamos isso"*.

A **divisa de fase** é o intervalo entre duas fases, e é o único lugar ao qual esta decisão pertence. No meio da fase não há decisão a tomar — continue, ou divida o trabalho restante em subagentes. Fazer compact no meio da fase faz o agente perder o fio da meada.

## As cinco opções

| Opção        | O que faz                                                       |
| ------------ | --------------------------------------------------------------- |
| **Continuar** | Ficar na sessão. Nenhuma troca de contexto.                     |
| **`/clear`** | Esvaziar a janela de contexto e começar do zero.                |
| **`/handoff`** | Escrever um arquivo markdown portátil e iniciar uma sessão em qualquer lugar com ele. |
| **Subagente** | Enviar a tarefa para sua própria janela de contexto e receber um relatório de volta. |
| **`/compact`** | Comprimir este contexto e iniciar uma nova sessão com o resumo. |

## A árvore

Trabalhe de cima para baixo na divisa. O primeiro **sim** vence.

**1. Você pode continuar nesta sessão?** Duas coisas tornam a resposta sim: a próxima fase precisa desta fase como uma **fonte primária**, ou você tem [smart zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone) restante suficiente (~150k tokens) para a próxima fase caber. Sabatina → implementação é o sim padrão: a implementação quer o raciocínio textual (verbatim), não um resumo dele. Continuar não custa nada e não perde nada, portanto descarte essa opção antes de qualquer outra.

**2. O contexto é irrelevante para o que vem a seguir?** Tudo nesta sessão — a exploração, as decisões, os becos sem saída — é descartável? Se sim, **`/clear`**. É o movimento mais barato do tabuleiro: não leva tempo nenhum e devolve a janela inteira. O `/clear` também não é terminal — a sessão antiga continua podendo ser retomada.

O custo de errar aqui é de mão única. Limpar um contexto *relevante* faz você perder o **porquê** por trás do que construiu, e nenhuma releitura do diff trará isso de volta.

**3. Você precisa passar o bastão (hand off)?** O `/handoff` é restrito. Você só precisa dele quando estiver:

- trocando para um **novo harness** (Claude → Codex),
- mudando para um **novo diretório** ou repositório,
- enviando o trabalho para um **colega**,
- ou bifurcando uma tarefa secundária encontrada **no meio da fase** sem descarrilar o que você está fazendo.

Essa lista é a cláusula inteira. O que o `/handoff` oferece é **portabilidade** — um arquivo que viaja. Se nada está viajando, você não precisa dele.

**4. A tarefa pode ser feita AFK?** O escopo está delimitado com precisão suficiente para rodar com você longe do teclado, sem direcionamento? Então envie-a para um **subagente** e deixe esta sessão intacta. A revisão automatizada é o caso padrão: o agente lê o diff e reporta, e você não é necessário enquanto ele faz isso.

**5. Caso contrário, `/compact`.** Contexto relevante, mesmo harness, mesmo diretório, e você precisa permanecer no circuito (in the loop) — é aqui que a árvore cai, e ela cai aqui com frequência. Passe uma instrução (`/compact vamos fazer QA desta área`) para que o resumo mantenha o que a próxima fase precisa.

O `/compact` é o **padrão, não a primeira escolha**. Ele fica na base porque as quatro perguntas acima dele são todas mais baratas ou mais precisas. O modo de falha quando as pessoas começam por aqui é uma nova sessão confiantemente errada sobre uma decisão que o resumo achatou.

## Fontes primárias e secundárias

Todo movimento, exceto **Continuar**, transforma uma **fonte primária** em uma **fonte secundária** — a sessão como ela aconteceu, substituída por um resumo dela. A troca tem sempre o mesmo formato:

| Fonte                             | Informação  | Ruído | Espaço para manobra |
| --------------------------------- | ----------- | ----- | ------------------- |
| Primária (Continuar)              | Completa    | Muito | Pouco               |
| Secundária (`/compact`, `/handoff`) | Com perdas  | Menos | Muito               |

É por isso que a pergunta 1 vem primeiro. Você só paga pelas perdas quando permanecer custa mais do que economiza.

## Estas são decisões de julgamento

As perguntas não são objetivas — cada uma envolve discernimento subjetivo, e a mesma divisa pode seguir caminhos diferentes em dias diferentes. O valor está em fazê-las **em ordem**, na divisa em vez de no meio do trabalho.
