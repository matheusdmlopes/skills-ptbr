❓ **Q1** - **Modelo de Persistência e Identificação do Usuário**: Como os artigos favoritados devem ser armazenados e associados ao usuário?
- Opção A: **100% Local (LocalStorage/IndexedDB)**: Sem necessidade de conta ou login. Rápido, sem custo de infraestrutura e com privacidade total, mas não sincroniza entre dispositivos diferentes do mesmo leitor.
- Opção B: **Autenticado (Banco de Dados)**: Requer que o leitor tenha uma conta no blog e faça login. Os favoritos sincronizam em qualquer navegador ou dispositivo.
- Opção C: **Híbrido**: Salva no LocalStorage para leitores anônimos e sincroniza com o banco de dados caso o usuário faça login.

➡️ **Recomendação**: Opção A se o blog não possui sistema de autenticação hoje (menor atrito e entrega imediata); ou Opção C se o blog já possui login implementado.

---

❓ **Q2** - **Stack Tecnológica Atual do Blog**: Qual é a arquitetura e as tecnologias em que o blog está construído atualmente?
- Opção A: **Framework Fullstack / SSR** (ex: Next.js, Remix, Astro com SSR, Nuxt).
- Opção B: **Gerador de Site Estático (SSG)** (ex: Astro estático, Hugo, Jekyll, 11ty).
- Opção C: **Backend Tradicional + Templates/SPA** (ex: FastAPI/Django/Rails + PostgreSQL/SQLite, ou WordPress).
- Opção D: **HTML, CSS e JavaScript puros**.

➡️ **Recomendação**: Especifique a stack para mapearmos se a solução exigirá criação de rotas de API/banco de dados ou apenas componentes client-side.

---

❓ **Q3** - **Ponto de Acesso e Visualização da Lista de Salvos**: Como o leitor deve acessar e gerenciar a lista de artigos que salvou para ler depois?
- Opção A: **Página dedicada** (ex: `/favoritos` ou `/salvos`), com listagem estruturada dos artigos salvos.
- Opção B: **Gaveta lateral (Drawer) ou Modal flutuante**, abrindo diretamente sobre a página em que o leitor estiver navegando.
- Opção C: **Aba dentro da área de perfil/conta do usuário** (caso autenticado).

➡️ **Recomendação**: Opção A (Página dedicada `/favoritos`) com um link/ícone visível no cabeçalho de navegação, garantindo melhor usabilidade e espaço para leitura.

---

❓ **Q4** - **Profundidade de Armazenamento (Referência vs Offline)**: O que deve acontecer quando o artigo for salvo?
- Opção A: **Apenas a referência** (ID, slug, título, resumo e link): O leitor precisa de conexão com a internet para abrir e ler o artigo depois.
- Opção B: **Cache completo para leitura offline (PWA / Service Worker)**: O texto e imagens essenciais do artigo são baixados localmente para permitir leitura sem internet.

➡️ **Recomendação**: Opção A (Apenas a referência), mantendo o escopo enxuto e o código leve, a menos que leitura offline seja indispensável.

---

❓ **Q5** - **Estrutura e Granularidade da Lista**: Qual é o nível de organização que o usuário terá sobre os itens salvos?
- Opção A: **Lista plana simples**: Ação binária (adicionar/remover) e visualização em ordem cronológica de inclusão.
- Opção B: **Lista com status de leitura**: Opção de marcar artigos como "Lido", "Não lido" ou arquivar.
- Opção C: **Organização avançada**: Criação de pastas, coleções personalizadas, tags e anotações.

➡️ **Recomendação**: Opção A para a primeira versão, priorizando simplicidade de uso e implementação rápida.
