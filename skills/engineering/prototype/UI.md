# Protótipo de Interface (UI)

Gere **várias variações de interface radicalmente diferentes** em uma única rota, alternáveis a partir de uma barra inferior flutuante. O usuário alterna entre as variantes no navegador, escolhe uma (ou aproveita partes de cada uma), e então descarta o restante.

Se a dúvida for sobre lógica/estado em vez de como algo deve parecer — caminho errado. Use [LOGIC.md](LOGIC.md).

## Quando este é o formato correto

- "Como esta página deve parecer?"
- "Quero ver algumas opções para este painel antes de me comprometer."
- "Experimente um layout diferente para a tela de configurações."
- Qualquer momento em que o usuário, de outra forma, passaria um dia escolhendo entre três mockups vagos na cabeça dele.

## Dois subformatos — prefira fortemente o subformato A

Um protótipo de interface é muito mais fácil de julgar quando está **em contato direto com o restante do aplicativo** — cabeçalho real, barra lateral real, dados reais, densidade real. Uma rota descartável isolada é um vácuo: toda variante parece boa isoladamente. Adote por padrão o subformato A sempre que houver uma página existente plausível para hospedar as variantes. Só recorra ao subformato B se o protótipo genuinamente não tiver um lar por perto.

### Subformato A — ajuste em uma página existente (preferido)

A rota já existe. As variantes são renderizadas **na mesma rota**, controladas por um parâmetro de busca na URL `?variant=`. A busca de dados existente, parâmetros e autenticação permanecem — apenas a renderização é trocada. Este é o padrão; escolha-o a menos que haja um motivo específico para não fazê-lo.

Se o protótipo for para algo que ainda não tem uma página, mas que *naturalmente viveria dentro de uma* (uma nova seção do painel, um novo card na tela de configurações, uma nova etapa em um fluxo existente) — isso ainda é o subformato A. Monte as variantes dentro da página hospedeira.

### Subformato B — uma nova página (último recurso)

Use isto apenas quando o elemento que está sendo prototipado genuinamente não tiver uma página existente para habitar — por exemplo, uma superfície de nível raiz inteiramente nova, ou um fluxo que não possa ser embutido em nenhum lugar sensato.

Crie uma **rota descartável** seguindo a convenção de rotas que o projeto já utiliza — não invente uma nova estrutura no nível raiz. Nomeie-a para que fique óbvio que é um protótipo (por exemplo, inclua a palavra `prototype` no caminho ou nome do arquivo). O mesmo padrão `?variant=`.

Antes de se comprometer com o subformato B, faça uma checagem de sanidade: realmente não há nenhuma página existente onde isso possa ser embutido? Uma rota vazia esconde problemas de design que uma rota populada exporia.

Em ambos os subformatos, a barra inferior flutuante é idêntica.

## Processo

### 1. Declare a dúvida e escolha N

Adote por padrão **3 variantes**. Mais de 5 deixa de ser radicalmente diferente e passa a ser ruído — limite-se a isso.

Anote o plano em uma linha, no local do protótipo ou em um comentário no topo do arquivo:

> "Três variantes da página de configurações, alternáveis via `?variant=`, na rota existente `/settings`."

Isso funciona quer o usuário esteja presente para opinar ou não.

### 2. Gere variantes radicalmente diferentes

Esboce cada variante. Submeta cada uma a:

- O propósito da página e os dados aos quais ela tem acesso.
- A biblioteca de componentes / sistema de estilos do projeto (TailwindCSS, shadcn, MUI, CSS puro, ou o que for).
- Um nome claro de componente exportado, por exemplo, `VariantA`, `VariantB`, `VariantC`.

As variantes devem ser **estruturalmente diferentes** — layout diferente, hierarquia de informações diferente, elemento de ação principal diferente, não apenas cores diferentes. Três grades de cards com pequenos ajustes não formam um protótipo de interface, formam papel de parede. Se dois rascunhos ficarem muito parecidos, refaça um com a orientação explícita "não use grade de cards".

### 3. Conecte-as

Crie um único componente alternador na rota:

```tsx
// pseudocódigo — adapte ao framework do projeto
const variant = searchParams.get('variant') ?? 'A';
return (
  <>
    {variant === 'A' && <VariantA {...data} />}
    {variant === 'B' && <VariantB {...data} />}
    {variant === 'C' && <VariantC {...data} />}
    <PrototypeSwitcher variants={['A','B','C']} current={variant} />
  </>
);
```

Para o subformato A (página existente): mantenha toda a busca de dados existente acima do alternador; apenas a subárvore renderizada muda por variante.

Para o subformato B (nova página): a rota descartável sob `/prototype/<nome>` monta o mesmo alternador.

### 4. Construa o alternador flutuante

Uma pequena barra de posição fixa na parte inferior central da tela com três partes:

- **Seta para a esquerda** — navega para a variante anterior (com rotação circular).
- **Rótulo da variante** — mostra a chave da variante atual e, se a variante exportar um nome, esse nome também. Exemplo: `B — Layout com barra lateral`.
- **Seta para a direita** — navega para a próxima (com rotação circular).

Comportamento:

- Clicar em uma seta atualiza o parâmetro de busca da URL (use o roteador do framework — `router.replace` no Next, `navigate` no React Router, etc.) para que a variante seja compartilhável e estável ao recarregar.
- Teclado: as teclas de seta `←` e `→` também alternam. Não intercepte as teclas de seta quando um `<input>`, `<textarea>` ou elemento com `[contenteditable]` estiver focado.
- Visualmente distinto da página (por exemplo, um formato de pílula em alto contraste, sombra suave) para que fique óbvio que não faz parte do design em avaliação.
- Oculto em builds de produção — controle via `process.env.NODE_ENV !== 'production'` ou checagem equivalente, para que um merge acidental do protótipo não envie a barra para os usuários.

Coloque o alternador em um único componente compartilhado para que ambos os subformatos possam reutilizá-lo. Posicione-o onde quer que os componentes compartilhados de interface fiquem no projeto.

### 5. Entregue-o

Apresente a URL (e as chaves de `?variant=`). O usuário navegará por elas quando puder. O feedback interessante costuma ser **"quero o cabeçalho da B com a barra lateral da C"** — esse é o design real que ele deseja.

### 6. Capture a resposta e faça a limpeza

Assim que uma variante vencer, capture a resposta — qual variante e por quê — depois capture o protótipo da forma descrita na [SKILL](SKILL.md). Incorpore a vencedora ao código real e mova o restante para a branch descartável, não para a main:

- **Subformato A** — incorpore a vencedora à página existente; remova da main as variantes derrotadas e o alternador.
- **Subformato B** — promova a variante vencedora a uma rota real; remova da main a rota descartável e o alternador.

O conjunto completo de variantes é a fonte primária, portanto ele vai para a branch descartável, não para a lixeira — componentes de variantes e o alternador esquecidos na branch main apodrecem rápido e confundem o próximo leitor.

## Antipadrões

- **Variantes que diferem apenas na cor ou no texto.** Isso é um ajuste fino, não um protótipo. Variantes reais divergem na estrutura.
- **Compartilhar código em excesso entre as variantes.** Um `<Header>` compartilhado é ótimo; um `<Layout>` compartilhado destrói o propósito. Cada variante deve ser livre para descartar o layout.
- **Conectar variantes a mutações reais.** Protótipos somente leitura são excelentes. Se uma variante precisar sofrer mutação, aponte para um stub — a dúvida é "como isso deve parecer", não "o backend funciona".
- **Promover o protótipo diretamente para produção.** O código da variante foi escrito sob restrições de protótipo (sem testes, tratamento mínimo de erros). Reescreva-o adequadamente ao incorporá-lo.
