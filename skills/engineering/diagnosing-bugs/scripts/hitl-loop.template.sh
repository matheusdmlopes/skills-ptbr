#!/usr/bin/env bash
# Ciclo de reprodução com humano no circuito (human-in-the-loop).
# Copie este arquivo, edite as etapas abaixo e execute-o.
# O agente executa o script; o usuário segue as instruções no terminal dele.
#
# Uso:
#   bash hitl-loop.template.sh
#
# Dois auxiliares:
#   step "<instrução>"            → exibe instrução, aguarda Enter
#   capture VAR "<pergunta>"      → exibe pergunta, lê resposta em VAR
#
# Ao final, os valores capturados são impressos como CHAVE=VALOR para o agente analisar.
#
# `capture` imprime seu valor de volta no terminal, onde o agente o lê — portanto
# capture observações, e deixe o login para o usuário como um `step`.

set -euo pipefail

step() {
  printf '\n>>> %s\n' "$1"
  read -r -p "    [Enter quando terminar] " _
}

capture() {
  local var="$1" question="$2" answer
  printf '\n>>> %s\n' "$question"
  read -r -p "    > " answer
  printf -v "$var" '%s' "$answer"
}

# --- edite abaixo -------------------------------------------------------

step "Abra o aplicativo em http://localhost:3000 e faça login."

capture ERRORED "Clique no botão 'Export'. Ocorreu um erro? (s/n)"

capture ERROR_MSG "Cole a mensagem de erro (ou 'none'):"

# --- edite acima -------------------------------------------------------

printf '\n--- Capturado ---\n'
printf 'ERRORED=%s\n' "$ERRORED"
printf 'ERROR_MSG=%s\n' "$ERROR_MSG"
