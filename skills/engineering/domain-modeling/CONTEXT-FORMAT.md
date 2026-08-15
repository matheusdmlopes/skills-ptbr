# Formato de CONTEXT.md

## Estrutura

```md
# {Nome do Contexto}

{Descrição de uma ou duas frases sobre o que é este contexto e por que ele existe.}

## Linguagem

**Order**:
{Uma descrição de uma ou duas frases do termo}
_Evitar_: Purchase, transaction

**Invoice**:
Uma solicitação de pagamento enviada a um cliente após a entrega.
_Evitar_: Bill, payment request

**Customer**:
Uma pessoa ou organização que faz pedidos.
_Evitar_: Client, buyer, account
```

## Regras

- **Seja opinativo.** Quando existirem várias palavras para o mesmo conceito, escolha a melhor e liste as outras sob `_Evitar_`.
- **Mantenha as definições concisas.** No máximo uma ou duas frases. Defina o que ele É, não o que ele faz.
- **Inclua apenas termos específicos ao contexto deste projeto.** Conceitos gerais de programação (timeouts, tipos de erro, padrões utilitários) não pertencem aqui, mesmo se o projeto os usar extensivamente. Antes de adicionar um termo, pergunte: este é um conceito exclusivo deste contexto ou um conceito geral de programação? Apenas o primeiro pertence aqui.
- **Agrupe termos sob subtítulos** quando surgirem agrupamentos naturais. Se todos os termos pertencerem a uma única área coesa, uma lista simples é suficiente.

## Repositórios de contexto único vs múltiplos contextos

**Contexto único (maioria dos repositórios):** Um `CONTEXT.md` na raiz do repositório.

**Múltiplos contextos:** Um `CONTEXT-MAP.md` na raiz do repositório lista os contextos, onde residem e como se relacionam entre si:

```md
# Context Map

## Contexts

- [Ordering](./src/ordering/CONTEXT.md) — recebe e rastreia pedidos de clientes
- [Billing](./src/billing/CONTEXT.md) — gera faturas e processa pagamentos
- [Fulfillment](./src/fulfillment/CONTEXT.md) — gerencia a separação e o envio no armazém

## Relationships

- **Ordering → Fulfillment**: Ordering emite eventos `OrderPlaced`; Fulfillment os consome para iniciar a separação
- **Fulfillment → Billing**: Fulfillment emite eventos `ShipmentDispatched`; Billing os consome para gerar faturas
- **Ordering ↔ Billing**: Tipos compartilhados para `CustomerId` e `Money`
```

A skill deduz qual estrutura se aplica:

- Se `CONTEXT-MAP.md` existir, leia-o para encontrar os contextos
- Se apenas um `CONTEXT.md` na raiz existir, contexto único
- Se nenhum dos dois existir, crie um `CONTEXT.md` na raiz sob demanda (lazily) quando o primeiro termo for resolvido

Quando existirem múltiplos contextos, deduza a qual deles o tópico atual se relaciona. Se não estiver claro, pergunte.
