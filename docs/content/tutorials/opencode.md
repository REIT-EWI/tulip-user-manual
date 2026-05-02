# OpenCode Integration

Use [OpenCode](https://opencode.ai) as an AI coding assistant with TULIP.

## Prerequisites

- OpenCode installed (`npm install -g opencode` or via [installation docs](https://opencode.ai/docs/installation/))
- A valid TULIP API key
- Access to the TU Delft network (or eduVPN)

## Setup

### 1. Create the Configuration File

Create or edit `~/.config/opencode/opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "tudelft-tulip": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "TU Delft Tulip",
      "options": {
        "baseURL": "https://api.tulip.tudelft.nl/chat/v1",
        "apiKey": "{env:TUDELFT_TULIP_API_KEY}"
      },
      "models": {
        "chat": {
          "name": "Tulip Chat"
        }
      }
    }
  }
}
```

### 2. Set Your API Key

Add the environment variable to your shell profile (`~/.bashrc`, `~/.zshrc`, or equivalent):

```bash
export TUDELFT_TULIP_API_KEY="your-tulip-api-key"
```

Reload your shell or run `source ~/.bashrc` (or `~/.zshrc`).

### 3. Verify

```bash
opencode
```

Select the `TU Delft Tulip` provider and `Tulip Chat` model when prompted.

## Usage

Start an interactive coding session:

```bash
opencode
```

Use `/models` to switch models mid-session.

Use `/connect` to manage provider connections.

## Troubleshooting

### "Unauthorized" or "request was blocked"

1. Verify `TUDELFT_TULIP_API_KEY` is set: `echo $TUDELFT_TULIP_API_KEY`
2. Ensure the `apiKey` field in `opencode.json` uses the correct syntax: `"{env:TUDELFT_TULIP_API_KEY}"`

### Connection timeout

Verify you are on the TU Delft network or connected via [eduVPN](https://tudelft.eduvpn.nl/portal/home).

### Model not found

The default model is `chat`. See [Model Mapping](../getting-started/model-mapping.md) for available models.
