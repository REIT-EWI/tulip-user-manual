# Tutorials Overview

This section contains practical, user-facing tutorials for common TULIP tasks.

## Quick Setup

1. Clone and enter the repository:

```bash
git clone https://gitlab.ewi.tudelft.nl/tulip/reference-tests.git
cd reference-tests
```

2. Create your environment file:

```bash
cp .env.example .env
```

3. Set your API key in `.env`.

## Dependency Setup

- If you run examples with `pixi run ...`, Python dependencies are managed from this repository's `pixi.toml`.
- Bash examples may still require system tools like `jq`.
- If you do not use Pixi, install dependencies from `pyproject.toml` manually.

## Available Tutorials

- [Chat & General Inference](chat-inference.md)
- [Embeddings](embeddings.md)
- [Tool Calling](tool_calling.md)

Each tutorial includes runnable Bash and Python examples.
