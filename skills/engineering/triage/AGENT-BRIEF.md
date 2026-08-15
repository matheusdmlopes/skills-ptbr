# Escrevendo Briefs de Agente

Um brief de agente é um comentário estruturado publicado em uma issue ou PR do GitHub quando este se move para `ready-for-agent`. É a especificação autoritativa a partir da qual um agente AFK trabalhará. O corpo original e a discussão são contexto — o brief de agente é o contrato.

O brief estabelece **o que o agente deve fazer**, o que se estende a ambas as superfícies: para uma issue, é construir a alteração do zero; para um PR, é o que resta fazer *no diff existente* — finalizá-lo, fechar lacunas, endereçar pontos de revisão. Os mesmos princípios em ambos os casos; o exemplo de PR abaixo mostra a diferença.

## Princípios

### Durabilidade em vez de precisão

A issue pode ficar em `ready-for-agent` por dias ou semanas. A base de código mudará nesse meio tempo. Escreva o brief de modo que ele continue útil mesmo que arquivos sejam renomeados, movidos ou refatorados.

- **Faça**: descreva interfaces, tipos e contratos de comportamento
- **Faça**: nomeie tipos específicos, assinaturas de funções ou formatos de configuração que o agente deva procurar ou modificar
- **Não faça**: referencie caminhos de arquivos — eles ficam desatualizados
- **Não faça**: referencie números de linha
- **Não faça**: presuma que a estrutura atual de implementação permanecerá a mesma

### Comportamental, não procedimental

Descreva **o que** o sistema deve fazer, não **como** implementá-lo. O agente explorará a base de código do zero e tomará suas próprias decisões de implementação.

- **Bom:** "O tipo `SkillConfig` deve aceitar um campo opcional `schedule` do tipo `CronExpression`"
- **Ruim:** "Abra src/types/skill.ts e adicione um campo schedule na linha 42"
- **Bom:** "Quando um usuário executa `/triage` sem argumentos, ele deve ver um resumo das issues que precisam de atenção"
- **Ruim:** "Adicione uma instrução switch na função principal de manipulação"

### Critérios de aceitação completos

O agente precisa saber quando terminou. Todo brief de agente deve ter critérios de aceitação concretos e testáveis. Cada critério deve ser verificável de forma independente.

- **Bom:** "Executar `gh issue list --label needs-triage` retorna issues que passaram pela classificação inicial"
- **Ruim:** "A triagem deve funcionar corretamente"

### Limites explícitos de escopo

Declare o que está fora de escopo. Isso impede que o agente adicione recursos desnecessários (gold-plating) ou faça suposições sobre funcionalidades adjacentes.

## Template

```markdown
## Brief de Agente

**Categoria:** bug / enhancement
**Resumo:** descrição de uma linha do que precisa acontecer

**Comportamento atual:**
Descreva o que acontece agora. Para bugs, este é o comportamento quebrado.
Para melhorias, este é o status quo sobre o qual a funcionalidade é construída.

**Comportamento desejado:**
Descreva o que deve acontecer quando o trabalho do agente estiver concluído.
Seja específico sobre casos de borda e condições de erro.

**Interfaces principais:**
- `TypeName` — o que precisa mudar e por quê
- Tipo de retorno de `functionName()` — o que ele retorna atualmente vs o que deveria retornar
- Formato de configuração — quaisquer novas opções de configuração necessárias

**Critérios de aceitação:**
- [ ] Critério 1, específico e testável
- [ ] Critério 2, específico e testável
- [ ] Critério 3, específico e testável

**Fora de escopo:**
- Algo que NÃO deve ser alterado ou endereçado nesta issue
- Funcionalidade adjacente que pode parecer relacionada, mas é separada
```

## Exemplos

### Bom brief de agente (bug)

```markdown
## Brief de Agente

**Categoria:** bug
**Resumo:** truncamento da descrição da skill corta no meio de uma palavra, produzindo saída quebrada

**Comportamento atual:**
Quando a descrição de uma skill excede 1024 caracteres, ela é truncada em
exatamente 1024 caracteres, sem respeitar os limites de palavra. Isso produz
descrições que terminam no meio de uma palavra (ex.: "Use when the user wants to confi").

**Comportamento desejado:**
O truncamento deve quebrar no último limite de palavra antes de 1024
caracteres e acrescentar "..." para indicar o truncamento.

**Interfaces principais:**
- O campo `description` do tipo `SkillMetadata` — não é necessária mudança
  de tipo, mas a lógica de validação/processamento que o popula precisa
  respeitar os limites de palavra
- Qualquer função que leia o frontmatter do SKILL.md e extraia a descrição

**Critérios de aceitação:**
- [ ] Descrições com menos de 1024 caracteres permanecem inalteradas
- [ ] Descrições com mais de 1024 caracteres são truncadas no último limite
      de palavra antes de 1024 caracteres
- [ ] Descrições truncadas terminam com "..."
- [ ] O comprimento total, incluindo "...", não excede 1024 caracteres

**Fora de escopo:**
- Alterar o próprio limite de 1024 caracteres
- Suporte a descrição em múltiplas linhas
```

### Bom brief de agente (enhancement)

```markdown
## Brief de Agente

**Categoria:** enhancement
**Resumo:** adicionar suporte ao diretório `.out-of-scope/` para rastrear solicitações de funcionalidades rejeitadas

**Comportamento atual:**
Quando uma solicitação de funcionalidade é rejeitada, a issue é fechada com a
label `wontfix` e um comentário. Não há registro persistente da decisão ou do
raciocínio. Solicitações futuras semelhantes exigem que o mantenedor recorde
ou procure a discussão anterior.

**Comportamento desejado:**
Solicitações de funcionalidades rejeitadas devem ser documentadas em arquivos
`.out-of-scope/<concept>.md` que registrem a decisão, o raciocínio e links
para todas as issues que solicitaram a funcionalidade. Ao triar novas issues,
esses arquivos devem ser verificados em busca de correspondências.

**Interfaces principais:**
- Formato de arquivo Markdown em `.out-of-scope/` — cada arquivo deve ter um
  cabeçalho `# Nome do Conceito`, uma linha `**Decisão:**`, uma linha
  `**Motivo:**` e uma lista `**Solicitações anteriores:**` com links de issues
- O fluxo de triagem deve ler todos os arquivos `.out-of-scope/*.md` logo no
  início e comparar as issues recebidas com eles por similaridade de conceito

**Critérios de aceitação:**
- [ ] Fechar uma funcionalidade como wontfix cria/atualiza um arquivo em `.out-of-scope/`
- [ ] O arquivo inclui a decisão, o raciocínio e o link para a issue fechada
- [ ] Se já existir um arquivo `.out-of-scope/` correspondente, a nova issue é
      anexada à sua lista de "Solicitações anteriores" em vez de criar um duplicado
- [ ] Durante a triagem, os arquivos `.out-of-scope/` existentes são verificados
      e apresentados quando uma nova issue corresponde a uma rejeição anterior

**Fora de escopo:**
- Correspondência automatizada (o humano confirma a correspondência)
- Reabrir funcionalidades previamente rejeitadas
- Relatos de bug (apenas rejeições de enhancement vão para `.out-of-scope/`)
```

### Bom brief de agente (PR)

Para um PR, "Comportamento atual" descreve o estado do diff, e o brief pede ao agente para finalizá-lo ou corrigi-lo em vez de construir do zero.

```markdown
## Brief de Agente

**Categoria:** enhancement
**Resumo:** finalizar a flag de saída `--json` do contribuidor para `triage list`

**Comportamento atual:**
O PR adiciona uma flag `--json` que serializa a lista de issues em JSON. O
caminho feliz funciona e o diff corresponde à estrutura de comandos do
projeto. Restam duas lacunas: os erros ainda são impressos como texto legível
por humanos (não JSON), e a nova flag não tem cobertura de teste.

**Comportamento desejado:**
Com `--json`, toda a saída — incluindo erros — é JSON bem formado no stdout,
e os códigos de saída do comando permanecem inalterados. A saída legível por
humanos existente permanece intocada quando a flag está ausente.

**Interfaces principais:**
- O caminho de erro do comando deve emitir `{ "error": string }` sob
  `--json`, em vez do erro em texto plano
- Reutilize o serializador existente que o PR já adicionou; não introduza um segundo

**Critérios de aceitação:**
- [ ] `triage list --json` emite JSON válido tanto para casos de sucesso quanto de erro
- [ ] Os códigos de saída correspondem ao comando sem JSON
- [ ] Um teste cobre a saída de sucesso do `--json` e um caso de erro
- [ ] A saída padrão (sem JSON) permanece byte a byte inalterada

**Fora de escopo:**
- Adicionar `--json` a qualquer outro comando
- Alterar o formato JSON do payload de sucesso que o PR já definiu
```

### Mau brief de agente

```markdown
## Brief de Agente

**Resumo:** corrigir o bug da triagem

**O que fazer:**
A coisa da triagem está quebrada. Olhe o arquivo principal e conserte.
A função por volta da linha 150 tem o problema.

**Arquivos a alterar:**
- src/triage/handler.ts (linha 150)
- src/types.ts (linha 42)
```

Isto é ruim porque:
- Sem categoria
- Descrição vaga ("a coisa da triagem está quebrada")
- Referencia caminhos de arquivo e números de linha que ficarão desatualizados
- Sem critérios de aceitação
- Sem limites de escopo
- Sem descrição do comportamento atual vs desejado
