# Issue tracker: Markdown Local

Issues e specs para este repo residem como arquivos markdown em `.scratch/`.

## Convenções

- Uma funcionalidade por diretório: `.scratch/<feature-slug>/`
- A spec é `.scratch/<feature-slug>/spec.md`
- Issues de implementação são um arquivo por ticket em `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numerados a partir de `01` — nunca um único arquivo de tickets combinado
- O estado de triagem é registrado como uma linha `Status:` próximo ao topo de cada arquivo de issue (veja `triage-labels.md` para as strings de papéis)
- Comentários e histórico de conversas são anexados ao final do arquivo sob um título `## Comments`

## Quando uma skill disser "publique no issue tracker"

Crie um novo arquivo sob `.scratch/<feature-slug>/` (criando o diretório se necessário).

## Quando uma skill disser "busque o ticket relevante"

Leia o arquivo no caminho referenciado. O usuário normalmente passará o caminho ou o número da issue diretamente.

## Operações de wayfinding

Usado por `/wayfinder`. O **mapa** é um arquivo com um arquivo **filho** por ticket.

- **Mapa**: `.scratch/<effort>/map.md` — o corpo de Notas / Decisões até o momento / Névoa.
- **Ticket filho**: `.scratch/<effort>/issues/NN-<slug>.md`, numerado a partir de `01`, com a pergunta no corpo. Uma linha `Type:` registra o tipo de ticket (`research`/`prototype`/`grilling`/`task`); uma linha `Status:` registra `claimed`/`resolved`.
- **Bloqueio**: uma linha `Bloqueado por: NN, NN` próximo ao topo. Um ticket está desbloqueado quando todos os arquivos que ele lista estiverem `resolved`.
- **Fronteira**: varra `.scratch/<effort>/issues/` em busca de arquivos abertos, desbloqueados e não reivindicados; o primeiro por número é escolhido.
- **Reivindicar (claim)**: defina `Status: claimed` e salve antes de qualquer trabalho.
- **Resolver**: anexe a resposta sob um título `## Answer`, defina `Status: resolved`, e então anexe um ponteiro de contexto (resumo + link) às Decisões até o momento do mapa em `map.md`.
