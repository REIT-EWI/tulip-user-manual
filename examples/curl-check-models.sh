#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/../.env" ]; then
  source "$SCRIPT_DIR/../.env"
fi

: "${TUDELFT_TULIP_API_KEY:?Set TUDELFT_TULIP_API_KEY in .env or environment}"

for route in chat code embed; do
   curl -s --fail --show-error "https://api.tulip.tudelft.nl/${route}/v1/models" \
    -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
    -H "Content-Type: application/json" | jq .
done
