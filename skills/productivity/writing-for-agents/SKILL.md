---
name: writing-for-agents
description: Redação de documentos para agentes. Use ao criar ou editar skills, ou ao modificar AGENTS.md ou CLAUDE.md.
---

Referência para a redação de qualquer documento consumido por um agente — uma skill, um `AGENTS.md` / `CLAUDE.md`, um documento acessado por um ponteiro. A embalagem difere; a redação não: as mesmas alavancas tornam cada um previsível — o agente seguindo o mesmo _processo_ a cada execução, sem necessariamente produzir a mesma saída.

Quando o documento que você estiver escrevendo for uma skill, leia [`SKILL-MECHANICS.md`](SKILL-MECHANICS.md) para frontmatter, escolha de invocação e skills roteadoras.

## Ponteiros de contexto

Um **ponteiro de contexto** (context pointer) é uma referência mantida no contexto do agente que nomeia algum material fora do contexto e codifica a condição para alcançá-lo. A descrição de uma skill é um; uma linha no `AGENTS.md` nomeando um documento é o mesmo objeto. A _formulação_ do ponteiro, e não o seu alvo, decide quando o agente alcança o material — e com que confiabilidade. Um alvo indispensável atrás de um ponteiro mal formulado é um bug de variância: aprimore a formulação primeiro e incorpore o material em linha somente se o aprimoramento falhar.

Um ponteiro cumpre duas funções — declarar o que é o material e listar as **ramificações** (branches) que devem disparar o seu acesso (uma ramificação é um caso distinto tratado pelo documento, de modo que execuções diferentes sigam caminhos diferentes através dele). Cada palavra de um ponteiro sempre carregado consome orçamento em cada turno, exigindo uma poda ainda mais rigorosa que a do corpo:

- **Destaque a leading word logo no início** — o ponteiro é onde ela realiza seu trabalho de disparo.
- **Um gatilho por ramificação.** Sinônimos que apenas renomeiam uma única ramificação são uma ramificação escrita duas vezes; condense-os e mantenha apenas ramificações genuinamente distintas.
- **Elimine elementos de identidade que o corpo já carrega.**

## As duas cargas

Cada documento e ponteiro adicionado consome um de dois orçamentos:

- **Carga de contexto** (context load) — o custo de material sempre carregado na janela do agente: uma linha do `AGENTS.md`, uma descrição de skill, qualquer coisa presente no contexto a cada turno, gastando tokens e atenção quer seja acionada ou não.
- **Carga cognitiva** (cognitive load) — o custo sobre o humano: quais documentos existem e quando recorrer a cada um. O humano é o índice. Não é um custo a ser minimizado — é o preço da agência humana; gaste-o onde o julgamento humano importa, remova-o onde não importa.

Material acessado apenas através de um ponteiro escapa da carga de contexto ao preço da linha do próprio ponteiro; material sem ponteiro algum recai inteiramente sobre a carga cognitiva.

## Hierarquia de informações

Um documento é construído a partir de dois tipos de conteúdo — **passos** (as ações ordenadas que o agente executa) e **referência** (definições, regras, fatos consultados sob demanda) — que se misturam livremente: apenas passos (uma receita), apenas referência (as regras de uma revisão, esta skill) ou ambos. A decisão central é onde cada parte se posiciona na **hierarquia de informações**, uma escala ordenada pelo quão imediatamente o agente precisa do material:

1. **Passo no arquivo** (in-file step) — o nível primário: o que o agente faz, em ordem.
2. **Referência no arquivo** (in-file reference) — consultada sob demanda. Frequentemente um conjunto nivelado de regras equivalentes (cada regra de uma revisão em um mesmo degrau) — um arranjo legítimo, não um code smell.
3. **Referência revelada** (disclosed reference) — deslocada para um arquivo separado, acessada por um ponteiro de contexto, carregada apenas quando o ponteiro dispara. Abrange desde um arquivo irmão na mesma pasta até uma referência totalmente externa que reside em qualquer lugar e à qual qualquer documento pode apontar.

Desloque pouco para baixo e o topo incha; desloque demais e você oculta material de que o agente realmente precisa. Essa tensão é toda a decisão.

**Revelação progressiva** (progressive disclosure) é o movimento descendo a escala — para fora do arquivo principal e atrás de um ponteiro — para que o topo permaneça legível. Não é primariamente uma otimização de tokens: é como a hierarquia é protegida. A ramificação é o teste de revelação mais limpo: incorpore o que toda ramificação precisa e empurre para trás de um ponteiro o que apenas algumas ramificações acessam. Quando um documento contém passos, a referência no arquivo que deveria ser revelada progressivamente acaba por soterrá-los e transforma a atenção dada a eles em cara ou coroa — uma alavanca de variância, não apenas de legibilidade.

**Co-localização** (co-location) é o complemento interno no arquivo: onde a escala decide o _quão abaixo_ uma parte fica, a co-localização decide _o que fica ao lado dela_ uma vez lá. Mantenha a definição, as regras e as ressalvas de um conceito sob um único cabeçalho em vez de espalhadas, para que a leitura de uma parte traga seus vizinhos junto. O teste: o documento deve ser lido como documentação escrita para o agente — material agrupado soa assim; material espalhado, não. (Distinto de duplicação: esta repete um mesmo significado em dois lugares; a dispersão fragmenta um significado em vários.)

**Prolixidade descontrolada** (sprawl) é o modo de falha aqui: um documento simplesmente longo demais, mesmo quando cada linha é ativa e única. A atenção se dispersa pelo excesso, e cada linha extra é mais uma a se manter relevante. A cura é a escala: revele a referência atrás de ponteiros e divida por ramificação ou sequência para que cada caminho carregue apenas o necessário.

## Passos e critérios de conclusão

Cada passo termina em um **critério de conclusão** (completion criterion) — a condição que informa ao agente que o trabalho está concluído. Duas propriedades fazem dele uma alavanca:

- **Clareza** — o agente consegue distinguir concluído de não concluído? Um limite vago ("entendimento alcançado") convida à **conclusão prematura** (premature completion): encerrar o passo antes de ele estar genuinamente concluído, com a atenção deslizando para o _estar concluído_. Os passos visíveis adiante — os **passos pós-conclusão** — fornecem a atração; a clareza do critério é a resistência. Defend em ordem: **torne o limite mais nítido primeiro** (local e barato); apenas se ele for irredutivelmente difuso _e_ você observar a pressa, oculte os passos posteriores dividindo a sequência — e ocultar só funciona através de uma divisa de contexto real (um handoff ou um despacho de subagente; uma chamada em linha mantém os passos posteriores no contexto e não limpa nada).
- **Exigência** — o quanto ele requer. "Todos os modelos modificados contabilizados" força um trabalho minucioso onde "produzir uma lista de alterações" não o faz. A exigência impulsiona o **trabalho de base** (legwork) — a investigação que o agente faz durante o trabalho, latente na formulação em vez de escrita como um passo próprio — e não está restrita a passos: "todas as regras aplicadas" vincula um corpo de referência nivelada da mesma forma que "todos os passos concluídos" vincula uma sequência, que é como um documento puramente de referência ainda impõe uma barra de exaustividade.

Os critérios mais fortes são simultaneamente verificáveis e exaustivos.

## Quando dividir

Dividir um documento em dois consome uma das duas cargas; portanto, divida apenas quando o corte justificar o custo:

- **Por sequência** — divida uma série de passos onde os passos pós-conclusão tentam o agente a apressar o passo atual. Mantê-los fora de vista estimula mais trabalho de base na tarefa atual. Cuidado com o inverso: mesclar sequências expõe os passos posteriores de cada etapa ao que vem a seguir, convidando à conclusão prematura.
- **Por invocação** — específico de skill: consulte [`SKILL-MECHANICS.md`](SKILL-MECHANICS.md).

## Leading words

Uma **leading word** é um conceito compacto já presente no pré-treinamento do modelo com o qual o agente raciocina durante a execução do documento (_lesson_, _fog of war_, _tracer bullets_). Repetida como um token, nunca como uma frase, ela acumula uma definição distribuída e ancora toda uma região de comportamento na menor quantidade de tokens, recrutando priors que o modelo já possui. Criar termos próprios funciona se você os definir com clareza, mas uma palavra inventada não recruta priors — você paga em tokens de definição o que uma palavra pré-treinada fornece de graça; recorra a uma palavra existente primeiro.

Ela ancora de duas formas. No corpo, na _execução_: o agente recorre ao mesmo comportamento toda vez que a palavra aparece, e dentro de uma referência nivelada ela foca a atenção em uma classe de elementos a procurar. Em um ponteiro, na _invocação_: quando a mesma palavra está presente em seus prompts, em seus documentos e em sua base de código, o agente conecta essa linguagem compartilhada ao material e o alcança com mais confiabilidade.

Procure oportunidades de refatorar com leading words. Uma tríade descrita em três locais, um ponteiro gastando uma frase para sinalizar uma única ideia — cada um é um trecho pedindo para ser condensado em um único token:

- "rápido, determinístico, de baixo overhead" → _tight_ (um loop _tight_).
- "um loop no qual você confia" → _red_ — uma restrição difusa se torna um estado observável binário (o loop fica _red_ no bug, ou não fica).

Você ganha em dobro: menos tokens e um gancho mais nítido para o agente ancorar seu raciocínio. Assuma que todo documento carrega reiterações que leading words eliminam — encontre-as.

**Negação** é o modo de falha ao lado dessa alavanca: conduzir por proibição arrasta o comportamento proibido para o contexto e o torna _mais_ disponível, não menos. _Não pense em um elefante_, e o elefante é tudo o que resta; a negação é um modificador fraco que o conceito fortemente ativado atropela, de modo que a proibição soa pela metade como uma instrução para fazer aquilo. Estimule o **positivo** — declare o comportamento desejado ("escreva comentários de uma linha") para que o proibido nunca seja pronunciado. Uma proibição só ganha seu lugar como uma trava rígida impossível de formular positivamente; mesmo assim, associe-a ao objetivo positivo para que a atenção se fixe no que deve ser feito.

## Poda

- Mantenha cada significado em uma **fonte única da verdade** (single source of truth): um local com autoridade, de modo que alterar o comportamento seja uma edição em um único lugar. **Duplicação** — o mesmo significado em mais de um lugar — custa manutenção e tokens, além de inflar o destaque de um significado na escala acima de seu nível real. (O inverso acidental de uma leading word, que repete um token de propósito, nunca o significado.)
- O **ambiente** também é uma fonte da verdade — scripts de `package.json`, arquivos de configuração, o layout de diretórios, saídas de `--help` — e um documento que o reitera é um **cache**: uma cópia de uma consulta, justificando sua carga apenas quando a consulta for custosa. Faça cache daquilo que o agente não consegue encontrar olhando: a convenção não escrita, o motivo por trás de uma escolha, a pegadinha que nenhuma configuração confessa. Deixe as consultas de um arquivo e um comando para o ambiente, onde elas não ficam defasadas.
- Verifique cada linha quanto à **relevância**: ela ainda afeta o que o documento faz? Uma linha perde relevância por nunca afetar a tarefa (mera exposição, ou uma ramificação que deveria ser revelada) ou por se tornar defasada conforme o comportamento ou o mundo que ela descreve mudam. Documentos mais curtos são mais fáceis de manter relevantes. Sem uma disciplina de poda, o destino padrão é a **sedimentação**: camadas defasadas que se acumulam porque adicionar parece seguro e remover parece arriscado, até que você precise perfurar através delas para encontrar o que ainda está ativo.
- Cace **no-ops** frase por frase: uma instrução que o modelo já obedece por padrão consome carga para não dizer nada. O teste — ela altera o comportamento em relação ao padrão? — é relativo ao modelo, não ao leitor: duas pessoas discordando sobre um no-op estão discordando sobre o padrão, e resolvem isso executando o documento, não por debate. Quando uma frase falhar, delete a frase inteira em vez de aparar palavras dela. O teste também avalia leading words: uma palavra fraca demais para superar o padrão (_seja minucioso_ quando o agente já é razoavelmente minucioso) é um no-op, e a correção é uma palavra mais forte (_implacável_), não uma técnica diferente.
