---
name: code-review
description: Revise as alterações desde um ponto fixo (commit, branch, tag ou merge-base) ao longo de dois eixos — Padrões (o código segue os padrões de código documentados deste repositório?) e Spec (o código corresponde ao que a issue/spec de origem pediu?). Executa ambas as revisões em subagentes paralelos e as relata lado a lado. Use quando o usuário quiser revisar um branch, um PR, alterações em andamento ou pedir para "revisar desde X".
---

Revisão em dois eixos do diff entre `HEAD` e um ponto fixo fornecido pelo usuário:

- **Standards** — o código está em conformidade com os padrões de código documentados deste repositório?
- **Spec** — o código implementa fielmente a issue / spec de origem?

Ambos os eixos rodam como **subagentes paralelos** para não poluir o contexto um do outro; em seguida, esta skill agrega suas constatações.

O issue tracker deve ter sido fornecido a você — execute `/setup-matt-pocock-skills` se `docs/agents/issue-tracker.md` estiver ausente.

## Processo

### 1. Fixe o ponto de referência

O que quer que o usuário tenha indicado como ponto fixo — um commit SHA, nome de branch, tag, `main`, `HEAD~5`, etc. Se não tiverem especificado um, pergunte por ele.

Capture o comando de diff uma vez: `git diff <fixed-point>...HEAD` (três pontos, para que a comparação seja contra a base de merge). Anote também a lista de commits via `git log <fixed-point>..HEAD --oneline`.

Antes de prosseguir, confirme que o ponto fixo é resolvido com sucesso (`git rev-parse <fixed-point>`) e que o diff não está vazio. Uma referência inválida ou diff vazio deve falhar aqui — não dentro de dois subagentes paralelos.

### 2. Identifique a fonte da spec

Procure a spec de origem, nesta ordem:

1. Referências a issues nas mensagens de commit (`#123`, `Closes #45`, GitLab `!67`, etc.) — busque por meio do fluxo de trabalho em `docs/agents/issue-tracker.md`.
2. Um caminho que o usuário passou como argumento.
3. Um arquivo de spec sob `docs/`, `specs/` ou `.scratch/` correspondente ao nome do branch ou funcionalidade.
4. Se nada for encontrado, pergunte ao usuário onde está a spec. Se ele disser que não há nenhuma, o subagente de **Spec** pulará a execução e relatará "nenhuma spec disponível".

### 3. Identifique as fontes dos padrões

Qualquer coisa no repositório que documente como o código deve ser escrito, como `CODING_STANDARDS.md` ou `CONTRIBUTING.md`.

Além do que quer que o repositório documente, o eixo Standards sempre carrega a **linha de base de smells** abaixo — um conjunto fixo de code smells do Fowler (_Refactoring_, cap. 3) que se aplica mesmo quando o repositório não documenta nada. Duas regras o regem:

- **O repositório tem precedência.** Um padrão documentado no repositório sempre vence; onde ele endossar algo que a linha de base sinalizaria, suprima o smell.
- **Sempre uma questão de julgamento.** Cada smell é uma heurística rotulada ("possível Feature Envy"), nunca uma violação estrita — e, como qualquer padrão aqui, ignore qualquer coisa que as ferramentas já apliquem.

Cada smell indica *o que é* → *como corrigir*; compare-o com o diff:

- **Mysterious Name** — uma função, variável ou tipo cujo nome não revela o que faz ou contém. → renomeie-a; se nenhum nome honesto surgir, o design está obscuro.
- **Duplicated Code** — a mesma estrutura lógica aparece em mais de um trecho (hunk) ou arquivo na alteração. → extraia a estrutura compartilhada, chame-a de ambos os lugares.
- **Feature Envy** — um método que acessa os dados de outro objeto mais do que os seus próprios. → mova o método para junto dos dados que ele inveja.
- **Data Clumps** — os mesmos poucos campos ou parâmetros continuam viajando juntos (um tipo querendo nascer). → agrupe-os em um único tipo, passe esse tipo.
- **Primitive Obsession** — um tipo primitivo ou string atuando no lugar de um conceito de domínio que merece seu próprio tipo. → dê ao conceito seu próprio tipo pequeno.
- **Repeated Switches** — o mesmo `switch`/cascata de `if` sobre o mesmo tipo se repete pela alteração. → substitua por polimorfismo, ou um único mapa que ambos os locais compartilham.
- **Shotgun Surgery** — uma alteração lógica força edições espalhadas por muitos arquivos no diff. → reúna o que muda junto em um único módulo.
- **Divergent Change** — um arquivo ou módulo é editado por vários motivos não relacionados. → divida para que cada módulo mude por um único motivo.
- **Speculative Generality** — abstração, parâmetros ou hooks adicionados para necessidades que a spec não tem. → exclua; desfaça o inline até que uma necessidade real apareça.
- **Message Chains** — navegação longa `a.b().c().d()` da qual o chamador não deveria depender. → oculte o caminho atrás de um único método no primeiro objeto.
- **Middle Man** — uma classe ou função que na maior parte apenas delega adiante. → corte-a, chame o alvo real diretamente.
- **Refused Bequest** — uma subclasse ou implementador que ignora ou sobrescreve a maior parte do que herda. → remova a herança, use composição.

### 4. Dispare ambos os subagentes em paralelo

**Prompt do subagente de Standards** — inclua:

- O comando completo de diff e a lista de commits.
- A lista de arquivos de fontes de padrões que você encontrou no passo 3, **mais a linha de base de smells do passo 3** colada na íntegra — o subagente não tem outro acesso a ela.
- A instrução: "Relate — por arquivo/hunk quando relevante — (a) cada lugar onde o diff viola um padrão documentado: cite o padrão (arquivo + a regra); e (b) qualquer smell da linha de base que você notar: dê o nome e cite o trecho (hunk). Distinga violações estritas de decisões de julgamento — violações de padrões documentados podem ser estritas, mas smells da linha de base são sempre decisões de julgamento, e um padrão documentado do repositório se sobrepõe à linha de base. Ignore qualquer coisa que as ferramentas já apliquem. Menos de 400 palavras."

**Prompt do subagente de Spec** — inclua:

- O comando de diff e a lista de commits.
- O caminho ou conteúdo obtido da spec.
- A instrução: "Relate: (a) requisitos que a spec pediu que estão ausentes ou parciais; (b) comportamento no diff que não foi pedido (aumento de escopo); (c) requisitos que parecem implementados, mas cuja implementação parece incorreta. Cite a linha da spec para cada constatação. Menos de 400 palavras."

Se a spec estiver ausente, pule o subagente de Spec e anote isso no relatório final.

### 5. Agregue

Apresente os dois relatórios sob os títulos `## Standards` e `## Spec`, literalmente ou levemente limpos. **Não** mescle nem reclassifique as constatações — os dois eixos são deliberadamente separados (veja _Por que dois eixos_).

Termine com um resumo de uma linha: total de constatações por eixo e o pior problema _dentro de cada eixo_ (se houver). Não escolha um único vencedor entre os eixos — essa é a reclassificação que a separação existe para evitar.

## Por que dois eixos

Uma alteração pode passar em um eixo e falhar no outro:

- Código que segue todos os padrões, mas implementa a coisa errada → **Standards passa, Spec falha.**
- Código que faz exatamente o que a issue pediu, mas quebra as convenções do projeto → **Spec passa, Standards falha.**

Relatá-los separadamente impede que um eixo mascare o outro.
