SHELL := /bin/bash
ROOT := $(CURDIR)

ifeq ($(shell docker info >/dev/null 2>&1 && echo yes),yes)
  COMPOSE := docker compose
else
  COMPOSE := sudo docker compose
endif

.PHONY: help env start stop status logs check

help:
	@echo "MQTT data collector — DS18B20, Mosquitto, CSV export"
	@echo ""
	@echo "  make env      Create .env from .env.example"
	@echo "  make start    Prompt TestUnit + serial, start stack"
	@echo "  make stop     Stop Mosquitto + publisher"
	@echo "  make status   Show containers"
	@echo "  make logs     Tail publisher logs"
	@echo "  make check    Verify MQTT + CSV"
	@echo ""
	@echo "Docs: docs/SENSORS.md  docs/CONFIG.md"

env:
	@if [[ ! -f .env ]]; then cp .env.example .env && echo "Created .env"; fi

start: env
	@$(ROOT)/scripts/compose-up.sh

stop:
	@$(ROOT)/scripts/compose-down.sh

status:
	@$(COMPOSE) ps

logs:
	@$(COMPOSE) logs -f mqtt-publisher

check:
	@$(ROOT)/scripts/check_pipeline.sh
