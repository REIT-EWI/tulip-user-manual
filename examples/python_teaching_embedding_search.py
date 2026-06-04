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

query = "Where does it say whether group work is allowed in assessment?"
document_chunks = [
    (
        "Assessment methods may include written exams, project-based evaluation, "
        "group work, and oral components when aligned with course learning "
        "outcomes."
    ),
    "Appeals can be submitted within 5 working days after the publication of results.",
    (
        "Students should expect responses on the discussion board within 2 working "
        "days during teaching weeks."
    ),
    "Weekly labs are intended to provide guided practice before the final assessment.",
]

response = client.embeddings.create(
    model=EMBED_MODEL_ALIAS,
    input=[query, *document_chunks],
    encoding_format="float",
)

vectors = [item.embedding for item in response.data]
query_vector = vectors[0]
chunk_vectors = vectors[1:]


def cosine_similarity(left: list[float], right: list[float]) -> float:
    dot_product = sum(a * b for a, b in zip(left, right, strict=True))
    left_norm = math.sqrt(sum(value * value for value in left))
    right_norm = math.sqrt(sum(value * value for value in right))
    if left_norm == 0 or right_norm == 0:
        return 0.0
    return dot_product / (left_norm * right_norm)


scored_chunks = []
for chunk, vector in zip(document_chunks, chunk_vectors, strict=True):
    scored_chunks.append((cosine_similarity(query_vector, vector), chunk))

scored_chunks.sort(reverse=True)

print(f"Question: {query}\n")
print("Most relevant policy snippets:")
for index, (score, chunk) in enumerate(scored_chunks[:2], start=1):
    print(f"{index}. score={score:.3f}")
    print(f"   {chunk}")
