#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/../.env" ]; then
  source "${SCRIPT_DIR}/../.env"
fi

echo "Using base URL: $TUDELFT_TULIP_BASE_URL"
echo "Using capability: $TUDELFT_TULIP_CAPABILITY"
echo "Using model alias: $TUDELFT_TULIP_MODEL_ALIAS"

echo -e "\n********** Check embeddings works (dimension check) *****************"
curl -sk ${TUDELFT_TULIP_BASE_URL}/${TUDELFT_TULIP_CAPABILITY}/v1/embeddings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
  -d '{"model":"'"$TUDELFT_TULIP_MODEL_ALIAS"'",
       "input":["Hello from tulip","this rocks!"],
       "encoding_format":"float"}' \
| jq '{n: (.data|length), dim: (.data[0].embedding|length)}'

echo -e "\n*** Check embeddings works (different strings -> different vectors) ***"
curl -sk ${TUDELFT_TULIP_BASE_URL}/${TUDELFT_TULIP_CAPABILITY}/v1/embeddings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
  -d '{"model":"'"$TUDELFT_TULIP_MODEL_ALIAS"'",
       "input":["cat","quantum entanglement"],
       "encoding_format":"float"}' \
| jq '.data[].embedding[0:5]'