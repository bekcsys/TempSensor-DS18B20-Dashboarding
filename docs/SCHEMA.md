Home › Schema

# Schema

Full DDL: [../sql/schema.sql](../sql/schema.sql)

## Relationships

```
product_models ──< product_units ──< test_runs ──< sensor_readings
powerbox_types ──< product_units (optional)
sensors ──< sensor_readings
test_runs ──< import_log (optional)
```

## Migrations

Add numbered SQL files to `sql/migrations/`:

```
sql/migrations/001_add_notes_column.sql
```

Then:

```bash
make migrate
```

Applied versions are tracked in `schema_migrations`.

To rebuild from scratch after editing the base design:

```bash
make reset
```

Then update `sql/schema.sql` to match.
