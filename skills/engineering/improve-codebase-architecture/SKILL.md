---
name: improve-codebase-architecture
description: Varra uma base de código em busca de oportunidades de aprofundamento, apresente-as como um relatório HTML visual e sabatine qualquer uma que você escolher.
disable-model-invocation: true
---

# Improve Codebase Architecture

Traga à tona a fricção arquitetural e proponha **oportunidades de aprofundamento** — refatorações que transformam módulos rasos em deep modules. O objetivo é testabilidade e navegabilidade por IA.

Este comando é _informado_ pelo modelo de domínio do projeto e construído sobre um vocabulário de design compartilhado:

- Execute a skill `/codebase-design` para o vocabulário de arquitetura (**módulo**, **interface**, **profundidade**, **costura**, **adaptador**, **alavancagem**, **localidade**) e seus princípios (o teste de deleção, "a interface é a superfície de teste", "um adaptador = costura hipotética, dois = real"). Use estes termos com exatidão em cada sugestão — não desvie para "componente", "serviço", "API" ou "divisa".
- A linguagem de domínio em `CONTEXT.md` dá nomes a boas costuras; ADRs em `docs/adr/` registram decisões que este comando não deve rediscutir.

## Processo

### 1. Explorar

**Delimite o escopo antes de varrer — YAGNI.** Aprofundar um módulo se paga ao facilitar mudanças futuras nele, portanto dê peso extra às partes da base de código que mudaram recentemente. Decida *onde* olhar antes de olhar:

- Se o usuário indicou uma direção — um módulo, um subsistema, um ponto de dor — siga-a e pule a inferência abaixo.
- Caso contrário, examine um bom trecho do histórico de commits (`git log --oneline`) para encontrar os hot spots da base de código — os arquivos e áreas que continuam aparecendo — e deixe esses caminhos chamarem sua atenção primeiro. Se as alterações estiverem espalhadas sem um hot spot claro, amplie a busca.

Leia o glossário de domínio do projeto (`CONTEXT.md`) e quaisquer ADRs na área em que você estiver mexendo primeiro.

Em seguida, dispare um subagente para percorrer a base de código. Não siga heurísticas rígidas — explore organicamente e anote onde sentir fricção:

- Onde o entendimento de um conceito exige alternar entre muitos módulos pequenos?
- Onde os módulos são **rasos** — interface quase tão complexa quanto a implementação?
- Onde funções puras foram extraídas apenas para testabilidade, mas os bugs reais se escondem em como elas são chamadas (sem **localidade**)?
- Onde módulos fortemente acoplados vazam através de suas costuras?
- Quais partes da base de código não são testadas ou são difíceis de testar por meio de sua interface atual?

Aplique o **teste de deleção** a qualquer coisa que você suspeite ser rasa: deletá-la concentraria a complexidade ou apenas a moveria de lugar? Um "sim, concentra" é o sinal que você procura.

### 2. Apresentar candidatos como um relatório HTML

Escreva um arquivo HTML autocontido no diretório temporário do sistema operacional para que nada caia no repositório. Resolva o diretório temporário a partir de `$TMPDIR`, com fallback para `/tmp` (ou `%TEMP%` no Windows), e escreva em `<tmpdir>/architecture-review-<timestamp>.html` para que cada execução receba um arquivo novo. Abra-o para o usuário — `xdg-open <path>` no Linux, `open <path>` no macOS, `start <path>` no Windows — e informe a eles o caminho absoluto.

O relatório usa **Tailwind via CDN** para layout e estilização, e **Mermaid via CDN** para diagramas onde um gráfico/fluxo/sequência comunica a estrutura de forma confiável. Misture Mermaid com recursos visuais em CSS/SVG feitos à mão — use Mermaid quando os relacionamentos tiverem formato de grafo (grafos de chamadas, dependências, sequências) e divs/SVG construídos à mão quando quiser algo mais editorial (diagramas de massa, cortes transversais, animações de colapso). Cada candidato ganha uma **visualização de antes/depois**. Seja visual.

Para cada candidato, renderize um card com:

- **Arquivos** — quais arquivos/módulos estão envolvidos
- **Problema** — por que a arquitetura atual está causando fricção
- **Solução** — descrição em linguagem clara do que mudaria
- **Benefícios** — explicados em termos de localidade e alavancagem, e como os testes melhorariam
- **Diagrama de Antes / Depois** — lado a lado, desenhado sob medida, ilustrando a superficialidade e o aprofundamento
- **Força da recomendação** — uma entre `Strong`, `Worth exploring`, `Speculative`, renderizada como um badge

Termine o relatório com uma seção de **Principal recomendação**: qual candidato você abordaria primeiro e por quê.

**Use o vocabulário de CONTEXT.md para o domínio e o vocabulário de `/codebase-design` para a arquitetura.** Se `CONTEXT.md` define "Order", fale sobre "o módulo de entrada de Order" — não "o FooBarHandler" e não "o serviço de Order".

**Conflitos com ADRs**: se um candidato contradisser um ADR existente, apresente-o apenas quando a fricção for real o suficiente para justificar revisitar o ADR. Marque isso claramente no card (por exemplo, um callout de aviso: _"contradiz o ADR-0007 — mas vale a pena reabrir porque…"_). Não liste toda refatoração teórica que um ADR proíbe.

Veja [HTML-REPORT.md](HTML-REPORT.md) para o scaffold HTML completo, padrões de diagramas e orientações de estilo.

NÃO proponha interfaces ainda. Após o arquivo ser escrito, pergunte ao usuário: "Qual destes você gostaria de explorar?"

### 3. Loop de sabatina (Grilling loop)

Assim que o usuário escolher um candidato, execute a skill `/grilling` para percorrer a árvore de decisões com ele — restrições, dependências, o formato do módulo aprofundado, o que fica atrás da costura, quais testes sobrevivem.

Efeitos colaterais acontecem inline conforme as decisões se cristalizam — execute a skill `/domain-modeling` para manter o modelo de domínio atualizado à medida que avança:

- **Nomeando um módulo aprofundado com um conceito que não está em `CONTEXT.md`?** Adicione o termo ao `CONTEXT.md`. Crie o arquivo sob demanda (lazily) se ele não existir.
- **Refinando um termo impreciso durante a conversa?** Atualize o `CONTEXT.md` ali mesmo.
- **O usuário rejeitou o candidato por um motivo estrutural importante (load-bearing)?** Ofereça um ADR, formulado como: _"Quer que eu registre isso como um ADR para que revisões de arquitetura futuras não voltem a sugerir isso?"_ Ofereça apenas quando o motivo realmente for necessário para que um explorador futuro evite sugerir a mesma coisa — ignore motivos efêmeros ("não vale a pena agora") e autoevidentes.
- **Quer explorar interfaces alternativas para o módulo aprofundado?** Execute a skill `/codebase-design` e use seu padrão de subagentes paralelos design-it-twice.
