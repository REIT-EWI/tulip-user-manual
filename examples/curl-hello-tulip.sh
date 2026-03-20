#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/../.env" ]; then
  source "$SCRIPT_DIR/../.env"
fi

: "${TUDELFT_TULIP_API_KEY:?Set TUDELFT_TULIP_API_KEY in .env or environment}"

curl -s --fail --silent --show-error https://api.tulip.tudelft.nl/chat/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
  -d '{
    "model": "chat",
    "messages": [
      {"role": "user", "content": "Say hello from TULIP."}
    ]
  }' | jq .