#!/bin/bash

source ./.env

BASE_URL="${TULIP_BASE_URL:-https://api.tulip.tudelft.nl}"
API_KEY="${TULIP_API_KEY:-DUMMY_KEY}"
MODEL="${TULIP_MODEL:-openai/gpt-oss-20b}"

echo -e "\nUsing base URL: $BASE_URL\n"

echo -e "\n***************************Listing models.***************************"

echo -e "\n\nUsing model: $MODEL\n"

echo -e "\n************************* Nvidia dynamo example ********************"
echo "https://github.com/ai-dynamo/dynamo/blob/5734f5c42739abe33eaf43f5d7b8ca60af72d169/docs/pages/backends/vllm/gpt-oss.md#4-reasoning-and-tool-calling"
curl ${BASE_URL}/v1/chat/completions  \
  -H "Content-Type: application/json" \
  -d '{
	  "model": "'"${MODEL}"'",
	  "messages": [
		{
		  "role": "user",
		  "content": "Hey, quick check: is everything up and running?"
		}
	  ],
	  "tools": [
		{
		  "type": "function",
		  "function": {
			"name": "get_system_health",
			"description": "Returns the current health status of the LLM runtime—use before critical operations to verify the service is live.",
			"parameters": {
			  "type": "object",
			  "properties": {}
			}
		  }
		}
	  ],
	  "response_format": {
		"type": "text"
	  },
	  "stream": false,
	  "max_tokens": 300
	}' | jq . 

curl ${BASE_URL}/v1/chat/completions  \
  -H "Content-Type: application/json" \
  -d '{
	  "model": "'"${MODEL}"'",
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
			"description": "Returns the current health status of the LLM runtime—use before critical operations to verify the service is live.",
			"parameters": {
			  "type": "object",
			  "properties": {}
			}
		  }
		}
	  ],
	  "response_format": {
		"type": "text"
	  },
	  "stream": false,
	  "max_tokens": 300
	}' | jq .
