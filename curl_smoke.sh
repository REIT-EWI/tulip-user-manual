#!/bin/bash

BASE_URL="${OPENAI_BASE_URL:-http://api.131.180.79.250.nip.io}"
API_KEY="${OPENAI_API_KEY:-DUMMY_KEY}"
MODEL="${OPENAI_MODEL:-gpt-oss-20b}"
MODEL="${OPENAI_MODEL:-mistralai/Mistral-7B-Instruct-v0.3}"

echo "Using base URL: $BASE_URL"
echo "Using model: $MODEL"


echo -e "\n***************************Listing models.***************************"
curl ${BASE_URL}/v1/models \
  -H "Authorization: Bearer ${API_KEY}" | jq .

echo -e "\n***************************Creating a model response.***************************"
curl ${BASE_URL}/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${API_KEY}" \
  -d '{
    "model": "'"${MODEL}"'",
    "input": "Tell me a three sentence bedtime story about a unicorn."
  }' | jq .


echo -e "\n***************************Creating a model response.***************************"
curl ${BASE_URL}/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${API_KEY}" \
  -d '{
    "model": "'"${MODEL}"'",
    "input": "another request. this time tell a long story."
  }' | jq .