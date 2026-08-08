# Setup Guide -- Linux Environment for Ollama

## Objective

Install Ollama on Linux and connect it to n8n as a local LLM backend for
AI Agent / Chat Model nodes -- no external API key required.

------------------------------------------------------------------------

# Prerequisites

-   `docker_setup_linux.md` completed
-   `n8n_localhost_setup_linux.md` completed, n8n reachable at
    `localhost:5678`
-   At least 8GB RAM free (16GB+ recommended for larger models)

------------------------------------------------------------------------

# 1. Install Ollama

``` bash
curl -fsSL https://ollama.com/install.sh | sh
```

Verify installation:

``` bash
ollama --version
```

------------------------------------------------------------------------

# 2. Confirm the Service Is Running

Ollama installs as a systemd service:

``` bash
sudo systemctl status ollama
```

Enable on boot if not already:

``` bash
sudo systemctl enable ollama
sudo systemctl start ollama
```

------------------------------------------------------------------------

# 3. Pull a Model

``` bash
ollama pull llama3.1
```

Other useful options:

``` bash
ollama pull mistral
ollama pull phi3
```

------------------------------------------------------------------------

# 4. Verify the Model

``` bash
ollama list
```

Test a prompt directly:

``` bash
ollama run llama3.1 "Say hello in one sentence."
```

------------------------------------------------------------------------

# 5. Confirm the API Endpoint

Ollama exposes a local API by default:

``` text
http://localhost:11434
```

Test it:

``` bash
curl http://localhost:11434/api/tags
```

------------------------------------------------------------------------

# 6. Connect n8n to Ollama

If n8n is running in Docker on the same Linux host, the container
cannot reach `localhost:11434` directly (that's the container's own
localhost). Two options:

**Option A -- host networking (simplest for local dev):**

``` yaml
# in n8n's docker-compose.yml
network_mode: "host"
```

**Option B -- bridge network with host gateway:**

``` yaml
extra_hosts:
  - "host.docker.internal:host-gateway"
```

Then in n8n:

``` text
Base URL: http://host.docker.internal:11434
```

In n8n:

1. Add an **Ollama** credential (Chat Model / AI Agent node)
2. Set the Base URL per the option chosen above
3. Select the model pulled in Step 3

------------------------------------------------------------------------

# 7. Test From n8n

Create a simple workflow: Manual Trigger → AI Agent (Ollama Chat Model) →
run it. Confirm you get a model response back in the node output.

------------------------------------------------------------------------

# Final Verification Checklist

-   [ ] Ollama installed
-   [ ] `ollama --version` works
-   [ ] systemd service running and enabled
-   [ ] At least one model pulled
-   [ ] `ollama run` produces a response
-   [ ] API reachable at `localhost:11434`
-   [ ] n8n networking configured (host mode or extra_hosts)
-   [ ] Test workflow in n8n returns a model response

------------------------------------------------------------------------

# Next Step

With Docker, n8n, and Ollama all verified, proceed to
`architecture.md` / `workflows.md` to start building AI Agent-powered
workflows.