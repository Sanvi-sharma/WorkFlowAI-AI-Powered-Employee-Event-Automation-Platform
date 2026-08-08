# Setup Guide -- Windows Environment for Docker

## Objective

Prepare a Windows machine for self-hosting Docker-based services (n8n,
Ollama, Evolution API, etc.) using Docker Desktop and WSL2.

------------------------------------------------------------------------

# Prerequisites

-   Windows 11 (or Windows 10 version 2004+)
-   Administrator access
-   Stable internet connection

------------------------------------------------------------------------

# 1. Check Windows Version

Press `Win + R`, type:

``` text
winver
```

Or run:

``` powershell
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
```

------------------------------------------------------------------------

# 2. Check WSL

Verify installation:

``` powershell
wsl --status
```

Check version:

``` powershell
wsl --version
```

List installed Linux distributions:

``` powershell
wsl --list --verbose
```

### Install WSL (if not installed)

``` powershell
wsl --install
```

Restart the computer after installation.

------------------------------------------------------------------------

# 3. Install Ubuntu

Check Ubuntu:

``` powershell
wsl --install -d Ubuntu
```

If Ubuntu is not installed:

``` powershell
wsl --install -d Ubuntu
```

Launch Ubuntu and create:

-   Linux username
-   Linux password

Update Ubuntu:

``` bash
sudo apt update
sudo apt upgrade -y
```

------------------------------------------------------------------------

# 4. Install Git

### Check

``` powershell
git --version
```

If Git is missing, install Git for Windows from the official website.

Verify again:

``` powershell
git --version
```

------------------------------------------------------------------------

# 5. Install Visual Studio Code

Recommended extensions:

-   Docker
-   YAML
-   GitLens
-   Prettier
-   Thunder Client

------------------------------------------------------------------------

# 6. Install Docker Desktop

Download Docker Desktop from the official Docker website.

During installation ensure:

-   Enable **Use WSL2 instead of Hyper-V**
-   Keep default settings unless required otherwise

Restart Windows after installation.

------------------------------------------------------------------------

# 7. Enable WSL Integration

Docker Desktop:

Settings

→ Resources

→ WSL Integration

Enable:

-   Ubuntu

Click **Apply & Restart**.

------------------------------------------------------------------------

# 8. Verify Docker

``` powershell
docker --version
```

``` powershell
docker compose version
```

``` powershell
docker info
```

``` powershell
docker run hello-world
```

Expected success:

    Hello from Docker!

------------------------------------------------------------------------

# 9. Verify Docker Inside Ubuntu

``` bash
docker --version
```

``` bash
docker compose version
```

``` bash
docker ps
```

------------------------------------------------------------------------

# 10. Create Project Workspace

Recommended structure:

``` text
C:\Projects\Automation-Lab\
├── n8n/
│   ├── docker-compose.yml
│   ├── .env
│   ├── data/
│   └── backups/
│
├── ollama/
│   ├── docker-compose.yml
│   ├── .env
│   └── data/
│
├── evolution/
│   ├── docker-compose.yml
│   ├── .env
│   └── data/
│
├── shared/
│   ├── ssl/
│   ├── uploads/
│   └── scripts/
│
├── docs/
│   ├── docker_setup_windows.md
│   ├── docker_setup_linux.md
│   ├── n8n_localhost_setup_windows.md
│   ├── n8n_localhost_setup_linux.md
│   ├── ollama_setup_windows.md
│   ├── ollama_setup_linux.md
│   └── architecture.md
│
└── README.md
```

------------------------------------------------------------------------

# Final Verification Checklist

-   [ ] Windows updated
-   [ ] WSL installed
-   [ ] Ubuntu installed
-   [ ] Ubuntu updated
-   [ ] Git installed
-   [ ] VS Code installed
-   [ ] Docker Desktop installed
-   [ ] WSL integration enabled
-   [ ] `docker --version` works
-   [ ] `docker compose version` works
-   [ ] `docker run hello-world` works
-   [ ] Project workspace created

------------------------------------------------------------------------

# Next Step

Once every item above is complete, proceed to `n8n_localhost_setup_windows.md`
to bring up n8n via `docker-compose.yml`.