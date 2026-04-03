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
