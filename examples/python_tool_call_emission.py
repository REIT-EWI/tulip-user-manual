from common import (
    TUDELFT_TULIP_API_KEY,
    TUDELFT_TULIP_BASE_URL,
    TUDELFT_TULIP_MODEL_ALIAS,
)
from openai import OpenAI

client = OpenAI(base_url=TUDELFT_TULIP_BASE_URL, api_key=TUDELFT_TULIP_API_KEY)
model = TUDELFT_TULIP_MODEL_ALIAS

tools = [
    {
        "type": "function",
        "function": {
            "name": "get_system_health",
            "description": "Returns current health status.",
            "parameters": {
                "type": "object",
                "properties": {},
            },
        },
    }
]

completion = client.chat.completions.create(
    model=model,
    messages=[
        {
            "role": "user",
            "content": (
                "Call the get_system_health tool now. Do not ",
                "answer in natural language.",
            ),
        }
    ],
    tools=tools,
    tool_choice="required",
    temperature=0,
    max_tokens=64,
)

print(completion.model_dump_json(indent=2))
