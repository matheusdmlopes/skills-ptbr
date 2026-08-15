---
name: wayfinder
description: Planeje uma grande fatia de trabalho — mais do que uma sessão de agente comporta — como um mapa compartilhado de decision tickets no seu issue tracker, e resolva-os um de cada vez até que o caminho até o destino esteja desimpedido.
disable-model-invocation: true
---

Uma ideia vaga chegou — grande demais para uma sessão de agente, e envolta em névoa: o caminho daqui até o **destino** ainda não está visível. O wayfinding consiste em encontrar esse caminho, não em avançar cegamente até o destino. Esta skill traça o caminho como um **mapa compartilhado** no issue tracker do repositório, e então trabalha seus **decision tickets** — perguntas cuja resolução é uma decisão, não fatias de um build a executar — um por vez até que a rota esteja clara.

O destino varia por iniciativa, e nomeá-lo é o primeiro ato do mapeamento — ele molda cada ticket. Pode ser uma spec para repassar e iterar, uma decisão a fixar antes do início do planejamento, ou uma alteração feita no local, como uma migração de estrutura de dados. O mapa é agnóstico de domínio — trabalho de engenharia, conteúdo de curso, o que quer que se encaixe no formato.

## Planeje, não execute

O Wayfinder é **planejamento** por padrão: cada ticket resolve uma decisão, e o mapa está concluído quando o caminho estiver desimpedido — nada mais a decidir antes que alguém vá e faça a coisa. O impulso de simplesmente fazer o trabalho costuma ser o sinal de que você atingiu a borda do mapa e é hora de passar o bastão (handoff). Uma iniciativa pode sobrescrever isso em suas **Notas** — levando a execução para dentro do próprio mapa —, mas, na ausência disso, produza decisões, não entregáveis.

## Referencie pelo nome

Todo mapa e ticket é uma issue, portanto possui um **nome** — seu título. Em tudo o que o humano lê — narração, Decisões até o momento no mapa — refira-se a ele por esse nome, nunca por um id, número ou slug puro. Uma parede de `#42, #43, #44` é ilegível; nomes são lidos num relance. O id e a URL não desaparecem — um nome envolve seu link —, mas eles viajam _dentro_ do nome, nunca o substituem.

## O Mapa

O mapa é uma única issue no issue tracker deste repo, rotulada como `wayfinder:map` — o artefato canônico. Seus tickets são issues filhas do mapa.

O mapa é um **índice**, não um armazenamento. Ele lista as decisões tomadas e aponta para os tickets que guardam seus detalhes; uma decisão vive em exatamente um lugar — seu ticket —, de modo que o mapa nunca a reitera, apenas resume sua essência e cria o link.

**Onde o mapa, suas issues filhas, o bloqueio e as consultas de fronteira residem fisicamente depende do tracker.** O issue tracker deve ter sido fornecido a você — execute `/setup-matt-pocock-skills` se não foi. Consulte a seção "Operações de wayfinding" da documentação do tracker para saber como _este_ repositório os expressa. Se nenhum tracker tiver sido fornecido, use como padrão o tracker de markdown local.

### O corpo do mapa

O mapa inteiro em baixa resolução, carregado uma vez por sessão. Tickets abertos **não** são listados — eles são issues filhas abertas, encontradas por consulta.

```markdown
## Destino

<como se parece o alcance do fim deste mapa — a spec, decisão ou alteração até a qual esta iniciativa está encontrando o caminho. Uma ou duas linhas; cada sessão se orienta por ele antes de escolher um ticket.>

## Notas

<domínio; skills que cada sessão deve consultar; preferências estabelecidas para esta iniciativa>

## Decisões até o momento

<!-- o índice — uma linha por ticket fechado: o suficiente para julgar a relevância, e depois amplie o link para os detalhes que o ticket contém -->

- [<título do ticket fechado>](link) — <resumo de uma linha da resposta>

## Não especificado ainda

<!-- veja "Névoa de guerra": névoa dentro do escopo que você ainda não consegue transformar em ticket; é promovida conforme a fronteira avança -->

## Fora de escopo

<!-- veja "Fora de escopo": trabalho determinado além do destino; fechado, nunca promovido -->
```

### Tickets

Cada ticket é uma **issue filha** do mapa; o id da issue no tracker é sua identidade. Seu corpo é a pergunta, dimensionada para uma sessão de agente de 100K tokens:

```markdown
## Pergunta

<a decisão ou investigação que este ticket resolve>
```

Cada ticket carrega uma label `wayfinder:<type>` — uma entre `research`, `prototype`, `grilling`, `task` (veja [Tipos de ticket](#tipos-de-ticket)).

Uma sessão **reivindica** (claim) um ticket atribuindo-o ao dev que está conduzindo o mapa, **primeiro**, antes de qualquer trabalho, para que sessões concorrentes o ignorem. Esse responsável (assignee) _é_ a reivindicação: um ticket aberto e não atribuído está não reivindicado.

O bloqueio usa a relação de dependência **nativa** do tracker — essencial porque renderiza a fronteira _visualmente_ na própria UI do tracker, de modo que o humano veja o que pode ser assumido sem abrir o mapa. Apenas um tracker que não tenha bloqueio nativo recorre a uma convenção no corpo. Um ticket está **desbloqueado** quando todos os tickets que o bloqueiam estiverem fechados; a **fronteira** são as filhas abertas, desbloqueadas e não reivindicadas — a borda do conhecido.

A resposta não faz parte do corpo — ela é registrada na resolução (veja [Trabalhar através do mapa](#trabalhar-atraves-do-mapa)). Ativos criados durante a resolução de um ticket são linkados a partir da issue, não colados nela.

## Tipos de ticket

Todo ticket é **HITL** — human in the loop, trabalhado _com_ um humano que fala por si mesmo — ou **AFK**, conduzido pelo agente sozinho. Um ticket HITL só é resolvido por meio dessa troca ao vivo; o agente nunca assume o lado do humano (um agente de sabatina que responde às suas próprias perguntas quebrou essa regra).

- **Research** (AFK): Leitura de documentação, APIs de terceiros ou recursos locais, como bases de conhecimento, para expor um fato do qual uma decisão depende. Resolvido por um subagente `/research`. Use quando for necessário conhecimento fora do diretório de trabalho atual.
- **Prototype** (HITL): Eleve a fidelidade da discussão criando um artefato barato, rascunhado e concreto para reagir — um esboço, uma versão preliminar, um stub ou código de UI/lógica via a skill /prototype. Linka o protótipo como um ativo. Use quando "como isso deve parecer" ou "como isso deve se comportar" for a pergunta principal.
- **Grilling** (HITL): Conversa. O caso padrão. Sempre invoque as skills /grilling e /domain-modeling.
- **Task** (HITL ou AFK): Trabalho manual que deve acontecer antes que uma _decisão_ possa ser tomada — nada para decidir, prototipar ou pesquisar, mas a discussão está bloqueada até que isso seja feito. Cadastrar-se em um serviço para que sua API possa ser avaliada, provisionar acesso, mover dados para que seu formato possa ser visto. Este é o único tipo que _faz_ em vez de decidir — e ele conquista seu lugar desbloqueando uma decisão, não entregando o destino. O agente o conduz sozinho onde puder (AFK); caso contrário, entrega ao humano um checklist preciso (HITL). Resolvido quando o trabalho é concluído; a resposta registra o que foi feito e quaisquer fatos resultantes (localização de credenciais, novas URLs, contagens de linhas) dos quais tickets posteriores dependam.

## Névoa de guerra

O mapa é _deliberadamente_ incompleto: não mapeie o que você ainda não consegue ver. Além dos tickets ativos reside a **névoa de guerra** — a visão tênue de decisões e investigações que você percebe que estão por vir, mas ainda não consegue fixar, porque dependem de perguntas ainda abertas. Resolver um ticket dissipa a névoa à frente dele, promovendo o que agora é especificável em novos tickets — um de cada vez, até que o caminho para o destino esteja desimpedido e nenhum ticket reste.

A seção **Não especificado ainda** do mapa é onde essa visão tênue é registrada: a pergunta sob suspeita, a área a revisitar mais tarde. É a fronteira não descoberta _em direção_ ao destino — tudo aqui está no escopo, apenas não nítido o suficiente para virar ticket. Escreva tão livremente ou tão detalhadamente quanto a visão permitir; ela funciona também como uma sinalização para colaboradores lendo sobre o rumo da iniciativa.

**Névoa ou ticket?** O teste é se você consegue formular a pergunta com precisão agora — _não_ se consegue respondê-la agora.

- **Ticket quando** a pergunta já for nítida — mesmo que esteja bloqueada e você não possa agir sobre ela ainda.
- **Não especificado ainda quando** você ainda não conseguir formulá-la com tanta nitidez. Não pré-fatie a névoa em pedaços do tamanho de tickets: ela é mais rústica do que um ticket, e um trecho de névoa pode ser promovido para vários tickets, ou nenhum, assim que a fronteira o alcançar.

**Não especificado ainda** exclui o que já foi decidido (Decisões até o momento), o que já é um ticket ativo e o que está fora de escopo (a próxima seção).

## Fora de escopo

A névoa só se acumula _em direção_ ao destino. O destino fixa o escopo, de modo que o trabalho além dele está **fora de escopo** — não é névoa e não pertence a **Não especificado ainda**. Ele ganha sua própria seção **Fora de escopo** no mapa: trabalho que você conscientemente descartou _desta_ iniciativa. É o escopo, não a nitidez, que o coloca aqui.

O trabalho fora de escopo nunca é promovido — a fronteira para no destino —, portanto só retorna se o destino for redesenhado, e então como uma nova iniciativa, não uma retomada.

Descartar algo do escopo é um ato de delimitação de escopo, não um passo na rota. Quando um ticket já existente se revelar situado além do destino — incluído erroneamente no mapeamento inicial ou exposto por uma resolução —, **feche-o** (um ticket fechado está inequivocamente fora da fronteira) e deixe uma linha na seção **Fora de escopo**: a essência mais o porquê de estar fora de escopo, linkando o ticket fechado. Ele permanece fora de **Decisões até o momento**, que registra a rota efetivamente percorrida — uma divisa de escopo não é um passo nela.

## Invocação

Dois modos. De qualquer forma, **nunca resolva mais de um ticket por sessão** — com exceção dos tickets de pesquisa.

### Traçar o mapa

O usuário invoca com uma ideia vaga.

1. **Nomeie o destino.** Execute uma sessão de `/grilling` e `/domain-modeling` para fixar até onde este mapa está encontrando o caminho — a spec, decisão ou alteração. O destino fixa o escopo, portanto é resolvido primeiro.
2. **Mapeie a fronteira.** Sabatine novamente, desta vez **em largura (breadth-first)**: espalhe-se por todo o espaço em vez de se aprofundar em qualquer linha única, trazendo à tona as decisões em aberto e os primeiros passos viáveis agora. **Se isso não revelar nenhuma névoa** — o caminho até o destino já estiver claro, toda a jornada for pequena o suficiente para uma sessão —, você não precisa de um mapa. Pare e pergunte ao usuário como ele gostaria de prosseguir.
3. **Crie o mapa** (label `wayfinder:map`): Destino e Notas preenchidos, Decisões até o momento vazias, a névoa esboçada em **Não especificado ainda**.
4. **Crie os tickets que você pode especificar agora** como issues filhas do mapa — e então conecte as arestas de bloqueio em uma **segunda passada** (as issues precisam de ids antes de poderem referenciar umas às outras). A conexão as organiza na fronteira e nos bloqueados; tudo o que você ainda não puder especificar permanece na névoa — a seção **Não especificado ainda**.
5. **Dispare os subagentes de pesquisa.** Para cada ticket `research` criado, inicie um subagente `/research` para resolvê-lo em paralelo, capturando suas descobertas em um branch descartável `research/<name>` com um ponteiro de contexto a partir do ticket.
6. Pare — traçar o mapa é o trabalho de uma sessão; não resolve nada manualmente.

### Trabalhar através do mapa

O usuário invoca com um mapa (URL ou número). Um ticket é **opcional** — sem um, você escolhe a próxima decisão, não o usuário.

1. Carregue o **mapa** — a visão em baixa resolução, não o corpo de todos os tickets.
2. Escolha o ticket. Se o usuário nomeou um, use-o. Caso contrário, pegue o primeiro ticket da fronteira em ordem. **Reivindique-o**: atribua-o a si mesmo antes de qualquer trabalho.
3. Resolva-o — **aprofunde conforme necessário (zoom as needed)**: busque o corpo completo de qualquer ticket relacionado ou fechado sob demanda; invoque as skills que o bloco `## Notas` nomeia. Em caso de dúvida, use `/grilling` e `/domain-modeling`.
4. Registre a resolução: publique a resposta como um **comentário de resolução**, **feche** a issue e **anexe um ponteiro de contexto** às Decisões até o momento do mapa.
5. Adicione tickets recém-surgidos (criar e depois conectar); promova qualquer névoa que a resposta tenha tornado especificável, limpando cada trecho promovido de **Não especificado ainda** para que ele viva apenas como seu novo ticket. Se a resposta revelar que um ticket — este ou outro — fica além do destino, **descarte-o do escopo** em vez de resolvê-lo na rota. Se a decisão invalidar outras partes do mapa, atualize ou exclua esses tickets.

O usuário pode executar tickets desbloqueados em paralelo, portanto espere que outras sessões estejam editando o tracker simultaneamente.
