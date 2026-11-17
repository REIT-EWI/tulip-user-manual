#!/bin/bash

source .env

for model in "chat" "code"; do
  echo -e "\n\nModel: $model"
  echo -e "---------------------------- Example 1a: Prompt-token Log Probabilities -----------------------"
  echo -e "\tExpected: One entry per prompt token; first null; remaining entries contain valid log probabilities."
  curl -s https://api.tulip.tudelft.nl/${model}/v1/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
    -d '{
      "model": "'$model'",
      "prompt": "The capital of France is Paris",
      "max_tokens": 1,
      "prompt_logprobs": 0,
      "nvext": {
        "extra_fields": ["prompt_logprobs"]
      }
    }' | jq .

    echo -e "---------------------------- Example 1b: batch processing -----------------------"
    echo -e "\tKnown limitation: Batch completions return multiple choices, but nvext.prompt_logprobs contains only the first prompt's log probabilities."
    echo -e "\tWorkaround: Submit prompts individually when computing perplexity."

    curl -s https://api.tulip.tudelft.nl/${model}/v1/completions \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
      -d '{
        "model": "'$model'",
        "prompt": ["The capital of France is Paris", "The capital of Germany is Berlin"],
        "max_tokens": 1,
        "prompt_logprobs": 0,
        "nvext": {
          "extra_fields": ["prompt_logprobs", "prompt_token_ids"]
        }
      }' | jq .



  echo -e "----------------------------Example 2: Output log probabilities -----------------------"
  echo -e "\tExpected: One entry per generated token; each entry contains a valid log probability."
  curl -s https://api.tulip.tudelft.nl/$model/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
    -d '{
      "model": "'$model'",
      "messages": [
        {
          "role": "user",
          "content": "Complete: The capital of France is"
        }
      ],
      "chat_template_kwargs": {"enable_thinking": false},
      "max_tokens": 5,
      "logprobs": true      
    }' | jq .

    echo -e "----------------------------Example 3: Top-k log probabilities -----------------------"
    echo -e "\tExpected: One entry per generated token, containing its log probability and up to 5 top-token alternatives."
    curl -s https://api.tulip.tudelft.nl/$model/v1/chat/completions \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
      -d '{
        "model": "'$model'",
        "messages": [
          {
            "role": "user",
            "content": "Complete: The capital of France is"
          }
        ],
        "chat_template_kwargs": {"enable_thinking": false},
        "max_tokens": 5,
        "logprobs": true,
        "top_logprobs": 5
      }' | jq .

    echo "*********************************************************************************"
  
  done