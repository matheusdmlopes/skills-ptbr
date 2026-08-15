❓ **Q6** - **Modelagem no Schema do Prisma**: Como a relação entre usuário, artigo e status de leitura deve ser estruturada no banco de dados?
- Opção A: **Tabela dedicada `Bookmark` com timestamp de leitura**: Modelo com campos `id`, `userId`, `articleId` (ou `articleSlug`), `createdAt: DateTime` e `readAt: DateTime?` (nulo significa "não lido", preenchido indica quando foi lido), com `@unique([userId, articleId])`.
- Opção B: **Tabela dedicada com boolean simples**: Campos `id`, `userId`, `articleId`, `isRead: Boolean @default(false)` e `createdAt: DateTime`.
- Opção C: **Extensão direta da tabela de artigos ou usuários** via relação N:N implícita do Prisma (limita a inclusão de metadados como status de leitura).

➡️ **Recomendação**: Opção A (`readAt: DateTime?`), pois resolve o status booleano (não nulo = lido) e preserva o histórico de quando a leitura foi concluída sem custo extra.

---

❓ **Q7** - **Comportamento para Usuários Não Autenticados**: O que acontece quando um leitor deslogado clica no botão de salvar/favoritar em um artigo?
- Opção A: **Redirecionamento imediato**: Envia o usuário direto para a tela de login (ex: `/login?callbackUrl=/artigo-slug`), salvando o favorito logo após a autenticação.
- Opção B: **Modal ou Toast explicativo**: Exibe um aviso contextual na tela informando que é necessário entrar para salvar artigos, com botão direto para login/cadastro sem sair da página.
- Opção C: **Botão desabilitado/oculto**: O botão de favoritar não aparece ou fica inativo para quem não tem sessão ativa.

➡️ **Recomendação**: Opção B (Modal ou Toast explicativo), preservando o contexto de leitura do visitante e incentivando o cadastro de forma suave.

---

❓ **Q8** - **Padrão Técnico de Mutação no Next.js App Router**: Como as ações de favoritar, desfavoritar e alternar status de leitura devem ser executadas no código?
- Opção A: **Server Actions com atualização otimista (`useOptimistic`)**: Execução nativa no servidor com feedback visual instantâneo na interface e revalidação de cache via `revalidatePath`.
- Opção B: **Route Handlers REST (`/api/bookmarks`)**: Endpoints de API tradicionais consumidos via `fetch` ou biblioteca client-side (ex: SWR, TanStack Query).

➡️ **Recomendação**: Opção A (Server Actions com `useOptimistic`), seguindo o padrão idiomático do Next.js App Router com menor volume de código e performance superior.

---

❓ **Q9** - **Gatilho de Transição do Status de Leitura**: Como um artigo salvo passa de "Não lido" para "Lido"?
- Opção A: **Exclusivamente manual**: O leitor clica explicitamente em um botão/checkbox "Marcar como lido" dentro da página `/favoritos` ou no próprio artigo.
- Opção B: **Automático ao abrir**: Ao clicar no artigo a partir da página `/favoritos`, o sistema altera o status para "Lido" automaticamente.
- Opção C: **Automático por tempo de rolagem**: Marca como lido apenas se o usuário rolar até o final do artigo ou permanecer mais de X segundos na página.

➡️ **Recomendação**: Opção A (Exclusivamente manual), evitando marcações acidentais quando o leitor apenas abre a página para checar o conteúdo rapidamente.

---

❓ **Q10** - **Filtros e Organização na Página `/favoritos`**: Como a lista de artigos deve ser apresentada ao usuário na rota `/favoritos`?
- Opção A: **Abas de status**: Três visualizações separadas ("Todos", "Não lidos", "Lidos"), ordenadas por data em que foram salvos (mais recentes primeiro).
- Opção B: **Lista única com ordenação dinâmica**: Tabela/grid única com seletores de ordenação (data de inclusão, título, tempo de leitura) e filtros combinados.
- Opção C: **Feed simples**: Lista contínua com badges visuais indicando "Lido" ou "Pendente", sem abas de separação.

➡️ **Recomendação**: Opção A (Abas "Todos", "Não lidos" e "Lidos"), oferecendo clareza imediata para o leitor gerenciar sua fila de pendências.
