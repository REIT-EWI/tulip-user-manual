# OpenCode Integration

Use [OpenCode](https://opencode.ai) as an AI coding assistant with TULIP.

## Prerequisites

- Having OpenCode installed (eg, via `curl -fsSL https://opencode.ai/install | bash` or your choice among their [other installation methods](https://opencode.ai/docs#install))
- A valid TULIP API key
- Access to the TU Delft network (or eduVPN)

## Setup

### 1. Configure OpenCode

Create or edit `~/.config/opencode/opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "tudelft-tulip": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "TU Delft TULIP",
      "options": {
        "baseURL": "https://api.tulip.tudelft.nl/code/v1",
        "apiKey": "{env:TUDELFT_TULIP_API_KEY}"
      },
      "models": {
        "code": {
          "name": "TULIP Code"
        }
      }
    }
  }
}

!!! note "Using another TULIP model"
- Each TULIP model has a corresponding endpoint and model alias. When changing models, update both `baseURL` and the key under `models`.
- See [Model Mapping](../getting-started/model-mapping.md) for the available aliases and their current backing models.
- To configure multiple TULIP models simultaneously, define a separate OpenCode provider for each one because `baseURL` is configured at the provider level.

### 2. Set Your API Key

Add the environment variable to your shell profile (`~/.bashrc`, `~/.zshrc`, or equivalent):

```bash
export TUDELFT_TULIP_API_KEY="your-tulip-api-key"
```

Reload your shell or run `` (or `~/.zshrc`).

### 3. Verify the connection

Run a simple request using the configured provider and model:

```bash
opencode run --model tudelft-tulip/code "Reply with OK."
```

A response confirms that OpenCode can authenticate with TULIP and access the code endpoint as below:

```bash
> build · code

The user wants me to simply reply with "OK". This is a straightforward request with no tools needed.
</think>

OK
```

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

Use `/connect` to manage provider connections.

!!tip "Different TULIP models as different providors" You can add additional TULIP models as additionals providors, since both endpoint path and model name vary between models



## Troubleshooting

### "Unauthorized" or "request was blocked"

1. Verify `TUDELFT_TULIP_API_KEY` is set: `echo $TUDELFT_TULIP_API_KEY`
2. Ensure the `apiKey` field in `opencode.json` uses the correct syntax: `"{env:TUDELFT_TULIP_API_KEY}"`

### Connection timeout

Verify you are on the TU Delft network or connected via [eduVPN](https://tudelft.eduvpn.nl/portal/home).

### Model not found

Ensure that the endpoint and model alias correspond. For example, the `code` alias must be used with the `/code/v1` endpoint.

Use the TULIP model alias in OpenCode, not the backing model name shown
in [Model Mapping](../getting-started/model-mapping.md).
