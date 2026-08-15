---
name: loop-me
description: Sabatine-me sobre specs para os workflows que quero construir, dentro deste workspace.
disable-model-invocation: true
argument-hint: "Um workflow para planejar, ou nada para encontrar um"
---

Execute uma sessão com estado de `/grilling` cuja única saída sejam specs de **workflows**. Use a disciplina de grilling — implacável, uma rodada de perguntas por vez, com uma resposta recomendada anexada a cada uma — orientada ao vocabulário e ao objetivo abaixo. Crie, edite e exclua specs à medida que a sabatina for resolvendo as decisões.

## A ótica dos loops (The loop lens)

Um **loop** é um padrão recorrente na vida do usuário: sua carreira, sua semana, sua manhã, uma única atividade repetida. Enxergar a vida como loops dentro de loops revela o quão previsíveis suas atividades realmente são — o que as torna dignas de serem **delegadas**. Use essa ótica para encontrar loops que valham a pena especificar e proponha aqueles que o usuário ainda não percebeu.

Um **workflow** é a spec de um loop tornada realidade. Você executa um workflow sobre um loop — o loop é sua instanciação em execução. Os workflows residem em `workflows/*.md` e são a fonte da verdade.

## Vocabulário

Uma linguagem compartilhada, utilizada somente quando um workflow a exigir — nunca como uma lista de verificação obrigatória. **Não imponha nada estrutural**: um workflow não precisa de IA, de checkpoint ou de agendamento, a menos que a sabatina demonstre essa necessidade.

- **Gatilho (Trigger)** — o que dispara cada execução: um **evento** (um novo e-mail, uma nova issue) ou um **agendamento** (toda manhã). O disparo por evento é geralmente o mais eficiente.
- **Ponto de verificação (Checkpoint)** — um ponto com intervenção humana (human-in-the-loop) onde o usuário é solicitado a verificar ou decidir. Alguns workflows não têm nenhum e rodam autonomamente; alguns não utilizam IA alguma.
- **Empurrar para a direita (Push right)** — adie o checkpoint o máximo possível. Faça o máximo de trabalho antes de envolver o humano, para que ele seja consultado uma única vez, no final, com tudo pronto.
- **Brief** — o que um checkpoint apresenta: um resumo conciso e pronto para decisão — o que foi produzido, o porquê e um link direto para o artefato em si — nunca a saída bruta. O usuário lê um brief, não um rascunho. A velocidade de revisão é imperativa.

## Definição de pronto (Definition of done)

Uma spec de workflow está pronta quando um agente implementador puder construí-la sem fazer uma única pergunta. Sabatine até esse ponto; nada está pronto enquanto restar uma pergunta.

## O workspace

- `workflows/*.md` — uma spec por workflow.
- `NOTES.md` — anotações brutas sobre o contexto do usuário: as ferramentas que ele usa, os canais que processa e sua própria terminologia para ambos. Quando estiver vazio ou sucinto, entreviste-o sobre o seu mundo antes de especificar qualquer coisa. Torne termos difusos em termos canônicos à medida que surgirem e registre-os aqui.
