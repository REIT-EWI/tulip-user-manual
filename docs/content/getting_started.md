# Getting Started

## API Endpoint

TULIP exposes a single API domain:

- **Base URL:** https://api.tulip.tudelft.nl


!!! info "Update"

    The previous endpoint `https://embedding.tulip.tudelft.nl` has been phased out. 
    Embedding models are now available under the unified API domain:`https://api.tulip.tudelft.nl/embed/v1`.


All models are now served under the same domain and grouped by capability:

| Capability              | Base Path        |
| ----------------------- | ---------------- |
| Chat / reasoning models | `/chat/v1`       |
| Coding models           | `/code/v1`       |
| Embedding models        | `/embed/v1` |

Each capability exposes its own OpenAI-compatible API namespace, so:

| Endpoint                    | Purpose               | Example                                                 |
| --------------------------- | --------------------- | ------------------------------------------------------- |
| `/chat/v1/chat/completions` | Chat-style interactions (messages)     | `https://api.tulip.tudelft.nl/chat/v1/chat/completions` |
| `/chat/v1/completions`      | Text completion (prompt → text)       | `https://api.tulip.tudelft.nl/chat/v1/completions`      |
| `/chat/v1/responses`        | Unified endpoint (recommended)      | `https://api.tulip.tudelft.nl/chat/v1/responses`        |
| `/chat/v1/models`           | List chat models      | `https://api.tulip.tudelft.nl/chat/v1/models`           |
| `/code/v1/models`           | List coding models    | `https://api.tulip.tudelft.nl/code/v1/models`           |
| `/embed/v1/models`     | List embedding models | `https://api.tulip.tudelft.nl/embed/v1/models`     |
| `/embed/v1/embeddings` | Generate embeddings   | `https://api.tulip.tudelft.nl/embed/v1/embeddings` |



> **Authentication:** disabled during pilot. A dummy API key may be passed but is ignored.

## Available Models

Currently deployed models are organized by capability.

| Capability | Models |
| ---------- | -------|
| Chat       | `openai/gpt-oss-20b` |
| Coding     | `Qwen/Qwen3-Coder-30B-A3B-Instruct-FP8` |
| Embedding  | `Qwen/Qwen3-Embedding-8B` |



The exact list may evolve over time. You can query the currently active models at:

```bash
curl https://api.tulip.tudelft.nl/chat/v1/models
curl https://api.tulip.tudelft.nl/code/v1/models
curl https://api.tulip.tudelft.nl/embed/v1/models
```

You can also open these URLs directly in a browser.

## How to send requests

### Using `curl`

Now, you can send a simple chat completion request like this:

```bash
curl -s https://api.tulip.tudelft.nl/chat/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H 'Authorization: Bearer DUMMY_API_KEY' \
  -d '{
        "model": "openai/gpt-oss-20b",
        "messages": [
          {"role": "user", "content": "Say hello from TULIP."}
        ],
        "max_tokens": 64
      }'
```

### Using Python (OpenAI SDK)

First, install the official OpenAI Python package, eg, using:

```bash
pip install openai
```

And, for a minimal example via `/v1/responses` endpoint:

```python
from openai import OpenAI

client = OpenAI(base_url = "https://api.tulip.tudelft.nl/chat/v1", 
                api_key = "DUMMY_API_KEY")

response = client.responses.create(
    model = "openai/gpt-oss-20b",
    input = "Write a short friendly greeting.",
    max_output_tokens = 640
)
print(response.output_text) # Prints the generated text
```

> To see the full structured response:

```python
print(response.output)  # May contain tool calls structures, reasoning traces, and/or other items
```

## Tool Calling Support

Reasoning and tool calling is supported in the OpenAI Chat Completion endpoint.

Currently verified:

| Model                                   | Tool calling | Notes               |
| --------------------------------------- | ------------ | ------------------- |
| `openai/gpt-oss-20b`                    | Supported    | Verified end-to-end |
| `Qwen/Qwen3-Coder-30B-A3B-Instruct-FP8` | Supported    | Verified end-to-end |

Tool calling has been validated for both models using repeated end-to-end tests (tool emission → execution → model continuation)


## Embedding models

TULIP also provides embedding models for retrieval and semantic search workloads.

Embeddings are available via: `https://api.tulip.tudelft.nl/embed/v1/embeddings`

You can use the embeddings endpoint to convert text into vector representations for downstream tasks such as search, clustering, and retrieval-augmented generation (RAG).

Supported models:

| Model                     | Notes                           |
| ------------------------- | ------------------------------- |
| `Qwen/Qwen3-Embedding-8B` | 4096-dimensional embeddings |


Example request:

```bash
curl -s https://api.tulip.tudelft.nl/embed/v1/embeddings \
  -H "Content-Type: application/json" \
  -d '{
    "model": "Qwen/Qwen3-Embedding-8B",
    "input": ["hello from tulip", "second string"],
    "encoding_format": "float"
  }'
```  


## Limits (Pilot Phase)

- Some OpenAI features (e.g. images, audio, realtime) are not available.
- Model choice and configuration may change as the platform evolves. Always check the relevant `/models` endpoint (e.g. `/chat/v1/models`, `/code/v1/models`, `/embed/v1/models`)
- The service is under active development: _expect occasional interruptions_. 

## Contact / Feedback

Please report:

- inconsistent or incorrect model behaviour,
- reliability issues or latency spikes,
- suggestions for new models or capabilities.

Early tester feedback directly shapes the next iteration of TULIP. __Please issue tickets on this repository or contact the TULIP team directly for feedback or questions.__

<!-- ## System Design (high-level)

- `Kubernetes` cluster hosted on TU Delft infrastructure
- `NVIDIA Dynamo` for LLM serving and orchestration
- `vLLM` as the main LLM inference engine
- `Prometheus` and `Grafana` for monitoring and observability
- `fluxcd` for GitOps-based deployment and configuration management

## Roadmap / Upcoming Features

- [ ] Authentication (OIDC / API keys)
- [ ] Accounting & usage metrics
- [ ] Web UI for chat and model selection
- [ ] Embedding model deployment
- [ ] Multimodal support (images / vision models)
- [ ] Autoscaling (KEDA)
- [ ] Additional curated model families (2–3 per domain) -->
