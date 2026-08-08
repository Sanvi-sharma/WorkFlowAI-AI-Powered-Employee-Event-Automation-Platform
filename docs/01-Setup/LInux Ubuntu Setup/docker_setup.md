# Setup Guide -- Linux Environment for Docker

## Objective

Prepare a Linux machine (Ubuntu/Debian-based) for self-hosting
Docker-based services (n8n, Ollama, Evolution API, etc.) using Docker
Engine and Docker Compose, natively -- no WSL layer required.

------------------------------------------------------------------------

# Prerequisites

-   Ubuntu 22.04+ / Debian 11+ (or another systemd-based distro)
-   sudo/root access
-   Stable internet connection

------------------------------------------------------------------------

# 1. Check Linux Version

``` bash
lsb_release -a
```

Or:

``` bash
cat /etc/os-release
```

------------------------------------------------------------------------

# 2. Update the System

``` bash
sudo apt update
sudo apt upgrade -y
```

------------------------------------------------------------------------

# 3. Remove Old Docker Versions (if any)

``` bash
sudo apt remove docker docker-engine docker.io containerd runc -y
```

------------------------------------------------------------------------

# 4. Install Git

### Check

``` bash
git --version
```

If missing:

``` bash
sudo apt install git -y
```

Verify again:

``` bash
git --version
```

------------------------------------------------------------------------

# 5. Install Visual Studio Code

``` bash
sudo snap install code --classic
```

Recommended extensions:

-   Docker
-   YAML
-   GitLens
-   Prettier
-   Thunder Client

------------------------------------------------------------------------

# 6. Install Docker Engine

Set up Docker's official repository:

``` bash
sudo apt install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Install Docker Engine + Compose plugin:

``` bash
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```

------------------------------------------------------------------------

# 7. Run Docker Without `sudo`

``` bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

Log out and back in (or reboot) for group changes to take full effect.

------------------------------------------------------------------------

# 8. Enable Docker on Boot

``` bash
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```

------------------------------------------------------------------------

# 9. Verify Docker

``` bash
docker --version
```

``` bash
docker compose version
```

``` bash
docker info
```

``` bash
docker run hello-world
```

Expected success:

    Hello from Docker!

------------------------------------------------------------------------

# 10. Create Project Workspace

Recommended structure:

``` text
~/Projects/Automation-Lab/
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

-   [ ] Linux updated
-   [ ] Old Docker versions removed
-   [ ] Git installed
-   [ ] VS Code installed
-   [ ] Docker Engine installed
-   [ ] Docker Compose plugin installed
-   [ ] Docker runs without `sudo`
-   [ ] Docker enabled on boot
-   [ ] `docker --version` works
-   [ ] `docker compose version` works
-   [ ] `docker run hello-world` works
-   [ ] Project workspace created

------------------------------------------------------------------------

# Next Step

Once every item above is complete, proceed to `n8n_localhost_setup_linux.md`
to bring up n8n via `docker-compose.yml`.