FROM python:3.13-slim-bookworm

WORKDIR /app

COPY requirements.txt .
RUN apt-get update \
    && apt-get install -y --no-install-recommends tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir -r requirements.txt

COPY publisher/sensor ./sensor
COPY publisher/mqtt_publisher.py publisher/mqtt_csv_logger.py ./
COPY docker/mqtt-publisher-entrypoint.sh /mqtt-publisher-entrypoint.sh
RUN chmod +x /mqtt-publisher-entrypoint.sh

ENV TZ=America/Chicago \
    MQTT_HOST=mosquitto \
    MQTT_PORT=1883 \
    MQTT_TOPIC=tempsensor/readings \
    CSV_DIR=/app/exports \
    SKIP_W1_MODPROBE=1

ENTRYPOINT ["/mqtt-publisher-entrypoint.sh"]
