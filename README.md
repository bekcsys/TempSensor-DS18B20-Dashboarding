Home

# MQTT Data Collector

**mqtt branch** — DS18B20 sensor reads, MQTT publish, CSV export. Use this branch to optimize data collection.

No Grafana. No InfluxDB. No database. No web app.

```
DS18B20 → mqtt-publisher → MQTT (Mosquitto)
              └→ exports/*.csv
```

## Quick start

```bash
cp .env.example .env
make start              # TestUnit + serial number
make check              # verify MQTT + CSV
make stop
```

## Structure

```
├── docker-compose.yml    # Mosquitto + mqtt-publisher
├── Makefile
├── publisher/            # sensor read, MQTT, CSV
├── stack/mosquitto/
├── docker/               # publisher image
├── scripts/
├── exports/              # CSV output (gitignored)
└── docs/
```

## Commands

| Command | Purpose |
|---------|---------|
| `make start` | Start collector |
| `make stop` | Stop stack |
| `make logs` | Publisher logs |
| `make check` | Test MQTT + CSV |

CSV columns: `timestamp`, `elapsed_time_in_Min`, `Timer_in_Min`, `sensor_id`, `sensor_label`, `temperature_c`, `temperature_f`

## Docs

| Guide | Contents |
|-------|----------|
| [docs/SENSORS.md](docs/SENSORS.md) | Add DS18B20 sensors |
| [docs/CONFIG.md](docs/CONFIG.md) | `.env`, timezone |

## License

[MIT License](LICENSE)
