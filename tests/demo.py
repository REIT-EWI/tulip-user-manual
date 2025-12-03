from openai import OpenAI

client = OpenAI(base_url=TULIP_API_URL, api_key=TULIP_API_KEY)

response = client.responses.create(
    model="openai/gpt-oss-20b",
    input="Write a short friendly greeting.",
    max_output_tokens=640
)
print(response.output_text) # Prints the generated text
