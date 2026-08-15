---
name: diagnosing-bugs
description: Ciclo de diagnóstico para bugs difíceis e regressões de desempenho. Use quando o usuário disser "diagnostique"/"debugue isso", ou relatar algo quebrado/lançando erro/falhando/lento.
---

# Diagnóstico de Bugs

Uma disciplina para bugs difíceis. Pule fases apenas quando explicitamente justificado.

Ao explorar a base de código, leia `CONTEXT.md` (se existir) para obter um modelo mental claro dos módulos relevantes e consulte os ADRs na área em que você estiver mexendo.

## Ocultação de dados sensíveis (Redact)

Esta skill faz você exibir comandos, saídas e artefatos capturados. **Oculte todos os segredos primeiro** — escreva `<REDACTED>` no lugar deles. Construa loops usando variáveis de ambiente, para que a credencial permaneça no ambiente em vez de aparecer no que você exibe. Artefatos capturados carregam cabeçalhos de autenticação: cite apenas as linhas que carregam o sinal relevante.

Se a saída ocultada não for suficiente para diagnosticar o bug, diga isso e pergunte ao usuário.

## Fase 1 — Construa um ciclo de feedback

**Esta é a essência da skill.** Todo o resto é mecânico. Se você tiver um sinal de passa/falha **apertado** para o bug — um que fique vermelho _neste_ bug específico — você encontrará a causa; bissecção, teste de hipóteses e instrumentação apenas o consomem. Se você não tiver um, nenhuma quantidade de tempo encarando o código salvará você.

Dedique um esforço desproporcional aqui. **Seja agressivo. Seja criativo. Recuse-se a desistir.**

### Maneiras de construir um — tente-as mais ou menos nesta ordem

1. **Teste que falha** em qualquer costura que alcance o bug — unitário, integração, e2e.
2. **Script curl / HTTP** contra um servidor de desenvolvimento em execução.
3. **Invocação via CLI** com uma entrada de fixture, comparando o diff da saída padrão (stdout) contra um snapshot sabidamente correto.
4. **Script de navegador headless** (Playwright / Puppeteer) — controla a interface, faz asserções no DOM/console/rede.
5. **Reproduzir um rastreamento capturado.** Salve uma requisição de rede / payload / log de eventos real no disco; reproduza-o pelo caminho do código de forma isolada.
6. **Harness descartável.** Suba um subconjunto mínimo do sistema (um serviço, dependências mockadas) que execute o caminho do código com o bug por meio de uma única chamada de função.
7. **Loop de propriedades / fuzzing.** Se o bug for "às vezes produz saída incorreta", execute 1000 entradas aleatórias e procure pelo modo de falha.
8. **Harness de bissecção.** Se o bug apareceu entre dois estados conhecidos (commit, conjunto de dados, versão), automatize "iniciar no estado X, checar, repetir" para que você possa rodar `git bisect run`.
9. **Loop diferencial.** Passe a mesma entrada pela versão antiga vs versão nova (ou duas configurações) e compare o diff das saídas.
10. **Script bash HITL (humano no circuito).** Último recurso. Se um humano precisar clicar, conduza-_o_ com `scripts/hitl-loop.template.sh` para que o ciclo ainda seja estruturado. A saída capturada alimenta você de volta.

Construa o ciclo de feedback certo e o bug estará 90% resolvido.

### Aperte o ciclo

Trate o ciclo como um produto. Assim que tiver _um_ ciclo, **aperte-o**:

- Posso torná-lo mais rápido? (Setup em cache, pular inicializações não relacionadas, restringir o escopo do teste.)
- Posso tornar o sinal mais nítido? (Fazer asserção no sintoma específico, não em "não travou".)
- Posso torná-lo mais determinístico? (Fixar o tempo, definir semente de RNG, isolar o sistema de arquivos, congelar a rede.)

Um ciclo instável de 30 segundos é quase tão ruim quanto nenhum ciclo; um determinístico de 2 segundos é apertado — um superpoder de depuração.

### Bugs não determinísticos

O objetivo não é uma reprodução limpa, mas uma **taxa de reprodução mais alta**. Repita o gatilho 100× em loop, paralelize, adicione estresse, reduza janelas de temporização, injete pausas (sleeps). Um bug instável que ocorre em 50% das vezes é depurável; 1% não é — continue aumentando a taxa até que ele seja depurável.

### Quando você genuinamente não conseguir construir um ciclo

Pare e diga isso explicitamente. Liste o que você tentou. Peça ao usuário: (a) acesso a qualquer ambiente que reproduza o problema, (b) um artefato capturado e com dados sensíveis ocultados (arquivo HAR, dump de log, core dump, gravação de tela com marcações de tempo) ou (c) permissão para adicionar instrumentação temporária de produção. **Não** avance para criar hipóteses sem um ciclo.

### Critério de conclusão — um ciclo apertado que fica vermelho

A Fase 1 está concluída quando o ciclo for **apertado** e **capaz de ficar vermelho**: você pode nomear **um único comando** — o caminho de um script, uma invocação de teste, um curl — que você **já executou pelo menos uma vez** (mostre a invocação e a saída dela, com dados sensíveis ocultados) e que seja:

- [ ] **Capaz de ficar vermelho** — ele executa o caminho de código real do bug e faz asserções sobre o **sintoma exato do usuário**, podendo ficar vermelho neste bug e verde assim que corrigido. Não apenas "executa sem dar erro" — ele precisa ser capaz de _capturar este bug específico_.
- [ ] **Determinístico** — mesmo veredito a cada execução (bugs instáveis: uma taxa alta e fixada de reprodução, conforme acima).
- [ ] **Rápido** — segundos, não minutos.
- [ ] **Executável por agente** — você pode executá-lo sem supervisão; humano no circuito apenas via `scripts/hitl-loop.template.sh`.

Se você se pegar lendo código para criar uma teoria antes que esse comando exista, **pare — pular direto para uma hipótese é a falha exata que esta skill previne.** Sem um comando capaz de ficar vermelho, sem Fase 2.

## Fase 2 — Reproduzir + minimizar

Execute o ciclo. Veja-o ficar vermelho — o bug aparece.

Confirme:

- [ ] O ciclo produz o modo de falha descrito pelo **usuário** — não uma falha diferente que por acaso esteja por perto. Bug errado = correção errada.
- [ ] A falha é reproduzível ao longo de várias execuções (ou, para bugs não determinísticos, reproduzível em uma taxa alta o suficiente para se depurar contra ela).
- [ ] Você capturou o sintoma exato (mensagem de erro, saída incorreta, tempo lento) para que as fases posteriores possam verificar se a correção realmente o soluciona.

### Minimizar

Assim que estiver vermelho, reduza a reprodução ao **menor cenário que ainda fica vermelho**. Corte entradas, chamadores, configuração, dados e etapas **um de cada vez**, reexecutando o ciclo após cada corte — mantenha apenas o que for indispensável para a falha.

Por que se dar ao trabalho: uma reprodução mínima reduz o espaço de hipóteses na Fase 3 (menos partes móveis sob suspeita) e se torna o teste de regressão limpo na Fase 5.

Concluído quando **cada elemento restante for indispensável** — remover qualquer um deles faz o ciclo ficar verde.

Não avance até ter reproduzido **e** minimizado.

## Fase 3 — Hipotetizar

Gere **3–5 hipóteses ranqueadas** antes de testar qualquer uma delas. Gerar uma única hipótese ancora a mente na primeira ideia plausível.

Cada hipótese deve ser **falseável**: declare a previsão que ela faz.

> Formato: "Se <X> for a causa, então <alterar Y> fará o bug desaparecer / <alterar Z> fará o bug piorar."

Se você não conseguir declarar a previsão, a hipótese é puro palpite — descarte-a ou refine-a.

**Mostre a lista ranqueada ao usuário antes de testar.** Muitas vezes ele possui conhecimento de domínio que reordena o ranking instantaneamente ("acabamos de publicar uma alteração no item 3"), ou conhece hipóteses que já descartou. Um ponto de verificação barato que economiza muito tempo. Não fique bloqueado nisso — prossiga com seu ranking se o usuário estiver ausente.

## Fase 4 — Instrumentar

Cada sonda deve mapear para uma previsão específica da Fase 3. **Altere uma variável por vez.**

Preferência de ferramentas:

1. **Depurador / inspeção no REPL** se o ambiente suportar. Um único breakpoint supera dez logs.
2. **Logs direcionados** nas divisas que diferenciam as hipóteses.
3. Nunca "logar tudo e dar grep".

**Marque cada log de depuração** com um prefixo exclusivo, por exemplo, `[DEBUG-a4f2]`. A limpeza ao final se torna um único `grep`. Logs não marcados sobrevivem; logs marcados morrem.

**Branch de desempenho.** Para regressões de desempenho, logs costumam ser enganosos. Em vez disso: estabeleça uma medição de linha de base (harness de temporização, `performance.now()`, profiler, plano de execução de consulta), depois faça a bissecção. Meça primeiro, corrija depois.

## Fase 5 — Corrigir + teste de regressão

Escreva o teste de regressão **antes da correção** — mas apenas se houver uma **costura correta** para ele.

Uma costura correta é aquela em que o teste exercita o **padrão real do bug** tal como ele ocorre no local de chamada. Se a única costura disponível for rasa demais (teste de um único chamador quando o bug precisa de múltiplos chamadores, teste unitário incapaz de reproduzir a cadeia que disparou o bug), um teste de regressão ali dará falsa confiança.

**Se não existir nenhuma costura correta, isso por si só já é o achado.** Anote. A arquitetura da base de código está impedindo que o bug seja blindado. Sinalize isso para a próxima fase.

Se existir uma costura correta:

1. Transforme a reprodução minimizada em um teste que falhe nessa costura.
2. Veja-o falhar.
3. Aplique a correção.
4. Veja-o passar.
5. Reexecute o ciclo de feedback da Fase 1 contra o cenário original (não minimizado).

## Fase 6 — Limpeza + post-mortem

Obrigatório antes de declarar como concluído:

- [ ] A reprodução original não se reproduz mais (reexecute o ciclo da Fase 1)
- [ ] O teste de regressão passa (ou a ausência de costura foi documentada)
- [ ] Toda a instrumentação `[DEBUG-...]` foi removida (`grep` pelo prefixo)
- [ ] Protótipos descartáveis foram excluídos (ou movidos para um local de depuração claramente demarcado)
- [ ] A hipótese que se provou correta foi declarada na mensagem do commit / PR — para que o próximo desenvolvedor aprenda

**Depois pergunte: o que teria evitado esse bug?** Se a resposta envolver mudança arquitetural (nenhuma boa costura de teste, chamadores emaranhados, acoplamento oculto), passe o bastão para a skill `/improve-codebase-architecture` com os detalhes específicos. Faça a recomendação **depois** que a correção estiver aplicada, não antes — agora você tem mais informações do que quando começou.
