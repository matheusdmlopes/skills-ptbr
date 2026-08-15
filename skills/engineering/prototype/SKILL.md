---
name: prototype
description: Construa um protótipo descartável para responder a uma dúvida de design. Use quando o usuário quiser verificar se um modelo de estado ou lógica faz sentido, ou explorar como uma interface deve parecer.
---

# Protótipo

Um protótipo é **código descartável que responde a uma dúvida**. A dúvida decide o formato.

## Escolha um caminho

Identifique qual dúvida está sendo respondida — a partir do prompt do usuário, do código ao redor ou perguntando se o usuário estiver por perto:

- **"Essa lógica / modelo de estado faz sentido?"** → [LOGIC.md](LOGIC.md). Construa um único arquivo HTML compartilhável — botões de uso livre mais tutoriais guiados em abas — que conduza a máquina de estados por casos difíceis de avaliar no papel e que uma pessoa não desenvolvedora possa operar.
- **"Como isso deve parecer?"** → [UI.md](UI.md). Gere várias variações visuais radicalmente diferentes em uma única rota, alternáveis via parâmetro de busca na URL (search param) e uma barra inferior flutuante.

Os dois caminhos produzem artefatos muito diferentes — errar nisso desperdiça o protótipo inteiro. Se a dúvida for genuinamente ambígua e o usuário não estiver acessível, adote por padrão o caminho que melhor corresponder ao código ao redor (um módulo de backend → lógica; uma página ou componente → interface) e declare essa premissa no topo do protótipo.

## Regras que se aplicam a ambos

1. **Descartável desde o primeiro dia, e claramente demarcado como tal.** Posicione o código do protótipo próximo de onde ele realmente será usado (ao lado do módulo ou da página para a qual está sendo prototipado) para que o contexto fique óbvio — mas nomeie-o de modo que um leitor casual veja que é um protótipo, não código de produção. Para rotas de interface descartáveis, siga a convenção de rotas que o projeto já utiliza; não invente uma nova estrutura no nível raiz.
2. **Trivial de executar.** Um protótipo de interface inicia a partir de um único comando no executor de tarefas do projeto — `pnpm <nome>`, `python <caminho>`, `bun <caminho>`, etc. Uma demonstração de lógica é um único arquivo HTML no qual o usuário clica duas vezes. De qualquer forma, não deve exigir esforço mental para iniciar.
3. **Sem persistência por padrão.** O estado vive na memória. A persistência é aquilo que o protótipo está _testando_, não algo de que ele deva depender. Se a dúvida envolver explicitamente um banco de dados, utilize um banco temporário ou um arquivo local com um nome claro como "PROTOTYPE — wipe me".
4. **Ignore o polimento.** Sem testes, sem tratamento de erros além do estritamente necessário para tornar o protótipo _executável_, sem abstrações. O objetivo é aprender algo rápido.
5. **Exponha o estado.** Após cada ação (lógica) ou a cada troca de variante (interface), imprima ou renderize todo o estado relevante para que o usuário possa ver o que mudou.
6. **Capture ao terminar.** Incorpore qualquer decisão validada ao código real, depois capture o próprio protótipo como uma **fonte primária**: faça commit dele em uma branch descartável, fora da main, e deixe um ponteiro de contexto para essa branch na issue de implementação. Capture também a resposta — o veredito e a dúvida que ele resolveu — na issue ou em um commit. A branch main mantém apenas a decisão validada.
