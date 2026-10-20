#!/usr/bin/env bash
# Build completo: pacotes, testes, scripts, conferência numérica e lint.
# Uso (Linux/macOS, da raiz ou de qualquer pasta):  bash scripts/build.sh
#      bash scripts/build.sh --rapido   (pula run_all: não reroda os scripts)
set -u
cd "$(dirname "$0")/.."
export LANG=C.UTF-8 LC_ALL=C.UTF-8

etapas=("Pacotes|R/00_setup.R --check" "Testes|tests/testthat.R")
[ "${1:-}" != "--rapido" ] && etapas+=("Scripts (run_all)|scripts/run_all.R")
etapas+=("Conferência numérica|scripts/check_numbers.R" "Lint|scripts/lint_repo.R")

for e in "${etapas[@]}"; do
  nome="${e%%|*}"; cmd="${e#*|}"
  echo; echo "===== $nome"
  if ! Rscript $cmd; then echo "Build FALHOU em: $nome"; exit 1; fi
done
echo; echo "Build OK."
