# Documentos de Domínio (Domain Docs)

Como as engineering skills devem consumir a documentação de domínio deste repo ao explorar a base de código.

## Antes de explorar, leia estes

- **`CONTEXT.md`** na raiz do repo — o glossário do projeto.
- **`.agents/adr/`** — leia os ADRs que tocam na área em que você está prestes a trabalhar.

Este é um repositório de contexto único: não há `CONTEXT-MAP.md` nem `CONTEXT.md` por contexto.

Se algum desses arquivos não existir, **prossiga em silêncio**. Não sinalize a ausência deles; não sugira criá-los antecipadamente. A skill `/domain-modeling` (acessada via `/grill-with-docs` e `/improve-codebase-architecture`) cria-os sob demanda quando termos ou decisões são efetivamente resolvidos.

## Estrutura de arquivos

```
/
├── CONTEXT.md
├── .agents/
│   ├── adr/
│   │   ├── 0001-explicit-setup-pointer-only-for-hard-dependencies.md
│   │   └── 0005-escopo-da-traducao.md
│   └── specs/
└── skills/
```

Os ADRs deste repositório ficam em `.agents/adr/`, não em `docs/adr/` — a árvore `docs/` aqui é reservada às páginas humanas das skills promovidas (`docs/<bucket>/<skill-name>.md`), conforme `CLAUDE.md`. Ao criar um ADR novo, escreva em `.agents/adr/` seguindo a numeração existente.

## Use o vocabulário do glossário

Quando sua saída nomear um conceito de domínio (em um título de issue, proposta de refatoração, hipótese, nome de teste), use o termo conforme definido em `CONTEXT.md`. Não desvie para sinônimos que o glossário explicitamente evita.

Se o conceito de que você precisa ainda não estiver no glossário, isso é um sinal — ou você está inventando linguagem que o projeto não usa (reconsidere) ou há uma lacuna real (anote para `/domain-modeling`).

## Sinalize conflitos com ADRs

Se a sua saída contradisser um ADR existente, exponha isso explicitamente em vez de sobrescrever silenciosamente:

> _Contradiz o ADR-0005 (escopo da tradução) — mas vale a pena reabrir porque…_
