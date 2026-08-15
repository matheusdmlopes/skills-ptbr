---
name: wizard
description: Gere um assistente interativo em bash que guia um humano pelas etapas que apenas ele pode executar. Use ao provisionar infraestrutura, configurar credenciais ou segredos de CI, navegar por um painel de terceiros desconhecido ou executar uma migração ou transição pontual. Não invoque isto para etapas que o próprio agente pode executar.
---

# Wizard

Um **wizard** é um script em bash que guia um humano, passo a passo, por um procedimento manual cansativo de fazer à mão e cansativo de reexplicar a uma IA toda vez. Ele abre cada URL, diz exatamente o que clicar e copiar, captura os valores, grava-os onde pertencem (`.env`, secrets do GitHub), pede confirmação em cada etapa e mostra quantas etapas restam. Ele pode configurar serviços de terceiros, rodar uma migração pontual ou mudar o projeto de um estado para outro.

A experiência de uso elegante já está resolvida pelo [template.sh](template.sh) — progresso etapa por etapa, travas de confirmação, abertura de URL multiplataforma (incluindo WSL), inserção oculta de segredos, upserts idempotentes em `.env`, gravação via `gh secret`/`gh variable` e um resumo de encerramento. **Seu trabalho é apenas delimitar o escopo do procedimento e escrever suas etapas.** A biblioteca acima do marcador `STAGES` é idêntica em todo wizard; essa consistência é o objetivo — nunca a edite manualmente.

Um wizard é efêmero por padrão — criado para uma única execução, salvo em um diretório temporário (scratch) ou em `scripts/`, e excluído quando o trabalho termina. Faça commit dele apenas quando o usuário desejar um fluxo de configuração repetível que deva residir no repositório.

## Processo

### 1. Delimitar o escopo do procedimento

Mapeie cada passo manual que o humano precisa realizar e cada valor que deve ser capturado ao longo do caminho. Leia o repositório primeiro — não faça perguntas sem contexto:

- Para configuração (setup): `.env`, `.env.example`, `.env.*`, `README`, `docker-compose*`, configurações do framework e `.github/workflows/*` (toda referência a `secrets.*` / `vars.*` é um valor que o wizard precisa produzir).
- Para uma migração ou transição: o estado atual, o estado alvo e as ações irreversíveis entre eles.

Em seguida, mostre ao usuário a lista ordenada de etapas e os valores que cada uma produz, e confirme — ele pode adicionar, remover ou reordenar.

**Concluído quando:** cada etapa estiver nomeada em ordem, e para cada valor capturado você souber (a) de onde o humano o obtém, (b) onde ele é gravado (`.env`, um secret do GitHub, ambos ou em nenhum lugar — algumas etapas são puramente ações) e (c) se é secreto (entrada oculta) ou público.

### 2. Mapear a jornada de cada etapa

Para cada etapa, escreva o caminho exato que o humano segue: qual URL abrir, o que fazer lá, onde o valor é exibido, qual variável ele preenche — ex.: "Dashboard → Desenvolvedores → Chaves de API → Revelar chave de teste → copiar". Quando você não souber a interface atual real ou o comando exato, diga isso e pergunte ao usuário ou consulte a documentação — nunca invente passos que possam não existir.

**Concluído quando:** cada etapa puder ser rastreada até instruções concretas que qualquer pessoa conseguiria seguir.

### 3. Escrever o wizard

Copie `template.sh` para o caminho de destino. Substitua a etapa de exemplo por um `stage` por passo, em ordem de dependência. Use os auxiliares da biblioteca — `stage`, `say`/`step`, `open_url`, `ask`/`ask_secret`, `write_env`, `set_secret`/`set_var`, `pause`/`confirm` — e defina `TOTAL_STAGES` com o número de etapas escritas.

Mantenha o padrão de qualidade definido pelo modelo: abra a URL antes de pedir o valor, use `ask_secret` para qualquer dado confidencial, use `write_env` em todo valor persistido, use `set_secret` apenas nos valores de que o CI realmente precisa e use `confirm` antes de qualquer ação irreversível. Cada `stage` limpa a tela para que apenas o passo atual fique visível — mantenha cada etapa restrita a uma tarefa focada para que nada do que o humano precisa saia da tela por rolagem. Não mexa na biblioteca acima do marcador.

### 4. Verificar e entregar

- `bash -n <script>`; execute `shellcheck` se disponível.
- `chmod +x <script>`.
- Não o execute de ponta a ponta você mesmo — ele abre navegadores e aguarda entradas humanas. Em vez disso, faça o rastreamento estático: certifique-se de que cada valor do passo 1 é capturado e gravado onde o passo 1 definiu, e que cada nome de `set_secret` corresponde exatamente a uma referência `secrets.*` no CI.
- Diga ao usuário como executá-lo. Se for um caminho de configuração repetível, faça o commit e crie um link no README para que a próxima pessoa execute o script em vez de perguntar a uma IA.
