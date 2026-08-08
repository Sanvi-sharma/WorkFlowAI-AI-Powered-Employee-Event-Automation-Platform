# Automation-Lab

Welcome to **Registration Automation System Technical Design & Implementation Documentation** 👋

This repository is my learning and experimentation workspace for automation, DevOps, AI workflows, and self-hosted services. The goal is not just to make automations work, but to understand the architecture behind them.

## Project Structure

```text
Automation-Lab/
│
├── docs/
│   ├── 00-Directory-structure.md
│   ├── 01-setup.md
│   ├── 02-docker-fundamentals.md
│   ├── 03-docker-compose.md
│   ├── 04-n8n-basics.md
│   ├── 05-google-sheets.md
│   ├── 06-whatsapp-automation.md
│   ├── 07-ai-agents.md
│   ├── 08-production-deployment.md
│   ├── 09-git-&-github-fundamentals.md
│   └── architecture.md
│   └── workflows.md
│   └── troubleshooting.md
│   └── glossary.md
│
├── n8n/
│   ├── docker-compose.yml
│   ├── .env
│   ├── data/
│   └── backups/
│
├── evolution/
│   ├── docker-compose.yml
│   ├── .env
│   └── data/
│
├── shared/
│   ├── uploads/
│   ├── ssl/
│   └── scripts/
│
├── assests/
│   ├── diagrams/
│   └── screenshots/
│
├── LICENSE
├── n8n workflow automation.txt
├── .gitignore
│
└── README.md
```

## Folder Guide

### docs/
The project's knowledge base. Every concept, setup guide, troubleshooting note, and architecture decision is documented here so the repository becomes a learning resource instead of just code.

### n8n/
Contains everything required to run n8n.

- **docker-compose.yml** – The blueprint that tells Docker which image to run, ports to expose, volumes to mount, restart policy, and environment variables.
- **.env** – Stores configuration and secrets (API keys, passwords, ports, URLs) outside the code.
- **data/** – Persistent storage. Containers are temporary; this folder ensures workflows, credentials, and settings survive container recreation.
- **backups/** – Exported workflows and backups for migration and disaster recovery.

### evolution/
Reserved for the WhatsApp automation service. Keeping it isolated makes it easy to update, replace, or troubleshoot independently.

### shared/
Resources used by multiple services.

- **uploads/** – Shared files.
- **ssl/** – HTTPS certificates.
- **scripts/** – Reusable automation and maintenance scripts.

## Why this structure?

Each service gets its own folder instead of mixing everything together. This improves:

- Scalability
- Maintenance
- Debugging
- Backups
- Team collaboration

## Learning Philosophy

> Learn **why** something works before learning **how** to use it.

Every technology added should include:
- Installation notes
- Concepts
- Practical examples
- Common mistakes
- Troubleshooting

## Future Services

As this lab grows, it may include:

- PostgreSQL
- Redis
- Ollama
- Qdrant
- Traefik
- MinIO
- AI Agents
- Monitoring Stack

Happy Learning! 🚀
