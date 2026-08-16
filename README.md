<p>
  <a href="https://www.aihero.dev/s/skills-newsletter">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skills-repo-dark_2x.png">
      <source media="(prefers-color-scheme: light)" srcset="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skill-repo-light_2x.png">
      <img alt="Skills" src="https://res.cloudinary.com/total-typescript/image/upload/v1777382277/skill-repo-light_2x.png" width="369">
    </picture>
  </a>
</p>

# Skills Para Engenheiros de Verdade

[![skills.sh](https://skills.sh/b/matheusdmlopes/skills-ptbr)](https://skills.sh/matheusdmlopes/skills-ptbr)

> Tradução para pt-BR da coleção de agent skills de [Matt Pocock](https://github.com/mattpocock/skills). Obra derivada sob licença MIT, não afiliada ao autor original — veja [NOTICE](./NOTICE). A seção "Por que essas skills existem" abaixo preserva a voz em primeira pessoa do autor original; o restante do documento é instrução operacional deste repositório.

Skills de agente que eu uso todos os dias para fazer engenharia de verdade — não vibe coding.

Desenvolver aplicações de verdade é difícil. Abordagens como GSD, BMAD e Spec-Kit tentam ajudar assumindo o controle do processo. Mas, ao fazer isso, tiram o seu controle e tornam os bugs do processo difíceis de resolver.

Estas skills foram desenhadas para serem pequenas, fáceis de adaptar e componíveis. Funcionam com qualquer modelo. São baseadas em décadas de experiência em engenharia. Mexa nelas. Faça-as suas. Aproveite.

Se você quiser acompanhar mudanças nestas skills, e quaisquer novas que eu criar, pode se juntar a ~60.000 outros devs na minha newsletter (em inglês):

[Assine a Newsletter](https://www.aihero.dev/s/skills-newsletter)

## Instalação (configuração de 30 segundos)

Esta tradução é instalada com o CLI [skills.sh](https://skills.sh/matheusdmlopes/skills-ptbr), que copia os arquivos de skill, editáveis, para o seu projeto.

### 1. Obtenha as skills

```bash
npx skills@latest add matheusdmlopes/skills-ptbr
```

Escolha as skills que quiser, e em quais agentes de código instalá-las. **O instalador deixa você escolher quais skills levar — garanta que `setup-matt-pocock-skills` seja uma delas.**

O instalador oferece todas as skills deste repositório, e nem todas estão traduzidas. Em pt-BR estão as skills promovidas listadas em `.claude-plugin/plugin.json`, mais `claude-handoff` e `loop-me`. As demais de `in-progress/`, todas as de `misc/` e `deprecated/`, e as páginas em `docs/` seguem no inglês original, herdadas sem alteração do repositório original. Para distinguir na hora de escolher, leia a `description` de cada item na lista — ela está escrita no idioma daquela skill.

Isso grava as skills no seu repositório como arquivos comuns, que você possui e pode editar. Nada é atualizado nas suas costas; busque as atualizações quando quiser com `npx skills update`.

Para trocar de idioma depois — por exemplo, voltar para o original em inglês —, reinstale a partir da outra origem. A reinstalação substitui integralmente a versão anterior:

```bash
npx skills@latest add mattpocock/skills            # inglês (original)
npx skills@latest add matheusdmlopes/skills-ptbr   # pt-BR (esta tradução)
```

### 2. Rode `/setup-matt-pocock-skills`

No seu agente, rode uma vez por repositório. Ele vai:

- Perguntar qual issue tracker você quer usar (GitHub, Linear, ou arquivos locais)
- Perguntar quais labels você aplica a tickets quando os tria (`/triage` usa labels)
- Perguntar onde você quer salvar quaisquer docs que criarmos

### 3. Pronto — você já pode começar.

### Nota: Antigravity / Gemini CLI (`agy`)

Se o passo 2 já deu "invalid command" pra você ao digitar `/setup-matt-pocock-skills` dentro do `agy`, não era bug desta tradução nem incompatibilidade permanente — era um bug do próprio `agy`, já corrigido. Versões antigas do CLI (1.0.1–1.0.8) tinham uma série de falhas documentadas no próprio changelog (`agy changelog`) em torno da descoberta e execução de comandos derivados de skill: skills que não recarregavam dinamicamente, sugestões do autocomplete que limpavam o campo sem executar o comando, descoberta de skill "fallback" que falhava quando o diretório de configuração padrão estava ausente. A partir da versão 1.0.8 essas falhas foram corrigidas, e a partir da 1.1.9 o mesmo mecanismo de expansão de slash-command passou a valer também no modo `-p`/print (`agy` atualiza sozinho, então é provável que você tenha simplesmente pego uma versão anterior a essa janela).

Testamos ao vivo com `agy` 1.1.13: `/setup-matt-pocock-skills` aparece no autocomplete (puxando a `description` do `SKILL.md`) e executa a skill de ponta a ponta, corretamente. Se ainda dermos erro na sua versão, rode `agy update` primeiro.

Dois detalhes que continuam valendo:

- O Antigravity lê skills de um diretório global por usuário (`~/.agents/skills`), além de um local por repositório — por isso uma skill instalada aparece em qualquer projeto, não só no repositório onde foi instalada.
- Desde a versão 1.1.12, o `agy` reconhece a flag `disable-slash-command: true` no frontmatter do `SKILL.md` — mas ela faz o oposto do que este repositório precisa: esconde a skill do menu `/`, mantendo-a invocável implicitamente pelo modelo. Não existe ainda, no Antigravity, um equivalente exato ao `disable-model-invocation` do Claude Code (que faz o oposto: bloqueia invocação implícita, mantém a explícita) — então skills marcadas aqui como *user-invoked* (como a própria `setup-matt-pocock-skills`) podem, em tese, também ser acionadas pelo modelo por conta própria no Antigravity, mesmo sem confirmação disso em teste.

## Por Que Essas Skills Existem

Eu construí estas skills como uma forma de corrigir modos de falha comuns que vejo no Claude Code, no Codex e em outros agentes de código.

### #1: O Agente Não Fez O Que Eu Queria

> "No-one knows exactly what they want"
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**O Problema**. O modo de falha mais comum no desenvolvimento de software é o desalinhamento. Você acha que o dev sabe o que você quer. Depois você vê o que ele construiu — e percebe que ele não te entendeu nada.

É a mesma coisa na era da IA. Existe uma lacuna de comunicação entre você e o agente. A correção para isso é uma **sessão de sabatina** — fazer o agente te perguntar detalhadamente sobre o que você está construindo.

**A Solução** é usar:

- [`/grill-me`](./skills/productivity/grill-me/SKILL.md) — para usos fora de código
- [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) — igual a [`/grill-me`](./skills/productivity/grill-me/SKILL.md), mas adiciona mais vantagens (veja abaixo)

Estas são minhas skills mais populares. Elas ajudam você a se alinhar com o agente antes de começar, e a pensar profundamente sobre a mudança que está fazendo. Use-as _toda_ vez que quiser fazer uma mudança.

### #2: O Agente É Verboso Demais

> With a ubiquitous language, conversations among developers and expressions of the code are all derived from the same domain model.
>
> Eric Evans, [Domain-Driven Design](https://www.amazon.co.uk/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215)

**O Problema**: No início de um projeto, os devs e as pessoas para quem estão construindo o software (os especialistas de domínio) normalmente falam idiomas diferentes.

Eu senti a mesma tensão com meus agentes. Agentes normalmente são jogados dentro de um projeto e instruídos a descobrir o jargão sozinhos, no processo. Então eles usam 20 palavras onde 1 bastaria.

**A Solução** para isso é uma linguagem compartilhada. É um documento que ajuda os agentes a decifrar o jargão usado no projeto.

<details>
<summary>
Exemplo
</summary>

Aqui está um exemplo de [`CONTEXT.md`](https://github.com/mattpocock/course-video-manager/blob/076a5a7a182db0fe1e62971dd7a68bcadf010f1c/CONTEXT.md), do meu repositório `course-video-manager`. Qual dos dois é mais fácil de ler?

- **ANTES**: "There's a problem when a lesson inside a section of a course is made 'real' (i.e. given a spot in the file system)"
- **DEPOIS**: "There's a problem with the materialization cascade"

Essa concisão se paga sessão após sessão.

</details>

Isso está embutido em [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md). É uma sessão de sabatina, mas que te ajuda a construir uma linguagem compartilhada com a IA, e a documentar decisões difíceis de explicar em ADRs.

É difícil explicar o quão poderosa essa técnica é. Pode ser a técnica mais legal deste repositório inteiro. Experimente, e veja.

> [!TIP]
> Uma linguagem compartilhada tem muitos outros benefícios além de reduzir a verbosidade:
>
> - **Variáveis, funções e arquivos são nomeados de forma consistente**, usando a linguagem compartilhada
> - Como resultado, a **base de código fica mais fácil de navegar** para o agente
> - O agente também **gasta menos tokens pensando**, porque tem acesso a uma linguagem mais concisa

### #3: O Código Não Funciona

> "Always take small, deliberate steps. The rate of feedback is your speed limit. Never take on a task that's too big."
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**O Problema**: Digamos que você e o agente estejam alinhados sobre o que construir. O que acontece quando o agente _ainda assim_ produz porcaria?

É hora de olhar para seus ciclos de feedback. Sem feedback sobre como o código que ele produz de fato roda, o agente vai estar voando às cegas.

**A Solução**: você precisa do conjunto usual de ciclos de feedback: tipagem estática, acesso a browser e testes automatizados.

Para testes automatizados, um ciclo red-green-refactor é fundamental. É quando o agente escreve um teste que falha primeiro, depois corrige o teste. Isso dá ao agente um nível consistente de feedback que resulta em código muito melhor.

Eu construí uma **skill [`/tdd`](./skills/engineering/tdd/SKILL.md)** que você pode encaixar em qualquer projeto. Ela incentiva red-green-refactor e dá ao agente bastante orientação sobre o que faz um teste bom ou ruim.

Para depuração, também construí uma skill **[`/diagnosing-bugs`](./skills/engineering/diagnosing-bugs/SKILL.md)** que empacota as melhores práticas de debugging num ciclo disciplinado, com portões fase a fase.

### #4: Construímos Uma Bola De Lama

> "Invest in the design of the system _every day_."
>
> Kent Beck, [Extreme Programming Explained](https://www.amazon.co.uk/Extreme-Programming-Explained-Embrace-Change/dp/0321278658)

> "The best modules are deep. They allow a lot of functionality to be accessed through a simple interface."
>
> John Ousterhout, [A Philosophy Of Software Design](https://www.amazon.co.uk/Philosophy-Software-Design-2nd/dp/173210221X)

**O Problema**: A maioria dos apps construídos com agentes são complexos e difíceis de mudar. Como agentes conseguem acelerar radicalmente a escrita de código, eles também aceleram a entropia do software. Bases de código ficam mais complexas numa velocidade sem precedentes.

**A Solução** para isso é uma abordagem radicalmente nova para o desenvolvimento com IA: se importar com o design do código.

Isso está embutido em cada camada destas skills:

- [`/to-spec`](./skills/engineering/to-spec/SKILL.md) te questiona sobre quais módulos você está tocando antes de criar uma spec

E, fundamentalmente, [`/improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) varre uma base de código em busca de oportunidades de aprofundamento e te entrega as candidatas. Recomendo rodá-la na sua base de código a cada poucos dias. É uma varredura, não um resgate: numa base de código genuinamente antiga ela vai encontrar candidatas reais, mas não vai desembaraçar a lama para você.

### Resumo

Fundamentos de engenharia de software importam mais do que nunca. Estas skills são meu melhor esforço em condensar esses fundamentos em práticas repetíveis, para te ajudar a lançar os melhores apps da sua carreira. Aproveite.

## Referência

Elas se dividem em um eixo — quem pode invocá-las. Skills **User-invoked** só são alcançáveis quando você as digita (ex.: `/grill-me`); seu papel é orquestrar. Skills **Model-invoked** podem ser invocadas por você _ou_ acionadas automaticamente pelo agente quando a tarefa se encaixa; elas carregam a disciplina reutilizável. Uma skill user-invoked pode invocar skills model-invoked, mas nunca outra user-invoked.

### Engenharia

Skills que uso diariamente para trabalho de código.

**User-invoked**

- **[ask-matt](./skills/engineering/ask-matt/SKILL.md)** — Pergunte qual skill ou fluxo se encaixa na sua situação. Um roteador sobre as skills user-invoked deste repositório.
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)** — Sessão de sabatina que também constrói o modelo de domínio do seu projeto, refinando a terminologia e atualizando `CONTEXT.md` e ADRs no processo.
- **[triage](./skills/engineering/triage/SKILL.md)** — Mova issues por uma máquina de estados de papéis de triagem.
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)** — Varra uma base de código em busca de oportunidades de aprofundamento, apresente-as como um relatório HTML visual, depois sabatine qual você escolher.
- **[setup-matt-pocock-skills](./skills/engineering/setup-matt-pocock-skills/SKILL.md)** — Configure este repositório para as skills de engenharia (issue tracker, labels de triagem, layout de docs de domínio). Rode uma vez por repositório antes de usar as outras skills de engenharia.
- **[to-spec](./skills/engineering/to-spec/SKILL.md)** — Transforme a conversa atual em uma spec e publique-a no issue tracker. Sem entrevista — apenas sintetiza o que você já discutiu.
- **[to-tickets](./skills/engineering/to-tickets/SKILL.md)** — Divida qualquer plano, spec ou conversa em um conjunto de tickets de bala traçante, cada um declarando suas arestas de bloqueio — escritos como texto em um arquivo local, ou como links nativos de bloqueio em um tracker real.
- **[implement](./skills/engineering/implement/SKILL.md)** — Construa o trabalho descrito por uma spec ou conjunto de tickets, acionando `/tdd` nas costuras pré-acordadas e concluindo com `/code-review` antes de commitar.
- **[wayfinder](./skills/engineering/wayfinder/SKILL.md)** — Planeje um pedaço enorme de trabalho, maior do que uma sessão de agente comporta, como um mapa compartilhado de decision tickets no issue tracker — resolva-os um de cada vez até que o caminho até o destino esteja claro.

**Model-invoked**

- **[prototype](./skills/engineering/prototype/SKILL.md)** — Construa um protótipo descartável para responder a uma questão de design — um único arquivo HTML compartilhável para questões de estado/lógica, ou várias variações de UI radicalmente diferentes alternáveis a partir de uma rota.
- **[diagnosing-bugs](./skills/engineering/diagnosing-bugs/SKILL.md)** — Ciclo de diagnóstico disciplinado para bugs difíceis e regressões de performance: construa um ciclo de feedback que fica vermelho neste bug → minimize → hipotetize → instrumente → corrija → teste de regressão.
- **[research](./skills/engineering/research/SKILL.md)** — Investigue uma pergunta contra fontes primárias de alta confiança e capture as descobertas como um arquivo Markdown citado no repositório, rodando como um agente em segundo plano.
- **[tdd](./skills/engineering/tdd/SKILL.md)** — Desenvolvimento orientado a testes com um ciclo red-green-refactor. Constrói funcionalidades ou corrige bugs uma fatia vertical por vez.
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)** — Construa e refine ativamente o modelo de domínio de um projeto — conteste termos contra o glossário, estresse-teste com cenários de casos de borda, e atualize `CONTEXT.md` e ADRs no processo.
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)** — Disciplina e vocabulário compartilhados para desenhar deep modules: muito comportamento atrás de uma interface pequena, posicionada em uma costura limpa, testável através dessa interface.
- **[code-review](./skills/engineering/code-review/SKILL.md)** — Revisão em dois eixos do diff desde um ponto fixo: **Standards** (segue os padrões de código do repositório, mais uma base de smells de Fowler?) e **Spec** (implementa fielmente a issue/spec de origem?), rodando como subagentes paralelos para que nenhum contamine o outro.
- **[resolving-merge-conflicts](./skills/engineering/resolving-merge-conflicts/SKILL.md)** — Trabalhe um merge ou rebase git em andamento hunk por hunk, resolvendo por intenção rastreada até a fonte primária de cada lado, depois finalize a operação — nunca `--abort`.
- **[wizard](./skills/engineering/wizard/SKILL.md)** — Gere um wizard interativo em bash que guia um humano por passos que só ele pode realizar: provisionar infraestrutura, configurar credenciais ou secrets de CI, navegar um dashboard de terceiros pouco familiar, ou rodar uma migração ou cutover pontual.

### Produtividade

Ferramentas gerais de fluxo de trabalho, não específicas de código.

**User-invoked**

- **[grill-me](./skills/productivity/grill-me/SKILL.md)** — Seja entrevistado implacavelmente sobre um plano ou design até que cada ramo da árvore de decisões esteja resolvido.
- **[handoff](./skills/productivity/handoff/SKILL.md)** — Compacte a conversa atual em um documento de handoff para que outro agente possa continuar o trabalho.
- **[teach](./skills/productivity/teach/SKILL.md)** — Ensine ao usuário uma nova skill ou conceito ao longo de múltiplas sessões, usando o diretório atual como um espaço de ensino com estado.
- **[to-questionnaire](./skills/productivity/to-questionnaire/SKILL.md)** — Transforme uma decisão que você não consegue responder sozinho em um questionário Markdown para a única pessoa que consegue — preenchido de forma assíncrona, ou junto em uma reunião. Ele sabatina você sobre o envio (para quem é, do que você precisa de volta), não sobre o assunto.
- **[wait-what](./skills/productivity/wait-what/SKILL.md)** — Acione isso no momento em que uma mensagem não for compreendida. O agente reapresenta o que disse com o contexto que está faltando, em linguagem simples, usando o vocabulário do seu `CONTEXT.md`.

**Model-invoked**

- **[grilling](./skills/productivity/grilling/SKILL.md)** — Entreviste o usuário implacavelmente sobre um plano, decisão ou ideia até que cada ramo da árvore de decisões esteja resolvido. A primitiva de entrevista reutilizável por trás de `grill-me`, `grill-with-docs`, `triage`, `wayfinder` e `improve-codebase-architecture`.
- **[writing-for-agents](./skills/productivity/writing-for-agents/SKILL.md)** — Escrever documentos para agentes: skills, AGENTS.md/CLAUDE.md, e qualquer doc que um agente alcance por um ponteiro.
