---
name: ask-matt
description: Pergunte qual skill ou fluxo se encaixa na sua situação. Um roteador sobre as skills deste repositório.
disable-model-invocation: true
---

# Ask Matt

Você não se lembra de cada skill, então pergunte.

Um **fluxo** é um caminho através das skills. A maioria dos caminhos segue por um **fluxo principal**, e dois **acessos** se conectam a ele. Todo o resto é independente (standalone), ou uma camada de vocabulário que opera por baixo.

## O fluxo principal: ideia → entrega

A rota pela qual a maior parte do trabalho transita. Você tem uma ideia e quer que ela seja construída.

1. **`/grill-with-docs`** — refine a ideia por sabatina. Comece aqui sempre que você estiver **trabalhando em um diretório de trabalho**: ela mantém estado (stateful), retendo o que aprende em `CONTEXT.md` e ADRs. (Sem diretório de trabalho? Use `/grill-me` — veja Standalone. Ambas executam a mesma primitiva `/grilling`; `grill-with-docs` é a que deixa um rastro documental, o que a torna a melhor das duas sempre que houver um repositório para deixá-lo.)
2. **Bifurcação — você consegue resolver todas as perguntas na conversa?** Se uma pergunta precisa de uma resposta executável (estado, lógica de negócios, uma UI que você precisa ver), faça um desvio por um protótipo, conectado por **`/handoff`** em ambas as direções (um protótipo vive em seu próprio diretório, que é exatamente para o que o `/handoff` serve — veja Divisas de fase):
   - **`/handoff`** para fora, depois abra uma nova sessão a partir desse arquivo,
   - **`/prototype`** para responder à pergunta com código descartável,
   - **`/handoff`** de volta com o que você aprendeu, e faça referência a isso a partir da conversa original da ideia.
3. **Bifurcação — esta é uma construção de múltiplas sessões?**
   - **Sim** → **`/to-spec`** (transforme a conversa em uma spec), depois **`/to-tickets`** para dividi-la em tickets de bala traçante, cada um declarando suas **arestas de bloqueio**. Em um tracker local, isso é um arquivo por ticket sob `.scratch/<feature>/issues/`, trabalhados manualmente na ordem de bloqueios primeiro; em um tracker real, as arestas se tornam links nativos de bloqueio, de modo que qualquer ticket cujos bloqueadores estejam concluídos possa ser assumido — dispare **`/implement`** por ticket, **fazendo `/clear` de contexto entre cada um**. Cada ticket é autocontido, portanto o contexto do anterior é descartável.
   - **Não** → **`/implement`** aqui mesmo, na mesma janela de contexto.

   De qualquer forma, **`/implement`** constrói cada issue acionando **`/tdd`** internamente — uma fatia red-green por vez — e depois conclui executando **`/code-review`**, uma revisão em dois eixos (Padrões + Spec) do diff, antes de commitar. Recorra ao **`/tdd`** isoladamente quando quiser apenas construir um comportamento concreto orientado a testes sem uma spec completa, e ao **`/code-review`** isoladamente sempre que quiser revisar um branch ou PR em relação a um ponto fixo.

### Higiene de contexto

Mantenha as etapas 1–3 em **uma janela de contexto ininterrupta** — não faça compact nem clear até depois de `/to-tickets` — para que a sabatina, a spec e os tickets se apoiem todos no mesmo raciocínio. Cada `/implement` então começa do zero, trabalhando a partir do ticket.

O limite disso é a **[smart zone](https://www.aihero.dev/ai-coding-dictionary/smart-zone)**: a janela (~150k tokens nos modelos topo de linha) dentro da qual o modelo ainda raciocina com precisão. Se uma sessão se aproximar dela antes de `/to-tickets`, não continue em modo degradado — use `/compact` na divisa de fase mais próxima e prossiga (veja Divisas de fase).

## Acessos

Uma situação inicial que gera trabalho e depois se integra ao fluxo principal.

- **Bugs e solicitações acumulando** → **`/triage`**. Ela move as issues através de papéis de triagem e produz issues prontas para agente, que **`/implement`** assume posteriormente.

  A triagem é apenas para issues **que você não criou** — relatórios de bugs, solicitações de novas funcionalidades que chegam, tudo o que chega de forma bruta. Os tickets produzidos por `/to-tickets` já estão prontos para agentes, portanto **não faça triagem deles**.

- **Algo quebrou** → **`/diagnosing-bugs`**. Para os casos difíceis: o bug que resiste a uma primeira olhada, a falha intermitente (flake), a regressão que surgiu entre dois estados conhecidos como bons. Ela se recusa a teorizar até que tenha um **ciclo de feedback curto** — um comando que já fique vermelho com *este* bug — e depois corrige com um teste de regressão. Seu post-mortem passa o bastão (handoff) para **`/improve-codebase-architecture`** quando a conclusão real for de que não há uma boa costura para isolar o bug.

- **Um esforço enorme e envolto em névoa — um projeto do zero (greenfield) ou a construção de uma funcionalidade gigante, grande demais para uma sessão** → **`/wayfinder`**, o fluxo cognitivamente mais exigente aqui. Quando o caminho daqui até o destino ainda não está visível, ela traça um **mapa compartilhado** de **decision tickets** no issue tracker e os resolve um por um — produzindo **decisões, não entregáveis** — até que a névoa seja dissipada e o caminho esteja desimpedido. Enquanto **`/grill-with-docs`** refina uma ideia que você consegue manter em uma única sessão, o wayfinder é para a ideia que você não consegue — e é mais lento e mais denso, portanto reserve-o exatamente para isso, nunca para uma funcionalidade bem delimitada.

  Quando o mapa estiver limpo, **ele faz handoff, ele não constrói**: integre-se ao fluxo principal em **`/to-spec`**, que consolida as decisões encadeadas do mapa em um plano executável, depois `/to-tickets` e `/implement` normalmente. Encaminhar o mapa diretamente para `/implement` pula essa consolidação e descarta os detalhes interligados — vá direto para `/implement` somente quando o esforço tiver se revelado genuinamente pequeno.

## Saúde da base de código

Não é desenvolvimento de funcionalidades — é manutenção.

- **`/improve-codebase-architecture`** — execute sempre que tiver um momento livre para manter a base de código boa para os agentes operarem. Ela traz à tona **oportunidades de aprofundamento**; escolher uma _gera uma ideia_ que você pode levar para o fluxo principal em `/grill-with-docs`. É a inspeção que encontra as candidatas; **`/codebase-design`** (abaixo) é a bancada onde você projeta a opção escolhida.

## Vocabulário subjacente

Duas referências invocadas pelo modelo que operam *sob* as outras skills — cada uma sendo a fonte única da verdade para o seu vocabulário. Recorra a elas diretamente quando as **palavras**, e não o processo, forem o problema; ou deixe que as skills acima as requisitem.

- **`/domain-modeling`** — refine a linguagem de *domínio* do projeto: questione um termo vago, resolva uma palavra sobrecarregada ("conta" fazendo três funções), registre uma decisão difícil de reverter como um ADR. É a disciplina ativa que `/grill-with-docs` conduz para manter o `CONTEXT.md` como um glossário limpo.
- **`/codebase-design`** — o vocabulário de deep modules (módulo, interface, profundidade, costura, adaptador, alavancagem, localidade) para projetar o *formato* de um módulo: muito comportamento por trás de uma interface pequena em uma costura limpa. Tanto `/tdd` quanto `/improve-codebase-architecture` falam essa língua.

## Divisas de fase

Uma **fase** é um bloco de trabalho dentro de uma sessão — a sabatina, a implementação, o QA. Na **divisa** entre duas delas, você tem cinco opções, e escolher entre elas é a decisão mais incerta em todo este mapa:

- **Continuar** — permaneça onde está. Não custa nada, não perde nada.
- **`/clear`** — esvazie a janela, quando nada aqui importar para o que vem a seguir.
- **`/handoff`** — escreva um arquivo markdown portátil. Restrito: apenas para um **novo harness**, um **novo diretório**, um **colega**, ou para bifurcar uma tarefa paralela **no meio da fase**. O que ele oferece é portabilidade.
- **Subagente** — envie uma tarefa de escopo bem delimitado para sua própria janela e receba um relatório de volta.
- **`/compact`** — comprima este contexto e inicialize uma nova sessão com ele. O **padrão**, na base da árvore e não a primeira escolha.

Leia [PHASE-BOUNDARIES.md](PHASE-BOUNDARIES.md) para ver a árvore ordenada — as cinco perguntas, o raciocínio por trás de cada ramificação e por que o custo da fonte primária faz de **Continuar** a primeira opção a ser descartada. Tome a decisão **em** uma divisa; no meio da fase, continue ou divida o restante em subagentes.

## Standalone

Completamente fora do fluxo principal.

- **`/grill-me`** — a mesma sabatina implacável do `/grill-with-docs`, mas **sem estado (stateless)**: não salva nada localmente e não cria nenhum `CONTEXT.md`. Recorra a ela quando você **não estiver trabalhando em um diretório de trabalho** — refinando um plano, um design, um texto, qualquer coisa sem um repositório por baixo. Se você estiver em um diretório de trabalho, use `/grill-with-docs`: ela executa a mesma sabatina e deixa um rastro documental, sendo estritamente a melhor opção.
- **`/grilling`** — a primitiva da sabatina em si: rodadas, a fronteira, fatos são trabalho do agente e decisões são suas. `/grill-me` e `/grill-with-docs` são os dois pontos de entrada nomeados, e `/triage`, `/wayfinder` e `/improve-codebase-architecture` executam-na internamente. Recorra a ela diretamente apenas quando quiser a sabatina sem nenhum invólucro ao redor.
- **`/resolving-merge-conflicts`** — trabalhe em um conflito de merge ou rebase em andamento hunk por hunk, resolvendo pela **intenção** rastreada até a fonte primária de cada lado em vez de escolher linhas, e depois conclua a operação. Ela nunca executa `--abort`. Independente e fora de qualquer fluxo: recorra a ela quando já estiver no meio de um conflito.
- **`/prototype`** — um programa pequeno e descartável que responde a uma única pergunta de design: este modelo de estado parece correto, ou como esta UI deve se parecer. Descartável é uma restrição sobre como o código é escrito, não uma promessa de destruí-lo: a resposta se integra ao código real, e o protótipo em si é mantido como uma **fonte primária** em um branch `prototype/<name>` a partir da main, apontado a partir da issue de implementação. É o desvio na etapa 2 do fluxo principal, mas recorra a ela sempre que uma dúvida de design for difícil de resolver no papel.
- **`/research`** — delegue o trabalho braçal de leitura a um **agente em segundo plano**: ele investiga uma pergunta com base em **fontes primárias** e deixa um arquivo Markdown citado no repositório. Continue trabalhando enquanto ele lê. O arquivo produzido é algo a ser levado *para dentro* do fluxo principal em `/grill-with-docs` — a pesquisa alimenta o raciocínio, não o substitui.
- **`/to-questionnaire`** — quando o que está bloqueando você não está na sua cabeça nem na base de código, mas na **de outra pessoa**, esta skill escreve um questionário para ela preencher. É o inverso de `/grill-me`: em vez de sabatinar você sobre o assunto, ela sabatina você sobre o **envio** — para quem vai, do que você precisa de volta — e direciona as perguntas para a lacuna. O que retorna é material para `/grill-with-docs` ou `/to-spec`.
- **`/wizard`** — para as etapas que apenas um **humano** pode realizar: provisionar infraestrutura, configurar credenciais ou segredos de CI, clicar em um painel de terceiros desconhecido, executar uma migração pontual ou virada de chave (cutover). Ela gera um script bash interativo que abre cada URL, captura cada valor e o grava no `.env` e nos secrets do GitHub — para que o procedimento deixe de ser algo que você reexplica a um agente a cada vez. Invocada pelo modelo, de modo que o agente recorre a ela no instante em que atinge uma barreira que apenas você pode ultrapassar. Se o agente pudesse simplesmente fazer sozinho, ele deveria; isto é para onde um humano está genuinamente no circuito (human in the loop).
- **`/wait-what`** — o corretivo para uma mensagem que não ficou clara. Use-a no meio da conversa, dentro de qualquer outra skill, e o agente reformulará o que acabou de dizer com o contexto que faltava, em linguagem direta, usando o vocabulário de `CONTEXT.md`. Ela funciona após o fato; `/grill-with-docs` é o remédio preventivo, porque uma linguagem compartilhada acordada logo cedo é o que impede que o jargão sequer apareça.
- **`/teach`** — aprenda um conceito ao longo de múltiplas sessões, usando o diretório atual como um workspace com estado (stateful).
- **`/writing-for-agents`** — referência para escrever documentos que agentes consomem: skills, AGENTS.md, documentos referenciados por ponteiros.

## Pré-requisito

**`/setup-matt-pocock-skills`** — execute antes do seu primeiro fluxo de engenharia para configurar o issue tracker, as labels de triagem e a estrutura de documentos que as outras skills assumem como padrão. Issue trackers personalizados também funcionam.
