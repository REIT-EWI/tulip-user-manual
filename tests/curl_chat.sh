#!/bin/bash

source ./.env

BASE_URL="${TULIP_BASE_URL:-https://api.tulip.tudelft.nl}"
API_KEY="${TULIP_API_KEY:-DUMMY_KEY}"
MODEL="${TULIP_MODEL:-openai/gpt-oss-20b}"

echo "Using base URL: $BASE_URL"
echo "Using model: $MODEL"

echo -e "\n***************************Listing models.***************************"
curl "${BASE_URL}/v1/models" \
  -H "Authorization: Bearer ${API_KEY}"

echo -e "\n\nUsing model: $MODEL\n"

echo -e "\n***************************Creating a model response.***************************"
curl ${BASE_URL}/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${API_KEY}" \
  -d '{
    "model": "'"${MODEL}"'",
    "max_tokens": 256,
    "temperature": 0.2,
    "messages": [
      { "role": "system", "content": "You are a helpful coding assistant for TU Delft." },
      { "role": "user", "content": "Write a tiny Python function that prints the TU Delft logo in ASCII." }
    ]
  }' | jq .
