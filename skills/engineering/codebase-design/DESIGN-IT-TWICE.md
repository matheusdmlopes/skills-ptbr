# Projete Duas Vezes (Design It Twice)

Quando o usuário quiser explorar interfaces alternativas para um candidato a aprofundamento escolhido, use este padrão de subagentes paralelos. Baseado em "Design It Twice" (Ousterhout) — sua primeira ideia dificilmente será a melhor.

Utiliza o vocabulário em [SKILL.md](SKILL.md) — **módulo**, **interface**, **costura**, **adaptador**, **alavancagem**.

## Processo

### 1. Enquadre o espaço do problema

Antes de disparar subagentes, escreva uma explicação voltada ao usuário sobre o espaço do problema para o candidato escolhido:

- As restrições que qualquer nova interface precisaria satisfazer
- As dependências nas quais ela se apoiaria e em qual categoria elas se enquadram (veja [DEEPENING.md](DEEPENING.md))
- Um esboço ilustrativo aproximado de código para fundamentar as restrições — não uma proposta, apenas uma forma de tornar as restrições concretas

Mostre isso ao usuário e prossiga imediatamente para o Passo 2. O usuário lê e reflete enquanto os subagentes trabalham em paralelo.

### 2. Dispare subagentes

Dispare 3+ subagentes em paralelo. Cada um deve produzir uma interface **radicalmente diferente** para o módulo aprofundado.

Oriente cada subagente com um briefing técnico separado (caminhos de arquivo, detalhes de acoplamento, categoria de dependência de [DEEPENING.md](DEEPENING.md), o que fica atrás da costura). O briefing é independente da explicação do espaço do problema voltada ao usuário no Passo 1. Dê a cada agente uma restrição de design diferente:

- Agente 1: "Minimize a interface — mire em 1–3 pontos de entrada no máximo. Maximize a alavancagem por ponto de entrada."
- Agente 2: "Maximize a flexibilidade — dê suporte a múltiplos casos de uso e extensão."
- Agente 3: "Otimize para o chamador mais comum — torne o caso padrão trivial."
- Agente 4 (se aplicável): "Projete em torno de portas & adaptadores para dependências que cruzam costuras."

Inclua tanto o vocabulário de [SKILL.md](SKILL.md) quanto o vocabulário de `CONTEXT.md` no briefing para que cada subagente nomeie as coisas de maneira consistente com a linguagem arquitetural e a linguagem de domínio do projeto.

Cada subagente gera como saída:

1. Interface (tipos, métodos, parâmetros — mais invariantes, ordenação, modos de erro)
2. Exemplo de uso mostrando como os chamadores a utilizam
3. O que a implementação oculta atrás da costura
4. Estratégia de dependências e adaptadores (veja [DEEPENING.md](DEEPENING.md))
5. Trade-offs — onde a alavancagem é alta, onde ela é baixa

### 3. Apresente e compare

Apresente os designs sequencialmente para que o usuário possa absorver cada um e, em seguida, compare-os em prosa. Contraste por **profundidade** (alavancagem na interface), **localidade** (onde a alteração se concentra) e **posicionamento da costura**.

Após a comparação, dê sua própria recomendação: qual design você considera o mais forte e por quê. Se elementos de designs diferentes combinarem bem, proponha um híbrido. Seja opinativo — o usuário quer uma leitura firme, não um cardápio de opções.
