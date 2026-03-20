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
    - Python examples load these values from `examples/common.py`.
    - Bash examples pretty-print JSON using [`jq`](https://jqlang.org/), so you may need to install it.
    - `TUDELFT_TULIP_CAPABILITY` chooses the path segment (`embed`).
    - `TUDELFT_TULIP_MODEL_ALIAS` chooses the deployed model alias.

!!! info "Endpoint"
    Embeddings are available at `/v1/embeddings`.

    *Reference:* [OpenAI Embeddings API](https://developers.openai.com/api/reference/resources/embeddings/methods/create).

## Supported Models

For available embedding models and the current model-to-alias mapping, see [Model Alias Mapping](../getting-started/model-mapping.md).

## Example Scripts

Both scripts perform the same two checks against `/v1/embeddings`.
Choose either Bash or Python based on your workflow.

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

## Validation Criteria

Checks:

- Embeddings endpoint availability.
- Vector dimensionality consistency.
- Different inputs produce different vectors.

!!! success "Success looks like"
    - You receive embedding vectors for both input strings.
    - Reported embedding dimensions are consistent (e.g., 4096).
    - The two sample outputs are different vectors (first elements are not identical).
