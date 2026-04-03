import asyncio

from common import (
    TUDELFT_TULIP_API_KEY,
    TUDELFT_TULIP_BASE_URL,
    TUDELFT_TULIP_MODEL_ALIAS,
)
from openai import AsyncOpenAI

client = AsyncOpenAI(base_url=TUDELFT_TULIP_BASE_URL, api_key=TUDELFT_TULIP_API_KEY)
model = TUDELFT_TULIP_MODEL_ALIAS


async def main() -> None:
    response = await client.responses.create(
        model=model, input="Explain disestablishmentarianism to a smart five year old."
    )
    print(response.output_text)


asyncio.run(main())
