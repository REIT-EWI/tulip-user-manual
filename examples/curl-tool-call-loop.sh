#!/bin/bash                                                                     
                                                                                
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/../.env" ]; then
  source "${SCRIPT_DIR}/../.env"
fi

curl -s --fail --show-error "${TUDELFT_TULIP_BASE_URL}/${TUDELFT_TULIP_CAPABILITY}/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
  -d '{
    "model": "'"${TUDELFT_TULIP_MODEL_ALIAS}"'",
    "messages": [
      {
        "role": "user",
        "content": "Hey, quick check: is everything up and running?"
      },
      {
        "role": "assistant",
        "tool_calls": [
          {
            "id": "call-1",
            "type": "function",
            "function": {
              "name": "get_system_health",
              "arguments": "{}"
            }
          }
        ]
      },
      {
        "role": "tool",
        "tool_call_id": "call-1",
        "content": "{\"status\":\"ok\",\"uptime_seconds\":372045}"
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
    "temperature": 0,
    "max_tokens": 128
  }' | jq .

