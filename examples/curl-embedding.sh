#!/bin/bash

set -o pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/../.env" ]; then
  source "${SCRIPT_DIR}/../.env"
fi

curl -sS --fail-with-body \
  "${TUDELFT_TULIP_BASE_URL}/embed/v1/embeddings" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
  -d '{
    "model": "'"${TUDELFT_TULIP_MODEL_ALIAS}"'",
    "input": "Hello from TULIP",
    "encoding_format": "float"
  }' | jq '{n: (.data|length), dim: (.data[0].embedding|length)}'
