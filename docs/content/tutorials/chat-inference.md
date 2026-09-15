# Chat & General Inference

## Before You Run Examples

All examples in this page assume environment variables are available. For convenience, create a `.env` file in the repository root (you can copy from `.env.example`) with:

```dotenv
TUDELFT_TULIP_BASE_URL=https://api.tulip.tudelft.nl
TUDELFT_TULIP_API_KEY=YOUR_SRAM_APPLICATION_TOKEN
TUDELFT_TULIP_MODEL_ALIAS=chat
TUDELFT_TULIP_CAPABILITY=chat
```

Replace `YOUR_SRAM_APPLICATION_TOKEN` with your SRAM application token, used as the TULIP API key. See [Request Access](../getting-started/access.md).

Set `TUDELFT_TULIP_BASE_URL` to host root only (for example `https://api.tulip.tudelft.nl`). The Python helper normalizes it to a capability-specific `/v1` endpoint automatically.

!!! info "What these examples assume"
    - The Python snippets on this page assume a local helper file `common.py` that loads environment variables and exports shared constants.
    - If you cloned this repository, `examples/common.py` is already present and the scripts run as shown below.
    - If you have not cloned the repo and are working with Python, expand the helper snippet below and place `common.py` next to the example you want to run.
    - Python run commands use `pixi run python ...`; dependencies come from `pixi.toml`.
    - Bash examples pretty-print JSON using [`jq`](https://jqlang.org/), so you may need to install it.
    - `TUDELFT_TULIP_CAPABILITY` chooses the path segment (`chat`, `code`, `embed`).
    - `TUDELFT_TULIP_MODEL_ALIAS` chooses the deployed model alias.

<!-- markdownlint-disable MD033 -->
<details>
<summary>If you have not cloned the repo and are working with Python, create common.py next to the example</summary>

```python title="common.py" linenums="1"
--8<-- "./examples/common.py"
```

</details>
<!-- markdownlint-enable MD033 -->

This tutorial covers two endpoints:

- `/v1/responses`
- `/v1/chat/completions`

!!! info "Quick setup"
    - Use `curl-responses-basic.sh` / `python_responses_basic.py` for `/v1/responses`, and `curl-chat-completions.sh` / `python_chat_completions.py` for `/v1/chat/completions`.

## Responses API

!!! info "Recommended approach"
    OpenAI recommends `/v1/responses` for new projects. It supports all capabilities (`chat`, `code`, `embed`) and provides a unified interface for text and non-text outputs.
    *For more,* see[OpenAI Responses API](https://developers.openai.com/api/reference/resources/responses/methods/create).

=== "Bash"
    ```bash title="curl-responses-basic.sh" linenums="1"
    --8<-- "./examples/curl-responses-basic.sh"
    ```
    Run:
    ```bash
    bash examples/curl-responses-basic.sh
    ```

=== "Python"
    **SDK:** OpenAI Python client (`OpenAI`)
    ```python title="python_responses_basic.py" linenums="1"
    --8<-- "./examples/python_responses_basic.py"
    ```
    Run:
    ```bash
    pixi run python examples/python_responses_basic.py
    ```

!!! success "Success looks like"
    - Bash: `curl-responses-basic.sh` prints a valid JSON response object from `/v1/responses`.
    - Python: `python_responses_basic.py` prints extracted model text via `response.output_text`.

## Chat Completions

!!! warning "Legacy endpoint (chat/completions only)"
    `/v1/chat/completions` is available for **chat** and **code** capabilities only. It does not support embeddings. For new projects or to work with all capabilities uniformly, prefer `/v1/responses` above.
    *For more,* see[OpenAI Chat Completions API](https://developers.openai.com/api/reference/resources/chat/subresources/completions/methods/create).

=== "Bash"
    ```bash title="curl-chat-completions.sh" linenums="1"
    --8<-- "./examples/curl-chat-completions.sh"
    ```
    Run:
    ```bash
    bash examples/curl-chat-completions.sh
    ```

=== "Python"
    **SDK:** OpenAI Python client (`OpenAI`)
    ```python title="python_chat_completions.py" linenums="1"
    --8<-- "./examples/python_chat_completions.py"
    ```
    Run:
    ```bash
    pixi run python examples/python_chat_completions.py
    ```

!!! success "Success looks like"
    - Bash: `curl-chat-completions.sh` returns valid JSON from `/v1/chat/completions`.
    - Python: `python_chat_completions.py` prints assistant text from `completion.choices[0].message.content`.

## Async & Streaming (Python)

### Async responses

**SDK:** OpenAI Python async client (`AsyncOpenAI`)

```python title="python_responses_async.py" linenums="1"
--8<-- "./examples/python_responses_async.py"
```

Run:

```bash
pixi run python examples/python_responses_async.py
```

!!! success "Success looks like"
    - Script finishes normally and prints text output.
    - No async transport or timeout errors for a basic request.

### Streaming chat

**Endpoint pattern:** Chat completions with `stream=True`

!!! warning
    Some deployments may not expose OpenAI Responses streaming events yet.
    This example uses chat-completions streaming for maximum compatibility.
    *For more,* see[OpenAI Streaming Responses guide](https://developers.openai.com/api/docs/guides/streaming-responses).

```python title="python_responses_stream.py" linenums="1"
--8<-- "./examples/python_responses_stream.py"
```

Run:

```bash
pixi run python examples/python_responses_stream.py
```

!!! success "Success looks like"
    - Output appears progressively token-by-token or chunk-by-chunk.
    - Stream completes with no protocol or parsing errors.
