---
name: triage
description: Mova issues e PRs externos por uma máquina de estados de papéis de triagem — categorizar, verificar, sabatinar se necessário e escrever briefs prontos para agentes.
disable-model-invocation: true
---

# Triagem (Triage)

Mova issues no issue tracker do projeto por uma pequena máquina de estados de papéis de triagem.

Se este repo tratar pull requests externos como uma superfície de requisição (veja a configuração do issue tracker), a triagem também os cobre: **um PR é uma issue com código anexado** — mesmos papéis, mesmos estados, mesma máquina, com alguns deltas marcados "para um PR" abaixo. Resolva um `#42` puro para uma issue ou PR conforme a configuração do tracker.

Todo comentário ou issue publicado no issue tracker durante a triagem **deve** começar com este aviso:

```
> *Isto foi gerado por IA durante a triagem.*
```

## Documentos de referência

- [AGENT-BRIEF.md](AGENT-BRIEF.md) — como escrever briefs de agente duradouros
- [OUT-OF-SCOPE.md](OUT-OF-SCOPE.md) — como a base de conhecimento `.out-of-scope/` funciona

## Papéis

Dois papéis de **categoria**:

- `bug` — algo está quebrado
- `enhancement` — nova funcionalidade ou melhoria

Cinco papéis de **estado**:

- `needs-triage` — o mantenedor precisa avaliar
- `needs-info` — aguardando mais informações do relator
- `ready-for-agent` — totalmente especificado, pronto para um agente AFK
- `ready-for-human` — necessita de implementação humana
- `wontfix` — não será executado

Para um PR, os mesmos estados são lidos contra o código anexado: `ready-for-agent` significa que um brief está anexado e um agente deve dar o próximo passo no diff; `ready-for-human` significa que está pronto para um humano fazer o merge.

Toda issue triada deve carregar exatamente um papel de categoria e um papel de estado. Se houver conflito entre papéis de estado, sinalize e pergunte ao mantenedor antes de fazer qualquer outra coisa.

Estes são nomes canônicos de papéis — as strings reais de label usadas no issue tracker podem ser diferentes. O mapeamento deve ter sido fornecido a você - execute `/setup-matt-pocock-skills` se não foi.

Transições de estado: uma issue sem label normalmente vai para `needs-triage` primeiro; de lá ela se move para `needs-info`, `ready-for-agent`, `ready-for-human` ou `wontfix`. `needs-info` retorna para `needs-triage` assim que o relator responder. O mantenedor pode sobrescrever a qualquer momento — sinalize transições que pareçam incomuns e pergunte antes de prosseguir.

## Invocação

O mantenedor invoca `/triage` e descreve o que deseja em linguagem natural. Interprete a solicitação e aja. Exemplos:

- "Show me anything that needs my attention" (Mostre-me qualquer coisa que precise da minha atenção)
- "Let's look at #42" (Vamos analisar a #42 — issue ou PR)
- "Move #42 to ready-for-agent" (Mova a #42 para ready-for-agent)
- "What's ready for agents to pick up?" (O que está pronto para os agentes assumirem?)

## Mostrar o que precisa de atenção

Consulte o issue tracker e apresente três baldes (buckets), do mais antigo para o mais recente:

1. **Sem label** — nunca triado.
2. **`needs-triage`** — avaliação em andamento.
3. **`needs-info` com atividade do relator desde as últimas notas de triagem** — precisa de reavaliação.

Quando PRs estiverem no escopo, inclua PRs externos nesses baldes e marque cada linha como `[PR]` ou `[issue]`. A descoberta expõe apenas PRs *externos* (a configuração do tracker define quem conta como externo) — o PR em andamento de um colaborador não é trabalho de triagem. Esse filtro é apenas para descoberta; um PR nomeado explicitamente é sempre triado, independentemente do autor.

Mostre as contagens e um resumo de uma linha por item. Deixe o mantenedor escolher.

## Triar uma issue ou PR específico

1. **Reúna o contexto.** Leia a issue ou PR completo (corpo, comentários, labels, autor, datas; para um PR, o diff também). Analise quaisquer notas de triagem anteriores para não fazer novamente perguntas já resolvidas. Explore a base de código usando o glossário de domínio do projeto, respeitando os ADRs na área. Execute duas verificações contra a base de código: (a) **redundância** — busque por uma implementação existente do comportamento solicitado pelo conceito de domínio (não apenas pela redação da solicitação), e relate onde você procurou. Se encontrada, é um `wontfix` já implementado (passo 5). (b) **rejeição prévia** — leia `.out-of-scope/*.md` e aponte qualquer um que se assemelhe a esta solicitação.

2. **Recomende.** Diga ao mantenedor sua recomendação de categoria e estado com a justificativa, além de um breve resumo da base de código relevante para a solicitação — incluindo se ela já está implementada. Aguarde instruções.

3. **Verifique a alegação.** Antes de qualquer sabatina, verifique se a alegação se sustenta. Para um bug, reproduza-o a partir dos passos do relator. Para um PR, confirme se o diff faz o que alega — faça o checkout dele, execute os testes ou comandos relevantes. Relate o que aconteceu: confirmado (com o caminho do código), falhou ou detalhes insuficientes (um forte sinal de `needs-info`). Uma verificação confirmada torna o brief do agente muito mais forte.

4. **Sabatinar (se necessário).** Se a solicitação precisar ser detalhada, execute as skills `/grilling` e `/domain-modeling` juntas — molde-a por meio de sabatina, uma rodada de perguntas por vez, refinando termos de domínio e atualizando `CONTEXT.md`/ADRs inline conforme as decisões são tomadas.

5. **Aplique o resultado:**
   - `ready-for-agent` — publique um comentário de brief de agente ([AGENT-BRIEF.md](AGENT-BRIEF.md)).
   - `ready-for-human` — mesma estrutura de um brief de agente, mas anote por que não pode ser delegado (decisões de julgamento, acesso externo, decisões de design, testes manuais).
   - `needs-info` — publique notas de triagem (template abaixo).
   - `wontfix` — feche, com o comentário dependendo do *porquê*:
     - **Já implementado** — a alteração já existe na base de código. Aponte onde ela vive; **não** escreva em `.out-of-scope/` (essa base de conhecimento é para solicitações *rejeitadas*, não construídas).
     - **Rejeitado (bug)** — explicação educada e feche.
     - **Rejeitado (enhancement)** — escreva em `.out-of-scope/`, crie um link para ele a partir de um comentário e feche ([OUT-OF-SCOPE.md](OUT-OF-SCOPE.md)).
   - `needs-triage` — aplique o papel. Comentário opcional se houver progresso parcial.

## Sobrescrita rápida de estado

Se o mantenedor disser "mova #42 para ready-for-agent", confie nele e aplique o papel diretamente. Confirme o que está prestes a fazer (mudanças de papel, comentário, fechamento) e aja. Pule a sabatina. Se estiver movendo para `ready-for-agent` sem uma sessão de sabatina, pergunte se ele deseja escrever um brief de agente.

## Template de needs-info

```markdown
## Notas de Triagem

**O que já estabelecemos até agora:**

- ponto 1
- ponto 2

**O que ainda precisamos de você (@reporter):**

- pergunta 1
- pergunta 2
```

Capture tudo o que foi resolvido durante a sabatina em "o que já estabelecemos até agora" para que o trabalho não seja perdido. As perguntas devem ser específicas e acionáveis, não "por favor, forneça mais informações".

## Retomando uma sessão anterior

Se existirem notas de triagem anteriores na issue ou PR, leia-as, verifique se o relator respondeu a alguma pergunta pendente e apresente um panorama atualizado antes de continuar. Não faça novamente perguntas já resolvidas.
