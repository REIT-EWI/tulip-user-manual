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