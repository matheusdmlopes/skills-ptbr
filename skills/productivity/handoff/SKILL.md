---
name: handoff
description: Compacte a conversa atual em um documento de handoff para outro agente assumir.
argument-hint: "Para que a próxima sessão será usada?"
disable-model-invocation: true
---

Escreva um documento de handoff resumindo a conversa atual para que um novo agente possa continuar o trabalho. Salve no diretório temporário do sistema operacional do usuário - não no workspace atual.

Inclua uma seção "suggested skills" no documento, sugerindo skills que o agente deve invocar.

Não duplique conteúdo já registrado em outros artefatos (specs, planos, ADRs, issues, commits, diffs). Em vez disso, faça referência a eles por caminho de arquivo ou URL.

Oculte (redact) qualquer informação confidencial, como chaves de API, senhas ou informações de identificação pessoal.

Se o usuário passou argumentos, trate-os como uma descrição do foco da próxima sessão e adapte o documento de acordo.
