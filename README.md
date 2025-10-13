# TULIP quick tests

Minimal smoke tests for the OpenAI-compatible API exposed by NVIDIA Dynamo + vLLM on TULIP.

## Setup

```bash
cd apps/quick-tests
cp .env.example .env   # edit the base URL, key and model if needed
```

## Run tests

Using `pixi` (recommended):
```bash
pixi run chat     # chat_completions.py
pixi run resp     # responses_basic.py
pixi run async    # responses_async.py
pixi run stream   # responses_stream.py (only if backend supports streaming)
pixi run curl     # curl + jq smoke test
```

## Notes / expectations

These tests are minimal sanity checks, and are all based on official examples from the OpenAI [Python SDK](https://github.com/openai/openai-python/tree/main) and [API reference](https://platform.openai.com/docs/api-reference/responses/create). 

Some API features (e.g. images, audio, realtime) are not supported by the current backend stack (Dynamo / vLLM) or by the selected model (e.g. gpt-oss-20b).

Passing all non-streaming tests confirms that the endpoint is OpenAI-compatible for standard text completions.