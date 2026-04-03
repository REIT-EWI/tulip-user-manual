# Embeddings

## Before You Run Examples

All examples in this page assume environment variables are available. For convenience, create a `.env` file in the repository root (you can copy from `.env.example`) with:

```dotenv
TUDELFT_TULIP_BASE_URL=https://api.tulip.tudelft.nl
TUDELFT_TULIP_API_KEY=YOUR_API_KEY
TUDELFT_TULIP_MODEL_ALIAS=embed
TUDELFT_TULIP_CAPABILITY=embed
```

!!! info "What these examples assume"
    - The Python snippets on this page assume a local helper file `common.py` that loads environment variables and exports shared constants.
    - If you cloned this repository, `examples/common.py` is already present and the scripts run as shown below.
    - If you have not cloned the repo and are working with Python, expand the helper snippet below and place `common.py` next to the example you want to run.
    - Python run commands use `pixi run python ...`; dependencies come from `pixi.toml`.
    - Bash examples pretty-print JSON using [`jq`](https://jqlang.org/), so you may need to install it.
    - `TUDELFT_TULIP_CAPABILITY` chooses the path segment (`embed`).
    - `TUDELFT_TULIP_MODEL_ALIAS` chooses the deployed model alias.

<!-- markdownlint-disable MD033 -->
<details>
<summary>If you have not cloned the repo and are working with Python, create common.py next to the example</summary>

```python title="common.py" linenums="1"
--8<-- "./examples/common.py"
```

</details>
<!-- markdownlint-enable MD033 -->

!!! info "Endpoint"
    Embeddings are available at `/v1/embeddings`.
    *For more,* see[OpenAI Embeddings API](https://developers.openai.com/api/reference/resources/embeddings/methods/create).

## Supported Models

For available embedding models and the current model-to-alias mapping, see [Model Alias Mapping](../getting-started/model-mapping.md).

## Example Scripts

=== "Bash"
    ```bash title="curl-embedding.sh" linenums="1"
    --8<-- "./examples/curl-embedding.sh"
    ```
    Run:
    ```bash
    bash examples/curl-embedding.sh
    ```

=== "Python"
    **SDK:** OpenAI Python client (`OpenAI`)
    ```python title="python_embedding.py" linenums="1"
    --8<-- "./examples/python_embedding.py"
    ```
    Run:
    ```bash
    pixi run python examples/python_embedding.py
    ```

!!! success "Success looks like"
    - You receive embedding vectors for both input strings.
    - Reported embedding dimensions are consistent (e.g., 4096).
    - The two sample outputs are different vectors (first elements are not identical).
