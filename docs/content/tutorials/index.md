# Tutorials Overview

Use TULIP directly through its OpenAI-compatible API, or connect it to
an existing application or agent.

The [API tutorials](#direct-api) include runnable Bash and Python examples. [Integration tutorials](#integrations) focus on configuring TULIP in external tools.

!!! info "TU Delft Network Access Required"
    TULIP is only reachable from the TU Delft network. Off campus, connect via [eduVPN](https://tudelft.eduvpn.nl/portal/home) before using the API.

## Direct API

These tutorials contain runnable Bash and Python examples:

- [Chat & General Inference](chat-inference.md)
- [Embeddings](embeddings.md)
- [Tool Calling](tool_calling.md)


### Before running the examples

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

### Dependency Setup

- If you run examples with `pixi run ...`, Python dependencies are managed from this repository's `pixi.toml`.
- Bash examples may still require system tools like `jq`.
- If you do not use Pixi, install dependencies from `pyproject.toml` manually.

## Integrations

These tutorials explain how to configure TULIP as the model provider for
external applications and agent tools. They do not require the example
repository unless stated otherwise.

- [VS Code with Continue](tulip-vscode.md) — coding assistance inside VS Code
- [OpenCode](opencode.md) — terminal-based coding agent
- [Hermes Agent](hermes.md) — general-purpose agent harness
- [Jan.ai](jan-ai.md) — desktop chat client


