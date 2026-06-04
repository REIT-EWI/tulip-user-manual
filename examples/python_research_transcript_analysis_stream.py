from common import (
    TUDELFT_TULIP_API_KEY,
    TUDELFT_TULIP_BASE_URL,
)
from openai import OpenAI

CHAT_CAPABILITY = "chat"
CHAT_MODEL_ALIAS = "chat"

_base_url = TUDELFT_TULIP_BASE_URL.rstrip("/")
if _base_url.endswith("/v1"):
    _base_url = _base_url[: -len("/v1")]
if _base_url.endswith((f"/{CHAT_CAPABILITY}", "/code", "/embed")):
    _base_url = _base_url.rsplit("/", 1)[0]
CHAT_BASE_URL = f"{_base_url}/{CHAT_CAPABILITY}/v1"

SYSTEM_PROMPT = (
    "You are a careful research assistant and clear communicator. "
    "Help analyse transcript excerpts in a cautious, structured way. "
    "Distinguish evidence from interpretation, avoid overclaiming, "
    "and flag uncertainty."
)

USER_PROMPT = """\
Analyse the following interview-style transcript excerpt.

Return:
1. A short neutral summary.
2. Candidate themes or labels.
3. Evidence snippets from the text.
4. Uncertainties or follow-up questions.
5. Anything that should not be inferred from this excerpt alone.

Do not invent information. Keep interpretation cautious.

Transcript:
Interviewer: What made you decide to use the tool?
Participant: At first I used it because others in the group were trying it.
It helped me summarise notes quickly, but I was unsure whether I could paste
sensitive material into it. I also found that the output sounded confident even
when it missed important context.
"""

client = OpenAI(base_url=CHAT_BASE_URL, api_key=TUDELFT_TULIP_API_KEY)

stream = client.chat.completions.create(
    model=CHAT_MODEL_ALIAS,
    temperature=0.2,
    stream=True,
    messages=[
        {"role": "system", "content": SYSTEM_PROMPT},
        {"role": "user", "content": USER_PROMPT},
    ],
)

for chunk in stream:
    if chunk.choices and chunk.choices[0].delta and chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="", flush=True)

print()
