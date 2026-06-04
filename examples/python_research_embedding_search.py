import math

from common import (
    TUDELFT_TULIP_API_KEY,
    TUDELFT_TULIP_BASE_URL,
)
from openai import OpenAI

EMBED_CAPABILITY = "embed"
EMBED_MODEL_ALIAS = "embed"

_base_url = TUDELFT_TULIP_BASE_URL.rstrip("/")
if _base_url.endswith("/v1"):
    _base_url = _base_url[: -len("/v1")]
if _base_url.endswith(("/chat", "/code", "/embed")):
    _base_url = _base_url.rsplit("/", 1)[0]
EMBED_BASE_URL = f"{_base_url}/{EMBED_CAPABILITY}/v1"

client = OpenAI(base_url=EMBED_BASE_URL, api_key=TUDELFT_TULIP_API_KEY)

research_question = (
    "Where do participants mention uncertainty about using AI with sensitive data?"
)

text_chunks = [
    (
        "Source 1: I used the tool to summarise meeting notes, but I was not "
        "sure whether confidential project details were allowed to be pasted into it."
    ),
    (
        "Source 2: The main benefit was speed. It helped me turn rough notes into "
        "a cleaner first draft before I edited the text myself."
    ),
    (
        "Source 3: Several people described trying the tool after seeing colleagues "
        "use it in their group."
    ),
    (
        "Source 4: I wanted to ask it about interview data, but I hesitated "
        "because the transcript included personal experiences and unpublished findings."
    ),
    (
        "Source 5: The answer looked polished, but it missed context from earlier "
        "in the conversation, so I still had to check it carefully."
    ),
]

response = client.embeddings.create(
    model=EMBED_MODEL_ALIAS,
    input=[research_question, *text_chunks],
    encoding_format="float",
)

vectors = [item.embedding for item in response.data]
question_vector = vectors[0]
chunk_vectors = vectors[1:]


def cosine_similarity(left: list[float], right: list[float]) -> float:
    dot_product = sum(a * b for a, b in zip(left, right, strict=True))
    left_norm = math.sqrt(sum(value * value for value in left))
    right_norm = math.sqrt(sum(value * value for value in right))
    if left_norm == 0 or right_norm == 0:
        return 0.0
    return dot_product / (left_norm * right_norm)


scored_chunks = []
for chunk, vector in zip(text_chunks, chunk_vectors, strict=True):
    scored_chunks.append((cosine_similarity(question_vector, vector), chunk))

scored_chunks.sort(reverse=True)

print(f"Research question: {research_question}\n")
print("Most relevant transcript/text chunks for researcher review:")
for index, (score, chunk) in enumerate(scored_chunks[:3], start=1):
    print(f"{index}. score={score:.3f}")
    print(f"   {chunk}")

print(
    "\nNote: embedding search ranks passages by semantic similarity. "
    "The retrieved chunks still need to be cited, checked, and interpreted"
    " by the researcher."
)
