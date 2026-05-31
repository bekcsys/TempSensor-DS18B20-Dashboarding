SHELL := /bin/bash
COMPOSE := docker compose
ROOT := $(CURDIR)
BACKUP_DIR := $(ROOT)/data/backups

.PHONY: help env start stop psql init migrate reset db-backup db-restore status

help:
	@echo "Database-only branch — PostgreSQL for schema design and upgrades"
	@echo ""
	@echo "  make env          Create .env from .env.example"
	@echo "  make start        Start PostgreSQL"
	@echo "  make stop         Stop PostgreSQL"
	@echo "  make psql         Open psql shell"
	@echo "  make init         Apply sql/schema.sql (empty database)"
	@echo "  make migrate      Apply sql/migrations/*.sql"
	@echo "  make reset        Stop, wipe volume, re-init schema"
	@echo "  make db-backup    Dump to data/backups/"
	@echo "  make db-restore   Restore from FILE=data/backups/....sql.gz"
	@echo "  make status       Container status"
	@echo ""
	@echo "Optional pgAdmin: cd pgadmin && make start"
	@echo "Docs: docs/DATABASE.md  docs/SCHEMA.md  docs/BACKUP.md"

env:
	@if [[ ! -f .env ]]; then cp .env.example .env && echo "Created .env"; fi

start: env
	$(COMPOSE) up -d --remove-orphans postgres
	@echo "PostgreSQL: localhost:$${POSTGRES_PUBLISH_PORT:-5433}"
	@echo "Connect: make psql"

stop:
	$(COMPOSE) down

psql: env
	@if ! $(COMPOSE) ps --status running --services 2>/dev/null | grep -qx postgres; then \
		echo "Start first: make start" >&2; exit 1; \
	fi
	$(COMPOSE) exec postgres psql -U $${POSTGRES_USER:-sauna_user} -d $${POSTGRES_DB:-sauna_tests}

init: env start
	@echo "Applying sql/schema.sql..."
	@$(COMPOSE) exec -T postgres psql -U $${POSTGRES_USER:-sauna_user} -d $${POSTGRES_DB:-sauna_tests} \
		-v ON_ERROR_STOP=1 -f - < sql/schema.sql
	@echo "Schema ready."

migrate: env
	@chmod +x scripts/apply_migrations.sh
	@./scripts/apply_migrations.sh

reset: env
	$(COMPOSE) down -v
	$(MAKE) init

db-backup: env
	@mkdir -p "$(BACKUP_DIR)"
	@if ! $(COMPOSE) ps --status running --services 2>/dev/null | grep -qx postgres; then \
		echo "Start first: make start" >&2; exit 1; \
	fi
	@stamp=$$(date +%Y%m%d_%H%M%S); \
	out="$(BACKUP_DIR)/sauna_tests_$$stamp.sql.gz"; \
	$(COMPOSE) exec -T postgres pg_dump -U $${POSTGRES_USER:-sauna_user} -d $${POSTGRES_DB:-sauna_tests} \
		| gzip > "$$out"; \
	echo "Backup: $$out"

db-restore: env
	@if [[ -z "$(FILE)" ]]; then \
		echo "Usage: make db-restore FILE=data/backups/sauna_tests_YYYYMMDD_HHMMSS.sql.gz" >&2; exit 1; \
	fi
	@if [[ ! -f "$(FILE)" ]]; then echo "File not found: $(FILE)" >&2; exit 1; fi
	@if ! $(COMPOSE) ps --status running --services 2>/dev/null | grep -qx postgres; then \
		echo "Start first: make start" >&2; exit 1; \
	fi
	@gunzip -c "$(FILE)" | $(COMPOSE) exec -T postgres psql -U $${POSTGRES_USER:-sauna_user} -d $${POSTGRES_DB:-sauna_tests}
	@echo "Restored from $(FILE)"

status:
	@$(COMPOSE) ps
