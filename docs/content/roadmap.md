
## 1 Roadmap

_A maturity checklist inspired by [ALCF's Inference Service](https://docs.alcf.anl.gov/services/inference-endpoints/) design_

### 1.1 Core Functionality

- [x] OpenAI-compatible API (`/v1/chat/completions`, `/v1/completions`, `/v1/responses`)
- [x] Multi-model serving with NVIDIA Dynamo + vLLM
- [x] Metrics exposed via Prometheus (`/metrics` endpoint)
- [x] Model health checks (`/health`, `/live` endpoints)
- [x] GPU metrics (DCGM) integrated into Prometheus/Grafana
- [x] Basic logging of requests and errors
- [x] Initial reference tests for smoketesting
- [x] Basic documentation and examples

### 1.2 Authentication & Access Control

- [ ] Token-based authentication (simple API keys)
- [ ] TU Delft SSO / OIDC integration
- [ ] Token scopes: rate-limit tiers
- [ ] Automatic issuance of tokens through GitLab

### 1.3 Accounting, Logging, Usage Tracking

- [x] Basic Prometheus metrics (requests, latency, queue size)
- [ ] Per-user request accounting
- [ ] Model-level usage statistics
- [ ] Optional logging of prompts (opt-in for research, disabled by default)
- [ ] Export usage summaries (daily/weekly) to a TU Delft dashboard

### 1.4 Quotas, Limits & Scheduling

- [x] Fair scheduling (vLLM queue)
- [x] Max context length harmonised across models
- [ ] Per-token or per-request quotas
- [ ] Per-user/request rate limits
- [ ] Quota enforcement at gateway
- [ ] Mechanism for _"priority users"_ (courses, faculty, grants)

### 1.5 Observability & Reliability

- [x] Prometheus + Grafana dashboards
- [x] DCGM GPU monitoring
- [x] Frontend/worker health endpoints
- [x] Basic liveness via Dynamo
- [ ] SLO/SLA metrics (latency, TTFT, tokens/sec, queue time)
- [ ] Alerts:
      - [ ] GPU OOM risk
      - [ ] API 5xx spikes
            - [ ] Degraded model health
            - [ ] High queue time
- [ ] Log aggregation
- [ ] Automated smoke tests on deployment (GitOps pre-deployment checks)

### 1.6 Multi-Tenancy & Stability

- [x] Single-node multi-model serving (1 GPU per model)
- [ ] Dedicated namespaces per course/project
- [ ] Per-tenant quotas and analytics
- [ ] Auto-eviction or scaling policies when GPUs become saturated
- [ ] Model versioning and rollback support
- [ ] Blue/green deployments for zero-downtime updates

### 1.7 Frontend Layer (User Experience)

- [x] Swagger UI auto-enabled (/docs)
- [x] Basic curl + Python examples
- [ ] Single-page web UI for chat (FastChat-like)
- [ ] Example notebooks for:
      - [ ] Data processing workflows
      - [ ] Code generation/ assistance

### 1.8 Model portfolio & Management

- [x] General assistant: Ministral 8B
- [x] Coding assistant: Qwen2.5 Coder 14B
- [x] GPT-style model: GPT-OSS-20B
- [x] Streaming enabled (partial success)
- [ ] Embedding model
<!-- (eg, bge-large, Instructor, E5, etc.) -->
- [ ] Multimodal model
 <!-- (eg, Qwen2-VL, LLaVA-style) -->
- [ ] Reasoning model
 <!-- (eg, DeepSeek-R1 or small distilled variants) -->
- [ ] Small fast model for high-throughput batches
- [ ] Tool-calling enabled model

### 1.9 Storage, CI/CD, & Infra
- [x] GitOps via FluxCD
- [x] Local path storage for model cache
- [x] Separate staging vs production clusters
- [x] Initial capacity planning for PVC
- [ ] Distributed cache or project storage for models
- [ ] Automated model preloading jobs
- [ ] Automated GPU checks before deployment
- [ ] Autoscaling via KEDA
- [ ] Support for multi-GPU nodes (future cluster expansion)

### 1.10 Governance, Policy, & Documentation

- [x] Basic user documentation (Getting Started)
- [x] Reference tests and examples
- [ ] Acceptable Use Policy (AUP) for LLM usage
- [ ] Data classification guidance (what NOT to send to the models)
- [ ] Documentation on supported models and limits
- [ ] Governance model for adding/removing models
- [ ] Support process (tickets, response time)