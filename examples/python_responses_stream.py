from common import (
    TUDELFT_TULIP_API_KEY,
    TUDELFT_TULIP_BASE_URL,
    TUDELFT_TULIP_MODEL_ALIAS,
)
from openai import OpenAI

client = OpenAI(base_url=TUDELFT_TULIP_BASE_URL, api_key=TUDELFT_TULIP_API_KEY)
model = TUDELFT_TULIP_MODEL_ALIAS

stream = client.chat.completions.create(
    model=model,
    messages=[{"role": "user", "content": "Hello TULIP streaming test!"}],
    stream=True,
)

for chunk in stream:
    # Each chunk is a ChatCompletionChunk; content trickles in delta.
    if chunk.choices and chunk.choices[0].delta and chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="", flush=True)
print()
