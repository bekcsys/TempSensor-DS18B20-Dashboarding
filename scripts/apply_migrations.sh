#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MIGRATIONS="${ROOT}/sql/migrations"
COMPOSE="docker compose -f ${ROOT}/docker-compose.yml --env-file ${ROOT}/.env"

if [[ ! -f "${ROOT}/.env" ]]; then
  echo "Missing .env — run: cp .env.example .env" >&2
  exit 1
fi

set -a
# shellcheck disable=SC1091
source "${ROOT}/.env"
set +a

if ! ${COMPOSE} ps --status running --services 2>/dev/null | grep -qx postgres; then
  echo "PostgreSQL is not running. Start first: make start" >&2
  exit 1
fi

shopt -s nullglob
files=("${MIGRATIONS}"/*.sql)
shopt -u nullglob

if [[ ${#files[@]} -eq 0 ]]; then
  echo "No migration files in sql/migrations/"
  exit 0
fi

for file in "${files[@]}"; do
  version="$(basename "${file}")"
  applied=$(${COMPOSE} exec -T postgres psql -U "${POSTGRES_USER:-sauna_user}" -d "${POSTGRES_DB:-sauna_tests}" -tAc \
    "SELECT 1 FROM schema_migrations WHERE version = '${version}'" 2>/dev/null || true)
  if [[ "${applied}" == "1" ]]; then
    echo "skip ${version}"
    continue
  fi
  echo "apply ${version}"
  ${COMPOSE} exec -T postgres psql -U "${POSTGRES_USER:-sauna_user}" -d "${POSTGRES_DB:-sauna_tests}" \
    -v ON_ERROR_STOP=1 -f - < "${file}"
  ${COMPOSE} exec -T postgres psql -U "${POSTGRES_USER:-sauna_user}" -d "${POSTGRES_DB:-sauna_tests}" \
    -c "INSERT INTO schema_migrations (version) VALUES ('${version}') ON CONFLICT DO NOTHING;"
done

echo "Migrations up to date."
