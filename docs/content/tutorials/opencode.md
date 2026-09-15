# OpenCode Integration

Use [OpenCode](https://opencode.ai) as an AI coding assistant with TULIP.

## Prerequisites

- OpenCode installed, for example with `curl -fsSL https://opencode.ai/install | bash`. See the [OpenCode installation documentation](https://opencode.ai/docs/#install) for other installation methods.
- An SRAM application token to use as your TULIP API key. See [Request Access](../getting-started/access.md).
- Access to the TU Delft network, either on campus or through [eduVPN](https://tudelft.eduvpn.nl/portal/home).

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
```

!!! note "Using another TULIP model"
    Each TULIP model has a corresponding endpoint and model alias. When changing models, update both `baseURL` and the key under `models`.
    See [Model Mapping](../getting-started/model-mapping.md) for the available aliases and their current backing models.
    To configure multiple TULIP models simultaneously, define a separate OpenCode provider for each one because `baseURL` is configured at the provider level.

### 2. Set your API key

Set your SRAM application token as `TUDELFT_TULIP_API_KEY` in your shell profile (`~/.bashrc`, `~/.zshrc`, or equivalent):

```bash
export TUDELFT_TULIP_API_KEY="YOUR_SRAM_APPLICATION_TOKEN"
```

Open a new terminal, or reload your current shell configuration:

```bash
source ~/.bashrc
```

For Zsh, use `source ~/.zshrc` instead.

### 3. Verify the connection

Run a simple request using the configured provider and model:

```bash
opencode run --model tudelft-tulip/code "Reply with OK."
```

A successful response confirms that OpenCode can authenticate with TULIP and access the coding endpoint.

## Usage

From the project directory in which you want to work, start OpenCode with the TULIP coding model:

```bash
opencode --model tudelft-tulip/code
```

Use `/models` within OpenCode to view or select configured models.

!!! warning
    OpenCode can read and modify files and run commands in its working directory. Start it in the intended project directory and review requested actions before approving them.

## Troubleshooting

### Unauthorized

Check whether the TULIP API key environment variable is set:

```bash
test -n "$TUDELFT_TULIP_API_KEY" \
  && echo "TULIP API key is set" \
  || echo "TULIP API key is not set"
```

Also ensure that the `apiKey` field in `opencode.json` uses the correct syntax:

```json
"apiKey": "{env:TUDELFT_TULIP_API_KEY}"
```

Restart OpenCode after setting or changing the environment variable.

### Connection timeout or request blocked

Verify that you are connected to the TU Delft network, either on campus or through [eduVPN](https://tudelft.eduvpn.nl/portal/home).

### Model not found

Ensure that the endpoint and model alias correspond. For example, the `code` alias must be used with the `/code/v1` endpoint.

Use the TULIP model alias in OpenCode, not the backing model name shown in [Model Mapping](../getting-started/model-mapping.md).

To check the models configured for the provider, run:

```bash
opencode models tudelft-tulip
```

The output should include `tudelft-tulip/code`.
