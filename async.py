

import os
import asyncio
from openai import AsyncOpenAI

client = AsyncOpenAI(base_url="http://demo.131.180.79.250.nip.io/v1", api_key="DUMMY_KEY")
model = "gpt-oss-20b"  

async def main() -> None:
    response = await client.responses.create(
        model=model, input="Explain disestablishmentarianism to a smart five year old."
    )
    print(response.output_text)


asyncio.run(main())