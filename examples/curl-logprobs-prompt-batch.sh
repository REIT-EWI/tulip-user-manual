#!/bin/bash

set -o pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/../.env" ]; then
  source "${SCRIPT_DIR}/../.env"
fi

echo -e "\n\nModel: ${TUDELFT_TULIP_MODEL_ALIAS}" >&2
echo -e "\tKnown limitation: Batch completions return multiple choices, but nvext.prompt_logprobs contains only the first prompt's log probabilities." >&2
echo -e "\tWorkaround: Submit prompts individually when computing perplexity." >&2

curl -sS --fail-with-body --connect-timeout 15 --max-time 120 "${TUDELFT_TULIP_BASE_URL}/${TUDELFT_TULIP_CAPABILITY}/v1/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
  -d '{
    "model": "'"${TUDELFT_TULIP_MODEL_ALIAS}"'",
    "prompt": ["The capital of France is Paris", "The capital of Germany is Berlin"],
    "max_tokens": 1,
    "prompt_logprobs": 0,
    "nvext": {
      "extra_fields": ["prompt_logprobs", "prompt_token_ids"]
    }
  }' | jq .
