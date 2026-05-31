Home › Config

# Configuration

Copy `.env.example` to `.env` before `make start`.

| Variable | Purpose |
|----------|---------|
| `SAMPLE_INTERVAL` | Seconds between reads (default `60`) |
| `MQTT_TOPIC` | Default `tempsensor/readings` |
| `TEST_UNIT`, `SERIAL_NUMBER` | CSV filename labels (set by `make start`) |
| `TIMER_START_MIN` | Countdown column start (default `90`) |
| `TZ` | Default `America/Chicago` |
| `CSV_DIR` | Default `exports` |

## Timezone

If timestamps are wrong:

```bash
sudo ./scripts/setup_timezone.sh
# set TZ=America/Chicago in .env
docker compose up -d --force-recreate mqtt-publisher
```

## CSV files

Each run creates `exports/YYYY-MM-DD_HHMMAM_TestUnit_serial.csv`.

On start, existing CSVs move to `exports/archive/`.
