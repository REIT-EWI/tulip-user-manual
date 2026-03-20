#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/../.env" ]; then
  source "${SCRIPT_DIR}/../.env"
fi

TUDELFT_TULIP_BASE_URL="${TUDELFT_TULIP_BASE_URL:-https://api.tulip.tudelft.nl}"
TUDELFT_TULIP_API_KEY="${TUDELFT_TULIP_API_KEY:-DUMMY_KEY}"
TUDELFT_TULIP_MODEL_ALIAS="${TUDELFT_TULIP_MODEL_ALIAS:-chat}"
TUDELFT_TULIP_CAPABILITY="${TUDELFT_TULIP_CAPABILITY:-chat}"

echo "Using capability: $TUDELFT_TULIP_CAPABILITY"
echo "Using model alias: $TUDELFT_TULIP_MODEL_ALIAS"

curl -s ${TUDELFT_TULIP_BASE_URL}/${TUDELFT_TULIP_CAPABILITY}/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
  -d '{
    "model": "'"${TUDELFT_TULIP_MODEL_ALIAS}"'",
    "input": "Tell me a three sentence bedtime story about a unicorn."
  }' | jq .


