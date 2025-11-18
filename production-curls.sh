#!/bin/bash

curl https://api.tulip.tudelft.nl/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "Qwen/Qwen2.5-Coder-14B-Instruct",
    "max_tokens": 256,
    "temperature": 0.2,
    "messages": [
      { "role": "system", "content": "You are a helpful coding assistant for TU Delft." },
      { "role": "user", "content": "Write a tiny Python function that prints the TU Delft logo in ASCII." }
    ]
  }' | jq .


curl https://api.tulip.tudelft.nl/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "mistralai/Ministral-8B-Instruct-2410",
    "max_tokens": 64,
    "temperature": 0.7,
    "messages": [
      { "role": "system", "content": "You are a helpful assistant for TU Delft users." },
      { "role": "user", "content": "Say hello from Ministral in one short sentence." }
    ]
  }' | jq .



curl https://api.tulip.tudelft.nl/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "openai/gpt-oss-20b",
    "max_tokens": 256,
    "temperature": 0.2,
    "messages": [
      { "role": "system", "content": "You are a helpful coding assistant for TU Delft." },
      { "role": "user", "content": "Write a tiny Python function that prints the TU Delft logo in ASCII." }
    ]
  }'| jq .