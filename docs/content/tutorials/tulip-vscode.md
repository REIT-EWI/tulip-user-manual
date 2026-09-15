# VS Code Integration

You can use TULIP from VS Code through the
[Continue extension](https://continue.dev). Continue supports OpenAI-compatible
providers, so it can talk to TULIP's `code` endpoint directly.

!!! info "TU Delft Network Access Required"
    TULIP is only reachable from the TU Delft network. Off campus, connect via
    [eduVPN](https://tudelft.eduvpn.nl/portal/home) before using Continue.

## Prerequisites

- Visual Studio Code
- The [Continue extension for VS Code](https://marketplace.visualstudio.com/items?itemName=Continue.continue)
- An SRAM application token to use as your TULIP API key. See [Request Access](../getting-started/access.md).

## Configure Continue

1. Install the Continue extension in VS Code.
2. Open the Continue panel.
3. Click the gear icon and select **Open Config file**.
4. Replace the contents of `config.yaml` with:

```yaml
name: TULIP
version: 1.0.0
schema: v1
models:
  - name: TULIP
    provider: openai
    model: AUTODETECT
    apiKey: YOUR_SRAM_APPLICATION_TOKEN
    apiBase: https://api.tulip.tudelft.nl/code/v1

context:
  - provider: code
  - provider: file
  - provider: diff
  - provider: terminal
  - provider: problems
# Optional: add these later if you want broader project retrieval.
# - provider: docs
# - provider: codebase
# - provider: folder

```

Replace `YOUR_SRAM_APPLICATION_TOKEN` with your SRAM application token, then save the
file. Continue reloads the configuration automatically; if the model selector
does not update, reload the VS Code window.

## Try It

Open a source file in VS Code, open the Continue chat, and send:

```text
Explain the current file.
```

Continue sends the request to TULIP through:

```text
https://api.tulip.tudelft.nl/code/v1
```

The `AUTODETECT` model value lets Continue discover the models available behind
the TULIP `code` capability.

!!! tip "Keep chat and code use separate"
    Continue is intended for coding workflows, so this configuration uses the
    `code` capability. For general chat outside VS Code, use the examples in
    [Chat & General Inference](chat-inference.md).

## Troubleshooting

!!! note
    If Continue cannot connect, first check that you are on the TU Delft network
    or connected through eduVPN.

!!! note
    If model discovery fails, verify that `apiBase` is exactly
    `https://api.tulip.tudelft.nl/code/v1`.

!!! warning "Known limitation"
    Continue currently has a known issue around Jupyter notebooks on remote
    machines. See
    [continuedev/continue#1463](https://github.com/continuedev/continue/issues/1463).
