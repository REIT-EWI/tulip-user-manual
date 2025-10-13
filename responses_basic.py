from openai import OpenAI
from common import BASE_URL, API_KEY, MODEL

client = OpenAI(base_url=BASE_URL, api_key=API_KEY)
model = MODEL

response = client.responses.create(
    model=model,
    # instructions="You are a coding assistant that talks like a pirate.", # not supported
    input="How do I check if a Python object is an instance of a class?",
)

print(response.output_text)