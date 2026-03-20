# Model Alias Mapping

TULIP currently deploys models optimized for three different tasks. Models are identified by aliases for convenience.

| Capability | Alias | Current Backing Model | Notes |
| ---------- | ----- | --------------------------------------- | ------ |
| Chat | `chat` | `openai/gpt-oss-20b` | Default chat model; tool-calling format may vary by serving/parser configuration |
| Coding | `code` | `Qwen/Qwen3-Coder-30B-A3B-Instruct-FP8` | Supports code generation and reasoning; verified in reference tests for structured OpenAI-style tool calling (`message.tool_calls`) |
| Embedding | `embed` | `Qwen/Qwen3-Embedding-8B` | 4096-dimensional embeddings for retrieval and semantic search |

<details>
<summary>Query Runtime Models (Optional)</summary>

This check is still useful for
debugging and environment validation. However, the serving layer may return alias-oriented output (and not real model names).

```bash
--8<-- "./examples/curl-check-models.sh"
```

Run it with:

```bash
bash examples/curl-check-models.sh
```

</details>

## Important Notes

- **Update channel:** Alias-to-model mapping changes are communicated via the TULIP mailing list.
- **Prefer aliases:** Use `chat`, `code`, and `embed` in your clients — don't hardcode backing model IDs, as they may change.
- **Tool-calling behavior:** For current limitations and expected output format, see the [Tool Calling tutorial](../tutorials/tool_calling.md).
