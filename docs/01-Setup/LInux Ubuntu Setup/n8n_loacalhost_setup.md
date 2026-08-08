# Setup Guide -- Linux Environment for n8n (Localhost)

## Objective

Bring up a local n8n instance on Linux via Docker Compose, and confirm it
is reachable at `localhost:5678`.

------------------------------------------------------------------------

# Prerequisites

-   `docker_setup_linux.md` completed
-   Docker Engine + Compose plugin installed, running without `sudo`
-   Project workspace created (`~/Projects/Automation-Lab/n8n/`)

------------------------------------------------------------------------

# 1. Create the `.env` File

Inside `~/Projects/Automation-Lab/n8n/`, create `.env`:

``` text
N8N_HOST=localhost
N8N_PORT=5678
N8N_PROTOCOL=http
WEBHOOK_URL=http://localhost:5678/
GENERIC_TIMEZONE=Asia/Kolkata

N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=changeme

N8N_ENCRYPTION_KEY=TODO-generate-a-random-key
```

------------------------------------------------------------------------

# 2. Create `docker-compose.yml`

``` yaml
version: "3.8"

services:
  n8n:
    image: n8nio/n8n:latest
    container_name: n8n
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - N8N_HOST=${N8N_HOST}
      - N8N_PORT=${N8N_PORT}
      - N8N_PROTOCOL=${N8N_PROTOCOL}
      - WEBHOOK_URL=${WEBHOOK_URL}
      - GENERIC_TIMEZONE=${GENERIC_TIMEZONE}
      - N8N_BASIC_AUTH_ACTIVE=${N8N_BASIC_AUTH_ACTIVE}
      - N8N_BASIC_AUTH_USER=${N8N_BASIC_AUTH_USER}
      - N8N_BASIC_AUTH_PASSWORD=${N8N_BASIC_AUTH_PASSWORD}
      - N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY}
    volumes:
      - ./data:/home/node/.n8n
      - ./backups:/backups
```

------------------------------------------------------------------------

# 3. Fix Volume Permissions

The n8n image runs as an unprivileged user inside the container. Ensure
the local `data` folder is writable:

``` bash
mkdir -p data backups
sudo chown -R 1000:1000 data backups
```

------------------------------------------------------------------------

# 4. Start n8n

From `~/Projects/Automation-Lab/n8n/`:

``` bash
docker compose up -d
```

------------------------------------------------------------------------

# 5. Verify Containers

``` bash
docker compose ps
```

``` bash
docker compose logs -f n8n
```

Wait for a line similar to:

    Editor is now accessible via: http://localhost:5678/

------------------------------------------------------------------------

# 6. Access n8n

Open a browser to:

``` text
http://localhost:5678
```

Log in using the `N8N_BASIC_AUTH_USER` / `N8N_BASIC_AUTH_PASSWORD` from
`.env`, and complete the first-run owner account setup.

------------------------------------------------------------------------

# 7. Confirm Persistence

``` bash
docker compose restart n8n
```

Refresh `localhost:5678` -- your workflows should still be there (stored in
the `./data` volume).

------------------------------------------------------------------------

# 8. Back Up Workflows

``` bash
docker exec n8n n8n export:workflow --all --output=/backups/workflows.json
docker exec n8n n8n export:credentials --all --output=/backups/credentials.json
```

------------------------------------------------------------------------

# Final Verification Checklist

-   [ ] `.env` file created
-   [ ] `docker-compose.yml` created
-   [ ] Volume permissions fixed
-   [ ] `docker compose up -d` runs without errors
-   [ ] `localhost:5678` loads the n8n editor
-   [ ] Basic-auth login works
-   [ ] Owner account created
-   [ ] Data persists after container restart
-   [ ] Backup export tested

------------------------------------------------------------------------

# Next Step

Once n8n is running, proceed to `ollama_setup_linux.md` to add a local LLM
backend for AI Agent nodes.