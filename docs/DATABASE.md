Home › Database

# Connect

| Item | Default |
|------|---------|
| Host | `localhost` |
| Port | `5433` |
| Database | `sauna_tests` |
| User | `sauna_user` |

```bash
make start
make psql
```

From the host:

```bash
psql -h localhost -p 5433 -U sauna_user -d sauna_tests
```

## Example queries

```sql
-- Tables
\dt

-- Latest test runs
SELECT tr.test_run_id, pm.model_name, pu.serial_number, tr.test_date
FROM test_runs tr
JOIN product_units pu ON pu.unit_id = tr.unit_id
JOIN product_models pm ON pm.model_id = pu.model_id
ORDER BY tr.test_date DESC
LIMIT 10;

-- Max temperature per sensor for a test
SELECT s.sensor_label, MAX(sr.temperature_f) AS max_f
FROM sensor_readings sr
JOIN sensors s ON s.sensor_id = sr.sensor_id
WHERE sr.test_run_id = 1
GROUP BY s.sensor_label;
```

Schema reference: [../sql/schema.sql](../sql/schema.sql) · [SCHEMA.md](SCHEMA.md)

Backup: [BACKUP.md](BACKUP.md)
