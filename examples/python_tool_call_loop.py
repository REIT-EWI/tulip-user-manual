from openai import OpenAI
from common import TUDELFT_TULIP_BASE_URL, TUDELFT_TULIP_API_KEY, TUDELFT_TULIP_MODEL_ALIAS

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
            "content": "Hey, quick check: is everything up and running?",
        },
        {
            "role": "assistant",
            "tool_calls": [
                {
                    "id": "call-1",
                    "type": "function",
                    "function": {
                        "name": "get_system_health",
                        "arguments": "{}",
                    },
                }
            ],
        },
        {
            "role": "tool",
            "tool_call_id": "call-1",
            "content": '{"status":"ok","uptime_seconds":372045}',
        },
    ],
    tools=tools,
    temperature=0,
    max_tokens=128,
)

print(completion.model_dump_json(indent=2))
