Home › pgAdmin

# pgAdmin (optional)

Browser UI for PostgreSQL. Separate from the database container.

```bash
cd .. && make start
cd pgadmin && make start
```

Open http://localhost:5050/ — login from `PGADMIN_DEFAULT_EMAIL` / `PGADMIN_DEFAULT_PASSWORD` in `.env`.

Server **Product Test DB** is registered automatically (host `host.docker.internal`, port `5433`).
