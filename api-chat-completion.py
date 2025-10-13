
from openai import OpenAI

client = OpenAI(base_url="http://demo.131.180.79.250.nip.io/v1", api_key="DUMMY_KEY")
model = "gpt-oss-20b"  

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