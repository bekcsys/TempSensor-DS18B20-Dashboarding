Home › Backup

# Backup and restore

Data lives in the Docker volume `postgres_data`.

| Action | Safe? |
|--------|-------|
| `make stop` | Yes — data kept |
| `make reset` | **No** — wipes volume |
| `docker compose down -v` | **No** — wipes volume |

## Backup

```bash
make db-backup
```

Creates `data/backups/sauna_tests_YYYYMMDD_HHMMSS.sql.gz`.

## Restore

```bash
make start
make db-restore FILE=data/backups/sauna_tests_YYYYMMDD_HHMMSS.sql.gz
```

Use the same `POSTGRES_PASSWORD` as when the backup was taken.

## Manual dump

```bash
docker compose exec -T postgres pg_dump -U sauna_user -d sauna_tests | gzip > data/backups/manual.sql.gz
```

See also: [DATABASE.md](DATABASE.md)
