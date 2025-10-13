from openai import OpenAI
from common import BASE_URL, API_KEY, MODEL

client = OpenAI(base_url=BASE_URL, api_key=API_KEY)
model = MODEL

stream = client.chat.completions.create(
    model=model,
    messages=[{"role": "user", "content": "Hello TULIP streaming test!"}],
    stream=True,
)

for chunk in stream:
    # Each chunk is a ChatCompletionChunk; content trickles in delta
    if chunk.choices and chunk.choices[0].delta and chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="", flush=True)
print()
