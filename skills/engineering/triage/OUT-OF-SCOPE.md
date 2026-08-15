# Base de Conhecimento Fora de Escopo (Out-of-Scope)

O diretório `.out-of-scope/` em um repositório armazena registros persistentes de solicitações de funcionalidades rejeitadas. Ele serve a dois propósitos:

1. **Memória institucional** — por que uma funcionalidade foi rejeitada, para que o raciocínio não seja perdido quando a issue for fechada
2. **Deduplicação** — quando chega uma nova issue correspondente a uma rejeição anterior, a skill pode apresentar a decisão prévia em vez de rediscuti-la

## Estrutura de diretórios

```
.out-of-scope/
├── dark-mode.md
├── plugin-system.md
└── graphql-api.md
```

Um arquivo por **conceito**, não por issue. Múltiplas issues solicitando a mesma coisa são agrupadas sob um único arquivo.

## Formato do arquivo

O arquivo deve ser escrito em um estilo descontraído e legível — mais parecido com um documento de design curto do que com uma entrada de banco de dados. Use parágrafos, exemplos de código e ilustrações para tornar o raciocínio claro e útil para alguém que o leia pela primeira vez.

```markdown
# Dark Mode

Este projeto não oferece suporte a dark mode ou tematização voltada ao usuário.

## Por que isso está fora de escopo

O pipeline de renderização assume uma única paleta de cores definida em
`ThemeConfig`. Suportar múltiplos temas exigiria:

- Um provedor de contexto de tema envolvendo toda a árvore de componentes
- Resolução de estilo sensível a tema por componente
- Uma camada de persistência para preferências de tema do usuário

Esta é uma mudança arquitetural significativa que não se alinha com o foco
do projeto na autoria de conteúdo. Tematização é uma preocupação de quem
consome downstream, incorporando ou redistribuindo a saída.

```ts
// A interface ThemeConfig atual não foi projetada para troca em tempo de execução:
interface ThemeConfig {
  colors: ColorPalette; // paleta única, resolvida em tempo de build
  fonts: FontStack;
}
```

## Solicitações anteriores

- #42 — "Add dark mode support"
- #87 — "Night theme for accessibility"
- #134 — "Dark theme option"
```

### Nomeando o arquivo

Use um nome curto e descritivo em kebab-case para o conceito: `dark-mode.md`, `plugin-system.md`, `graphql-api.md`. O nome deve ser reconhecível o suficiente para que alguém navegando pelo diretório entenda o que foi rejeitado sem precisar abrir o arquivo.

### Escrevendo a justificativa

A justificativa deve ser substantiva — não "não queremos isso", mas o porquê. Boas justificativas fazem referência a:

- Escopo ou filosofia do projeto ("Este projeto foca em X; a tematização é uma preocupação de quem consome downstream")
- Restrições técnicas ("Suportar isso exigiria Y, o que entra em conflito com nossa arquitetura Z")
- Decisões estratégicas ("Optamos por usar A em vez de B porque...")

A justificativa deve ser duradoura. Evite fazer referência a circunstâncias temporárias ("estamos muito ocupados no momento") — essas não são rejeições reais, são adiamentos.

## Quando verificar `.out-of-scope/`

Durante a triagem (Passo 1: Reunir contexto), leia todos os arquivos em `.out-of-scope/`. Ao avaliar uma nova issue:

- Verifique se a solicitação corresponde a um conceito existente fora de escopo
- A correspondência é por similaridade de conceito, não por palavra-chave — "night theme" corresponde a `dark-mode.md`
- Se houver uma correspondência, apresente-a ao mantenedor: "Isto é semelhante a `.out-of-scope/dark-mode.md` — rejeitamos isto anteriormente porque [motivo]. Você ainda pensa da mesma forma?"

O mantenedor pode:

- **Confirmar** — a nova issue é adicionada à lista de "Solicitações anteriores" do arquivo existente e depois fechada
- **Reconsiderar** — o arquivo fora de escopo é excluído ou atualizado, e a issue segue pela triagem normal
- **Discordar** — as issues são relacionadas, mas distintas; prossiga com a triagem normal

## Quando escrever em `.out-of-scope/`

Apenas quando uma **melhoria (enhancement)** (não um bug) for *rejeitada* como `wontfix`. Isso se aplica a PRs de melhoria exatamente como a issues — um PR rejeitado é registrado aqui para que a mesma solicitação não retorne como código novo.

**Não** escreva aqui quando algo for fechado como `wontfix` por estar **já implementado**. Essa é uma funcionalidade construída, não rejeitada; registrá-la contaminaria as verificações de deduplicação com falsas rejeições. Em vez disso, o comentário de encerramento aponta para onde a funcionalidade já reside.

O fluxo:

1. O mantenedor decide que uma solicitação de funcionalidade está fora de escopo
2. Verifique se já existe um arquivo correspondente em `.out-of-scope/`
3. Se sim: anexe a nova issue à lista de "Solicitações anteriores"
4. Se não: crie um novo arquivo com o nome do conceito, decisão, motivo e primeira solicitação anterior
5. Publique um comentário na issue explicando a decisão e mencionando o arquivo `.out-of-scope/`
6. Feche a issue com a label `wontfix`

## Atualizando ou removendo arquivos fora de escopo

Se o mantenedor mudar de ideia sobre um conceito previamente rejeitado:

- Exclua o arquivo `.out-of-scope/`
- A skill não precisa reabrir issues antigas — elas são registros históricos
- A nova issue que desencadeou a reconsideração segue pela triagem normal
