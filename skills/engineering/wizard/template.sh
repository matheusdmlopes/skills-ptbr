#!/usr/bin/env bash
#
# Um wizard — guia um humano passo a passo por um procedimento manual.
# Gerado pela skill /wizard.
#
# Tudo acima do marcador "STAGES" é a biblioteca do wizard: não a edite
# manualmente. Escreva as etapas passo a passo abaixo do marcador.

set -euo pipefail

# ──────────────────────────────────────────────────────────────────────────
# Biblioteca do wizard — experiência de uso elegante e consistente. Idêntica em todo wizard.
# ──────────────────────────────────────────────────────────────────────────

if [[ -t 1 ]] && command -v tput >/dev/null 2>&1 && [[ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]]; then
  BOLD=$(tput bold); DIM=$(tput dim); RESET=$(tput sgr0)
  BLUE=$(tput setaf 4); GREEN=$(tput setaf 2); YELLOW=$(tput setaf 3); RED=$(tput setaf 1)
else
  BOLD=""; DIM=""; RESET=""; BLUE=""; GREEN=""; YELLOW=""; RED=""
fi

# O autor define isto no topo da seção de etapas.
TOTAL_STAGES=0

_STAGE_INDEX=0
ENV_FILE="${ENV_FILE:-.env}"
WRITTEN_ENV=()    # CHAVEs gravadas em ENV_FILE nesta execução
WRITTEN_SECRET=() # NOMEs de secrets definidos nesta execução
SKIPPED=()        # coisas que não pudemos fazer (ex.: gh ausente)

# _clear — limpa o terminal para que apenas o passo atual fique na tela. No-op quando
# a saída não for um terminal, para que logs encadeados permaneçam legíveis.
_clear() {
  [[ -t 1 ]] || return 0
  if command -v tput >/dev/null 2>&1; then tput clear; else printf '\033[2J\033[3J\033[H'; fi
}

# banner "Título" — tela de abertura: o que este wizard faz.
banner() {
  _clear
  printf '\n%s%s  %s%s\n' "$BOLD" "$BLUE" "$1" "$RESET"
  printf '%s  %s etapas%s\n\n' "$DIM" "$TOTAL_STAGES" "$RESET"
  printf '%s  Você navega no browser; este wizard diz exatamente o que fazer e\n' "$DIM"
  printf '  captura os valores que você colar de volta. Pare a qualquer momento com Ctrl-C\n'
  printf '  e execute novamente depois — ele lembra os valores já salvos.%s\n' "$RESET"
  pause "Pronto para começar?"
}

# stage "Nome" — limpa a tela, anuncia a etapa e mostra o progresso.
# Limpar mantém apenas o passo atual na tela.
stage() {
  _clear
  _STAGE_INDEX=$((_STAGE_INDEX + 1))
  printf '\n%s%s▸ Etapa %s/%s · %s%s\n' \
    "$BOLD" "$BLUE" "$_STAGE_INDEX" "$TOTAL_STAGES" "$1" "$RESET"
}

# say "..." — uma linha simples de instrução.
say()  { printf '  %s\n' "$1"; }
# step "..." — uma ação numerada que o humano realiza no navegador.
step() { printf '  %s•%s %s\n' "$BLUE" "$RESET" "$1"; }
note() { printf '  %s%s%s\n' "$DIM" "$1" "$RESET"; }
warn() { printf '  %s⚠ %s%s\n' "$YELLOW" "$1" "$RESET"; }

# open_url URL — abre no navegador do humano, multiplataforma incl. WSL.
open_url() {
  local url="$1"
  printf '  %s↗ abrindo%s %s\n' "$GREEN" "$RESET" "$url"
  { if   command -v wslview     >/dev/null 2>&1; then wslview "$url"
    elif command -v explorer.exe >/dev/null 2>&1; then explorer.exe "$url"
    elif command -v xdg-open    >/dev/null 2>&1; then xdg-open "$url"
    elif command -v open        >/dev/null 2>&1; then open "$url"
    else warn "não foi possível abrir o navegador — acesse manualmente: $url"; fi
  } >/dev/null 2>&1 || warn "não foi possível abrir o navegador — acesse manualmente: $url"
}

# pause "msg" — aguarda o humano confirmar que concluiu a parte manual.
pause() {
  printf '  %s%s%s ' "$DIM" "${1:-Pressione Enter para continuar}" "$RESET"
  read -r _ || true
}

# confirm "pergunta" — trava s/N; retorna sucesso em caso afirmativo.
confirm() {
  local reply=""
  printf '  %s? %s [s/N] ' "$YELLOW" "$1"
  read -r reply || true
  [[ "$reply" =~ ^[SsYy] ]]
}

# _existing KEY — valor atual de KEY em ENV_FILE, se houver.
_existing() {
  [[ -f "$ENV_FILE" ]] || return 1
  local line; line=$(grep -E "^${1}=" "$ENV_FILE" | tail -n1) || return 1
  printf '%s' "${line#*=}"
}

# ask KEY "Prompt" — lê um valor para $KEY. Oferece o valor existente no .env como
# padrão em reexecuções (Enter mantém o atual). Entrada visível (não confidencial).
ask() {
  local key="$1" prompt="$2" current input
  current=$(_existing "$key" || true)
  if [[ -n "$current" ]]; then
    printf '  %s%s%s %s[Enter mantém o atual]%s ' "$BOLD" "$prompt" "$RESET" "$DIM" "$RESET"
  else
    printf '  %s%s%s ' "$BOLD" "$prompt" "$RESET"
  fi
  read -r input || true
  [[ -z "$input" && -n "$current" ]] && input="$current"
  printf -v "$key" '%s' "$input"
}

# ask_secret KEY "Prompt" — como ask, mas a entrada é oculta.
ask_secret() {
  local key="$1" prompt="$2" current input
  current=$(_existing "$key" || true)
  if [[ -n "$current" ]]; then
    printf '  %s%s%s %s[Enter mantém o atual]%s ' "$BOLD" "$prompt" "$RESET" "$DIM" "$RESET"
  else
    printf '  %s%s%s ' "$BOLD" "$prompt" "$RESET"
  fi
  read -rs input || true
  printf '\n'
  [[ -z "$input" && -n "$current" ]] && input="$current"
  printf -v "$key" '%s' "$input"
}

# write_env KEY VALUE — upsert de KEY=VALUE em ENV_FILE (cria o arquivo; substitui
# qualquer linha existente). Idempotente.
write_env() {
  local key="$1" value="$2" tmp
  touch "$ENV_FILE"
  tmp=$(mktemp)
  grep -vE "^${key}=" "$ENV_FILE" > "$tmp" || true
  printf '%s=%s\n' "$key" "$value" >> "$tmp"
  mv "$tmp" "$ENV_FILE"
  WRITTEN_ENV+=("$key")
  printf '  %s✓ gravou%s %s → %s\n' "$GREEN" "$RESET" "$key" "$ENV_FILE"
}

# set_secret NAME VALUE — define um secret do repositório no GitHub Actions via gh.
# Emite um aviso (e registra) se o gh não estiver disponível ou não autenticado.
set_secret() {
  local name="$1" value="$2"
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    if printf '%s' "$value" | gh secret set "$name" >/dev/null 2>&1; then
      WRITTEN_SECRET+=("$name")
      printf '  %s✓ definiu%s GitHub secret %s\n' "$GREEN" "$RESET" "$name"
      return
    fi
  fi
  SKIPPED+=("GitHub secret $name (defina manualmente: gh secret set $name)")
  warn "GitHub secret $name ignorado — gh não está pronto; defina mais tarde"
}

# set_var NAME VALUE — define uma variável do repositório no GitHub Actions (não confidencial).
set_var() {
  local name="$1" value="$2"
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    if gh variable set "$name" --body "$value" >/dev/null 2>&1; then
      printf '  %s✓ definiu%s GitHub variable %s\n' "$GREEN" "$RESET" "$name"
      return
    fi
  fi
  SKIPPED+=("GitHub variable $name")
  warn "GitHub variable $name ignorada — gh não está pronto; defina mais tarde"
}

# finish — limpa a tela e exibe um resumo final de tudo o que foi configurado.
finish() {
  _clear
  printf '\n%s%s  ✓ Configuração concluída%s\n' "$BOLD" "$GREEN" "$RESET"
  (( ${#WRITTEN_ENV[@]} ))    && note "gravou ${#WRITTEN_ENV[@]} valor(es) em $ENV_FILE: ${WRITTEN_ENV[*]}"
  (( ${#WRITTEN_SECRET[@]} )) && note "definiu ${#WRITTEN_SECRET[@]} GitHub secret(s): ${WRITTEN_SECRET[*]}"
  if (( ${#SKIPPED[@]} )); then
    printf '\n'; warn "ainda pendente para fazer manualmente:"
    for s in "${SKIPPED[@]}"; do note "  - $s"; done
  fi
  printf '\n'
}

# ──────────────────────────────────────────────────────────────────────────
# STAGES — escreva esta seção. Um stage() por passo realizado pelo humano.
# Substitua o exemplo abaixo. Ajuste TOTAL_STAGES para corresponder às etapas escritas.
# ──────────────────────────────────────────────────────────────────────────

TOTAL_STAGES=1

banner "Configuração do Stripe"

# ── Etapa de exemplo: substitua pelos seus passos reais ───────────────────
stage "Stripe — Chaves de API"
say "Vamos obter suas chaves de teste do Stripe e armazená-las para dev local + CI."
open_url "https://dashboard.stripe.com/test/apikeys"
step "Na página de chaves de API, copie a chave publicável (Publishable key, começa com pk_test_)."
ask STRIPE_PUBLISHABLE_KEY "Cole a chave publicável:"
step "Clique em 'Reveal test key' na linha da chave secreta (Secret key) e copie-a."
ask_secret STRIPE_SECRET_KEY "Cole a chave secreta:"
write_env STRIPE_PUBLISHABLE_KEY "$STRIPE_PUBLISHABLE_KEY"
write_env STRIPE_SECRET_KEY "$STRIPE_SECRET_KEY"
set_secret STRIPE_SECRET_KEY "$STRIPE_SECRET_KEY"   # O CI precisa desta chave
# ──────────────────────────────────────────────────────────────────────────

finish
