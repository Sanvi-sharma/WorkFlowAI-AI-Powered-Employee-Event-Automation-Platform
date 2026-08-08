# Ollama Setup

This directory contains the Docker setup for Ollama, a local LLM (Large Language Model) service.

## Quick Start

### Start Ollama

```bash
cd /home/sanvi/Automation-Lab/Ollama
docker compose up -d
```

Ollama will be available at `http://localhost:11434`

### Stop Ollama

```bash
docker compose down
```

## Using Ollama

### Pull a Model

```bash
docker compose exec ollama ollama pull llama2
```

Available models:
- `llama2` - Meta's Llama 2 (7B, 13B, 70B variants)
- `mistral` - Mistral 7B
- `neural-chat` - Intel Neural Chat
- `dolphin-mixtral` - Dolphin Mixtral
- `orca-mini` - Orca Mini

### Run a Model

```bash
docker compose exec ollama ollama run llama2
```

### API Usage

Generate a completion:
```bash
curl http://localhost:11434/api/generate -d '{
  "model": "llama2",
  "prompt": "Why is the sky blue?",
  "stream": false
}'
```

Chat with a model:
```bash
curl http://localhost:11434/api/chat -d '{
  "model": "llama2",
  "messages": [
    {"role": "user", "content": "Hello!"}
  ]
}'
```

List available models:
```bash
curl http://localhost:11434/api/tags
```

## Configuration

### Environment Variables

- `OLLAMA_HOST` - Server address (default: 0.0.0.0:11434)
- `OLLAMA_MODELS` - Model storage location (default: ~/.ollama)

### GPU Acceleration (Optional)

To enable GPU acceleration with NVIDIA:

1. Install NVIDIA Docker runtime
2. Uncomment the `runtime: nvidia` section in docker-compose.yml
3. Uncomment the GPU environment variables in .env

Then restart:
```bash
docker compose down
docker compose up -d
```

## Integration with n8n

You can use Ollama with n8n by:

1. Creating HTTP requests to `http://ollama:11434/api/generate`
2. Using the Ollama node (if available)
3. Building custom workflows that call the Ollama API

## Troubleshooting

### Check Ollama Status

```bash
docker compose ps
```

### View Logs

```bash
docker compose logs -f ollama
```

### Available Models

```bash
docker compose exec ollama ollama list
```

### Remove a Model

```bash
docker compose exec ollama ollama rm llama2
```

## Performance Notes

- First model pull can take time (depends on model size and internet speed)
- Models are stored in `./data` directory
- Ensure sufficient disk space for models (models range from 4GB to 40GB+)
- GPU acceleration significantly improves inference speed (10-100x faster)
