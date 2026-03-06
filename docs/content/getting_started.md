# Getting Started

## API Endpoint

TULIP currently exposes two API base URLs:

- **LLM inference:** https://api.tulip.tudelft.nl
- **Embedding models:** https://embedding.tulip.tudelft.nl
```

Supported OpenAI-style endpoints:

| Endpoint               | Purpose                            | Status                                                                                   |
| ---------------------- | ---------------------------------- | ---------------------------------------------------------------------------------------- |
| `/v1/chat/completions` | Chat-style interactions (messages) | ✓ enabled                                                                                |
| `/v1/completions`      | Text completion (prompt → text)    | ✓ enabled                                                                                |
| `/v1/responses`        | Unified endpoint (recommended)     | ✓ enabled                                                                                |
| `/v1/models`           | List of available models           | ✓ enabled                                                                                |
| `/v1/embeddings`       | Embeddings                         | ✓ (available at `https://embedding.tulip.tudelft.nl`)                     |


> **Authentication:** disabled during pilot. A dummy API key may be passed but is ignored.

## Available Models

Currently deployed models include:

<!-- - `mistralai/Ministral-8B-Instruct-2410`: general-purpose assistant
- `Qwen/Qwen2.5-Coder-14B-Instruct`: coding-focused assistant -->
- `openai/gpt-oss-20b`: open-weights GPT-style model

The exact list may evolve overtime. You can query the currently active models at:

```bash
curl https://api.tulip.tudelft.nl/v1/models 
curl https://embedding.tulip.tudelft.nl/v1/models # For embedding models
```

Or, by simply visiting these websites above.

## How to send requests

### Using `curl`

Now, you can send a simple chat completion request like this:

```bash
curl https://api.tulip.tudelft.nl/v1/chat/completions \
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

client = OpenAI(base_url=TULIP_API_URL, api_key=TULIP_API_KEY)

response = client.responses.create(
    model="openai/gpt-oss-20b",
    input="Write a short friendly greeting.",
    max_output_tokens=640
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

| Model   | Tool calling           | Notes                                               |
| ------- | ---------------------- | --------------------------------------------------- |
| GPT-OSS | Supported            | Verified end-to-end (function emission + tool loop) |

Minimal working example:

## Embedding models

TULIP also provides embedding models for retrieval and semantic search workloads.

Embedding models are exposed through a separate API base URL:

- Embeddings API base URL: https://embedding.tulip.tudelft.nl
- Endpoint: `/v1/embeddings`

You can use the embeddings endpoint to convert text into vector representations for downstream tasks such as search, clustering, and retrieval-augmented generation (RAG).

| Model                     | Notes                           |
| ------------------------- | ------------------------------- |
| `Qwen/Qwen3-Embedding-8B` | 4096-dimensional embeddings |


Example request:

```bash
curl -sS https://embedding.tulip.tudelft.nl/v1/embeddings \
  -H "Content-Type: application/json" \
  -d '{
    "model": "Qwen/Qwen3-Embedding-8B",
    "input": ["hello from tulip", "second string"],
    "encoding_format": "float"
  }'
```  


## Limits (Pilot Phase)

- Some OpenAI features (e.g. images, audio, realtime) are not available.
- Streaming support varies per model.
- Model choice and configuration may change as the platform evolves. Always check the `/v1/models` endpoint for the latest list of available models.
- The service is under active development: _expect occasional interruptions_. 

## Contact / Feedback

Please report:

- inconsistent or incorrect model behaviour,
- reliability issues or latency spikes,
- suggestions for new models or capabilities.

Early tester feedback directly shapes the next iteration of TULIP. Please issue tickets on this repository or contact the TULIP team directly for feedback or questions.

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
