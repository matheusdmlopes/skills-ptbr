# Formato de ADR

ADRs vivem em `docs/adr/` e usam numeração sequencial: `0001-slug.md`, `0002-slug.md`, etc.

Crie o diretório `docs/adr/` sob demanda (lazily) — apenas quando o primeiro ADR for necessário.

## Template

```md
# {Título curto da decisão}

{1-3 frases: qual é o contexto, o que decidimos e por quê.}
```

É só isso. Um ADR pode ser um único parágrafo. O valor está em registrar *que* uma decisão foi tomada e o *porquê* — não em preencher seções.

## Seções opcionais

Inclua-as apenas quando agregarem valor genuíno. A maioria dos ADRs não precisará delas.

- Frontmatter de **Status** (`proposed | accepted | deprecated | superseded by ADR-NNNN`) — útil quando decisões são revisitadas
- **Opções Consideradas** — apenas quando as alternativas rejeitadas valerem a pena ser lembradas
- **Consequências** — apenas quando efeitos colaterais não óbvios precisarem ser destacados

## Numeração

Varra `docs/adr/` em busca do maior número existente e incremente em um.

## Quando oferecer um ADR

Todos estes três pontos devem ser verdadeiros:

1. **Difícil de reverter** — o custo de mudar de ideia mais tarde é significativo
2. **Surpreendente sem contexto** — um leitor futuro olhará para o código e se perguntará "por que diabos fizeram desta forma?"
3. **O resultado de um trade-off real** — existiam alternativas genuínas e você escolheu uma por motivos específicos

Se uma decisão for fácil de reverter, ignore-a — você simplesmente vai revertê-la. Se não for surpreendente, ninguém vai se perguntar o porquê. Se não existia alternativa real, não há nada a registrar além de "fizemos o óbvio".

### O que se qualifica

- **Formato arquitetural.** "Estamos usando um monorepo." "O write model é event-sourced, o read model é projetado no Postgres."
- **Padrões de integração entre contextos.** "Ordering e Billing se comunicam via domain events, não HTTP síncrono."
- **Escolhas tecnológicas que trazem lock-in.** Banco de dados, barramento de mensagens, provedor de autenticação, alvo de deploy. Não toda biblioteca — apenas aquelas que levariam um trimestre para trocar.
- **Decisões de divisa e escopo.** "Dados do cliente pertencem ao contexto Customer; outros contextos fazem referência a eles apenas por ID." Os nãos explícitos são tão valiosos quanto os sims.
- **Desvios deliberados do caminho óbvio.** "Estamos usando SQL manual em vez de um ORM devido a X." Qualquer coisa em que um leitor razoável assumiria o oposto. Isso impede que o próximo engenheiro "corrija" algo que foi deliberado.
- **Restrições não visíveis no código.** "Não podemos usar AWS devido a requisitos de conformidade." "Os tempos de resposta devem ser inferiores a 200ms por causa do contrato da API de parceiros."
- **Alternativas rejeitadas quando a rejeição não é óbvia.** Se você considerou GraphQL e escolheu REST por motivos sutis, registre isso — caso contrário, alguém sugerirá GraphQL novamente em seis meses.
