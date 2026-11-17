<!-- --8<-- [start:setup-intro] -->
## Before You Run Examples

All examples in this page assume environment variables are available. For convenience, create a `.env` file in the repository root (you can copy from `.env.example`) with:

<!-- --8<-- [end:setup-intro] -->

<!-- --8<-- [start:setup-details] -->

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

```python title="common.py" linenums="1"
--8<-- "./examples/common.py"
```

</details>
<!-- markdownlint-enable MD033 -->

<!-- --8<-- [end:setup-details] -->