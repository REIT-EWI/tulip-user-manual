from common import (
    TUDELFT_TULIP_API_KEY,
    TUDELFT_TULIP_BASE_URL,
    TUDELFT_TULIP_MODEL_ALIAS,
)
from openai import OpenAI

client = OpenAI(base_url=TUDELFT_TULIP_BASE_URL, api_key=TUDELFT_TULIP_API_KEY)

stream = client.chat.completions.create(
    model=TUDELFT_TULIP_MODEL_ALIAS,
    temperature=0.2,
    stream=True,
    messages=[
        {
            "role": "system",
            "content": (
                "You rewrite higher-education policy text into clear, structured "
                "teaching content."
            ),
        },
        {
            "role": "user",
            "content": (
                "Rewrite the following into a clear, student-friendly web page "
                'section:\n\n"Our assessment policy ensures that all evaluations '
                "are aligned with course learning objectives. Students must "
                "demonstrate competency across theoretical understanding and "
                "practical application. Appeals can be submitted within 5 working "
                'days."\n\nMake it:\n- simpler language\n- structured with headings\n'
                "- include bullet points"
            ),
        },
    ],
)

for chunk in stream:
    if chunk.choices and chunk.choices[0].delta and chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="", flush=True)

print()
