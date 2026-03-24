#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/../.env" ]; then
  source "${SCRIPT_DIR}/../.env"
fi

curl -s --fail --show-error ${TUDELFT_TULIP_BASE_URL}/${TUDELFT_TULIP_CAPABILITY}/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
  -d '{
    "model": "'"${TUDELFT_TULIP_MODEL_ALIAS}"'",
    "input": "Tell me a three sentence bedtime story about a unicorn."
  }' | jq .


