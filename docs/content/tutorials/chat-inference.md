# Chat & General Inference

## Before You Run Examples

All examples in this page assume environment variables are available. For convenience, create a `.env` file in the repository root (you can copy from `.env.example`) with:

```dotenv
TUDELFT_TULIP_BASE_URL=https://api.tulip.tudelft.nl
TUDELFT_TULIP_API_KEY=YOUR_API_KEY
TUDELFT_TULIP_MODEL_ALIAS=chat
TUDELFT_TULIP_CAPABILITY=chat
```

!!! info "What these examples assume"
    - Python examples load these values from `examples/common.py`.
    - Bash examples pretty-print JSON using [`jq`](https://jqlang.org/), so you may need to install it.
    - `TUDELFT_TULIP_CAPABILITY` chooses the path segment (`chat`, `code`, `embed`).
    - `TUDELFT_TULIP_MODEL_ALIAS` chooses the deployed model alias.

This tutorial covers two endpoints:

- `/v1/responses`
- `/v1/chat/completions`

!!! info "Quick setup"
    - Use `curl-responses-basic.sh` / `python_responses_basic.py` for `/v1/responses`, and `curl-chat-completions.sh` / `python_chat_completions.py` for `/v1/chat/completions`.

## Responses API

!!! info "Recommended approach"
    OpenAI recommends `/v1/responses` for new projects. It supports all capabilities (`chat`, `code`, `embed`) and provides a unified interface for text and non-text outputs.
    
    *Reference:* [OpenAI Responses API](https://developers.openai.com/api/reference/resources/responses/methods/create).

### Bash

**Endpoint:** `/v1/responses`

```bash title="curl-responses-basic.sh" linenums="1"
--8<-- "./examples/curl-responses-basic.sh"
```

Checks:

- Basic request/response compatibility for the Responses API.
- A short text generation flow using `curl`.

Run:

```bash
bash examples/curl-responses-basic.sh
```

!!! success "Success looks like"
    - You receive a structured Responses API object from `/v1/responses`.
    - Output is valid JSON and includes model-generated text.

### Python

**SDK:** OpenAI Python client (`OpenAI`)

```python title="python_responses_basic.py" linenums="1"
--8<-- "./examples/python_responses_basic.py"
```

Checks:

- OpenAI-compatible `/v1/responses` behavior in Python.
- Basic text output extraction from `response.output_text`.

Run:

```bash
python examples/python_responses_basic.py
```

!!! success "Success looks like"
    - Script prints `response.output_text`.
    - Request succeeds without client-side errors.

## Chat Completions

!!! warning "Legacy endpoint (chat/completions only)"
    `/v1/chat/completions` is available for **chat** and **code** capabilities only. It does not support embeddings. For new projects or to work with all capabilities uniformly, prefer `/v1/responses` above.

    *Reference:* [OpenAI Chat Completions API](https://developers.openai.com/api/reference/resources/chat/subresources/completions/methods/create).

### Bash

Example script:

```bash title="curl-chat-completions.sh" linenums="1"
--8<-- "./examples/curl-chat-completions.sh"
```

Checks:

- The chat endpoint is reachable.
- Your selected model can generate a regular assistant reply.

Run:

```bash
bash examples/curl-chat-completions.sh
```

!!! success "Success looks like"
    - `/v1/chat/completions` returns valid JSON with assistant content.

### Python

**SDK:** OpenAI Python client (`OpenAI`)

```python title="python_chat_completions.py" linenums="1"
--8<-- "./examples/python_chat_completions.py"
```

Checks:

- OpenAI-compatible chat-completions behavior through the Python SDK.
- Basic message formatting and response parsing.

Run:

```bash
python examples/python_chat_completions.py
```

!!! success "Success looks like"
    - Script prints assistant text from `completion.choices[0].message.content`.
    - No client or serialization errors are raised.

## Async & Streaming (Python)

### Async responses

**SDK:** OpenAI Python async client (`AsyncOpenAI`)

```python title="python_responses_async.py" linenums="1"
--8<-- "./examples/python_responses_async.py"
```

Checks:

- Asynchronous request flow for `/v1/responses`.
- Event-loop compatibility for simple async generation.

Run:

```bash
python examples/python_responses_async.py
```

!!! success "Success looks like"
    - Script finishes normally and prints text output.
    - No async transport or timeout errors for a basic request.

### Streaming chat

**Endpoint pattern:** Chat completions with `stream=True`

!!! warning
    Some deployments may not expose OpenAI Responses streaming events yet.
    This example uses chat-completions streaming for maximum compatibility.
    
    *Reference:* [OpenAI Streaming Responses guide](https://developers.openai.com/api/docs/guides/streaming-responses).

```python title="python_responses_stream.py" linenums="1"
--8<-- "./examples/python_responses_stream.py"
```

Checks:

- Streaming chunk emission from the model.
- Incremental rendering of partial deltas.

Run:

```bash
python examples/python_responses_stream.py
```

!!! success "Success looks like"
    - Output appears progressively token-by-token or chunk-by-chunk.
    - Stream completes with no protocol or parsing errors.
