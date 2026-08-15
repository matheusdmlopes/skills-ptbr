---
name: resolving-merge-conflicts
description: "Use quando precisar resolver um conflito em andamento de merge/rebase no git."
---

1. **Veja o estado atual** do merge/rebase. Verifique o histórico do git e os arquivos em conflito.

2. **Encontre as fontes primárias** para cada conflito. Entenda a fundo por que cada alteração foi feita e qual era a intenção original. Leia as mensagens de commit, consulte os PRs, consulte as issues/tickets originais.

3. **Resolva cada trecho (hunk).** Preserve ambas as intenções sempre que possível. Onde forem incompatíveis, escolha aquela que corresponda ao objetivo declarado do merge e registre o trade-off. **Não** invente comportamentos novos. Sempre resolva; nunca use `--abort`.

4. Descubra as **checagens automatizadas** do projeto e execute-as — normalmente checagem de tipos (typecheck), depois testes, depois formatação. Corrija qualquer coisa que o merge tenha quebrado.

5. **Conclua o merge/rebase.** Adicione tudo à staging area e faça o commit. Se estiver em rebase, continue o processo de rebase até que todos os commits tenham sido aplicados.
