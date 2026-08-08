# Setup Guide -- Windows Environment for Ollama

## Objective

Install Ollama on Windows and connect it to n8n as a local LLM backend for
AI Agent / Chat Model nodes -- no external API key required.

------------------------------------------------------------------------

# Prerequisites

-   `docker_setup_windows.md` completed
-   `n8n_localhost_setup_windows.md` completed, n8n reachable at
    `localhost:5678`
-   At least 8GB RAM free (16GB+ recommended for larger models)

------------------------------------------------------------------------

# 1. Install Ollama

Download the Windows installer from the official Ollama website and run
it. This installs Ollama as a background service.

Verify installation:

``` powershell
ollama --version
```

------------------------------------------------------------------------

# 2. Pull a Model

``` powershell
ollama pull llama3.1
```

Other useful options:

``` powershell
ollama pull mistral
ollama pull phi3
```

------------------------------------------------------------------------

# 3. Verify Ollama Is Running

``` powershell
ollama list
```

Test a prompt directly:

``` powershell
ollama run llama3.1 "Say hello in one sentence."
```

------------------------------------------------------------------------

# 4. Confirm the API Endpoint

Ollama exposes a local API by default:

``` text
http://localhost:11434
```

Test it:

``` powershell
curl http://localhost:11434/api/tags
```

------------------------------------------------------------------------

# 5. Connect n8n to Ollama

Since n8n is running inside Docker Desktop (WSL2) and Ollama runs
natively on Windows, use `host.docker.internal` instead of `localhost`
so the container can reach the host:

``` text
Base URL: http://host.docker.internal:11434
```

In n8n:

1. Add an **Ollama** credential (Chat Model / AI Agent node)
2. Set Base URL to `http://host.docker.internal:11434`
3. Select the model pulled in Step 2

------------------------------------------------------------------------

# 6. Test From n8n

Create a simple workflow: Manual Trigger → AI Agent (Ollama Chat Model) →
run it. Confirm you get a model response back in the node output.

------------------------------------------------------------------------

# Final Verification Checklist

-   [ ] Ollama installed
-   [ ] `ollama --version` works
-   [ ] At least one model pulled
-   [ ] `ollama run` produces a response
-   [ ] API reachable at `localhost:11434`
-   [ ] n8n credential configured with `host.docker.internal:11434`
-   [ ] Test workflow in n8n returns a model response

------------------------------------------------------------------------

# Next Step

With Docker, n8n, and Ollama all verified, proceed to
`architecture.md` / `workflows.md` to start building AI Agent-powered
workflows.