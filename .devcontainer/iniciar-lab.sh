#!/usr/bin/env bash
# Executado a cada início do Codespace: sobe os contêineres mysql-writer e mysql-reader.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

echo "==> Aguardando o Docker..."
for _ in $(seq 1 60); do
  docker info > /dev/null 2>&1 && break
  sleep 2
done
if ! docker info > /dev/null 2>&1; then
  echo "✘ O Docker não iniciou. Execute 'Codespaces: Rebuild Container' (F1) e aguarde."
  exit 1
fi

echo "==> Subindo mysql-writer e mysql-reader (na primeira vez, o download das imagens leva alguns minutos)..."
if docker compose up -d --wait --wait-timeout 420; then
  echo
  bash bin/status-lab || true
  echo
  echo "✔ Ambiente pronto. Abra dois terminais lado a lado e rode 'sessao-a' em um e 'sessao-b' no outro."
  echo "  Comandos disponíveis: ajuda-lab"
else
  echo "✘ Os contêineres não ficaram prontos. Últimas linhas dos logs:"
  docker compose logs --tail 30
  echo "Tente 'reiniciar-lab'. Se o erro persistir, chame o professor."
  exit 1
fi
