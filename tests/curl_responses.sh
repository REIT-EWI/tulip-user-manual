#!/bin/bash

source ./.env

BASE_URL="${TULIP_BASE_URL:-https://api.tulip.tudelft.nl}"
API_KEY="${TULIP_API_KEY:-DUMMY_KEY}"
MODEL="${TULIP_MODEL:-openai/gpt-oss-20b}"

echo -e "\nUsing base URL: $BASE_URL\n"

echo -e "\n***************************Listing models.***************************"
curl "${BASE_URL}/v1/models" \
  -H "Authorization: Bearer ${API_KEY}"

echo -e "\n\nUsing model: $MODEL\n"


echo -e "\n***************************Creating a model response.***************************"
curl ${BASE_URL}/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${API_KEY}" \
  -d '{
    "model": "'"${MODEL}"'",
    "input": "Tell me a three sentence bedtime story about a unicorn."
  }' | jq .

echo -e "\n************************* Nvidia dynamo example ********************"
curl -X POST ${BASE_URL}/v1/responses \
  -H "Content-Type: application/json" \
  -d '{
    "model": "'"${MODEL}"'",
    "input": "Explain the concept of disaggregated serving in LLM inference in 3 sentences.",
    "max_output_tokens": 200,
    "stream": false
  }' | jq .


