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

print(
    "\n********** Check embeddings works (dimension check) *****************",
    file=sys.stderr,
)
response = client.embeddings.create(
    model=TUDELFT_TULIP_MODEL_ALIAS,
    input="Hello from tulip",
    encoding_format="float",
)
print(f"Number of embeddings: {len(response.data)}")
print(f"Embedding dimension: {len(response.data[0].embedding)}")
