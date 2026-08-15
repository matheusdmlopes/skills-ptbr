# Rastrear o upstream por histórico importado, não por fork do GitHub

O repositório importou o histórico completo de `mattpocock/skills` (`git reset --hard upstream/main` sobre uma branch sem commits) e mantém o original como remote `upstream`, sem ser um fork do GitHub.

O que faz a tradução sobreviver ao tempo não é o fork, é o **ancestral comum**: com ele, `git merge upstream/main` faz os conflitos caírem exatamente nas linhas em inglês que mudaram, lado a lado com a tradução correspondente. Sem histórico compartilhado, cada sincronização vira um diff manual entre duas árvores sem relação.

O fork do GitHub acrescentaria apenas o selo de proveniência e a possibilidade de abrir PR para o original, nada tecnicamente necessário, e traria um atrito concreto: um fork de `mattpocock/skills` nasce chamado `skills`, colidindo com o repositório que já existia na conta. A proveniência é declarada no `README` e no `NOTICE`, que cumprem a exigência de atribuição da MIT melhor do que um selo.

## Consequência: nenhum metadado de versão por arquivo

Não há cabeçalho de SHA nem `SYNC.md` mapeando skill para o commit traduzido. O conflito de merge já é o rastreador, e é preciso por linha; um SHA por arquivo é metadado que depende de disciplina humana e passa a mentir na primeira vez que alguém esquece de atualizar. Se a primeira sincronização real mostrar que isso não basta, a decisão se revisita.
