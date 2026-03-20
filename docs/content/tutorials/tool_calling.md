# Tool Calling

## Before You Run Examples

All examples in this page assume environment variables are available. For convenience, create a `.env` file in the repository root (you can copy from `.env.example`) with:

```dotenv
TUDELFT_TULIP_BASE_URL=https://api.tulip.tudelft.nl
TUDELFT_TULIP_API_KEY=YOUR_API_KEY
TUDELFT_TULIP_MODEL_ALIAS=code
TUDELFT_TULIP_CAPABILITY=code
```

!!! info "What these examples assume"
    - Python examples load these values from `examples/common.py`.
    - Bash examples pretty-print JSON using [`jq`](https://jqlang.org/), so you may need to install it.
    - `TUDELFT_TULIP_CAPABILITY` chooses the path segment (for example `code` or `chat`).
    - `TUDELFT_TULIP_MODEL_ALIAS` chooses the deployed model alias.
    - For strict OpenAI-style `tool_calls` output, use the currently verified `code` alias.

!!! info "Endpoint"
    Tool calling is available at `/v1/chat/completions` via the `tools` parameter.

!!! warning "Endpoint And Format Limitations"
    - These examples use **Chat Completions** endpoint (`client.chat.completions.create`, `messages=[...]`).
    - Although OpenAI also documents a **Responses API** variant (`client.responses.create`, `input=[...]`), tool calling via Responses currently does **not** work in this environment due to a backend serving limitation.
    - Tool-calling output shape is model/capability dependent; some configurations emit raw tool markup in `message.content` instead of structured `message.tool_calls`.
    - For strict OpenAI-style checks in this tutorial, treat a non-empty `message.tool_calls` array as the pass condition.

    *Reference:* [OpenAI Function Calling Guide](https://developers.openai.com/api/docs/guides/function-calling).

## Supported Models

For available aliases and current backing models, see [Model Alias Mapping](../getting-started/model-mapping.md).

## Emission Test

=== "Bash"

    ```bash title="curl-tool-call-emission.sh" linenums="1"
    --8<-- "examples/curl-tool-call-emission.sh"
    ```

    Run:

    ```bash
    bash examples/curl-tool-call-emission.sh
    ```

=== "Python"

    **SDK:** OpenAI Python client (`OpenAI`)

    ```python title="python_tool_call_emission.py" linenums="1"
    --8<-- "examples/python_tool_call_emission.py"
    ```

    Run:

    ```bash
    pixi run python examples/python_tool_call_emission.py
    ```

!!! success "Success looks like"

    - Response includes a `tool_calls` array.
    - The requested tool name and arguments are present in output.

## Loop Test

=== "Bash"

    ```bash title="curl-tool-call-loop.sh" linenums="1"
    --8<-- "examples/curl-tool-call-loop.sh"
    ```

    Run:

    ```bash
    bash examples/curl-tool-call-loop.sh
    ```

=== "Python"

    **SDK:** OpenAI Python client (`OpenAI`)

    ```python title="python_tool_call_loop.py" linenums="1"
    --8<-- "examples/python_tool_call_loop.py"
    ```

    Run:

    ```bash
    pixi run python examples/python_tool_call_loop.py
    ```

!!! success "Success looks like"

    - The model consumes the provided tool message.
    - Final assistant response is coherent and consistent with tool output.
