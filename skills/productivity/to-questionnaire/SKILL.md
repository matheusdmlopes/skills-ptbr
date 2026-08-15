---
name: to-questionnaire
description: Transforme uma decisão que você não consegue responder totalmente em um questionário para outra pessoa preencher.
disable-model-invocation: true
---

Transforme algo que o usuário não consegue responder sozinho em um **questionário** — um documento Markdown que ele entrega a uma pessoa para preencher de forma assíncrona ou preencherem juntos em uma reunião. O destinatário detém o conhecimento que falta ao usuário; o questionário extrai isso dele.

**Sabatine o envio, não o assunto.** Entreviste o usuário apenas sobre o _envio_, o que ele sempre é capaz de responder: para quem vai e do que ele precisa de volta. As perguntas no documento visam então à **lacuna** entre o que o destinatário sabe e o que o usuário precisa.

1. **Para quem vai?** Pergunte, em uma única interação, a função, a especialidade e a relação do destinatário com o usuário. Isso define o tom do questionário e quanto contexto ele deve carregar. Concluído quando você souber quem é o destinatário e o que ele sabe que o usuário não sabe.

2. **Do que você precisa de volta?** Pergunte, em uma única interação, as decisões ou fatos específicos que o usuário não consegue resolver sozinho e dos quais precisa dessa pessoa. Concluído quando você tiver uma lista concreta do que o usuário precisa sair dali capaz de fazer ou decidir.

3. **Escreva o questionário.** Redija perguntas direcionadas à lacuna das etapas 1–2, seguindo a Estrutura do documento abaixo. Escreva o arquivo em `to-questionnaire-<slug>.md` no diretório atual (slug extraído do tópico) e informe o caminho. Concluído quando o arquivo existir e cada item mencionado pelo usuário na etapa 2 estiver coberto por uma pergunta.

## Estrutura do documento

Estruture o documento como um **questionário de descoberta**: falta contexto ao usuário, o destinatário o detém. Ordene as perguntas das mais importantes para as menos importantes — o formato assíncrono significa que você pode ter apenas uma chance — e agrupe-as sob títulos `##` por tema quando houver mais do que algumas poucas. Escreva-o usando o template abaixo.

<questionnaire-template>

# <Título do questionário>

**Objetivo:** por que este questionário existe e a decisão que depende dele.

**De:** <o usuário> — **Para:** <o destinatário> — **Como suas respostas serão usadas:** <para onde elas vão>

## Contexto

Um parágrafo orientando um destinatário que não estava na cabeça do usuário. O suficiente para responder bem, não uma página inteira.

## Como responder

Prazo e esforço estimado. Respostas parciais e "Não sei" são úteis — sinalize qualquer coisa sobre a qual você não tenha certeza em vez de pular a pergunta.

## <Título do tema>

Uma seção `##` por tema. Sob cada uma, suas perguntas, das mais importantes para as menos importantes. Cada pergunta é uma única ideia — nunca composta — com um espaço para resposta logo abaixo e uma única linha de _por que isso importa_ apenas onde a pergunta puder ser mal interpretada ou incitar uma resposta superficial.

<question-example>
### Que carga o sistema deve suportar no lançamento?

_Por que isso importa: isso define se provisionamos para picos de tráfego agora ou adiamos isso._

>
</question-example>

## Algo mais?

Um fechamento abrangente: há algo que não perguntamos e que deveríamos saber?

</questionnaire-template>
