import asyncio
from openai import AsyncOpenAI
from common import BASE_URL, API_KEY, MODEL

client = AsyncOpenAI(base_url=BASE_URL, api_key=API_KEY)
model = MODEL

async def main() -> None:
    response = await client.responses.create(
        model=model, input="Explain disestablishmentarianism to a smart five year old."
    )
    print(response.output_text)


asyncio.run(main())