# Nomes de skill, de comando e de artefato não são traduzidos

A tradução para pt-BR mantém em inglês todo nome que funciona como interface: as pastas das skills (`tdd`, `grill-me`), os comandos que elas expõem (`/grilling`, `/to-spec`), os artefatos que geram (`CONTEXT.md`, `docs/adr/`, `docs/agents/issue-tracker.md`) e as labels de triagem (`needs-triage`, `ready-for-agent`). Só a prosa é traduzida.

O motivo é que esses nomes formam um grafo: há cerca de 90 referências cruzadas entre as skills promovidas, e o `AGENTS.md` de cada repositório consumidor aponta para elas por nome. Traduzir um nome obriga a retraduzir o grafo inteiro e rompe a ponte com a documentação, os vídeos e os artigos do autor original, que continuam sendo o material de referência.

## Consequência: a colisão é deliberada

Instalar esta tradução por cima do original **substitui** as skills de mesmo nome. Verificado com o CLI `skills` (vercel-labs): a instalação sobrescreve o diretório inteiro sem prompt, removendo inclusive os arquivos auxiliares da versão anterior, e registra a origem ativa em `skills-lock.json`.

Isso é aceito, e é o que dispensa um instalador próprio: alternar de idioma é reinstalar da outra origem.

```bash
npx skills@latest add matheusdmlopes/skills-ptbr   # pt-BR
npx skills@latest add mattpocock/skills            # inglês
```

Foram rejeitados: sufixar os nomes (`tdd-ptbr`), que evita a colisão mas quebra as referências cruzadas e polui o comando; e guardar a versão anterior lado a lado como `.bak.md`, que é redundante (a fonte é um repositório público) e arriscado (qualquer `SKILL.md` sob `~/.claude/skills/*/` é carregado pelo harness, criando duas skills disputando o mesmo comando).
