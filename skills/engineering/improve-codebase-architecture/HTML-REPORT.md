# Formato do Relatório HTML

A revisão arquitetural é renderizada como um único arquivo HTML autocontido no diretório temporário do sistema operacional. Tailwind e Mermaid vêm ambos de CDNs. O Mermaid lida com diagramas em formato de grafo de forma confiável; divs construídos à mão e SVG inline lidam com recursos visuais mais editoriais (diagramas de massa, cortes transversais). Misture os dois — não dependa do Mermaid para tudo, começará a parecer genérico.

## Scaffold

```html
<!doctype html>
<html lang="pt-BR">
  <head>
    <meta charset="utf-8" />
    <title>Revisão de arquitetura — {{repo name}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      /* pequena camada personalizada para coisas que o Tailwind não cobre de forma limpa:
         linhas de costura tracejadas, pontas de seta com aspecto feito à mão, etc. */
      .seam { stroke-dasharray: 4 4; }
      .leak { stroke: #dc2626; }
      .deep { background: linear-gradient(135deg, #0f172a, #1e293b); }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-5xl mx-auto px-6 py-12 space-y-12">
      <header>...</header>
      <section id="candidates" class="space-y-10">...</section>
      <section id="top-recommendation">...</section>
    </main>
  </body>
</html>
```

## Cabeçalho

Nome do repositório, data e uma legenda compacta: caixa sólida = módulo, linha tracejada = costura, seta vermelha = vazamento (leakage), caixa escura e grossa = deep module. Sem parágrafo de introdução — direto aos candidatos.

## Card do candidato

Os diagramas carregam o peso. A prosa é esparsa, direta e usa os termos do glossário (da skill `/codebase-design`) sem rodeios.

Cada candidato é um `<article>`:

- **Título** — curto, nomeia o aprofundamento (ex.: "Colapsar o pipeline de entrada de pedidos").
- **Linha de badges** — força da recomendação (`Strong` = esmeralda, `Worth exploring` = âmbar, `Speculative` = slate), mais uma tag para a categoria de dependência (`in-process`, `local-substitutable`, `ports & adapters`, `mock`).
- **Arquivos** — lista monoespaçada, `font-mono text-sm`.
- **Diagrama de Antes / Depois** — a peça central. Duas colunas, lado a lado. Veja os padrões abaixo.
- **Problema** — uma frase. O que incomoda.
- **Solução** — uma frase. O que muda.
- **Ganhos (Wins)** — tópicos, ≤6 palavras cada. ex.: "Testes atingem uma interface", "Lógica de preços para de vazar", "Exclui 4 wrappers rasos".
- **Callout de ADR** (se aplicável) — uma linha em uma caixa com tom âmbar.

Sem parágrafos de explicação. Se o diagrama precisar de um parágrafo para ser compreendido, redesenhe o diagrama.

## Padrões de diagrama

Escolha o padrão que se adapta ao candidato. Misture-os. Não faça todos os diagramas parecerem iguais — variedade faz parte do objetivo.

### Grafo Mermaid (o cavalo de batalha para dependências / fluxo de chamadas)

Use um `flowchart` ou `graph` do Mermaid quando o ponto for "X chama Y que chama Z, e veja a bagunça". Envolva-o em um card estilizado com Tailwind para que não pareça deslocado. Estilize com classDef para colorir arestas de vazamento em vermelho e o deep module em escuro. Diagramas de sequência funcionam bem para "antes: 6 viagens de ida e volta (round-trips); depois: 1".

```html
<div class="rounded-lg border border-slate-200 bg-white p-4">
  <pre class="mermaid">
    flowchart LR
      A[OrderHandler] --> B[OrderValidator]
      B --> C[OrderRepo]
      C -.leak.-> D[PricingClient]
      classDef leak stroke:#dc2626,stroke-width:2px;
      class C,D leak
  </pre>
</div>
```

### Caixas e setas feitas à mão (quando o layout do Mermaid brigar com você)

Módulos como `<div>`s com bordas e rótulos. Setas como elementos SVG inline `<line>` ou `<path>` posicionados de forma absoluta sobre um contêiner relativo. Recorra a isso quando quiser que o diagrama "depois" pareça um único deep module de bordas grossas com partes internas esmaecidas — o Mermaid não renderizará isso com o peso correto.

### Corte transversal (bom para superficialidade em camadas)

Empilhe faixas horizontais (`h-12 border-l-4`) para mostrar as camadas pelas quais uma chamada passa. Antes: 6 camadas finas, cada uma fazendo nada. Depois: 1 faixa grossa rotulada com a responsabilidade consolidada.

### Diagrama de massa (bom para "interface tão ampla quanto a implementação")

Dois retângulos por módulo — um para a área de superfície da interface, outro para a implementação. Antes: o retângulo da interface é quase tão alto quanto o retângulo da implementação (raso). Depois: o retângulo da interface é curto, o retângulo da implementação é alto (deep).

### Colapso do grafo de chamadas

Antes: uma árvore de chamadas de funções renderizada como caixas aninhadas. Depois: a mesma árvore colapsada em uma única caixa, com as chamadas agora internas exibidas esmaecidas dentro dela.

## Guia de estilo

- Editorial enxuto, não um painel corporativo. Espaçamento generoso. Serifa opcional para títulos (`font-serif` funciona bem com stone/slate).
- Cor com moderação: um destaque (esmeralda ou índigo) mais vermelho para vazamentos e âmbar para avisos.
- Mantenha os diagramas com ~320px de altura para que o antes/depois fique confortavelmente lado a lado sem rolagem.
- Use `text-xs uppercase tracking-wider` para rótulos de módulos dentro dos diagramas — eles devem ser lidos como esquemáticos, não como UI.
- Os únicos scripts são o CDN do Tailwind e a importação ESM do Mermaid. O relatório é estático em tudo o mais — sem código de aplicação, sem interatividade além da própria renderização do Mermaid.

## Seção de principal recomendação

Um card maior. Nome do candidato, uma frase sobre o porquê, link âncora para o seu card. É só isso.

## Tom

Português claro e conciso — mas os substantivos e verbos arquiteturais vêm direto da skill `/codebase-design`. Concisão não é desculpa para desvios.

**Use com exatidão:** módulo, interface, implementação, profundidade, deep, raso, costura, adaptador, alavancagem, localidade.

**Nunca substitua:** componente, serviço, unidade (para módulo) · API, assinatura (para interface) · divisa (para costura) · camada, wrapper (para módulo, quando quiser dizer módulo).

**Formulações que se encaixam no estilo:**

- "Módulo de entrada de pedidos é raso — a interface quase coincide com a implementação."
- "Preços vazam através da costura."
- "Aprofunde: uma interface, um lugar para testar."
- "Dois adaptadores justificam a costura: HTTP em produção, em memória nos testes."

**Tópicos de ganhos (Wins)** nomeiam o ganho em termos do glossário: *"localidade: bugs se concentram em um módulo"*, *"alavancagem: uma interface, N pontos de chamada"*, *"interface encolhe; implementação absorve os wrappers"*. Não escreva *"mais fácil de manter"* ou *"código mais limpo"* — esses termos não estão no glossário e não justificam seu espaço.

Sem hesitação, sem enrolação, sem "vale ressaltar que…". Se uma frase puder ser um tópico, torne-a um tópico. Se um tópico puder ser cortado, corte-o. Se um termo não estiver no glossário de `/codebase-design`, procure um que esteja antes de inventar um novo.
