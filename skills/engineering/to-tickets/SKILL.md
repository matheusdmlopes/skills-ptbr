---
name: to-tickets
description: Divida um plano, spec ou a conversa atual em um conjunto de tickets de bala traçante, cada um declarando suas arestas de bloqueio, publicados no tracker configurado — arestas como texto em um arquivo por ticket localmente, ou links de bloqueio nativos em um tracker real.
disable-model-invocation: true
---

# To Tickets

Divida um plano, spec ou conversa em um conjunto de **tickets** — fatias verticais de bala traçante, cada uma declarando os tickets que a **bloqueiam**.

O vocabulário de issue tracker e de labels de triagem deve ter sido fornecido a você — execute `/setup-matt-pocock-skills` se não foi.

## Processo

### 1. Reúna o contexto

Trabalhe a partir do que já está no contexto da conversa. Se o usuário passar uma referência (o caminho de uma spec, o número ou URL de uma issue) como argumento, busque-a e leia seu corpo e comentários na íntegra.

### 2. Explore a base de código (opcional)

Se ainda não explorou a base de código, faça-o para entender o estado atual do código. Os títulos e descrições dos tickets devem usar o vocabulário do glossário de domínio do projeto e respeitar os ADRs na área em que você estiver mexendo.

Procure oportunidades para pré-fatorar o código e facilitar a implementação. "Torne a mudança fácil, depois faça a mudança fácil."

### 3. Esboce as fatias verticais

Divida o trabalho em tickets de **bala traçante**.

<vertical-slice-rules>

- Cada fatia corta um caminho estreito, mas COMPLETO, através de todas as camadas (schema, API, UI, testes) — vertical, e NÃO uma fatia horizontal de uma única camada
- Uma fatia concluída é demonstrável ou verificável por si só
- Cada fatia é dimensionada para caber em uma única janela de contexto limpa
- Qualquer pré-fatoração deve ser feita primeiro

</vertical-slice-rules>

Dê a cada ticket suas **arestas de bloqueio** — os outros tickets que devem ser concluídos antes que ele possa começar. Um ticket sem bloqueadores pode começar imediatamente.

**Refatorações amplas são a exceção ao fatiamento vertical.** Uma **refatoração ampla** é uma alteração mecânica — renomear uma coluna, retipar um símbolo compartilhado — cujo **raio de impacto** se espalha por toda a base de código, de modo que uma única edição quebra milhares de locais de chamada de uma só vez e nenhuma fatia vertical consegue passar em verde. Não a force em uma bala traçante; encadeie-a como **expand–contract**. Primeiro expanda: adicione a nova forma ao lado da antiga para que nada quebre. Em seguida, migre os locais de chamada em lotes dimensionados pelo raio de impacto (por pacote, por diretório), sendo cada lote seu próprio ticket bloqueado pela expansão, mantendo a CI verde de lote em lote porque a forma antiga ainda existe. Por fim, contraia: exclua a forma antiga assim que nenhum chamador restar, em um ticket bloqueado por todos os lotes de migração. Quando nem mesmo os lotes conseguirem se manter verdes sozinhos, mantenha a sequência, mas faça-os compartilhar um branch de integração que, em conjunto, bloqueia um ticket final de integrar-e-verificar — o verde é prometido apenas lá.

### 4. Questione o usuário

Apresente a divisão proposta como uma lista numerada. Para cada ticket, mostre:

- **Título**: nome descritivo curto
- **Bloqueado por**: quais outros tickets (se houver) devem ser concluídos primeiro
- **O que entrega**: o comportamento de ponta a ponta que este ticket faz funcionar

Pergunte ao usuário:

- A granularidade parece adequada? (muito grossa / muito fina)
- As arestas de bloqueio estão corretas — cada ticket depende apenas de tickets que genuinamente o impedem de avançar?
- Algum ticket deve ser mesclado ou dividido ainda mais?

Itere até que o usuário aprove a divisão.

### 5. Publique os tickets no tracker configurado

Publique os tickets aprovados. **Como** fazer depende do tracker configurado por `/setup-matt-pocock-skills` — os tickets são os mesmos em ambos os casos, apenas o formato das arestas de bloqueio muda:

- **Arquivos locais** → escreva um arquivo por ticket sob `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numerados a partir de `01` em ordem de dependência (bloqueadores primeiro). O campo "Bloqueado por" de cada arquivo lista os números/títulos dos quais ele depende. Use o template de arquivo por ticket abaixo — um ticket por arquivo, nunca um único arquivo combinado.
- **Um issue tracker real (GitHub, Linear, …)** → publique uma issue por ticket em ordem de dependência (bloqueadores primeiro) para que as arestas de bloqueio de cada ticket possam referenciar identificadores reais. Use o relacionamento nativo de bloqueio / sub-issue da plataforma quando ela tiver um; caso contrário, defina o "Bloqueado por" de cada ticket para as issues bloqueadoras. Aplique a label de triagem `ready-for-agent`, a menos que instruído de outra forma — os tickets já estão prontos para serem assumidos por agentes por construção.

Trabalhe na **fronteira**: qualquer ticket cujos bloqueadores estejam todos concluídos. Para uma cadeia puramente linear, isso significa de cima para baixo.

NÃO feche nem modifique nenhuma issue pai.

<local-ticket-template>

# <NN> — <Título do ticket>

**O que construir:** o comportamento de ponta a ponta que este ticket faz funcionar, sob a perspectiva do usuário — não uma lista de implementação camada por camada.

**Bloqueado por:** os números/títulos dos tickets que bloqueiam este, ou "Nenhum — pode começar imediatamente".

**Status:** ready-for-agent

- [ ] Critério de aceitação 1
- [ ] Critério de aceitação 2

</local-ticket-template>

<issue-template>

## Pai

Uma referência à issue pai no tracker (se a fonte foi uma issue existente; caso contrário, omita esta seção).

## O que construir

O comportamento de ponta a ponta que este ticket faz funcionar, sob a perspectiva do usuário — não implementação camada por camada.

## Critérios de aceitação

- [ ] Critério 1
- [ ] Critério 2

## Bloqueado por

- Uma referência a cada ticket bloqueador, ou "Nenhum — pode começar imediatamente".

</issue-template>

Em ambos os formatos, evite caminhos de arquivo específicos ou trechos de código — eles ficam desatualizados rápido. Exceção: se um protótipo produziu um trecho que codifica uma decisão com mais precisão do que a prosa é capaz (máquina de estados, reducer, schema, formato de tipo), inclua-o inline e anote brevemente que ele veio de um protótipo. Reduza aos trechos ricos em decisões — não uma demo funcional, apenas as partes importantes.
