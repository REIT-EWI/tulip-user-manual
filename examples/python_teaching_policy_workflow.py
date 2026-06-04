from common import (
    TUDELFT_TULIP_API_KEY,
    TUDELFT_TULIP_BASE_URL,
)
from openai import OpenAI

CHAT_CAPABILITY = "chat"
CHAT_MODEL_ALIAS = "chat"

_base_url = TUDELFT_TULIP_BASE_URL.rstrip("/")
if _base_url.endswith("/v1"):
    _base_url = _base_url[: -len("/v1")]
if _base_url.endswith((f"/{CHAT_CAPABILITY}", "/code", "/embed")):
    _base_url = _base_url.rsplit("/", 1)[0]
CHAT_BASE_URL = f"{_base_url}/{CHAT_CAPABILITY}/v1"

client = OpenAI(base_url=CHAT_BASE_URL, api_key=TUDELFT_TULIP_API_KEY)
model = CHAT_MODEL_ALIAS

tools = [
    {
        "type": "function",
        "function": {
            "name": "lookup_assessment_policy",
            "description": (
                "Returns approved assessment policy details for a course team."
            ),
            "parameters": {
                "type": "object",
                "properties": {
                    "topic": {
                        "type": "string",
                        "description": "Policy topic to retrieve.",
                    }
                },
                "required": ["topic"],
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
                "We are updating a course page. Can students appeal within 7 "
                "working days, "
                "and are project-based assessments allowed now?"
            ),
        },
        {
            "role": "assistant",
            "tool_calls": [
                {
                    "id": "call-1",
                    "type": "function",
                    "function": {
                        "name": "lookup_assessment_policy",
                        "arguments": '{"topic":"assessment policy"}',
                    },
                }
            ],
        },
        {
            "role": "tool",
            "tool_call_id": "call-1",
            "content": (
                "{"
                '"appeal_window_working_days":5,'
                '"allowed_assessment_modes":['
                '"written exams","project-based evaluation",'
                '"group work","oral components"'
                "],"
                '"source":"Teaching regulations update 2026"'
                "}"
            ),
        },
    ],
    tools=tools,
    temperature=0,
    max_tokens=180,
)

print(completion.choices[0].message.content)
