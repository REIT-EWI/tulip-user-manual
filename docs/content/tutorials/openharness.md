# OpenHarness Integration

Use [OpenHarness](https://github.com/anthropics/openharness) as an AI coding assistant with TULIP.

## Prerequisites

- OpenHarness installed (`pip install openharness` or `uv tool install openharness`)
- A valid TULIP API key
- Access to the TU Delft network (or eduVPN)

## Setup

### 1. Create the Provider Profile

```bash
oh provider add tulip \
  --label "TU Delft Tulip" \
  --provider openai \
  --api-format openai \
  --auth-source openai_api_key \
  --model "chat" \
  --base-url "https://api.tulip.tudelft.nl/chat/v1" \
  --credential-slot tulip
```

### 2. Store Your API Key

Edit the credentials file:

```bash
nano ~/.openharness/credentials.json
```

Add your TULIP API key with the `profile:tulip` key:

```json
{
  "profile:tulip": {"api_key": "your-tulip-api-key"}
}
```

**Multiple providers:** If you have other providers configured (e.g., OpenAI),
keep them alongside the TULIP entry:

```json
{
  "openai": {"api_key": "sk-your-openai-key"},
  "profile:tulip": {"api_key": "your-tulip-api-key"}
}
```

### 3. Activate the Profile

```bash
oh provider use tulip
```

### 4. Verify

```bash
oh -p "hello"
```

You should see a response from TULIP.

## Usage

Start an interactive coding session:

```bash
oh
```

Run a single prompt:

```bash
oh -p "Explain this Python code: def fib(n): return n if n < 2 else fib(n-1) + fib(n-2)"
```

## Switching Providers

```bash
oh provider use tulip      # Use TULIP
oh provider use claude-api # Switch to Claude
oh provider list           # Show all configured providers
```

## Troubleshooting

### "No API key configured"

Ensure `~/.openharness/credentials.json` contains `"profile:tulip"` with the `profile:` prefix.

### Connection timeout

Verify you are on the TU Delft network or connected via [eduVPN](https://tudelft.eduvpn.nl/portal/home).

### Model not found

The default model is `chat`. See [Model Mapping](../getting-started/model-mapping.md) for available models.
