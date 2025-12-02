from openai import OpenAI
from common import BASE_URL, API_KEY, MODEL

client = OpenAI(base_url=BASE_URL, api_key=API_KEY)
model = MODEL
print("Using model:", model, "\n")

print("Chat Completion Example:")
chat = client.chat.completions.create(
    model=model,
    messages=[
        {"role": "user", 
         "content": "Write a short friendly greeting."}],
    temperature=0.0,
    max_tokens=64,
)
print(chat.choices[0].message.content)
print("----")

print("Response Example:")
response = client.responses.create(
    model=model,
    input="Provide a 1 sentence explanation OpenAI API.",
    max_output_tokens=640
)
print(response.output_text)