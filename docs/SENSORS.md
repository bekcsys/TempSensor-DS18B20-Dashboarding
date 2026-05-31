Home › Sensors

# DS18B20 sensors

## Enable 1-Wire (Pi)

```bash
sudo raspi-config    # Interface Options → 1-Wire → Enable
sudo reboot
ls /sys/bus/w1/devices/28-*
```

## Map sensors

Edit `publisher/sensor/ds18b20_reader.py`:

```python
SENSOR_MAP = {
    '28-0000004a6df4': 'Sensor1',
    '28-031731d057ff': 'Sensor2',
}
```

## Apply

```bash
docker compose build mqtt-publisher
docker compose up -d mqtt-publisher
docker compose logs mqtt-publisher --tail 20
```

## Verify

```bash
mosquitto_sub -h localhost -t 'tempsensor/readings' -v
tail -f exports/*.csv
make check
```
