# Hermes Integration

Use the [Hermes agent harness](https://hermes-agent.nousresearch.com/) by Nous Research with TULIP as its model backend.

## Prerequisites

- Hermes installed (desktop app or CLI)
- A valid TULIP API key or SRAM personal token
- Access to the TU Delft network (or eduVPN)

## Setup

Hermes reads its configuration from `~/.hermes/config.yaml`. Point the main model at TULIP by setting a custom base URL:

```yaml
model:
  default: chat
  provider: custom
  base_url: https://api.tulip.tudelft.nl/chat/v1
  api_key: YOUR_TULIP_TOKEN
```

`default` is the model name sent in requests; use `chat` for the chat endpoint (see [Available Models](../getting-started/model-mapping.md)). When `base_url` is set, Hermes bypasses its built-in providers and sends OpenAI-format requests directly to that URL.

Instead of `api_key` in the config file, the token can be placed in `~/.hermes/.env` as `OPENAI_API_KEY=YOUR_TULIP_TOKEN`. Setting it inline in `config.yaml` is the more reliable option with the current desktop app.

After changing the configuration, quit Hermes completely (Cmd+Q on macOS; closing the window is not enough) and reopen it.

## Desktop app limitation

The Hermes desktop model picker only lists built-in providers and does not show custom endpoints ([tracked upstream](https://github.com/NousResearch/hermes-agent/issues/38975)). New sessions still use the `model.default` from the config file, so start a chat without selecting a model in the picker. The Hermes CLI reads the same configuration and is not affected.

## Auxiliary model routing

To keep another provider as the main model and route only specific tasks to TULIP, use an `auxiliary` block instead:

```yaml
auxiliary:
  compression:
    base_url: https://api.tulip.tudelft.nl/chat/v1
    api_key: YOUR_TULIP_TOKEN
    model: chat
```

## Troubleshooting

### HTTP 401: Missing Authentication header

Hermes did not send the token. Set `api_key` directly in the `model:` block of `~/.hermes/config.yaml` and fully restart the app.

### Connection timeout

Verify you are on the TU Delft network or connected via [eduVPN](https://tudelft.eduvpn.nl/portal/home).

### Unsupported parameter errors

TULIP supports a subset of OpenAI parameters (`temperature`, `top_k`, `top_p`). If Hermes sends others and requests fail, check the request log in `~/.hermes/logs/`.

## References

- [Hermes configuration documentation](https://hermes-agent.nousresearch.com/docs/user-guide/configuration)
