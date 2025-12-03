#!/bin/bash

#export SERVER_IP=131.180.79.250

BASE_URL="${TULIP_BASE_URL:-http://demo.131.180.79.250.nip.io}"
API_KEY="${TULIP_API_KEY:-DUMMY_KEY}"
MODEL="${TULIP_MODEL:-gpt-oss-20b}"
MAX_OUTPUT=8                         # keep tiny so output tokens don't dominate

echo "Using base URL: $BASE_URL"
echo "Using model: $MODEL"

echo -e "\n***************************Checking varied context***************************"
CONTEXT_LEN=(2000 4000 8000 16000 32000)  # word-count proxies

for len in ${CONTEXT_LEN[@]}; do
  echo "******************* Testing with ~${len} words***************"

  echo "1) Generate a varied prompt into a file (reduces BPE quirks)"
  python3 - "$len" > prompt_${len}.txt <<'PY'
import sys, random, string
N = int(sys.argv[1])
rng = random.Random(42)
words = [''.join(rng.choices(string.ascii_lowercase, k=5)) for _ in range(N)]
print(' '.join(words) + '\nSay ONLY: probe')
PY

  echo "2) Build JSON safely (no giant inline strings)"
  jq -n \
    --arg model "${MODEL}" \
    --rawfile content prompt_${len}.txt \
    --argjson max "${MAX_OUTPUT}" \
    '{model:$model, messages:[{role:"user", content:$content}], max_tokens:$max, stream:false}' \
    > payload_${len}.json

  echo "3) POST (file-based to avoid arg-length limits)"
  curl -s "${BASE_URL}/v1/chat/completions" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${API_KEY}" \
    --data-binary @payload_${len}.json \
    | jq '{ok: (has("choices")), usage: (.usage // null), error: (.error // null)}'

  rm prompt_${len}.txt payload_${len}.json 
done
