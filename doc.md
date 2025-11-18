“Using the TULIP API (Preview)” with:

Base URL: `https://api.tulip.tudelft.nl`

Supported endpoints

- `/v1/responses` (recommended)
- `/v1/chat/completions` (beta)
- `/v1/completions `(legacy)

Available models (for now)

- `mistralai/Ministral-8B-Instruct-2410`
- `Qwen/Qwen2.5-Coder-14B-Instruct`
- mention “subject to change during preview”.

Simple examples

- `curl` example with `/v1/responses`
- Python example with OpenAI-compatible client using `responses.create()`.

```python
from openai import OpenAI
client = OpenAI(base_url="https://api.tulip.tudelft.nl/v1", api_key="YOUR_TOKEN")
r = client.chat.completions.create(
    model="mistralai/Ministral-8B-Instruct-2410",
    messages=[{"role":"user","content":"Hello"}]
)
print(r.choices[0].message.content)
```

Limits / caveats

- model-specific context window
- max output tokens
- fair-use guidelines
- “Preview, not production”
- “No data persistence guarantees yet”
- “We log and monitor usage for debugging” (if true).