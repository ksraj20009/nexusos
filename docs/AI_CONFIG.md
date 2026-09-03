# NexusOS AI Configuration Guide

## Overview

The Nexus AI assistant runs as a systemd service on `127.0.0.1:5210`. It provides:
- Web search (DuckDuckGo + Wikipedia)
- OS control (open apps, run commands)
- Voice recognition (offline, Vosk)
- Local LLM integration (Ollama)
- REST API for programmatic access

## Configuration

Edit the config file:
```bash
sudo nano /opt/nexusos/ai/config.yaml
```

Restart the service:
```bash
sudo systemctl restart nexus-ai
```

## Voice Recognition

### Requirements
- Vosk model (Indian English)
- Microphone access
- `python-vosk` and `python-sounddevice` packages

### Download voice model
```bash
sudo mkdir -p /opt/nexusos/ai/models
cd /opt/nexusos/ai/models
sudo wget https://alphacephei.com/vosk/models/vosk-model-small-en-in-0.4.zip
sudo unzip vosk-model-small-en-in-0.4.zip
sudo rm vosk-model-small-en-in-0.4.zip
```

### Change wake word
Edit `config.yaml`:
```yaml
voice:
  wake_word: "computer"  # Default: "nexus"
```

### Supported languages
Download other Vosk models from https://alphacephei.com/vosk/models:
- `vosk-model-small-en-us-0.15` (US English)
- `vosk-model-small-hi-0.22` (Hindi)
- `vosk-model-small-ta-0.22` (Tamil)
- `vosk-model-small-te-0.22` (Telugu)

## Local LLM (Ollama)

### Install Ollama
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

### Download a model
```bash
ollama pull llama3.2      # Default, 3.8B params, ~2GB
ollama pull mistral       # 7B params, ~4GB
ollama pull phi3          # 3.8B params, ~2GB
ollama pull gemma2        # 9B params, ~5GB
```

### Change model
Edit `config.yaml`:
```yaml
llm:
  model: "mistral"
```

### Disable LLM (use web search only)
```yaml
llm:
  enabled: false
```

## REST API

### Ask a question
```bash
curl -X POST http://127.0.0.1:5210/query \
  -H "Content-Type: application/json" \
  -d '{"query": "search for best laptops"}'
```

### Get system status
```bash
curl http://127.0.0.1:5210/status
```

### Start voice listening
```bash
curl -X POST http://127.0.0.1:5210/voice/start
```

### Get conversation history
```bash
curl http://127.0.0.1:5210/history
```

### Clear conversation
```bash
curl -X POST http://127.0.0.1:5210/context/clear
```

## CLI Mode

Run the AI in terminal:
```bash
nexus-ai
```

Or ask a single question:
```bash
nexus-ai "what time is it?"
```

## Command Reference

| Command | Example | Description |
|---------|---------|-------------|
| search | "search for AI news" | Web search |
| alternatives | "alternatives for Notion" | Find software alternatives |
| open | "open browser" | Launch application |
| run | "run ls -la" | Execute shell command |
| list files | "list files /home" | List directory |
| system status | "system status" | System info |
| lock | "lock screen" | Lock screen |
| help | "help" | Show all commands |

## Integration

### From a web app
```javascript
const response = await fetch('http://127.0.0.1:5210/query', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ query: 'what is the weather?' })
});
const result = await response.json();
console.log(result.data.response);
```

### From a Python script
```python
import requests
response = requests.post('http://127.0.0.1:5210/query', json={'query': 'open browser'})
print(response.json()['data']['response'])
```