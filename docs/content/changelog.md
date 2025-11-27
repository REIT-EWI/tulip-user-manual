## v0.1.0-alpha: Pilot Launch

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