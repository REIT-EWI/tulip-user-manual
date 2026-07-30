# Hermes Integration

Use the [Hermes agent harness](https://hermes-agent.nousresearch.com/) by Nous Research with TULIP as its model backend.

## Prerequisites

- Hermes installed (desktop app or CLI)
- A valid TULIP API key or SRAM personal token
- Access to the TU Delft network (or eduVPN)

## Setup

Hermes reads its configuration from `~/.hermes/config.yaml`. Define TULIP as a named provider so it appears under its own name in the Hermes menus:

```yaml
model:
  provider: custom:tulip
  default: chat
providers:
  tulip:
    api: https://api.tulip.tudelft.nl/chat/v1
    name: "TULIP"
    api_key: YOUR_TULIP_TOKEN
    default_model: chat
    models:
      chat:
        context_length: 65536
```

`chat` is the model id sent in requests (the TULIP chat endpoint serves this single model); `name` is only the display label. Hermes sends OpenAI-format requests directly to the configured `api` URL.

After changing the configuration, quit Hermes completely (Cmd+Q on macOS; closing the window is not enough) and reopen it.

## Desktop app note

With a named provider the desktop model picker lists the model under the configured display name after a full restart of the app (Cmd+Q, not just closing the window). Some desktop versions do not list custom endpoints in the picker ([tracked upstream](https://github.com/NousResearch/hermes-agent/issues/38975)); sessions then still use `model.default` from the config file, so start a chat without selecting a model. The Hermes CLI reads the same configuration and is unaffected either way.

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
