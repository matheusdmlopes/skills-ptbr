---
name: codebase-design
description: Vocabulário compartilhado para projetar deep modules. Use quando o usuário quiser projetar ou melhorar a interface de um módulo, encontrar oportunidades de aprofundamento, decidir onde uma costura deve ficar, tornar o código mais testável ou navegável por IA, ou quando outra skill precisar do vocabulário de deep modules.
---

# Codebase Design

Projete **deep modules**: muito comportamento atrás de uma interface pequena, posicionada em uma costura limpa, testável por meio dessa interface. Use esta linguagem e estes princípios onde quer que o código esteja sendo projetado ou reestruturado. O objetivo é alavancagem para os chamadores, localidade para os mantenedores e testabilidade para todos.

## Glossário

Use estes termos com exatidão — não substitua por "componente", "serviço", "API" ou "divisa". Linguagem consistente é todo o propósito.

**Módulo (Module)** — qualquer coisa com uma interface e uma implementação. Deliberadamente agnóstico de escala: uma função, classe, pacote ou fatia transversal a camadas. _Evitar_: unidade, componente, serviço.

**Interface** — tudo o que um chamador precisa saber para usar o módulo corretamente: a assinatura de tipos, mas também invariantes, restrições de ordenação, modos de erro, configuração necessária e características de desempenho. _Evitar_: API, assinatura (muito estreitas — referem-se apenas à superfície no nível de tipos).

**Implementação (Implementation)** — o que está dentro de um módulo, seu corpo de código. Distinto de **Adaptador**: algo pode ser um adaptador pequeno com uma implementação grande (um repositório Postgres) ou um adaptador grande com uma implementação pequena (um fake em memória). Use "adaptador" quando a costura for o assunto; "implementação" caso contrário.

**Profundidade (Depth)** — alavancagem na interface: a quantidade de comportamento que um chamador (ou teste) pode exercitar por unidade de interface que precisa aprender. Um módulo é **deep** quando uma grande quantidade de comportamento reside atrás de uma interface pequena, **raso (shallow)** quando a interface é quase tão complexa quanto a implementação.

**Costura (Seam)** _(Michael Feathers)_ — um lugar onde você pode alterar o comportamento sem editar nesse lugar; o *local* no qual a interface de um módulo reside. Onde colocar a costura é uma decisão de design própria, distinta do que fica atrás dela. _Evitar_: divisa (sobrecarregado com bounded context do DDD).

**Adaptador (Adapter)** — uma coisa concreta que satisfaz uma interface em uma costura. Descreve o *papel* (qual slot preenche), não a substância (o que está dentro).

**Alavancagem (Leverage)** — o que os chamadores obtêm da profundidade: mais capacidade por unidade de interface que aprendem. Uma implementação se paga ao longo de N pontos de chamada e M testes.

**Localidade (Locality)** — o que os mantenedores obtêm da profundidade: alterações, bugs, conhecimento e verificação se concentram em um único lugar em vez de se espalharem pelos chamadores. Corrija uma vez, corrigido em todo lugar.

## Deep vs shallow

**Deep module** = interface pequena + muita implementação:

```
┌─────────────────────┐
│   Small Interface   │  ← Poucos métodos, parâmetros simples
├─────────────────────┤
│                     │
│  Deep Implementation│  ← Lógica complexa oculta
│                     │
└─────────────────────┘
```

**Módulo raso (shallow)** = interface grande + pouca implementação (evite):

```
┌─────────────────────────────────┐
│       Large Interface           │  ← Muitos métodos, parâmetros complexos
├─────────────────────────────────┤
│  Thin Implementation            │  ← Apenas repassa chamadas
└─────────────────────────────────┘
```

Ao projetar uma interface, pergunte-se:

- Posso reduzir o número de métodos?
- Posso simplificar os parâmetros?
- Posso ocultar mais complexidade no interior?

## Princípios

- **A profundidade é uma propriedade da interface, não da implementação.** Um deep module pode ser composto internamente de partes pequenas, mockáveis e substituíveis — elas apenas não fazem parte da interface. Um módulo pode ter **costuras internas** (privadas à sua implementação, usadas por seus próprios testes), bem como a **costura externa** em sua interface.
- **O teste de deleção.** Imagine deletar o módulo. Se a complexidade desaparecer, ele era apenas um repassador. Se a complexidade reaparecer espalhada por N chamadores, ele estava justificando sua existência.
- **A interface é a superfície de teste.** Chamadores e testes cruzam a mesma costura. Se você quiser testar *além* da interface, o módulo provavelmente está com o formato errado.
- **Um adaptador significa uma costura hipotética. Dois adaptadores significam uma costura real.** Não introduza uma costura a menos que algo realmente varie através dela.

## Projetando para testabilidade

Boas interfaces tornam os testes naturais:

1. **Aceite dependências, não as crie.**

   ```typescript
   // Testable
   function processOrder(order, paymentGateway) {}

   // Hard to test
   function processOrder(order) {
     const gateway = new StripeGateway();
   }
   ```

2. **Retorne resultados, não produza efeitos colaterais.**

   ```typescript
   // Testable
   function calculateDiscount(cart): Discount {}

   // Hard to test
   function applyDiscount(cart): void {
     cart.total -= discount;
   }
   ```

3. **Superfície pequena.** Menos métodos = menos testes necessários. Menos parâmetros = configuração de teste mais simples.

## Relações

- Um **Módulo** tem exatamente uma **Interface** (a superfície que ele apresenta a chamadores e testes).
- **Profundidade** é uma propriedade de um **Módulo**, medida em relação à sua **Interface**.
- Uma **Costura** é onde a **Interface** de um **Módulo** reside.
- Um **Adaptador** fica em uma **Costura** e satisfaz a **Interface**.
- **Profundidade** produz **Alavancagem** para chamadores e **Localidade** para mantenedores.

## Enquadramentos rejeitados

- **Profundidade como proporção entre linhas de implementação e linhas de interface** (Ousterhout): recompensa inflar a implementação. Em vez disso, usamos profundidade-como-alavancagem.
- **"Interface" como a palavra-chave `interface` do TypeScript ou os métodos públicos de uma classe**: muito estreito — interface aqui inclui todo fato que um chamador precisa saber.
- **"Boundary"**: sobrecarregado com bounded context do DDD. Diga **costura** ou **interface**.

## Indo mais a fundo

- **Aprofundando um cluster dadas as suas dependências** — veja [DEEPENING.md](DEEPENING.md): categorias de dependência, disciplina de costuras e testes no estilo substituir-não-acumular em camadas (replace-don't-layer).
- **Explorando interfaces alternativas** — veja [DESIGN-IT-TWICE.md](DESIGN-IT-TWICE.md): inicialize subagentes paralelos para projetar a interface de várias maneiras radicalmente diferentes e, em seguida, compare quanto a profundidade, localidade e posicionamento da costura.
