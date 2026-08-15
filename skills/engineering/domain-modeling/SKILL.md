---
name: domain-modeling
description: Construa e refine o modelo de domínio de um projeto. Use ao discutir a terminologia da base de código, ao escrever ou editar um CONTEXT.md, ou ao registrar ou editar um ADR.
---

# Domain Modeling

Construa e refine ativamente o modelo de domínio do projeto enquanto você projeta. Esta é a disciplina *ativa* — contestar termos, inventar cenários de casos de borda e registrar o glossário e as decisões no momento em que se cristalizarem. (Apenas *ler* o `CONTEXT.md` para obter vocabulário não é esta skill — esse é um hábito de uma linha que qualquer skill pode fazer. Esta skill é para quando você estiver alterando o modelo, não apenas consumindo-o.)

## Estrutura de arquivos

A maioria dos repositórios tem um único contexto:

```
/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

Se existir um `CONTEXT-MAP.md` na raiz, o repositório tem múltiplos contextos. O mapa aponta para onde cada um reside:

```
/
├── CONTEXT-MAP.md
├── docs/
│   └── adr/                          ← decisões de todo o sistema
├── src/
│   ├── ordering/
│   │   ├── CONTEXT.md
│   │   └── docs/adr/                 ← decisões específicas do contexto
│   └── billing/
│       ├── CONTEXT.md
│       └── docs/adr/
```

Crie arquivos sob demanda (lazily) — apenas quando tiver algo para escrever. Se nenhum `CONTEXT.md` existir, crie um quando o primeiro termo for resolvido. Se nenhum `docs/adr/` existir, crie-o quando o primeiro ADR for necessário.

## Durante a sessão

### Conteste com base no glossário

Quando o usuário usar um termo que entre em conflito com a linguagem existente em `CONTEXT.md`, aponte isso imediatamente. "Seu glossário define 'cancelamento' como X, mas você parece querer dizer Y — qual dos dois é?"

### Refine linguagem imprecisa

Quando o usuário usar termos vagos ou sobrecarregados, proponha um termo canônico preciso. "Você está dizendo 'conta' — você se refere ao Cliente ou ao Usuário? São coisas diferentes."

### Discuta cenários concretos

Quando relacionamentos de domínio estiverem sendo discutidos, faça testes de estresse com cenários específicos. Invente cenários que sondem casos de borda e forcem o usuário a ser preciso sobre as divisas entre conceitos.

### Faça referência cruzada com o código

Quando o usuário declarar como algo funciona, verifique se o código concorda. Se você encontrar uma contradição, traga-a à tona: "Seu código cancela Pedidos inteiros, mas você acabou de dizer que cancelamento parcial é possível — qual está correto?"

### Atualize o CONTEXT.md inline

Quando um termo for resolvido, atualize o `CONTEXT.md` ali mesmo. Não acumule essas atualizações em lote — registre-as conforme acontecem. Use o formato em [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

O `CONTEXT.md` deve ser totalmente desprovido de detalhes de implementação. Não trate o `CONTEXT.md` como uma spec, um bloco de rascunho ou um repositório de decisões de implementação. Ele é um glossário e nada mais.

### Ofereça ADRs com moderação

Apenas ofereça criar um ADR quando os três pontos forem verdadeiros:

1. **Difícil de reverter** — o custo de mudar de ideia mais tarde é significativo
2. **Surpreendente sem contexto** — um leitor futuro vai se perguntar "por que fizeram desta forma?"
3. **O resultado de um trade-off real** — existiam alternativas genuínas e você escolheu uma por motivos específicos

Se qualquer um dos três estiver ausente, ignore o ADR. Use o formato em [ADR-FORMAT.md](./ADR-FORMAT.md).
