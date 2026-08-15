# Validação empírica da tradução

Depois de traduzir as 27 skills promovidas (ver `NOTICE` e `.agents/adr/0005-escopo-da-traducao.md`), a etapa final foi verificar que as skills traduzidas continuam funcionando — não só que a prosa está correta, mas que um modelo, lendo *apenas* o `SKILL.md` em português, entende e executa o comportamento pretendido.

## Método

Dois agentes isolados (`agy --new-project`, modelo `gemini-3.7-flash-high`), cada um sem nenhum contexto além do texto do `SKILL.md` traduzido colado no prompt — nenhum acesso a este repositório, para garantir que o teste avalia só o texto da skill, não pistas do ambiente. O `despachar.sh` (usado nos lotes de tradução) não foi reaproveitado aqui: seus perfis (`tradutor`, `programador`, `revisor`) trazem regras fixas para modificar este repositório, incompatíveis com uma simulação de conversa isolada.

- **`grilling/`** — a skill `skills/productivity/grilling` foi colada no prompt de um agente instruído a conduzi-la sobre uma ideia fictícia ("adicionar favoritos a um blog"). O papel de usuário, respondendo cada rodada, foi feito por um segundo agente (Claude, na sessão que conduziu este teste), continuando a mesma conversa via `--conversation <id>` por duas rodadas.
- **`tdd/`** — a skill `skills/engineering/tdd` foi colada no prompt de um agente em modo `accept-edits`, que implementou `calcularTotal(itens)` em duas fatias verticais, num diretório vazio isolado deste repositório.

## Resultado

**`grilling`**: o formato `❓ **Qn** - **título**: ... ➡️ recomendação` foi seguido à risca, em português fluente. A lógica de **fronteira** funcionou de verdade — a rodada 2 só trouxe perguntas desbloqueadas pelas respostas dadas na rodada 1 (schema Prisma porque a resposta citou Next.js + Prisma, opções de Server Actions por ser App Router, referência à rota `/favoritos` aceita antes). Identificadores de código (`readAt`, `isRead`, `Bookmark`, `useOptimistic`, `revalidatePath`) permaneceram em inglês, como esperado.

**`tdd`**: o agente citou a própria regra da skill (traduzida) antes de cada etapa, identificou a costura pública, escreveu o teste antes do código e mostrou a falha real (`Cannot find module`), implementou o mínimo para passar, depois repetiu o ciclo para a segunda fatia — sem sinal de fatiamento horizontal ou acoplamento a detalhes internos. `carrinho.js` e `carrinho.test.js` neste diretório são a saída real, não transcrita.

## Conclusão

As duas skills traduzidas produzem o comportamento pretendido quando consumidas isoladamente por um modelo — a tradução preserva não só o sentido da prosa, mas a capacidade de a skill ser executada corretamente.
