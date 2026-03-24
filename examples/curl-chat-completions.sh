#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/../.env" ]; then
  source "${SCRIPT_DIR}/../.env"
fi

curl -s --fail --show-error ${TUDELFT_TULIP_BASE_URL}/${TUDELFT_TULIP_CAPABILITY}/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
  -d '{
    "model": "'"${TUDELFT_TULIP_MODEL_ALIAS}"'",
    "max_tokens": 256,
    "temperature": 0.2,
    "messages": [
      { "role": "system", "content": "You are a helpful coding assistant for TU Delft." },
      { "role": "user", "content": "Write a tiny Python function that prints the TU Delft logo in ASCII." }
    ]
  }' | jq .
