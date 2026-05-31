SHELL := /bin/bash
COMPOSE := docker compose --env-file ../.env
DB_COMPOSE := docker compose -f ../docker-compose.yml --env-file ../.env

.PHONY: help start stop logs status reset urls

help:
	@echo "pgAdmin (optional):"
	@echo "  make start    Start pgAdmin"
	@echo "  make stop     Stop pgAdmin"
	@echo "  make urls     Show login URL"
	@echo ""
	@echo "Requires PostgreSQL: cd .. && make start"

start:
	@if ! $(DB_COMPOSE) ps --status running --services 2>/dev/null | grep -qx postgres; then \
		echo "Start PostgreSQL first: cd .. && make start" >&2; exit 1; \
	fi
	$(COMPOSE) up -d
	@echo "Waiting for pgAdmin..."
	@for i in $$(seq 1 24); do \
		if $(COMPOSE) ps pgadmin 2>/dev/null | grep -q '(healthy)'; then \
			echo "pgAdmin is ready."; break; \
		fi; \
		sleep 5; \
	done
	@$(MAKE) urls

stop:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs -f pgadmin

status:
	@$(COMPOSE) ps

reset:
	$(COMPOSE) down -v

urls:
	@port=$${PGADMIN_PUBLISH_PORT:-5050}; \
	echo "pgAdmin: http://localhost:$$port/"; \
	echo "Login: PGADMIN_DEFAULT_EMAIL / PGADMIN_DEFAULT_PASSWORD in ../.env"
