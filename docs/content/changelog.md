## v0.3.0-alpha Usability & Access (2026-03-20)

### API & Access

- Introduced model aliases (e.g. `chat`, `code`, `embed`) as the primary user interface  
  → Raw model names are no longer user-facing
- Basic API key authentication enforced at ingress level

### Documentation & Examples

- Complete documentation restructure with:
    - Clear Getting Started flow
    - Capability-based API reference
    - Explicit model mapping
- Removed outdated or unverified content
- Added validated, copy-paste examples for core capabilities:
    - Chat, Responses API, Embeddings, Tool calling

### Known limitations

- Tool calling via `/v1/responses` currently not reliable in this environment due to backend serving limitations
- Authentication is API-key based only (no SRAM/OIDC yet)
- No rate limiting or quota enforcement
- Service remains in pilot phase (no uptime guarantees)

## v0.2.0-alpha: API consolidation (2026-03-12)

### Added

- Capability-based API namespaces (`/chat/v1`, `/code/v1`, `/embed/v1`)

### API changes

- Removed embedding endpoint `https://embedding.tulip.tudelft.nl`
- Embeddings now available at `/embed/v1` under the main API domain
- All models are now served under the unified domain `https://api.tulip.tudelft.nl`

### Improvements

- Separated DynamoGraphDeployments per model backend
- Resolved tool-calling instability caused by mixed model graphs
- Verified reliable tool-calling for both:
  - `openai/gpt-oss-20b`
  - `Qwen/Qwen3-Coder-30B-A3B-Instruct-FP8`

### Migration

Old endpoint:
https://embedding.tulip.tudelft.nl/v1/embeddings

New endpoint:
https://api.tulip.tudelft.nl/embed/v1/embeddings

## v0.1.1-alpha: Embedding Support (2026-03-06)

Added

- OpenAI-compatible embeddings endpoint
- Dedicated embedding API base URL: https://embedding.tulip.tudelft.nl
- Initial embedding model: `Qwen/Qwen3-Embedding-8B` (4096-dim)

Documentation

- Updated Getting Started with embedding usage example
- Clarified separate base URLs for inference and embeddings

Notes

- Authentication remains disabled during the pilot phase
- Model availability may evolve as the platform matures


## v0.1.0-alpha: Pilot Launch (2025-11-27)

### Added

- OpenAI-compatible endpoints: `/v1/chat/completions`, `/v1/completions`, `/v1/responses`
- Multi-model serving (Ministral 8B, Qwen2.5 Coder 14B, GPT-OSS 20B)
- Basic observability: Prometheus, Grafana, DCGM GPU metrics
- Reference tests repository with `curl` + Python examples
- Basic documentation: Landing page + Getting Started + Roadmap
- GitOps deployment via FluxCD
- Staging and production environments
- PVC-backed cache for model storage

### Known limitations

- No authentication yet
- Streaming unstable for some models
- Lack of quotas / accounting
- Limited model portfolio
- No embedding or multimodal models yet