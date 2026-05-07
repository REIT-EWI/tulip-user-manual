#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/../.env" ]; then
  source "${SCRIPT_DIR}/../.env"
fi

: "${TUDELFT_TULIP_API_KEY:?Set TUDELFT_TULIP_API_KEY in .env or environment}"

BASE_URL="${TUDELFT_TULIP_BASE_URL:-https://api.tulip.tudelft.nl}"
CAPABILITY="chat"
MODEL_ALIAS="chat"
API_ROOT="${BASE_URL%/}/${CAPABILITY}/v1"

curl -sS --fail "${API_ROOT}/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
  -d '{
    "model": "'"${MODEL_ALIAS}"'",
    "temperature": 0.2,
    "messages": [
      {
        "role": "system",
        "content": "You rewrite higher-education policy text into clear, structured teaching content."
      },
      {
        "role": "user",
        "content": "Rewrite the following into a clear, student-friendly web page section:\n\n\"Our assessment policy ensures that all evaluations are aligned with course learning objectives. Students must demonstrate competency across theoretical understanding and practical application. Appeals can be submitted within 5 working days.\"\n\nMake it:\n- simpler language\n- structured with headings\n- include bullet points"
      }
    ]
  }' | jq -r '.choices[0].message.content'