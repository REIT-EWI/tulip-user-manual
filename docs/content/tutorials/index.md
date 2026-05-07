# Tutorials Overview

This section contains practical, user-facing tutorials for common TULIP tasks.

!!! info "TU Delft Network Access Required"
    TULIP is only reachable from the TU Delft network. Off campus, connect via [eduVPN](https://tudelft.eduvpn.nl/portal/home) before using the API.

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
- [VS Code Integration](tulip-vscode.md)
- [OpenHarness Integration](openharness.md)
- [Jan.ai Integration](jan-ai.md)

The API tutorials include runnable Bash and Python examples. Integration
tutorials focus on configuring TULIP in external tools.
