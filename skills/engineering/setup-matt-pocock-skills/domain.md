# Documentos de Domínio (Domain Docs)

Como as engineering skills devem consumir a documentação de domínio deste repo ao explorar a base de código.

## Antes de explorar, leia estes

- **`CONTEXT.md`** na raiz do repo, ou
- **`CONTEXT-MAP.md`** na raiz do repo se ele existir — ele aponta para um `CONTEXT.md` por contexto. Leia cada um relevante para o tema.
- **`docs/adr/`** — leia os ADRs que tocam na área em que você está prestes a trabalhar. Em repositórios de múltiplos contextos, verifique também `src/<context>/docs/adr/` para decisões de escopo de contexto.

Se algum desses arquivos não existir, **prossiga em silêncio**. Não sinalize a ausência deles; não sugira criá-los antecipadamente. A skill `/domain-modeling` (acessada via `/grill-with-docs` e `/improve-codebase-architecture`) cria-os sob demanda quando termos ou decisões são efetivamente resolvidos.

## Estrutura de arquivos

Repositório de contexto único (a maioria dos repositórios):

```
/
├── CONTEXT.md
├── docs/adr/
│   ├── 0001-event-sourced-orders.md
│   └── 0002-postgres-for-write-model.md
└── src/
```

Repositório de múltiplos contextos (presença de `CONTEXT-MAP.md` na raiz):

```
/
├── CONTEXT-MAP.md
├── docs/adr/                          ← decisões de todo o sistema
└── src/
    ├── ordering/
    │   ├── CONTEXT.md
    │   └── docs/adr/                  ← decisões específicas do contexto
    └── billing/
        ├── CONTEXT.md
        └── docs/adr/
```

## Use o vocabulário do glossário

Quando sua saída nomear um conceito de domínio (em um título de issue, proposta de refatoração, hipótese, nome de teste), use o termo conforme definido em `CONTEXT.md`. Não desvie para sinônimos que o glossário explicitamente evita.

Se o conceito de que você precisa ainda não estiver no glossário, isso é um sinal — ou você está inventando linguagem que o projeto não usa (reconsidere) ou há uma lacuna real (anote para `/domain-modeling`).

## Sinalize conflitos com ADRs

Se a sua saída contradisser um ADR existente, exponha isso explicitamente em vez de sobrescrever silenciosamente:

> _Contradiz o ADR-0007 (pedidos com event sourcing) — mas vale a pena reabrir porque…_
