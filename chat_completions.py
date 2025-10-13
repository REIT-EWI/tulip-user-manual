from openai import OpenAI
from common import BASE_URL, API_KEY, MODEL

client = OpenAI(base_url=BASE_URL, api_key=API_KEY)
model = MODEL

completion = client.chat.completions.create(
    model=model,
    messages=[
        {"role": "developer", "content": "Talk like a pirate."},
        {
            "role": "user",
            "content": "How do I check if a Python object is an instance of a class?",
        },
    ],
)

print(completion.choices[0].message.content)