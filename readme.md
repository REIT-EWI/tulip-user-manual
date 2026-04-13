---
title: "Home"
---

## Tulip docs

Guides, tutorials, and reference information.

To view this documentation live, invoke:

```shell
cd docs/
uv run zensical serve
```

This will publish the documentation at [localhost:8000](http://localhost:8000/) by default, and watch for any changes to the documentation source files.

[Zensical Documentation](https://zensical.org/){ .md-button }

## Smoke gate

Two release gates live in `tests/` and both run a fixed, in-script test matrix (hardcoded checks and invocation order).

`smoke` runs hardcoded API calls in place (`models`, `chat/completions`, `embeddings`) with strict `jq` shape assertions.
`smoke-full` runs a hardcoded list of example scripts in place (7 bash + 8 Python) and gates on exit code.

1. Copy `.env.example` to `.env` and set `TUDELFT_TULIP_API_KEY`.
2. If your deployment uses non-default model aliases, override `TUDELFT_TULIP_CHAT_ALIAS`, `TUDELFT_TULIP_CODE_ALIAS`, and `TUDELFT_TULIP_EMBED_ALIAS` (all default to `chat`, `code`, `embed`).
3. Run `pixi run smoke` for the fast gate.
4. Run `pixi run smoke-full` to verify every example script runs successfully.

Each smoke script runs all checks, then exits `0` if all passed or non-zero if any failed.
Timestamped logs are written to `tests/logs/` for inspection.

### Smoke levels

| Level | Command | Coverage |
| --- | --- | --- |
| Fast | `pixi run smoke` | `/models` per namespace, one chat completion, one code completion, one embedding — with `jq` shape checks |
| Full | `pixi run smoke-full` | hardcoded list of all 7 bash (`curl-*.sh`) + all 8 Python (`python_*.py`) example scripts, executed directly (exit-code gate) |

`smoke` makes direct API calls with strong `jq` shape assertions.
`smoke-full` invokes each docs example script directly. It sets capability and model alias env vars per test, and each script also sources `.env` when present.

### Run one example manually

Examples source `./.env`, so `TUDELFT_TULIP_CAPABILITY` and `TUDELFT_TULIP_MODEL_ALIAS` from `.env` determine the route/model pair used by curl scripts.
Use `TUDELFT_TULIP_BASE_URL` as host root in `.env` (for example `https://api.tulip.tudelft.nl`); Python examples normalize it internally to capability-specific `/v1` endpoints.

If you see a `404` like `chat/completions` on `embed`, it usually means capability and endpoint intent do not match. For chat completions, use a chat/code capability and matching alias in `.env`.

```shell
bash examples/curl-chat-completions.sh
```

The scripts themselves exit non-zero on HTTP errors (all `curl` calls use `--fail`; Python uses the openai SDK which raises on non-2xx).

To run tests multiple times for consistency checking:

```shell
bash tests/smoke.sh --loop 3
bash tests/smoke-full.sh --loop 3
```
