#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "${SCRIPT_DIR}/../.env-staging" ]; then
  source "${SCRIPT_DIR}/../.env-staging"
fi

build_url() {
  local base="${TUDELFT_TULIP_BASE_URL%/}"
  local capability="${TUDELFT_TULIP_CAPABILITY:-}"

  if [ -n "${capability}" ]; then
    printf '%s/%s/v1/chat/completions\n' "$base" "$capability"
  else
    printf '%s/v1/chat/completions\n' "$base"
  fi
}

URL="$(build_url)"

function send_request() {
    local prompt="$1"
    curl -s -o /dev/null -w "%{http_code}\n" "${URL}" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
    -d '{
        "model": "chat",
        "messages": [{"role": "user", "content": "'"${prompt}"'"}]
    }'
}


run_parallel_test() {
  local label="$1"
  local count="$2"
  local prompt="$3"
  local tmpfile="$(mktemp)"

  echo "== ${label} test =="
  echo "Sending ${count} requests in parallel..."
  echo

  for i in $(seq 1 "$count"); do
    (
      code="$(send_request "$prompt")"
      printf '%s %02d -> %s\n' "$label" "$i" "$code"
      printf '%s\n' "$code" >> "$tmpfile"
    ) &
  done
  wait

  echo

  echo "${label} summary:"
  printf '%-10s %s\n' "# tests" "# status-code"
  sort "${tmpfile}" | uniq -c | awk '{printf "%-10s %s\n", $1, $2}'

  rm -f "${tmpfile}"
  echo
}

echo "Testing TULIP edge limits at: ${URL}"
echo

echo "== Single request sanity check =="
code="$(send_request "Say hello from TULIP.")"
echo "single -> $code"
echo

run_parallel_test "burst" 25 "Say hello from TULIP."
run_parallel_test "inflight" 5 "Write 120 numbered one-line facts about Delft. Keep going until all 120 are complete."
