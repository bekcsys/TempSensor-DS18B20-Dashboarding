#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

if docker compose version >/dev/null 2>&1; then
  COMPOSE=(docker compose)
else
  COMPOSE=(docker-compose)
fi

if [[ "${EUID}" -eq 0 ]]; then
  "${COMPOSE[@]}" down "$@"
elif command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
  "${COMPOSE[@]}" down "$@"
else
  sudo "${COMPOSE[@]}" down "$@"
fi
