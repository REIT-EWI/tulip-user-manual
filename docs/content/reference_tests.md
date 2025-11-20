# Reference Tests for the LLM API

This page points to small, self-contained tests for **TULIP**. It is meant for **early testers** to:

- Verify that the TULIP API endpoint is reachable.
- Send basic `/v1/chat/completions`, `/v1/completions`, and `/v1/responses` requests.
- Explore latency, context-length limits, and streaming behaviour.
- Provide minimal working examples to integrate into research code.

## Setup

1. Clone this repository and navigate into it:
   ```bash
   git clone https://gitlab.ewi.tudelft.nl/tulip/reference-tests.git
   cd reference-tests
   ```

2. Copy the example environment file and edit its variables if needed:
   ```bash
   cp .env.example .env
   cat .env # to view current settings
   ```

Where:

   - `BASE_URL`: defaults to the production endpoint (https://api.tulip.tudelft.nl). 
   - `MODEL`: a model available on the backend (e.g. `Qwen/Qwen2.5-Coder-14B-Instruct`). You can check available models by checking `https://api.tulip.tudelft.nl/v1/models`.
   - `API_KEY`: unused for now but kept for forward compatibility



## Running tests

Each of the following scripts uses the values in `.env` and/or a shared helper (`common.py`).

Using `pixi` (recommended):

```bash
# Bash examples
pixi run curl_responses     # curl_responses.sh 
pixi run curl_chat          # curl_chat.sh

# Python examples
pixi run chat     # chat_completions.py --> /v1/chat/completions. Not supported for mistralai/Ministral-8B-Instruct-2410
pixi run resp     # responses_basic.py --> /v1/responses. Supported for all models.
pixi run async    # responses_async.py --> async /v1/responses. Supported for all models.
pixi run stream   # responses_stream.py --> Flanky with openai/gpt-oss-20b
```

## Expected behaviour

These tests are minimal sanity checks based on official examples from the OpenAI [Python SDK](https://github.com/openai/openai-python/tree/main) and [API reference](https://platform.openai.com/docs/api-reference/responses/create). They send minimal sample requests to `/v1/chat/completions` and `/v1/responses`.

They verify:

- That the endpoint responds correctly.
- That the selected model is registered and healthy.
- That the platform returns text completions in OpenAI-compatible JSON.

Passing all non-streaming tests confirms that the endpoint is OpenAI-compatible for standard text completions.

## Notes

- These are reference tests, not performance benchmarks.
- Some API features (e.g. images, audio, realtime) are not supported by the current backend stack (Dynamo / vLLM) or by the selected model (e.g. `gpt-oss-20b`).
- Model choice and configuration may change during the pilot.
- _Feedback is welcome and helps guide the next iteration of the platform._ Please issue tickets on this repository or contact the TULIP team directly for feedback or questions.