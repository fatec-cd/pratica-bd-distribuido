# Funções compartilhadas pelos comandos do laboratório (não execute este arquivo diretamente).
# shellcheck shell=bash

RAIZ="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"
CONFIG="$RAIZ/config"
BANCO="ecommerce_central"

# Cliente MySQL com as credenciais de um dos arquivos de config/ (ex.: mysql_cfg admin-reader -e "...")
mysql_cfg() {
  local cfg="$1"
  shift
  mysql --defaults-extra-file="$CONFIG/$cfg.cnf" "$@"
}

compose() {
  docker compose --project-directory "$RAIZ" -f "$RAIZ/docker-compose.yml" "$@"
}

# Abre uma sessão interativa identificada no prompt (SESSAO-A writer / SESSAO-B reader).
abrir_sessao() {
  local letra="$1" papel="$2" cfg="$3" porta="$4"
  shift 4
  cd "$RAIZ" || exit 1
  if ! mysql_cfg "$cfg" -e "SELECT 1" > /dev/null 2>&1; then
    echo "✘ Não foi possível conectar ao $papel (porta $porta). Rode 'status-lab' para ver o estado do ambiente." >&2
    exit 1
  fi
  local banco=()
  if mysql_cfg "$cfg" -e "USE $BANCO" > /dev/null 2>&1; then
    banco=(--database="$BANCO")
  fi
  exec mysql --defaults-extra-file="$CONFIG/$cfg.cnf" "${banco[@]}" \
    --prompt="SESSAO-$letra $papel [\\d]> " "$@"
}
