---
name: claude-handoff
description: Transfira a conversa atual para um novo agente em segundo plano que assume o trabalho imediatamente.
argument-hint: "Para que a próxima sessão será usada?"
disable-model-invocation: true
---

Escreva um resumo de handoff da conversa atual para que um novo agente possa continuar o trabalho. Em vez de salvá-lo, inicie um agente em segundo plano alimentado com o resumo como seu prompt: `claude --bg --name "<descriptive name>" "<handoff summary>"`. Ele inicia no diretório de trabalho atual e retorna imediatamente; o usuário o gerencia com `claude agents`.

Sempre passe `-n`/`--name` com um nome descritivo (ex.: `--name "Fix login bug"`) — isso define o nome de exibição mostrado na lista de tarefas (job list), no seletor de sessões e no título do terminal.

Inclua uma seção "suggested skills" no resumo, sugerindo skills que o agente deve invocar.

Não duplique conteúdo já registrado em outros artefatos (specs, planos, ADRs, issues, commits, diffs). Em vez disso, faça referência a eles por caminho de arquivo ou URL.

Oculte (redact) qualquer informação confidencial, como chaves de API, senhas ou informações de identificação pessoal — o resumo se tornará o prompt do agente.

Se o usuário passou argumentos, trate-os como uma descrição do foco da próxima sessão e adapte o resumo de acordo.
