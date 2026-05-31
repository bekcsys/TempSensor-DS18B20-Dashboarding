#!/bin/sh
set -e

archive_csv() {
  python -c "from mqtt_csv_logger import archive_csv_exports; paths = archive_csv_exports(); print(f'Archived {len(paths)} CSV file(s)', flush=True)"
}

term_handler() {
  if [ -n "${child:-}" ]; then
    kill -TERM "${child}" 2>/dev/null || true
    wait "${child}" 2>/dev/null || true
  fi
  exit 0
}

archive_csv
trap term_handler TERM INT

python -u mqtt_publisher.py &
child=$!
wait "${child}"
