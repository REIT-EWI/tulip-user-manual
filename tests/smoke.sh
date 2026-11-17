#!/usr/bin/env bash

# Smoke-test chat/code model listings and completions, plus embeddings.
# Load configuration from the repository-root .env or environment.
# Requires: bash, curl, jq, and TUDELFT_TULIP_API_KEY.
#
# Usage:
#   bash tests/smoke.sh
#   bash tests/smoke.sh --loop 3
#
# Write results to tests/logs/. Exit nonzero if any check fails.

# set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

if [ -f "${REPO_ROOT}/.env" ]; then
  # shellcheck disable=SC1090
  source "${REPO_ROOT}/.env"
fi

: "${TUDELFT_TULIP_API_KEY:?Set TUDELFT_TULIP_API_KEY in .env or environment}"

export TUDELFT_TULIP_BASE_URL="${TUDELFT_TULIP_BASE_URL:-https://api.tulip.tudelft.nl}"
API_ROOT="${TUDELFT_TULIP_BASE_URL%/}"

chat_alias="${TUDELFT_TULIP_CHAT_ALIAS:-chat}"
code_alias="${TUDELFT_TULIP_CODE_ALIAS:-code}"
embed_alias="${TUDELFT_TULIP_EMBED_ALIAS:-embed}"

LOOP_COUNT=1
while [[ $# -gt 0 ]]; do
  case "$1" in
    --loop)
      [[ $# -ge 2 ]] || { echo "--loop requires a value" >&2; exit 2; }
      LOOP_COUNT="$2"
      shift 2
      ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done

[[ "${LOOP_COUNT}" =~ ^[0-9]+$ ]] || { echo "--loop must be an integer" >&2; exit 2; }
[[ "${LOOP_COUNT}" -gt 0 ]] || { echo "--loop must be >= 1" >&2; exit 2; }

LOG_DIR="${SCRIPT_DIR}/logs"
mkdir -p "${LOG_DIR}"
LOG_FILE="${LOG_DIR}/smoke-$(date +%d%m%y-%H%M).log"
: > "${LOG_FILE}"

check_chat_content() {
  jq -e '
    .choices as $choices |
    ($choices | type == "array" and length > 0) and
    ($choices[0].message | type == "object") and
    (
      ($choices[0].message.content? | type == "string" and length > 0) or
      ($choices[0].message.reasoning_content? | type == "string" and length > 0) or
      ($choices[0].message.tool_calls? | type == "array" and length > 0)
    )
  ' >/dev/null
}

check_models_list() {
  jq -e '.data | type == "array" and length > 0 and all(.[]; .id? != null)' >/dev/null
}

check_embedding_vector() {
  jq -e '.data[0].embedding | type == "array" and length > 0' >/dev/null
}

run_models() {
  local capability="$1"

  curl -s --fail --show-error "${API_ROOT}/${capability}/v1/models" \
    -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json"
}

run_embeddings() {
  local capability="$1"
  local alias="$2"

  curl -s --fail --show-error "${API_ROOT}/${capability}/v1/embeddings" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
    -H "Accept: application/json" \
    -d '{
      "model": "'"${alias}"'",
      "input": ["Hello from tulip", "this rocks!"],
      "encoding_format": "float"
    }'
}

run_chat_completion() {
  local capability="$1"
  local alias="$2"

  curl -s --fail --show-error "${API_ROOT}/${capability}/v1/chat/completions" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${TUDELFT_TULIP_API_KEY}" \
    -H "Accept: application/json" \
    -d '{
      "model": "'"${alias}"'",
      "max_tokens": 32,
      "temperature": 0,
      "messages": [
        { "role": "system", "content": "You are a helpful coding assistant for TU Delft." },
        { "role": "user", "content": "Write a tiny Python function that prints the TU Delft logo in ASCII." }
      ]
    }'
}

run_and_check() {
  local title="$1"
  local checker="$2"
  local reference_script="$3"
  shift 3
  local output_file

  output_file="$(mktemp)"
  printf '%-40s' "${title} ..."
  printf '\n== %s ==\n' "${title}" >> "${LOG_FILE}"
  printf 'reference_example: %s\n' "${reference_script}" >> "${LOG_FILE}"

  if ! "$@" >"${output_file}" 2>>"${LOG_FILE}"; then
    cat "${output_file}" >> "${LOG_FILE}"
    rm -f "${output_file}"
    echo "FAIL"
    return 1
  fi

  cat "${output_file}" >> "${LOG_FILE}"

  if ! "${checker}" < "${output_file}"; then
    rm -f "${output_file}"
    echo "FAIL"
    return 1
  fi

  rm -f "${output_file}"
  echo "PASS"
}

FAILED_TOTAL=0

for ((run = 1; run <= LOOP_COUNT; run++)); do
  FAILED_RUN=0
  [[ "${LOOP_COUNT}" -gt 1 ]] && echo "--- Run ${run}/${LOOP_COUNT} ---"
  printf '\n--- Run %s/%s ---\n' "${run}" "${LOOP_COUNT}" >> "${LOG_FILE}"

  if ! run_and_check "Chat models"      check_models_list      "examples/curl-check-models.sh"     run_models chat; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi
  if ! run_and_check "Chat completion"  check_chat_content     "examples/curl-chat-completions.sh"  run_chat_completion chat  "${chat_alias}"; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi
  if ! run_and_check "Code models"      check_models_list      "examples/curl-check-models.sh"     run_models code; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi
  if ! run_and_check "Code completion"  check_chat_content     "examples/curl-chat-completions.sh"  run_chat_completion code  "${code_alias}"; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi
  if ! run_and_check "Embed models"     check_models_list      "examples/curl-check-models.sh"     run_models embed; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi
  if ! run_and_check "Embeddings"       check_embedding_vector "examples/curl-embedding.sh"         run_embeddings embed "${embed_alias}"; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi

  if [[ "${FAILED_RUN}" -gt 0 ]]; then
    echo "Run ${run}/${LOOP_COUNT}: ${FAILED_RUN} failed test(s)."
  fi
done

echo
if [[ "${FAILED_TOTAL}" -gt 0 ]]; then
  echo "Smoke tests completed with ${FAILED_TOTAL} failure(s).  Log: ${LOG_FILE}"
  exit 1
elif [[ "${LOOP_COUNT}" -gt 1 ]]; then
  echo "${LOOP_COUNT}/${LOOP_COUNT} runs passed.  Log: ${LOG_FILE}"
else
  echo "Smoke tests passed.  Log: ${LOG_FILE}"
fi
