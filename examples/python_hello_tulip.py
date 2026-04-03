import os
from pathlib import Path

from dotenv import load_dotenv
from openai import OpenAI

load_dotenv(dotenv_path=Path(__file__).parent.parent / ".env")

TUDELFT_TULIP_API_KEY = os.getenv("TUDELFT_TULIP_API_KEY")

if not TUDELFT_TULIP_API_KEY:
    raise RuntimeError("Set TUDELFT_TULIP_API_KEY in .env or the environment.")

client = OpenAI(
    base_url="https://api.tulip.tudelft.nl/chat/v1/", api_key=TUDELFT_TULIP_API_KEY
)

response = client.chat.completions.create(
    model="chat", messages=[{"role": "user", "content": "Say hello from TULIP."}]
)
print(response.choices[0].message.content)
