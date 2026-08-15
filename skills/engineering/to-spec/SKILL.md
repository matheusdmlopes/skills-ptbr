---
name: to-spec
description: Transforme a conversa atual em uma spec e publique-a no issue tracker do projeto — sem entrevista, apenas a síntese do que já foi discutido.
disable-model-invocation: true
---

Esta skill pega o contexto da conversa atual e o entendimento da base de código e produz uma spec. NÃO entreviste o usuário — apenas sintetize o que você já sabe.

O vocabulário de issue tracker e de labels de triagem deve ter sido fornecido a você — execute `/setup-matt-pocock-skills` se não foi.

## Processo

1. Explore o repositório para entender o estado atual da base de código, se ainda não o fez. Use o vocabulário do glossário de domínio do projeto por toda a spec e respeite quaisquer ADRs na área em que você estiver mexendo.

2. Esboce as costuras nas quais você vai testar a funcionalidade. Costuras existentes devem ser preferidas a novas. Use a costura mais alta possível. Se novas costuras forem necessárias, proponha-as no ponto mais alto que puder. Quanto menos costuras pela base de código, melhor - o número ideal é uma.

Verifique com o usuário se essas costuras atendem às expectativas dele.

3. Escreva a spec usando o template abaixo e, em seguida, publique-a no issue tracker do projeto. Aplique a label de triagem `ready-for-agent` - não é necessária triagem adicional.

<spec-template>

## Declaração do Problema

O problema que o usuário está enfrentando, sob a perspectiva do usuário.

## Solução

A solução para o problema, sob a perspectiva do usuário.

## Histórias de Usuário

Uma lista LONGA e numerada de histórias de usuário. Cada história de usuário deve estar no formato:

1. Como um <ator>, eu quero <funcionalidade>, para que <benefício>

<user-story-example>
1. Como cliente de banco móvel, eu quero ver o saldo das minhas contas, para que eu possa tomar decisões mais bem informadas sobre meus gastos
</user-story-example>

Esta lista de histórias de usuário deve ser extremamente abrangente e cobrir todos os aspectos da funcionalidade.

## Decisões de Implementação

Uma lista das decisões de implementação que foram tomadas. Isso pode incluir:

- Os módulos que serão construídos/modificados
- As interfaces desses módulos que serão modificadas
- Esclarecimentos técnicos do desenvolvedor
- Decisões arquiteturais
- Alterações de schema
- Contratos de API
- Interações específicas

NÃO inclua caminhos de arquivo específicos nem trechos de código. Eles podem ficar desatualizados muito rapidamente.

Exceção: se um protótipo produziu um trecho que codifica uma decisão com mais precisão do que a prosa é capaz (máquina de estados, reducer, schema, formato de tipo), inclua-o inline na decisão relevante e anote brevemente que ele veio de um protótipo. Reduza aos trechos ricos em decisões — não uma demo funcional, apenas as partes importantes.

## Decisões de Teste

Uma lista das decisões de teste que foram tomadas. Inclua:

- Uma descrição do que constitui um bom teste (testar apenas comportamento externo, não detalhes de implementação)
- Quais módulos serão testados
- Arte prévia para os testes (ou seja, tipos semelhantes de testes na base de código)

## Fora de Escopo

Uma descrição das coisas que estão fora de escopo para esta spec.

## Notas Adicionais

Quaisquer notas adicionais sobre a funcionalidade.

</spec-template>
