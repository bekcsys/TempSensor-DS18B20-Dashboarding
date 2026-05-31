#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

echo "=== Containers ==="
docker compose ps

echo ""
echo "=== MQTT sample (3s) ==="
timeout 3 mosquitto_sub -h localhost -t 'tempsensor/readings' -C 2 -v 2>/dev/null || \
  echo "Install: sudo apt-get install -y mosquitto-clients"

echo ""
echo "=== CSV (latest file, last 3 lines) ==="
LATEST_CSV="$(ls -t exports/*.csv 2>/dev/null | head -1 || true)"
if [[ -n "${LATEST_CSV}" ]]; then
  echo "${LATEST_CSV}"
  tail -3 "${LATEST_CSV}"
else
  echo "(no CSV yet)"
fi
