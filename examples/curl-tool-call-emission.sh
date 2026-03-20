#!/bin/bash                                                                     
                                                                                
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/../.env" ]; then
  source "${SCRIPT_DIR}/../.env"
fi

echo "Using base URL: $TUDELFT_TULIP_BASE_URL"
echo "Using capability: $TUDELFT_TULIP_CAPABILITY"
echo "Using model alias: $TUDELFT_TULIP_MODEL_ALIAS"

echo "Check: can the model, plus parser, produce a proper OpenAI-style tool_calls object"

curl -s "${TUDELFT_TULIP_BASE_URL}/${TUDELFT_TULIP_CAPABILITY}/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
  -d '{
    "model": "'"${TUDELFT_TULIP_MODEL_ALIAS}"'",
    "messages": [
      {
        "role": "user",
        "content": "Call the get_system_health tool now. Do not answer in natural language."
      }
    ],
    "tools": [
      {
        "type": "function",
        "function": {
          "name": "get_system_health",
          "description": "Returns current health status.",
          "parameters": {
            "type": "object",
            "properties": {}
          }
        }
      }
    ],
    "tool_choice": "required",
    "temperature": 0,
    "max_tokens": 64
  }' | jq .
