from openai import OpenAI
from common import TUDELFT_TULIP_BASE_URL, TUDELFT_TULIP_API_KEY, TUDELFT_TULIP_MODEL_ALIAS

client = OpenAI(base_url=TUDELFT_TULIP_BASE_URL, api_key=TUDELFT_TULIP_API_KEY)
model = TUDELFT_TULIP_MODEL_ALIAS

response = client.responses.create(
    model=model,
    input="Tell me a three sentence bedtime story about a unicorn.",
)

print(response.output_text)