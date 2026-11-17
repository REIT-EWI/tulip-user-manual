import sys

from common import (
    TUDELFT_TULIP_API_KEY,
    TUDELFT_TULIP_BASE_URL,
    TUDELFT_TULIP_MODEL_ALIAS,
)
from openai import OpenAI

print(f"Using base URL: {TUDELFT_TULIP_BASE_URL}", file=sys.stderr)
print(f"Using model alias: {TUDELFT_TULIP_MODEL_ALIAS}", file=sys.stderr)

client = OpenAI(base_url=TUDELFT_TULIP_BASE_URL, api_key=TUDELFT_TULIP_API_KEY)


# Reproduce the current multi-input limitation; API errors exit nonzero.
print("Requesting embeddings for two input strings", file=sys.stderr)
response = client.embeddings.create(
    model=TUDELFT_TULIP_MODEL_ALIAS,
    input=["Hello from tulip", "this rocks!"],
    encoding_format="float",
)
for item in response.data:
    print(f"Index {item.index}: {item.embedding[0:5]}")
