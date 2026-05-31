Home

# Product Test Database

PostgreSQL-only branch for **schema design, upgrades, and exploration**. No web app. No MQTT.

Use this branch to experiment with tables, indexes, and migrations before merging changes elsewhere.

## Quick start

```bash
cp .env.example .env          # set POSTGRES_PASSWORD
make start                    # PostgreSQL on localhost:5433
make init                     # apply sql/schema.sql
make psql                     # interactive shell
```

Optional GUI: `cd pgadmin && make start` → http://localhost:5050/

## Commands

| Command | Purpose |
|---------|---------|
| `make start` / `make stop` | Run / stop PostgreSQL |
| `make psql` | Open psql in the container |
| `make init` | Apply full schema from `sql/schema.sql` |
| `make migrate` | Apply new files in `sql/migrations/` |
| `make reset` | Wipe volume and re-init (destructive) |
| `make db-backup` | Save dump to `data/backups/` |
| `make db-restore FILE=...` | Restore from backup |

## Schema changes

1. Edit or add SQL under `sql/migrations/` (e.g. `001_add_column.sql`)
2. `make migrate`

For a clean slate: `make reset` then edit `sql/schema.sql` if the base design changed.

## Tables

| Table | Purpose |
|-------|---------|
| `product_models` | Product model definitions |
| `product_units` | Serial numbers / orders |
| `test_runs` | Test sessions (TestID) |
| `sensors` | DS18B20 sensor registry |
| `sensor_readings` | Temperature time series |
| `import_log` | Import history |
| `powerbox_types` | Power box lookup |
| `schema_migrations` | Applied migration files |

Reference: [sql/schema.sql](sql/schema.sql)

## Docs

| Guide | Contents |
|-------|----------|
| [docs/DATABASE.md](docs/DATABASE.md) | Connect, example queries |
| [docs/SCHEMA.md](docs/SCHEMA.md) | Tables and relationships |
| [docs/BACKUP.md](docs/BACKUP.md) | Backup and restore |
| [pgadmin/README.md](pgadmin/README.md) | Optional pgAdmin UI |

## License

[MIT License](LICENSE)
