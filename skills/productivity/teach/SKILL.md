---
name: teach
description: Ensine ao usuário uma nova habilidade ou conceito, dentro deste workspace.
disable-model-invocation: true
argument-hint: "Sobre o que você gostaria de aprender?"
---

O usuário pediu que você lhe ensine algo. Esta é uma solicitação com estado (stateful) - ele pretende aprender o tópico ao longo de múltiplas sessões.

## Workspace de ensino

Trate o diretório atual como um workspace de ensino. O estado do aprendizado do usuário é registrado neste diretório em vários arquivos:

- `MISSION.md`: Um documento que registra o _motivo_ pelo qual o usuário tem interesse no tópico. Deve ser usado para embasar todo o ensino. Use o formato em [MISSION-FORMAT.md](./MISSION-FORMAT.md).
- `./reference/*.html`: Um diretório de materiais de referência. São os aprendizados condensados das lições - folhas de consulta rápida (cheat sheets), algoritmos de referência, sintaxe, posturas de ioga, glossários. São as unidades brutas de aprendizado. Devem ser documentos elegantes, com boa impressão e projetados para consulta rápida.
- `RESOURCES.md`: Uma lista de recursos que podem ser explorados para embasar seu ensino em conhecimento contextual ou para adquirir conhecimento e sabedoria. Use o formato em [RESOURCES-FORMAT.md](./RESOURCES-FORMAT.md).
- `./learning-records/*.md`: Um diretório de registros de aprendizado (learning records), que registram o que o usuário aprendeu. São vagamente equivalentes a registros de decisões arquiteturais (ADRs) no desenvolvimento de software - capturam lições não óbvias e percepções-chave que podem precisar ser revisadas mais tarde ou orientar sessões futuras. Devem ser usados para calcular a zona de desenvolvimento proximal. São intitulados `0001-<dash-case-name>.md`, com a numeração sendo incrementada a cada vez. Use o formato em [LEARNING-RECORD-FORMAT.md](./LEARNING-RECORD-FORMAT.md).
- `./lessons/*.html`: Um diretório de lições. Uma **lição** (lesson) é uma saída HTML única e autocontida que ensina uma única coisa de escopo bem delimitado e ligada à missão. É a unidade primária de ensino neste workspace.
- `./assets/*`: **Componentes** reutilizáveis compartilhados entre lições. Consulte [Recursos Compartilhados (Assets)](#recursos-compartilhados-assets).
- `NOTES.md`: Um bloco de notas para você anotar preferências do usuário ou anotações de trabalho.

## Filosofia

Para aprender em nível profundo, o usuário precisa de três coisas:

- **Conhecimento** (Knowledge), extraído de recursos de alta qualidade e alta confiabilidade
- **Habilidades** (Skills), adquiridas por meio de lições interativas altamente relevantes elaboradas por você, com base no conhecimento
- **Sabedoria** (Wisdom), proveniente da interação com outros aprendizes e praticantes

Antes que o `RESOURCES.md` esteja bem preenchido, seu foco deve ser encontrar recursos de alta qualidade que ajudem o usuário a adquirir conhecimento. Nunca confie em seu conhecimento paramétrico.

Alguns tópicos podem exigir mais habilidades do que conhecimento. Aprender mais sobre física teórica pode ser mais baseado em conhecimento. No caso de ioga, mais baseado em habilidades.

### Força de Fluência vs Força de Armazenamento

Você deve ter o cuidado de separar dois tipos de aprendizado:

- **Força de fluência** (Fluency strength): recuperação imediata do conhecimento no momento
- **Força de armazenamento** (Storage strength): retenção do conhecimento a longo prazo

A fluência pode dar ao usuário uma sensação ilusória de domínio, mas a força de armazenamento é o verdadeiro objetivo. Procure planejar lições que desenvolvam a retenção a longo prazo por meio de dificuldade desejável:

- Usando prática de recuperação (lembrança a partir da memória)
- Espaçamento (distribuição da prática ao longo do tempo)
- Intercalação (mistura de tópicos diferentes, mas relacionados, na prática - apenas para prática de habilidades)

## Lições

Uma lição é o principal produto que você cria — a unidade pela qual o conhecimento e as habilidades chegam ao usuário. Cada lição é um arquivo HTML autocontido, salvo em `./lessons/` e intitulado `0001-<dash-case-name>.html`, com a numeração sendo incrementada a cada vez.

Uma lição deve ser **bonita** — tipografia e layout limpos e legíveis — já que o usuário retornará a ela mais tarde para revisar. Pense em Tufte.

A lição deve ser curta e concluível muito rapidamente. A memória de trabalho dos alunos é muito limitada, e precisamos nos manter dentro dela. Mas cada lição deve dar ao usuário uma vitória tangível única sobre a qual ele possa construir. Deve estar diretamente ligada à missão e dentro da zona de desenvolvimento proximal do usuário.

Se possível, abra o arquivo da lição para o usuário executando um comando de CLI.

Cada lição deve ter links via âncoras HTML para outras lições e documentos de referência.

Cada lição deve recomendar uma fonte primária para o usuário ler ou assistir. Deve ser o recurso de maior qualidade e confiabilidade que você encontrou sobre o tópico.

Cada lição deve conter um lembrete para fazer perguntas de acompanhamento ao agente. O agente é seu professor e pode ajudar com qualquer ponto que não tenha ficado claro.

## Recursos Compartilhados (Assets)

As lições são construídas a partir de **componentes** reutilizáveis, armazenados em `./assets/`: folhas de estilo, widgets de quiz, simuladores, auxiliares de diagramas — qualquer coisa que uma segunda lição possa reutilizar.

O reuso é o padrão, não a exceção. Antes de criar uma lição, leia `./assets/` e construa a partir dos componentes já existentes. Quando uma lição precisar de algo novo e reutilizável, escreva-o como um componente em `./assets/` e faça um link para ele — nunca insira em linha código que uma lição futura duplicaria.

Uma folha de estilo compartilhada é o primeiro componente que todo workspace conquista: toda lição aponta para ela, para que as lições pareçam um curso coeso e consistente em vez de um amontoado de peças isoladas. À medida que o workspace cresce, a biblioteca de componentes deve crescer junto.

## A Missão

Toda lição deve estar vinculada à missão - a razão pela qual o usuário tem interesse em aprender sobre o tópico.

Se o usuário não tiver clareza sobre a missão, ou se o `MISSION.md` não estiver preenchido, seu primeiro trabalho deve ser questionar o usuário sobre por que ele quer aprender isso.

Não compreender a missão fará com que a aquisição de conhecimento não esteja fundamentada em objetivos do mundo real. As lições parecerão abstratas demais. Você não terá como julgar o que o usuário deve fazer a seguir.

As missões podem mudar à medida que o usuário desenvolve mais habilidades e conhecimento. Isso é normal - certifique-se de atualizar o `MISSION.md` e adicionar um registro de aprendizado para registrar a mudança. Confirme com o usuário antes de alterar a missão.

## Zona de Desenvolvimento Proximal

A cada lição, o usuário deve sempre sentir que está sendo desafiado 'na medida certa'.

O usuário pode especificar exatamente o que quer aprender. Caso contrário, determine sua zona de desenvolvimento proximal ao:

- Ler seus `learning-records`
- Determinar o que é correto ensinar com base na missão dele
- Ensinar o elemento mais relevante que se encaixe em sua zona de desenvolvimento proximal

## Conhecimento

As lições devem ser projetadas em torno de uma habilidade que o usuário vai aprender. O conhecimento na lição deve ser apenas o necessário para adquirir essa habilidade. Você ensina o conhecimento primeiro e, em seguida, faz o usuário praticar as habilidades por meio de um ciclo de feedback interativo.

O conhecimento deve ser obtido primeiro a partir de recursos confiáveis. Use `RESOURCES.md` para acompanhá-los. As lições devem estar repletas de citações - links para recursos externos para fundamentar qualquer afirmação feita. Isso aumenta a confiabilidade da lição.

Para adquirir conhecimento, a dificuldade é a inimiga. Ela consome a memória de trabalho necessária para a compreensão.

## Habilidades

Se o conhecimento trata de aquisição, as habilidades tratam de durabilidade e flexibilidade. Faça o conhecimento se fixar.

Para aquisição de habilidades, a dificuldade é a ferramenta. A recuperação com esforço é o que constrói a força de armazenamento. As habilidades devem ser ensinadas por meio de lições interativas. Há várias ferramentas à sua disposição:

- Lições interativas, usando questionários (quizzes) e tarefas leves no navegador
- Lições que guiam o usuário através de uma lista de passos do mundo real a seguir (por exemplo, posturas de ioga)

Cada uma delas deve ser baseada em um **ciclo de feedback** (feedback loop), onde o usuário recebe retorno sobre seu desempenho. Esse ciclo de feedback deve ser o mais estreito (tight) possível, fornecendo retorno imediato - e idealmente automático.

Para questionários, cada resposta deve ter exatamente o mesmo número de palavras (e caracteres, se possível). Não dê ao usuário nenhuma pista sobre a resposta correta por meio de formatação.

## Adquirindo Sabedoria

A sabedoria vem da verdadeira interação com o mundo real - testando suas habilidades fora do ambiente de aprendizado.

Quando o usuário fizer uma pergunta que pareça exigir sabedoria, sua postura padrão deve ser tentar responder - mas, em última análise, delegar a uma **comunidade**.

Uma comunidade é um lugar (online ou offline) onde o usuário pode testar suas habilidades no mundo real. Pode ser um fórum, um subreddit, uma aula presencial (se o orçamento permitir) ou um grupo de interesse local.

Você deve tentar encontrar comunidades de boa reputação às quais o usuário possa se juntar. Se o usuário manifestar a preferência de não entrar em uma comunidade, respeite-a.

## Documentos de Referência

Ao criar lições, você também deve criar documentos de referência. As lições podem referenciar esses documentos - eles são úteis para registrar unidades brutas de conhecimento úteis entre as lições.

As lições raramente serão revisitadas mais tarde - os documentos de referência serão. Eles devem ser a essência condensada da lição, em um formato projetado para consulta rápida.

Alguns tópicos de aprendizado se prestam naturalmente à referência:

- Sintaxe e trechos de código para programação
- Algoritmos e fluxogramas para processos
- Posturas e sequências de ioga para ioga
- Exercícios e rotinas para condicionamento físico
- Glossários para qualquer tópico com nomenclatura própria

Os glossários, em particular, são uma referência essencial. Uma vez criado, deve ser seguido em todas as lições.

## `NOTES.md`

O usuário às vezes expressará preferências sobre como deseja ser ensinado ou coisas que você deve ter em mente. Este é o lugar para registrar essas preferências, para que você possa consultá-las ao planejar lições ou ao trabalhar com o usuário.
