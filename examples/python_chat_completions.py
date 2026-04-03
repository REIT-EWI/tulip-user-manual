from common import (
    TUDELFT_TULIP_API_KEY,
    TUDELFT_TULIP_BASE_URL,
    TUDELFT_TULIP_MODEL_ALIAS,
)
from openai import OpenAI

client = OpenAI(base_url=TUDELFT_TULIP_BASE_URL, api_key=TUDELFT_TULIP_API_KEY)
model = TUDELFT_TULIP_MODEL_ALIAS

completion = client.chat.completions.create(
    model=model,
    messages=[
        {
            "role": "developer",
            "content": "You are a helpful coding assistant for TU Delft.",
        },
        {
            "role": "user",
            "content": (
                "Write a tiny Python function that prints the TU Delft logo in ASCII.",
            ),
        },
    ],
)

print(completion.choices[0].message.content)
