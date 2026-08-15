# Formato de Registro de Aprendizado (Learning Record)

Os registros de aprendizado residem em `./learning-records/` e usam numeração sequencial: `0001-slug.md`, `0002-slug.md`, etc. Crie o diretório sob demanda (lazily) — apenas quando o primeiro registro for escrito.

Eles são o equivalente aos ADRs no ensino: capturam lições não óbvias, percepções-chave e conhecimentos prévios declarados que guiarão sessões futuras. São usados para calcular a zona de desenvolvimento proximal.

## Modelo (Template)

```md
# {Título curto do que foi aprendido ou estabelecido}

{1 a 3 frases: o que foi aprendido (ou qual conhecimento prévio foi estabelecido) e por que isso importa para sessões futuras.}
```

Esse é o formato completo. Um registro de aprendizado pode ser um único parágrafo. O valor está em registrar _que_ isso agora é conhecido e o _porquê_ de isso mudar o que ensinar a seguir — não em preencher seções.

## Seções opcionais

Inclua-as apenas quando agregarem valor genuíno. A maioria dos registros não precisará delas.

- Frontmatter de **Status** (`active | superseded by LR-NNNN`) — útil quando um entendimento anterior se mostra incorreto e é substituído.
- **Evidência** (Evidence) — como o usuário demonstrou o entendimento (uma pergunta respondida, um exercício concluído, experiência prévia citada). Útil quando a alegação puder ser revisitada.
- **Implicações** (Implications) — o que isso desbloqueia ou descarta para sessões futuras. Vale a pena registrar quando não for óbvio.

## Numeração

Varra `./learning-records/` em busca do maior número existente e incremente em um.

## Quando escrever um registro de aprendizado

Escreva um quando qualquer uma destas condições for verdadeira:

1. **O usuário demonstrou entendimento genuíno de algo não trivial** — não apenas contato, mas evidência de que consegue usar o conceito corretamente. Isso estabelece um novo patamar para o que ensinar a seguir.
2. **O usuário declarou conhecimento prévio** — "Eu já sei X." Registre isso para que sessões futuras não o ensinem novamente. Registre também a _profundidade_ alegada.
3. **Um equívoco foi corrigido** — o usuário acreditava anteriormente em algo incorreto e agora compreende o motivo. Estes são de alto valor: predizem futuros obstáculos em tópicos correlatos.
4. **A missão mudou em resposta ao aprendizado** — o usuário descobriu que se importava com algo diferente do que pensava. Faça link cruzado com [[MISSION.md]] e atualize-o.

### O que _não_ se qualifica

- Material que foi meramente abordado. Abordagem não é aprendizado. Aguarde por evidências.
- Qualquer coisa já registrada de forma concisa em [[GLOSSARY.md]] como definição de termo. Não duplique.
- Logs de atividades sessão a sessão. Registros de aprendizado não são um diário — são percepções de nível de decisão.

## Substituição (Supersession)

Quando um registro posterior contradisser um anterior (o entendimento do usuário se aprofundou ou foi corrigido), marque o registro antigo como `Status: superseded by LR-NNNN` em vez de excluí-lo. O histórico de como o entendimento evoluiu é, por si só, um sinal útil.
