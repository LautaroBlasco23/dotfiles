# Ollama Model Configuration for Opencode

This directory contains the configuration for using local Ollama models with Opencode agents.

## Installed Models

The following models have been installed via Ollama:

1. **phi3:mini** (2.2 GB) - General-purpose agent with strong reasoning
2. **tinyllama:1.1b** (637 MB) - Research/fast-info-gatherer agent
3. **codellama:7b-instruct** (3.8 GB) - Coding-specialized agent

## Configuration

The agent configuration is stored in `opencode.json`:

```json
{
  "version": "1.0.0",
  "agents": {
    "general": {
      "provider": "ollama",
      "model": "phi3:mini",
      "settings": {
        "temperature": 0.7,
        "num_ctx": 32768
      }
    },
    "research": {
      "provider": "ollama",
      "model": "tinyllama:1.1b",
      "settings": {
        "temperature": 0.3,
        "num_ctx": 8192
      }
    },
    "coding": {
      "provider": "ollama",
      "model": "codellama:7b-instruct",
      "settings": {
        "temperature": 0.2,
        "num_ctx": 16384
      }
    }
  }
}
```

## Agent Purposes

### General Agent (phi3:mini)
- **Purpose**: Smart + fast agent for debugging, planning, and code implementation
- **Strengths**: Strong reasoning (MMLU ~69%), 128k context, ~15 tok/s on CPU
- **Use Cases**: Debugging, planning, general code implementation

### Research Agent (tinyllama:1.1b)
- **Purpose**: Fast info-gatherer for scanning files, summarizing snippets
- **Strengths**: Very lightweight, ~30 tok/s, excellent speed for look-ups
- **Use Cases**: File scanning, snippet summarization, information gathering

### Coding Agent (codellama:7b-instruct)
- **Purpose**: Code-specialized agent for writing/modifying code
- **Strengths**: Trained on code, solid generation quality (~HumanEval 35%), 8 tok/s
- **Use Cases**: Writing new code, modifying existing code, code generation

## Usage

To use these agents in your Opencode workflow:

1. Ensure Ollama is running: `ollama serve`
2. Opencode will automatically use the configured models based on agent type
3. You can reference agents by their purpose:
   - Use the general agent for planning and debugging tasks
   - Use the research agent for information gathering and file analysis
   - Use the coding agent for implementation and code modification tasks

## Customization

You can adjust the settings in `opencode.json`:
- `temperature`: Controls randomness (lower = more deterministic)
- `num_ctx`: Context window size (adjust based on your needs)

For larger context windows in research tasks, you can increase the `num_ctx` value for the research agent.