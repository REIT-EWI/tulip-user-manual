
from openai import OpenAI
client = OpenAI(base_url="http://demo.131.180.79.250.nip.io/v1", api_key="DUMMY_KEY")
model = "gpt-oss-20b"  

response = client.responses.create(
    model=model,
    # instructions="You are a coding assistant that talks like a pirate.", # not supported
    input="How do I check if a Python object is an instance of a class?",
)

print(response.output_text)