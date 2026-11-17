# Embeddings

--8<-- "./docs/content/tutorials/includes/setup.md:setup-intro"

```dotenv
TUDELFT_TULIP_BASE_URL=https://api.tulip.tudelft.nl
TUDELFT_TULIP_API_KEY=YOUR_SRAM_APPLICATION_TOKEN
TUDELFT_TULIP_MODEL_ALIAS=embed
TUDELFT_TULIP_CAPABILITY=embed
```

The `embed` capability selects the embedding endpoint, and the `embed` model alias
selects its deployed model. See [Model Alias Mapping](../getting-started/model-mapping.md)
for the current embedding model behind that alias.

--8<-- "./docs/content/tutorials/includes/setup.md:setup-details"

!!! info "Endpoint"
    Embeddings are available at `/v1/embeddings`.
    *For more,* see [OpenAI Embeddings API](https://developers.openai.com/api/reference/resources/embeddings/methods/create).

## Single-input examples

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
    - A single input string returns an embedding vector.
    - The returned vector has the dimensionality of the deployed embedding model.

## Batch requests—known limitation

!!! warning "Known limitation"
    In the current TULIP deployment, requests containing multiple input strings
    have been observed to fail with HTTP 500 (`Failed to fold embeddings stream`).
    Submit strings individually as a workaround.

These examples reproduce the limitation and can be used to retest batch support.

=== "Bash"
    ```bash title="curl-embedding-batch.sh" linenums="1"
    --8<-- "./examples/curl-embedding-batch.sh"
    ```
    Run:
    ```bash
    bash examples/curl-embedding-batch.sh
    ```

=== "Python"
    ```python title="python_embedding_batch.py" linenums="1"
    --8<-- "./examples/python_embedding_batch.py"
    ```
    Run:
    ```bash
    pixi run python examples/python_embedding_batch.py
    ```
