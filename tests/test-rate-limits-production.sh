#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/../.env" ]; then
  source "${SCRIPT_DIR}/../.env"
fi

build_url() {
  local capability="$1"
  local base="${TUDELFT_TULIP_BASE_URL%/}"
  printf '%s/%s/v1\n' "$base" "$capability"
}

function run_curl() {
  local output
  local rc

  output="$(curl -sS -o /dev/null -w "%{http_code}" "$@")" || rc=$?
  rc="${rc:-0}"
  printf '%s/%s\n' "$output" "$rc"
}

function send_chat_request() {
    local capability="$1"
    local model_alias="${2:-chat}"
    local prompt="$3"

    local URL="$(build_url "$capability")/chat/completions"
    
    run_curl "${URL}" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
    -d '{
        "model": "'"${model_alias}"'",
        "messages": [{"role": "user", "content": "'"${prompt}"'"}]
    }'
}

function send_embed_request() {
    local capability="$1"
    local model_alias="${2:-embed}"

    local URL="$(build_url "$capability")/embeddings"
    
    run_curl "${URL}" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
    -d '{
        "model": "'"${model_alias}"'",
        "input": ["hello from TULIP", "bye from TULIP"]
    }'
}

run_parallel_test() {
  local label="$1"
  local count="$2"
  local kind="$3" # "chat" or "embed"
  local capability="$4" # chat, code, embed
  local model_alias="$5" # chat, code, embed
  local prompt="$6"
  
  local tmpdir="$(mktemp -d)"

  echo "== ${label} test: ${capability} =="
  echo "Sending ${count} requests in parallel..."
  echo

  for i in $(seq 1 "$count"); do
    (
      if [ "$kind" = "embed" ]; then
        code="$(send_embed_request "$capability" "$model_alias")"
      else
        code="$(send_chat_request "$capability" "$model_alias" "$prompt")"
      fi
      printf '%s\n' "$code" > "${tmpdir}/${i}.code"
      # printf '%s %s %03d -> %s\n' "$label" "$capability" "$i" "$code"
    ) &
  done
  wait

  echo
  echo "${label} summary (${capability}):"
  printf '%-10s %-10s %-10s\n' "# tests" "http" "rc"

  awk -F/ '
  {
    key = $1 "/" $2
    count[key]++
  }
  END {
    for (k in count) {
      split(k, a, "/")
      printf "%-10d %-10s %-10s\n", count[k], a[1], a[2]
    }
  }
  ' "${tmpdir}"/*.code | sort -nr
  echo "total recorded: $(cat "${tmpdir}"/*.code | wc -l)"
  rm -rf "${tmpdir}"
  echo
}

echo "Testing TULIP edge limits at: ${TUDELFT_TULIP_BASE_URL}"
echo

echo "== Sanity checks =="
echo "chat  -> $(send_chat_request chat chat 'Say hello from TULIP.')"
echo "code  -> $(send_chat_request code code 'Write a hello-world function in Python.')"
echo "embed -> $(send_embed_request embed embed)"
echo

# test concurrent requests via `limit-connections`. 
# 200 is success, 503 when the limit is hit.
echo "Testing concurrency limits...============================================================="
run_parallel_test "concurrency" 30 chat chat chat "Write 15 numbered one-line facts about Delft."
run_parallel_test "concurrency" 30 chat code code "Write 15 short Python utility functions, each on its own numbered line."

# test burst (`limit-rps` and `limit-burst-multiplier`) 
# dominated by `limit-connections` for chat/code due to longer request duration, but should be more visible for embed, due to shorter request duration allowing more total requests and retries within the test duration.
# more visible for embed, due to shorter duration allowing more total requests and retries within the test duration.
# 200 is success, 503 when the limit is hit.
echo "Testing burst limits...================================================================="
run_parallel_test "burst" 60 chat chat chat "Reply with one word: hello"
run_parallel_test "burst" 60 chat code code "Return exactly this string and nothing else: print('hello')"
run_parallel_test "burst" 200 embed embed embed

# backend latency / timeout probe, not a pure limit-connections test
echo "Testing time-out limits...=============================================================="
run_parallel_test "time-out" 15 chat chat chat "Write 80 numbered one-line facts about Delft"
run_parallel_test "time-out" 15 chat code code "Write 50 short Python functions, each 2-3 lines, numbered."