# Spec: comunicar o escopo da tradução no ponto de instalação

## Problem Statement

Quem instala esta tradução roda `npx skills@latest add matheusdmlopes/skills-ptbr` e recebe uma lista de 35 skills para escolher. Os rótulos dessa lista são os nomes originais — `tdd`, `setup-pre-commit`, `writing-shape` — porque **Termo invariante** (ADR 0003) mantém nome de skill em inglês de propósito. Nada na lista diz que apenas 27 das 35 estão em pt-BR.

O resultado é que a pessoa marca `setup-pre-commit` ou `writing-shape` esperando português e leva inglês, sem aviso em nenhum momento do fluxo.

Os documentos que deveriam avisar têm duas falhas:

1. **A enumeração está incompleta.** `README.md` e `NOTICE` dizem que o que permanece em inglês são as skills de `misc/` e `deprecated/` e a documentação em `docs/`. Nenhum dos dois cita `skills/in-progress/`, onde ficam 4 das 8 skills não traduzidas (`setup-ts-deep-modules`, `writing-beats`, `writing-fragments`, `writing-shape`). Um leitor que confie na enumeração conclui que `in-progress/` inteiro está em pt-BR, quando só 2 das 6 estão.
2. **O aviso não está onde a decisão acontece.** A frase sobre escopo vive num parágrafo antes do comando; a escolha real acontece dentro do instalador, num menu que este repositório não controla.

A única descrição precisa do escopo é a ADR 0005, que o instalador não lê e o usuário final não abre.

## Solution

O escopo parcial da tradução é uma decisão deliberada e permanente (ADR 0005), não uma pendência. Então o trabalho não é traduzir mais nada: é fazer o repositório declarar esse escopo com precisão, e no lugar onde a pessoa está prestes a escolher.

Três movimentos, nenhum deles tocando um `SKILL.md`:

- **Corrigir a enumeração** em `README.md` e `NOTICE` para incluir `in-progress/` como bucket parcialmente traduzido, com a regra que o descreve — não uma lista de nomes.
- **Levar o aviso para junto do comando**, no bloco de instalação, explicando como a pessoa distingue as duas famílias dentro do próprio menu do instalador: a `description` de cada item aparece na lista, e ela está em pt-BR exatamente nas skills traduzidas.
- **Manter uma fonte única.** `.agents/install-block.md` já se declara a origem canônica do texto de instalação ("Change it here first, then propagate"). O texto novo nasce lá e desce para `README.md` e `NOTICE`.

A `description` funcionar como marcador de idioma não é acidente feliz que precisamos criar: é consequência de traduzir a prosa e preservar o nome. A spec só torna esse sinal explícito para quem lê.

## User Stories

1. Como pessoa instalando pela primeira vez, quero saber quantas das skills oferecidas estão em pt-BR, para não supor que o repositório inteiro foi traduzido.
2. Como pessoa instalando, quero saber como distinguir uma skill traduzida de uma não traduzida dentro do próprio menu, para escolher com informação no momento da escolha.
3. Como pessoa instalando, quero que o aviso esteja perto do comando que vou copiar, para não depender de ter lido um parágrafo anterior.
4. Como pessoa instalando, quero que a enumeração dos buckets não traduzidos seja completa, para não ser surpreendida por um bucket omitido.
5. Como pessoa que leu o `README`, quero que `in-progress/` apareça descrito como parcialmente traduzido, para entender por que `claude-handoff` está em português e `writing-shape` não.
6. Como pessoa avaliando se adoto esta tradução, quero encontrar a proporção traduzida sem abrir uma ADR, para decidir rápido.
7. Como pessoa que instalou e encontrou uma skill em inglês, quero reconhecer que isso é esperado e documentado, para não abrir uma issue de bug.
8. Como pessoa que já usa as skills originais, quero continuar sabendo que os nomes colidem de propósito, para escolher conscientemente qual origem instalar.
9. Como mantenedor, quero que a correção não toque nenhum `SKILL.md`, para não criar conflito adicional em cada **Sync**.
10. Como mantenedor, quero que a enumeração seja escrita como regra e não como lista de nomes, para que ela sobreviva quando o **Upstream** adicionar ou remover uma skill em `misc/` ou `in-progress/`.
11. Como mantenedor, quero que o texto de instalação continue tendo uma origem única, para que `README` e `NOTICE` não divirjam com o tempo.
12. Como mantenedor, quero que a mudança não toque `.claude-plugin/`, para preservar a política de mantê-lo idêntico ao **Upstream**.
13. Como mantenedor, quero que a ADR 0005 continue sendo a autoridade sobre o escopo, com os demais documentos derivando dela, para não criar uma segunda fonte de verdade.
14. Como mantenedor, quero uma forma de verificar que a enumeração declarada bate com o conteúdo real do repositório, para detectar divergência antes de publicar.
15. Como mantenedor, quero que a verificação seja um comando reproduzível, para reexecutá-la depois de cada **Sync**.
16. Como mantenedor, quero que o `NOTICE` permaneça juridicamente preciso sobre o que é obra derivada e o que é herdado sem alteração, para não enfraquecer a atribuição.
17. Como agente lendo este repositório, quero que a `description` de cada skill permaneça tradução fiel do **Upstream**, para que o roteamento por description não mude de comportamento.
18. Como pessoa que instala uma skill isolada com `--skill=<nome>`, quero saber o idioma daquele nome específico, para não precisar rodar o menu inteiro.
19. Como pessoa trocando de idioma, quero continuar encontrando as duas linhas de comando lado a lado, para reinstalar da outra origem sem procurar.
20. Como leitor do `README` do bucket `in-progress/`, quero entender que duas daquelas skills estão traduzidas e as outras não, para não me confundir ao abrir os arquivos.
21. Como pessoa que contribui com uma tradução nova, quero saber qual documento atualizar quando uma skill mudar de idioma, para não deixar a enumeração velha.
22. Como mantenedor, quero que a próxima skill promovida pelo **Upstream** entre no escopo sem exigir reescrita do texto de instalação, para que a regra escale.

## Implementation Decisions

**Nenhum `SKILL.md` é modificado.** Esta é a decisão central, tomada nesta sessão entre três costuras possíveis. Prefixar `(pt-BR)` na `description` das 27 traduzidas funcionaria no instalador, mas faria 27 arquivos divergirem do **Upstream** num campo hoje traduzido com fidelidade, transformando cada um em conflito recorrente a cada **Sync** — e a `description` é o texto que o modelo lê em runtime para decidir invocação. Prefixar `(EN)` nas 8 restantes tocaria menos arquivos, mas contradiria o `NOTICE`, que declara publicamente que as skills de `misc/` permanecem "no inglês original, sem alteração".

**O campo `name` está fora de discussão, e agora com evidência.** ADR 0003 já rejeitou sufixar nomes. A inspeção do CLI `skills` (vercel-labs, v1.5.22) confirma que não haveria como fazê-lo apenas visualmente: `getSkillDisplayName(skill)` devolve `skill.name || basename(skill.path)`, e o mesmo valor alimenta `sanitizeName(...)` para nomear o diretório instalado — que converte para minúsculas e troca todo caractere fora de `[a-z0-9._]` por hífen. Um `name: tdd (pt-BR)` instalaria a skill como `tdd-pt-br`. Rótulo e identificador são o mesmo campo; não existe campo de exibição separado.

**A enumeração vira regra, não lista.** O texto passa a descrever *o critério* — estão em pt-BR as **Skills promovidas** de `.claude-plugin/plugin.json`, mais `claude-handoff` e `loop-me`; o restante de `in-progress/`, todo o `misc/`, o `deprecated/` e `docs/` permanecem em inglês. Uma lista de nomes envelheceria no primeiro **Sync** que mexesse nesses buckets.

**Os módulos tocados são três documentos, com dependência declarada:**

- `.agents/install-block.md` — origem canônica. Recebe primeiro a frase de escopo e a orientação de leitura da lista do instalador.
- `README.md` — consome o bloco verbatim, conforme `CLAUDE.md`. A frase de escopo hoje na seção "Instalação" é corrigida e reposicionada junto ao comando.
- `NOTICE` — a seção "O que não foi traduzido" passa a incluir `in-progress/` como parcial.

**A ADR 0005 não é reaberta.** Ela permanece a autoridade sobre o escopo; os três documentos derivam dela. Se a proporção mudar no futuro, muda-se a ADR e propaga-se — a ordem não inverte.

**`.claude-plugin/` continua intocado.** O CLI agrupa a lista por plugin quando encontra um manifest, o que hoje já separa visualmente as 25 promovidas das demais 10 sob um grupo "Other". Ajustar esse agrupamento exigiria editar `.claude-plugin/`, vedado pela política do repositório.

**A orientação de leitura da lista é factual e verificável:** dentro do menu, cada item exibe sua `description`; as traduzidas exibem prosa em português e as demais, em inglês.

## Testing Decisions

Este repositório não tem suíte automatizada para prosa, e a mudança é textual — então "teste" aqui significa verificação executável de consistência, não asserção sobre implementação interna. O que se testa é comportamento observável do repositório: o que os documentos afirmam versus o que o conteúdo é.

**A costura escolhida é única e de alto nível:** um comando que deriva a verdade do próprio repositório (quais skills existem por bucket, e quais estão em pt-BR) e a confronta com a regra declarada nos três documentos. Um só ponto de verificação, reexecutável após cada **Sync** — em vez de conferência manual espalhada por arquivo.

O que deve ser verificado:

- A regra declarada bate com o conteúdo: as **Skills promovidas** de `plugin.json` mais `claude-handoff` e `loop-me` estão em pt-BR, e nenhuma outra está.
- `README.md` e `NOTICE` concordam entre si e com `.agents/install-block.md` no texto de instalação, como `CLAUDE.md` já exige (bloco copiado verbatim).
- Nenhum arquivo sob `skills/` foi modificado pelo trabalho — verificável por diff, e é o critério que separa esta spec das alternativas rejeitadas.
- `claude plugin validate . --strict` continua passando. Os manifests não são tocados, então a verificação é barata e serve de rede.

**Prior art:** `.agents/validation/` guarda a evidência empírica das traduções (transcrições de `tdd` e `grilling` exercitadas de verdade), e é o precedente de "verificação registrada como artefato" neste repositório. A conferência de escopo segue o mesmo espírito: um artefato reproduzível, não uma afirmação.

## Out of Scope

- **Traduzir as 8 skills restantes.** ADR 0005 as deixa de fora com motivo declarado: `misc/` é ferramental interno do curso do autor, e as quatro de `in-progress/` são beta que pode mudar ou desaparecer. Reverter isso é decisão de ADR, não de spec.
- **Marcadores `(pt-BR)` ou `(EN)` em qualquer `description`.** Avaliado e rejeitado nesta sessão pelo custo de **Sync** e pela contradição com o `NOTICE`.
- **Sufixar nomes de skill.** Já rejeitado pela ADR 0003.
- **Alterar `.claude-plugin/`** para influenciar o agrupamento da lista.
- **Traduzir `docs/`** (ADR 0005) e os `README.md` dos buckets, que ficaram fora do escopo original — a ADR cobre "as 27 skills e o `README.md` da raiz".
- **Propor mudanças ao CLI `skills`** (vercel-labs) para suportar um campo de exibição separado do identificador. Seria a correção de fundo, mas é repositório de terceiros e não bloqueia este trabalho.
- **Qualquer alteração no fluxo de instalação local do mantenedor** (`scripts/link-skills.sh`, symlinks em `~/.claude/skills`).

## Further Notes

Detalhes apurados no CLI `skills` v1.5.22 que sustentam as decisões acima, todos verificados no bundle publicado:

- A descoberta varre `skills/` até três níveis de profundidade, o que cobre o layout `skills/<bucket>/<nome>/SKILL.md` deste repositório — daí as 35 ofertas, e não as 25 do `plugin.json`.
- A instalação remove apenas o caminho exato da skill que está sendo escrita (`rm(flatSkillPath, …)` seguido de `writeFile`), nunca varrendo o diretório de destino. Skills instaladas que não pertencem à origem não são afetadas.
- O escopo padrão do instalador é o projeto local, não o global; há prompt de escolha, e `-g` força global.
- O grupo "Other" já aparece hoje na lista para as 10 skills fora do `plugin.json`, o que dá uma separação visual parcial de graça. O corte é "promovida vs. não promovida", que não coincide exatamente com "pt-BR vs. inglês": `claude-handoff` e `loop-me` são traduzidas e caem em "Other".

Observação de manutenção: a imprecisão corrigida aqui — `in-progress/` ausente da enumeração — provavelmente surgiu porque a ADR 0005 descreve as duas betas como exceções *incluídas*, e os documentos derivados registraram a inclusão sem registrar o complemento. Vale como sinal: quando o escopo tem exceção, o texto derivado precisa declarar os dois lados dela.
