# Mecânica de skills

A ramificação específica para skills de [`writing-for-agents`](SKILL.md): o que muda quando o documento é uma skill — frontmatter, a escolha de invocação e skills roteadoras. Todo o resto sobre sua redação é a referência universal em `SKILL.md`.

## Invocação

Duas escolhas, balanceando as duas cargas:

- Uma skill **invocada por modelo** (model-invoked) mantém uma `description`, de modo que o agente possa acioná-la de forma autônoma — e outras skills possam alcançá-la. Você ainda pode digitar seu nome: a invocação por modelo sempre _inclui_ o alcance do usuário; uma descrição apenas adiciona a descoberta pelo agente, nunca remove a do humano. A descrição é o ponteiro de contexto de nível superior da skill, forçado a permanecer carregado o tempo todo — carga de contexto permanente em troca de capacidade de descoberta. Uma skill invocada por modelo cujo conteúdo seja puramente de referência também é um lar para referência compartilhada: outra skill pode invocá-la, de modo que a referência necessária para várias skills resida em um único lugar. Mecânica: omita `disable-model-invocation` e escreva uma descrição voltada ao modelo contendo as ramificações de gatilho (as regras de redação de ponteiros em `SKILL.md` se aplicam integralmente).
- Uma skill **invocada por usuário** (user-invoked) retira a descrição do alcance do agente: apenas o humano digitando seu nome pode invocá-la, e nenhuma outra skill pode fazê-lo. Zero carga de contexto, mas consome carga cognitiva — você é o índice que precisa lembrar que ela existe. Mecânica: defina `disable-model-invocation: true`; a `description` torna-se voltada para humanos — um resumo de uma linha, com listas de gatilhos removidas.

Escolha a invocação por modelo apenas quando o agente precisar alcançar a skill por conta própria, ou quando outra skill precisar alcançá-la. Se ela só for disparada manualmente, torne-a invocada por usuário e não pague carga de contexto.

Referência compartilhada necessária para duas skills invocadas por usuário não pode residir em nenhuma delas — sem descrições, nenhuma pode acionar a outra. Mova-a para um arquivo comum fora do sistema de skills: referência externa para a qual qualquer skill pode apontar.

## Divisão por invocação

O corte de divisão por invocação (o corte por sequência está em `SKILL.md`): separe uma skill invocada por modelo quando tiver uma leading word distinta que deva acioná-la por conta própria — uma palavra-gatilho que você realmente usa em seus prompts — ou quando outra skill precisar alcançá-la. Você paga carga de contexto pela nova descrição sempre carregada, portanto esse alcance independente precisa valer a pena.

## Skills roteadoras

Quando skills invocadas por usuário se multiplicam além do que você consegue lembrar, essa carga cognitiva acumulada é sanada por uma **skill roteadora** (router skill): uma skill invocada por usuário que nomeia as outras e quando recorrer a cada uma, de modo que o humano tenha uma única skill para lembrar em vez de várias. Ela só pode sugerir, nunca acioná-las: skills invocadas por usuário não possuem descrição, portanto nada além do humano pode alcançá-las.
