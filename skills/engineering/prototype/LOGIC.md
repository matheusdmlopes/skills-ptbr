# Protótipo de Lógica

Um único arquivo HTML autocontido — uma **demonstração compartilhável** — que permite a qualquer pessoa operar um modelo de estado clicando em botões. Use isso quando a dúvida for sobre **lógica de negócios, transições de estado ou formato de dados** — o tipo de coisa que parece razoável no papel, mas que só dá sensação de estar errada quando você a submete a casos reais.

Como é um único arquivo sem nada para instalar, você pode entregá-lo a uma pessoa não desenvolvedora — um designer, um PM, um especialista no domínio — e deixá-la sentir o modelo por conta própria. Assim, ele fala a língua deles, não a do código.

## Quando este é o formato correto

- "Não tenho certeza se essa máquina de estados lida com o caso de borda em que X acontece e depois Y."
- "Esse modelo de dados realmente me permite representar o caso em que..."
- "Quero sentir como a API deve ser antes de escrevê-la."
- Qualquer situação em que alguém queira **pressionar botões e ver o estado mudar**.

Se a dúvida for "como isso deve parecer" — caminho errado. Use [UI.md](UI.md).

## Processo

### 1. Declare a dúvida

Antes de escrever código, anote qual modelo de estado e qual dúvida você está prototipando. Um parágrafo, no topo da demonstração (em uma introdução visível, não apenas em um comentário). Um protótipo de lógica que responde à dúvida errada é puro desperdício — torne a dúvida explícita para que possa ser conferida mais tarde, quer o usuário esteja acompanhando agora ou voltando a ela depois.

### 2. Isole a lógica em um módulo portátil

Coloque a lógica real — a parte que está respondendo à dúvida — em um único bloco `<script>` escrito como um módulo pequeno e puro que possa ser extraído e inserido na base de código real mais tarde. A página ao redor é descartável; este módulo não é.

O formato correto depende da dúvida:

- **Um reducer puro** — `(state, action) => state`. Bom quando as ações são eventos discretos e o estado é um valor único.
- **Uma máquina de estados** — estados e transições explícitos. Bom quando "quais ações são sequer válidas neste momento" faz parte da dúvida.
- **Um pequeno conjunto de funções puras** sobre um tipo de dado simples. Bom quando não há estado atual implícito — apenas transformações.
- **Uma classe ou módulo com uma superfície clara de métodos** quando a lógica genuinamente detém estado interno contínuo.

Escolha o formato que melhor se adaptar à dúvida levantada, *não* o que for mais fácil de conectar a uma página. Mantenha-o puro: nada de DOM, nada de `document`, nada de manipuladores de botões acessando suas entranhas. A página chama o módulo; nada flui na direção oposta. É isso que torna o protótipo útil além de sua própria vida útil: uma vez respondida a dúvida, o conjunto validado de reducer / máquina / funções é transferido para o módulo real por conta própria.

### 3. Construa o arquivo HTML compartilhável

Um único arquivo, HTML/CSS/JS puro — sem framework, sem empacotador (bundler), sem servidor, tudo embutido para que abra com um clique duplo e sobreviva ao envio por e-mail. Qualquer pessoa deve ser capaz de executá-lo apenas abrindo-o.

Escreva-o para uma pessoa não desenvolvedora. Cada rótulo deve estar na **linguagem de domínio**, não em código — botões e estados devem soar como o negócio, não como o reducer. Explique em palavras simples o que está acontecendo.

Organize-o com uma hierarquia limpa, de cima para baixo:

1. **Título e explicação de uma linha** sobre o que esta demonstração permite explorar (a dúvida da etapa 1).
2. **Estado atual** — o estado relevante completo, renderizado como um painel legível (campos rotulados, não um dump bruto de JSON), renderizado novamente após cada clique para que a mudança fique visível. Onde ajudar uma pessoa não desenvolvedora a acompanhar, destaque o que acabou de mudar.
3. **Botões de uso livre** — um botão por ação, sempre disponível, para que qualquer pessoa possa experimentar o modelo em qualquer ordem. Cada clique despacha sua ação e renderiza o estado novamente.
4. **Tutoriais guiados** — um conjunto de **cenários**, um por aba. Cada aba contém uma breve descrição em linguagem simples sobre o cenário — a situação que ele prepara e o que observar — e, abaixo dela, a sequência ordenada de **botões a pressionar** para aquele cenário. Cada etapa é um botão real: clicar nele executa a ação e avança para a próxima etapa. Iniciar um tutorial redefine para um estado inicial conhecido para que o cenário execute da mesma forma todas as vezes.

Escolha cenários que demonstrem os casos complicados — o caminho feliz, um caso de borda capcioso, uma tentativa de fazer algo que deveria ser inválido — aqueles difíceis de raciocinar no papel.

Mantenha-o bonito, mas contido: tipografia limpa, espaçamento generoso, uma única cor de destaque. Sem animações, sem firulas — nada que concorra com o estado e com os botões.

### 4. Entregue-o

Envie o arquivo a eles, ou abra-o para eles. Eles clicarão pelos tutoriais e experimentarão livremente quando puderem; os momentos interessantes são quando dizem "espere, isso não deveria ser possível" ou "ué, eu achava que X seria diferente" — esses são os bugs na _ideia_, que é exatamente o ponto. Se quiserem novas ações ou um novo cenário, adicione-os. Protótipos evoluem.

### 5. Capture a resposta e o protótipo

Assim que o protótipo tiver respondido à sua dúvida, capture a resposta e depois capture o protótipo da forma descrita na [SKILL](SKILL.md). O mapeamento específico para lógica: o conjunto validado de reducer / máquina / funções é incorporado ao módulo real (a decisão, absorvida); a casca HTML é levada para a branch descartável que mantém o protótipo como uma fonte primária — e, sendo um único arquivo autocontido, ele permanece trivialmente reexecutável por lá.

## Antipadrões

- **Não adicione testes.** Um protótipo que precisa de testes não é mais um protótipo.
- **Não conecte ao banco de dados real.** Use estado em memória, a menos que a dúvida seja especificamente sobre persistência.
- **Não generalize.** Nada de "e se quisermos suportar X mais tarde". O protótipo responde a uma única dúvida.
- **Não misture a lógica com a página.** Se o módulo puro fizer referência ao DOM, a `document` ou a manipuladores de botões, ele não poderá mais ser extraído facilmente. Mantenha a página como uma casca fina sobre um módulo puro.
- **Não recorra a framework, bundler ou servidor.** Um arquivo no qual o destinatário dá um clique duplo; um aplicativo React ou um servidor de desenvolvimento destroem a característica de ser "compartilhável".
- **Não envie a casca HTML para produção.** A página foi otimizada para cliques manuais. O módulo de lógica por trás dela é a parte que vale a pena manter.
