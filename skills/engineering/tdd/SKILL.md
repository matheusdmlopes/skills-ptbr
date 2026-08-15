---
name: tdd
description: Desenvolvimento orientado a testes (TDD). Use quando o usuário quiser construir funcionalidades ou corrigir bugs começando pelos testes, mencionar "red-green-refactor", ou quiser testes de integração.
---

# Desenvolvimento Orientado a Testes (TDD)

TDD é o ciclo red → green. Esta skill é a referência que faz esse ciclo produzir testes que valem a pena manter: o que é um bom teste, onde os testes ficam, os antipadrões e as regras do ciclo. Cada seção se aplica a cada ciclo — consulte-as antes e durante o ciclo, não depois.

Ao explorar a base de código, leia `CONTEXT.md` (se existir) para que os nomes dos testes e o vocabulário de interface correspondam à linguagem de domínio do projeto e respeitem os ADRs na área em que você estiver mexendo.

## O que é um bom teste

Os testes verificam o comportamento por meio de interfaces públicas, não de detalhes de implementação. O código pode mudar completamente; os testes não deveriam. Um bom teste soa como uma especificação — "user can checkout with valid cart" diz exatamente qual capacidade existe — e sobrevive a refatorações porque não se importa com a estrutura interna.

Consulte [tests.md](tests.md) para ver exemplos e [mocking.md](mocking.md) para diretrizes de mocking.

## Costuras — onde os testes ficam

Uma **costura** é o limite público no qual você testa: a interface onde você observa o comportamento sem mexer no que está dentro. Os testes vivem nas costuras, nunca contra detalhes internos.

**Teste apenas em costuras previamente acordadas.** Antes de escrever qualquer teste, anote as costuras em teste e confirme-as com o usuário. Nenhum teste deve ser escrito em uma costura não confirmada. Você não pode testar tudo — acordar as costuras antecipadamente é como o esforço de teste recai sobre os caminhos críticos e lógica complexa em vez de cada caso de borda.

Pergunte: "Qual é a interface pública e quais costuras devemos testar?"

Quando o formato dessa interface estiver em questão — quão profundo é o módulo, a qual lugar a costura pertence, o que a interface deve expor — use a skill `/codebase-design` para o vocabulário. Ela é a fonte compartilhada dos termos módulo, interface, profundidade, costura, adaptador, alavancagem e localidade, e é uma referência para consultar, não uma sessão para executar.

## Antipadrões

- **Acoplado à implementação** — usa mocks de colaboradores internos, testa métodos privados ou verifica por um canal lateral (consultando o banco de dados em vez de usar a interface). O sinal claro: o teste quebra quando você refatora, mas o comportamento não mudou.
- **Tautológico** — a asserção recalcula o valor esperado da mesma forma que o código faz (`expect(add(a, b)).toBe(a + b)`, um snapshot derivado manualmente da mesma maneira, uma constante afirmada como igual a si mesma), passando por construção e nunca discordando do código. Os valores esperados devem vir de uma fonte de verdade independente — um literal sabidamente correto, um exemplo resolvido, a spec.
- **Fatiamento horizontal** — escrever todos os testes primeiro, depois toda a implementação. Testes em lote verificam um comportamento _imaginado_: você testa a _forma_ das coisas em vez do comportamento voltado ao usuário, os testes ficam insensíveis a mudanças reais e você se compromete com a estrutura do teste antes de entender a implementação. Em vez disso, trabalhe em **fatias verticais** — um teste → uma implementação → repita, cada teste sendo uma **bala traçante** que responde ao que o último ciclo ensinou.

## Regras do ciclo

- **Red antes de green.** Escreva o teste que falha primeiro e, em seguida, apenas código suficiente para fazê-lo passar. Não antecipe testes futuros nem adicione recursos especulativos.
- **Uma fatia por vez.** Uma costura, um teste, uma implementação mínima por ciclo.
- **Refatoração não faz parte do ciclo.** Ela pertence à etapa de revisão (veja a skill `code-review`), não ao ciclo de implementação red → green.
