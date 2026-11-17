#!/bin/bash

set -o pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/../.env" ]; then
  source "${SCRIPT_DIR}/../.env"
fi

echo -e "\n\nModel: ${TUDELFT_TULIP_MODEL_ALIAS}" >&2
echo -e "\tExpected: One entry per generated token, containing its log probability and up to 5 top-token alternatives." >&2
curl -sS --fail-with-body --connect-timeout 15 --max-time 120 "${TUDELFT_TULIP_BASE_URL}/${TUDELFT_TULIP_CAPABILITY}/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
  -d '{
    "model": "'"${TUDELFT_TULIP_MODEL_ALIAS}"'",
    "messages": [
      {
        "role": "user",
        "content": "Complete: The capital of France is"
      }
    ],
    "chat_template_kwargs": {"enable_thinking": false},
    "max_tokens": 5,
    "logprobs": true,
    "top_logprobs": 5
  }' | jq .
