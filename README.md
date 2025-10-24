# TULIP quick tests

Minimal smoke tests for the OpenAI-compatible API exposed by NVIDIA Dynamo + vLLM on TULIP.

These scripts provide quick validation that a deployed endpoint conforms to standard OpenAI request and response formats for basic text completion and chat APIs.

## Setup

1 . Clone this repository and navigate into it:
   ```bash
   git clone https://gitlab.ewi.tudelft.nl/tulip/tulip-reference-tests.git
   cd tulip-reference-tests
   ```
2. Copy the example environment file and edit parameters as needed
```bash
cp .env.example .env
cat .env   # edit the base URL, key and model if needed
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

## Expected behaviour

These tests are minimal sanity checks, and are all based on official examples from the OpenAI [Python SDK](https://github.com/openai/openai-python/tree/main) and [API reference](https://platform.openai.com/docs/api-reference/responses/create). 

They send minimal sample requests to `/v1/chat/completions` and `/v1/responses`.

Some API features (e.g. images, audio, realtime) are not supported by the current backend stack (Dynamo / vLLM) or by the selected model (e.g. gpt-oss-20b).

Passing all non-streaming tests confirms that the endpoint is OpenAI-compatible for standard text completions.

## Notes

- These are reference tests, not benchmarks.
- The demo backend is a test environment on a single GPU node. Configuration and model availability may change while the prototype evolves.
