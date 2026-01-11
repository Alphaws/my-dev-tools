#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
CERTS_DIR="${ROOT_DIR}/certs"
CONFIG_DIR="${ROOT_DIR}/config"
TLS_CONFIG="${CONFIG_DIR}/dynamic.yml"

mkdir -p "${CERTS_DIR}"
mkdir -p "${CONFIG_DIR}"

domains=(
  "traefik.localhost"
  "portainer.localhost"
  "mailhog.localhost"
  "adminer.localhost"
  "grafana.localhost"
  "metrics.localhost"
  "whoami.localhost"
)

if [ "$#" -gt 0 ]; then
  domains+=("$@")
fi

for domain in "${domains[@]}"; do
  mkcert -cert-file "${CERTS_DIR}/${domain}.pem" -key-file "${CERTS_DIR}/${domain}-key.pem" "${domain}"
done

tmp_file="$(mktemp)"
{
  echo "tls:"
  echo "  certificates:"
  while IFS= read -r cert_path; do
    cert_name="$(basename "${cert_path}")"
    key_name="${cert_name%.pem}-key.pem"
    key_path="${CERTS_DIR}/${key_name}"
    if [ -f "${key_path}" ]; then
      echo "    - certFile: /etc/traefik/certs/${cert_name}"
      echo "      keyFile: /etc/traefik/certs/${key_name}"
    fi
  done < <(find "${CERTS_DIR}" -maxdepth 1 -type f -name "*.pem" ! -name "*-key.pem" ! -name "local-cert.pem" | sort)
} > "${tmp_file}"
mv "${tmp_file}" "${TLS_CONFIG}"
