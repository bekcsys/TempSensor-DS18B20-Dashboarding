Home

# Product Test Database

PostgreSQL-only branch for **schema design, upgrades, and exploration**.

No web app. No MQTT. No data collector.

## Quick start

```bash
cp .env.example .env
make start
make init
make psql
```

Optional GUI: `cd pgadmin && make start` → http://localhost:5050/

## Structure

```
├── docker-compose.yml    # PostgreSQL
├── Makefile
├── sql/
│   ├── schema.sql        # base schema
│   └── migrations/       # incremental changes
├── scripts/              # apply_migrations.sh
├── data/backups/
├── pgadmin/              # optional UI
└── docs/
```

## Commands

| Command | Purpose |
|---------|---------|
| `make start` / `make stop` | Run / stop PostgreSQL |
| `make psql` | Interactive SQL shell |
| `make init` | Apply `sql/schema.sql` |
| `make migrate` | Apply `sql/migrations/*.sql` |
| `make reset` | Wipe volume and re-init |
| `make db-backup` | Dump to `data/backups/` |
| `make db-restore FILE=...` | Restore from backup |

## Schema workflow

1. Edit `sql/schema.sql` or add `sql/migrations/001_change.sql`
2. `make migrate` (or `make reset` for a clean slate)

## Tables

`product_models` · `product_units` · `test_runs` · `sensors` · `sensor_readings` · `import_log` · `powerbox_types` · `schema_migrations`

See [sql/schema.sql](sql/schema.sql) and [docs/SCHEMA.md](docs/SCHEMA.md).

## Docs

| Guide | Contents |
|-------|----------|
| [docs/DATABASE.md](docs/DATABASE.md) | Connect, example queries |
| [docs/SCHEMA.md](docs/SCHEMA.md) | Relationships, migrations |
| [docs/BACKUP.md](docs/BACKUP.md) | Backup and restore |
| [pgadmin/README.md](pgadmin/README.md) | Optional pgAdmin |

## License

[MIT License](LICENSE)
