# TULIP: Reference Tests for the LLM API

This repository contains small, self-contained tests for **TULIP**, TU Delft LLM Infrastructure Platform. 
TULIP provides an OpenAI-compatible API endpoint backed by NVIDIA Dynamo and vLLM, enabling users to interact with large language models (LLMs) in a familiar way.

TULIP exposes an **OpenAI-compatible API** backed by **NVIDIA Dynamo** and **vLLM**, allowing users to interact with local LLMs using standard OpenAI client libraries.

## Purpose

This repo is meant for **early testers** to:

- Verify that the TULIP API endpoint is reachable.
- Send basic `/v1/chat/completions`, `/v1/completions`, and `/v1/responses` requests.
- Explore latency, context-length limits, and streaming behaviour.
- Provide minimal working examples to integrate into research code.


## Setup

1 . Clone this repository and navigate into it:
   ```bash
   git clone https://gitlab.ewi.tudelft.nl/tulip/tulip-reference-tests.git
   cd tulip-reference-tests
   ```

2. Copy the example environment file and set endpoint and API key (future) as needed:

   ```bash
   cp .env.example .env
   cat .env   # edit BASE_URL, MODEL, and API key (once enabled) as needed
   ```

Note:

- `BASE_URL` defaults to the production endpoint (https://api.tulip.tudelft.nl). 
- `MODEL` can be set to any model available on the backend (e.g. `gpt-oss-20b`). You can check available models by querying the `/v1/models` endpoint (eg, by a command like: `curl $BASE_URL/v1/models`, or, from the browser at the `https://api.tulip.tudelft.nl/v1/models`).
- During the pilot there is no authentication, but the variable is kept for forward compatibility.

## Running tests

Each of the following scripts uses the values in `.env` and/or a shared helper (`common.py`).

Using `pixi` (recommended):

```bash
# Bash examples
pixi run curl_responses     # curl_responses.sh 
pixi run curl_chat     # curl_chat.sh

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