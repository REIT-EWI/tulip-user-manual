#!/bin/bash

source ./.env

BASE_URL="${TULIP_BASE_URL:-https://embedding.tulip.tudelft.nl}"
API_KEY="${TULIP_API_KEY:-DUMMY_KEY}"
MODEL="${TULIP_MODEL:-Qwen/Qwen3-Embedding-8B}"

echo "Using base URL: $BASE_URL"
echo "Using model: $MODEL"

echo -e "\n***************************Listing models.***************************"
curl "${BASE_URL}/v1/models" \
  -H "Authorization: Bearer ${API_KEY}"

echo -e "\n\nUsing model: $MODEL\n"

echo -e "\n********** Check embeddings works (dimension check) *****************"
curl -sk ${BASE_URL}/v1/embeddings \
  -H "Content-Type: application/json" \
  -d '{"model":"'"$MODEL"'","input":["a","b"],"encoding_format":"float"}' \
| jq '{n: (.data|length), dim: (.data[0].embedding|length)}'

echo -e "\n*** Check embeddings works (different strings -> different vectors) ***"
curl -sk ${BASE_URL}/v1/embeddings \
  -H "Content-Type: application/json" \
  -d '{"model":"'"$MODEL"'","input":["cat","quantum entanglement"],"encoding_format":"float"}' \
| jq '.data[].embedding[0:5]'