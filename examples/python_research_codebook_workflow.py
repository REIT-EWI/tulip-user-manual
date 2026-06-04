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

CODEBOOK = """\
Candidate categories:

- trust: The participant describes confidence, doubt, reliability, or perceived
  accuracy of the tool.
- usability: The participant describes ease of use, friction, speed, usefulness,
  or fit with their workflow.
- privacy concern: The participant describes uncertainty or concern about using
  sensitive, personal, confidential, or unpublished material.
- social influence: The participant describes adoption because peers,
  colleagues, supervisors, or group norms shaped their behaviour.
"""

TRANSCRIPT_EXCERPT = """\
Interviewer: What made you decide to use the tool?
Participant: At first I used it because others in the group were trying it.
It helped me summarise notes quickly, but I was unsure whether I could paste
sensitive material into it. I also found that the output sounded confident even
when it missed important context.
"""

USER_PROMPT = f"""\
A researcher has provided the following small codebook.

{CODEBOOK}

Analyse the transcript excerpt against this codebook.

Return:
1. Suggested labels from the codebook only.
2. A supporting quote for each suggested label.
3. Confidence or uncertainty for each suggestion.
4. A short reason why the researcher should review the suggestion.
5. Anything that should not be concluded from this excerpt alone.

Keep the output cautious. Do not invent categories, participant context, or
findings beyond the excerpt.

Transcript excerpt:
{TRANSCRIPT_EXCERPT}
"""

client = OpenAI(base_url=CHAT_BASE_URL, api_key=TUDELFT_TULIP_API_KEY)

completion = client.chat.completions.create(
    model=CHAT_MODEL_ALIAS,
    temperature=0.2,
    # This prompt asks for a relatively structured answer, so a larger budget
    # reduces the chance of the model being cut off mid-response.
    max_tokens=700,
    messages=[
        {
            "role": "system",
            "content": (
                "You are a careful research assistant and clear communicator. "
                "Apply researcher-provided codebooks cautiously. Distinguish "
                "textual evidence from interpretation, avoid overclaiming, and "
                "flag uncertainty."
            ),
        },
        {"role": "user", "content": USER_PROMPT},
    ],
)

message = completion.choices[0].message
# Some backends occasionally return reasoning text without a final content
# field; fall back so the demo does not print literal `None`.
output_text = message.content or getattr(message, "reasoning_content", None)

if output_text:
    print(output_text)
else:
    print("No text content was returned by the model.")
