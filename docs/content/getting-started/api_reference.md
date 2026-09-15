# API Reference

## API Endpoint

TULIP exposes a single API domain: <https://api.tulip.tudelft.nl>

!!! warning "TU Delft Network Access Required"
    TULIP is only reachable from the TU Delft network. Off campus, you must connect via [eduVPN](https://tudelft.eduvpn.nl/portal/home) before using this endpoint.

!!! info "Update"
    The previous endpoint `https://embedding.tulip.tudelft.nl` has been phased out.
    Embedding models are now available under the unified API domain: `https://api.tulip.tudelft.nl/embed/v1`.

## Authentication

Authentication is required for all endpoints. Use your **SRAM application token** as the API key. Requests send it in the `Authorization: Bearer` header.

Set your SRAM application token with:

```bash
export TUDELFT_TULIP_API_KEY="YOUR_SRAM_APPLICATION_TOKEN"
```

See [Request Access](access.md) for instructions on joining the collaboration and creating your SRAM application token.

## Usage limits

TULIP currently applies protective request limits at the ingress layer to help prevent overload during early use.

At the moment:

- limits are applied per client IP
- `chat`/`code` routes are more restrictive than `embeddings`
- requests may return `503` if limits are exceeded

!!! warning "Usage Limits"
    If you encounter unexpected errors or unusual latency during normal use, especially from notebooks or scripts, please get in touch at [tulip-reit@tudelft.nl](mailto:tulip-reit@tudelft.nl).

## Available Endpoints

Each capability exposes its own OpenAI-compatible API namespace:

| Endpoint                    | Purpose               | Example                                                 |
| --------------------------- | --------------------- | ------------------------------------------------------- |
| `/chat/v1/chat/completions` | Chat-style interactions (messages)     | `https://api.tulip.tudelft.nl/chat/v1/chat/completions` |
| `/chat/v1/completions`      | Text completion (prompt → text)       | `https://api.tulip.tudelft.nl/chat/v1/completions`      |
| `/chat/v1/responses`        | Unified endpoint (recommended)      | `https://api.tulip.tudelft.nl/chat/v1/responses`        |
| `/chat/v1/models`           | List chat models      | `https://api.tulip.tudelft.nl/chat/v1/models`           |
| `/code/v1/models`           | List coding models    | `https://api.tulip.tudelft.nl/code/v1/models`           |
| `/embed/v1/models`          | List embedding models | `https://api.tulip.tudelft.nl/embed/v1/models`          |
| `/embed/v1/embeddings`      | Generate embeddings   | `https://api.tulip.tudelft.nl/embed/v1/embeddings`      |

## Examples

For runnable `curl` and Python examples, see:

- [Your First Request](./first-interaction.md)
