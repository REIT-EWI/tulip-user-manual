# API Reference

## API Endpoint

TULIP exposes a single API domain: https://api.tulip.tudelft.nl

!!! info "Update"

    The previous endpoint `https://embedding.tulip.tudelft.nl` has been phased out. 
    Embedding models are now available under the unified API domain: `https://api.tulip.tudelft.nl/embed/v1`.

## Authentication

Authentication is required for all endpoints.

Set your key with:

```bash
export TUDELFT_TULIP_API_KEY="<your_api_key>"
```

If you need access, get in touch at [tulip-reit@tudelft.nl](mailto:tulip-reit@tudelft.nl).

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
