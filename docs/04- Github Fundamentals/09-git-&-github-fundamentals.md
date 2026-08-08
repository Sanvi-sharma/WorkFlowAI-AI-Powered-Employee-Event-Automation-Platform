# Automation-Lab

This workspace contains the local automation environment for n8n and supporting services.

## Quick start

### Start n8n

```bash
cd /home/sanvi/Automation-Lab/n8n
docker compose up -d
```

Open http://localhost:5678

### Start Evolution service

```bash
cd /home/sanvi/Automation-Lab/Evolution
docker compose up -d
```

Open http://localhost:8081

## Structure

- n8n/ – n8n Docker setup, env file, data, and backups
- Evolution/ – placeholder service environment for future automation work
- shared/ – reusable uploads, SSL, and scripts