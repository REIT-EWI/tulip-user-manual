# Your First Request

## The Basics

TULIP exposes a single, unified API at <https://api.tulip.tudelft.nl> with OpenAI-compatible endpoints for three capabilities:

| Capability | Base Path | Use Case |
| --- | --- | --- |
| **Chat** | `/chat/v1` | Conversational AI with reasoning & tool calling |
| **Code** | `/code/v1` | Code generation and reasoning |
| **Embeddings** | `/embed/v1` | Text vectorization for semantic search & RAG |

!!! warning "TU Delft Network Access Required"
    TULIP is only reachable from the TU Delft network. Off campus, you must connect via [eduVPN](https://tudelft.eduvpn.nl/portal/home).

## Authentication

Every request carries a credential in the `Authorization: Bearer` header. TULIP accepts two kinds:

- **SRAM personal token** (recommended): join the `tudelfttulip` collaboration in [SURF Research Access Management](https://sram.surf.nl/), then create a personal token on your SRAM profile page. Your access tier follows your group membership in the collaboration. Tokens are self-service: you can create and revoke them without contacting the TULIP team.
- **Legacy API key** (`sk-tulip-...`): keys issued before the SRAM migration keep working during the migration period and will be retired afterwards. New users should use SRAM tokens.

The examples below work identically with either credential; set it as `TUDELFT_TULIP_API_KEY`.

## Your First Request

Both examples below use the **Chat Completions** API.
If you want configurable model selection (for example via `TUDELFT_TULIP_MODEL_ALIAS`), continue with [Chat & General Inference](../tutorials/chat-inference.md).

### Using `cURL`

!!! tip "Try It Yourself"
    This shell example expects `TUDELFT_TULIP_API_KEY` to be set and also uses [`jq`](https://jqlang.org/).
    To keep setup simple, it uses the default `chat` model in the request body.

```bash title="curl-hello-tulip.sh" linenums="1"
--8<-- "./examples/curl-hello-tulip.sh"
```

And simply run:

```bash
bash curl-hello-tulip.sh
```

### Using Python (OpenAI SDK)

!!! tip "Try It Yourself"
    The Python example reads `TUDELFT_TULIP_API_KEY` from `.env` if present and assumes `openai` and `python-dotenv` are installed.
    To keep setup simple, it uses the default `chat` model in the request body.

```python title="python_hello_tulip.py" linenums="1"
--8<-- "./examples/python_hello_tulip.py"
```

And run:

```bash
python python_hello_tulip.py
```
