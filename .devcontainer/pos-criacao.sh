#!/usr/bin/env bash
# Executado UMA vez, quando o Codespace é criado: instala o cliente MySQL e ajusta permissões.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "==> Instalando o cliente MySQL..."
sudo apt-get update -qq
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq mysql-client > /dev/null

# Arquivos enviados pela interface web do GitHub perdem a permissão de execução.
chmod +x bin/* .devcontainer/*.sh
# O cliente MySQL ignora arquivos de configuração graváveis por todos.
chmod 644 config/*.cnf

echo "==> $(mysql --version)"
