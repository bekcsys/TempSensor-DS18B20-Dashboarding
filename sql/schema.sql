-- Full reference schema (product test data platform).
-- Fresh database: make init
-- Incremental changes: sql/migrations/ + make migrate

CREATE TABLE IF NOT EXISTS schema_migrations (
    version TEXT PRIMARY KEY,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product_models (
    model_id SERIAL PRIMARY KEY,
    model_name TEXT UNIQUE NOT NULL,
    supplier VARCHAR(20) NOT NULL DEFAULT '',
    rated_voltage NUMERIC(6,2),
    rated_power_watts NUMERIC(10,2),
    notes TEXT NOT NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_product_models_model_name ON product_models(model_name);

CREATE TABLE powerbox_types (
    powerbox_type_id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO powerbox_types (name) VALUES ('Lee'), ('Luis'), ('Wang')
ON CONFLICT (name) DO NOTHING;

CREATE TABLE product_units (
    unit_id SERIAL PRIMARY KEY,
    model_id INT NOT NULL REFERENCES product_models(model_id),
    serial_number TEXT UNIQUE NOT NULL,
    powerbox_type_id INT REFERENCES powerbox_types(powerbox_type_id) ON DELETE SET NULL,
    wattage NUMERIC(10,2),
    notes TEXT NOT NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_product_units_serial ON product_units(serial_number);
CREATE INDEX idx_product_units_model_id ON product_units(model_id);

CREATE TABLE test_runs (
    test_run_id BIGSERIAL PRIMARY KEY,
    unit_id INT NOT NULL REFERENCES product_units(unit_id),
    test_date TIMESTAMP NOT NULL,
    tester_name TEXT NOT NULL DEFAULT '',
    supply_voltage NUMERIC(6,2),
    total_amp_draw_start NUMERIC(6,2),
    run_duration_min INT NOT NULL DEFAULT 90,
    target_temperature_f NUMERIC(5,2) NOT NULL DEFAULT 150,
    test_location TEXT NOT NULL DEFAULT '',
    notes TEXT NOT NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_test_runs_unit_id ON test_runs(unit_id);
CREATE INDEX idx_test_runs_test_date ON test_runs(test_date);

CREATE TABLE sensors (
    sensor_id SERIAL PRIMARY KEY,
    sensor_serial TEXT UNIQUE NOT NULL,
    sensor_label TEXT NOT NULL DEFAULT '',
    sensor_type TEXT NOT NULL DEFAULT 'DS18B20',
    notes TEXT NOT NULL DEFAULT '',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sensor_readings (
    reading_id BIGSERIAL PRIMARY KEY,
    test_run_id BIGINT NOT NULL REFERENCES test_runs(test_run_id) ON DELETE CASCADE,
    sensor_id INT NOT NULL REFERENCES sensors(sensor_id),
    reading_time TIMESTAMP NOT NULL,
    elapsed_time_min INT NOT NULL,
    timer_remaining_min INT,
    temperature_c NUMERIC(6,2),
    temperature_f NUMERIC(6,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_sensor_readings_test_run ON sensor_readings(test_run_id);
CREATE INDEX idx_sensor_readings_sensor ON sensor_readings(sensor_id);
CREATE INDEX idx_sensor_readings_time ON sensor_readings(reading_time);
CREATE INDEX idx_sensor_readings_run_time ON sensor_readings(test_run_id, reading_time);

CREATE TABLE import_log (
    import_id BIGSERIAL PRIMARY KEY,
    file_name TEXT NOT NULL,
    original_file_path TEXT NOT NULL DEFAULT '',
    archived_file_path TEXT NOT NULL DEFAULT '',
    test_run_id BIGINT REFERENCES test_runs(test_run_id) ON DELETE SET NULL,
    status TEXT NOT NULL,
    rows_imported INT NOT NULL DEFAULT 0,
    sensors_detected INT NOT NULL DEFAULT 0,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    error_message TEXT NOT NULL DEFAULT ''
);
CREATE INDEX idx_import_log_file_name ON import_log(file_name);
CREATE INDEX idx_import_log_status ON import_log(status);
