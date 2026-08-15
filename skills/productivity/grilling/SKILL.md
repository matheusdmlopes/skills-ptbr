---
name: grilling
description: Sabatine o usuário implacavelmente sobre um plano, decisão ou ideia. Use quando o usuário quiser estressar seu raciocínio ou usar qualquer frase de ativação com 'grill'.
---

Entreviste o usuário implacavelmente até chegar a um entendimento compartilhado. Mapeie isso como uma **árvore de decisões**: cada decisão se ramifica nas decisões que dependem dela.

Percorra a árvore em **rodadas**. A **fronteira** é toda decisão cujos pré-requisitos já foram resolvidos — as perguntas que você pode fazer _agora_ sem chutar respostas que ainda não ouviu. Faça todas as perguntas da fronteira em uma única rodada: numere cada pergunta e dê sua resposta recomendada. Em seguida, aguarde as respostas do usuário antes da próxima rodada.

Cada pergunta deve ser formatada assim:

```
❓ **Q1** - **<título da pergunta>**: <corpo da pergunta, pode ter vários parágrafos, incluindo opções de múltipla escolha>

➡️ <sua resposta recomendada>
```

Cada rodada respondida pelo usuário remodela a árvore — decisões resolvidas expandem a fronteira e desbloqueiam perguntas que dependiam delas. Recalcule a fronteira e faça a próxima rodada. Uma pergunta cuja resposta depende de outra pergunta ainda aberta nesta rodada pertence a uma rodada _posterior_, não a esta.

Encontrar _fatos_ é trabalho seu, nunca do usuário. Quando uma pergunta da fronteira precisar de um fato do ambiente (sistema de arquivos, ferramentas, etc.), despache um subagente para encontrá-lo — não peça ao usuário nada que você mesmo possa consultar. Não se bloqueie por isso: uma exploração em andamento é um pré-requisito não resolvido, portanto apenas as perguntas dependentes dela aguardam o relatório do subagente — faça o restante das perguntas da fronteira agora. As _decisões_ cabem ao usuário — apresente cada uma a ele e aguarde.

A sessão termina quando a fronteira estiver vazia: todos os ramos da árvore de decisões visitados, nada deixado tacitamente assumido. Não tome nenhuma ação com base nisso até que o usuário confirme que vocês chegaram a um entendimento compartilhado.
