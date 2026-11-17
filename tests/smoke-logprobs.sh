#!/usr/bin/env bash

# Validate prompt, batch-prompt, output, and top-k log probabilities
# for chat and code by running the four curl-logprobs example scripts.
# Use temporary copies with per-model configuration: eight requests per run.
# Load configuration from the repository-root .env or environment.
# Requires: bash, curl, jq, and TUDELFT_TULIP_API_KEY.
#
# Usage:
#   bash tests/smoke-logprobs.sh
#   bash tests/smoke-logprobs.sh --loop 3
#
# Write results to tests/logs/. Exit nonzero if any check fails.
# The known batch prompt-logprobs limitation produces a warning.

set -uo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
if [ -f "${REPO_ROOT}/.env" ]; then
  # shellcheck disable=SC1090
  source "${REPO_ROOT}/.env"
fi

: "${TUDELFT_TULIP_API_KEY:?Set TUDELFT_TULIP_API_KEY in .env or environment}"
API_ROOT="${TUDELFT_TULIP_BASE_URL:-https://api.tulip.tudelft.nl}"
API_ROOT="${API_ROOT%/}"
chat_alias="${TUDELFT_TULIP_CHAT_ALIAS:-chat}"
code_alias="${TUDELFT_TULIP_CODE_ALIAS:-code}"

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
[[ "$LOOP_COUNT" =~ ^[0-9]+$ ]] || { echo "--loop must be an integer" >&2; exit 2; }
LOOP_COUNT=$((10#$LOOP_COUNT))
[[ "$LOOP_COUNT" -gt 0 ]] || { echo "--loop must be >= 1" >&2; exit 2; }
for dependency in curl jq; do
  command -v "$dependency" >/dev/null || { echo "Missing dependency: $dependency" >&2; exit 2; }
done

LOG_DIR="${SCRIPT_DIR}/logs"
mkdir -p "$LOG_DIR" || exit 1
LOG_FILE="$(mktemp "${LOG_DIR}/smoke-logprobs-$(date +%d%m%y-%H%M%S)-XXXXXX.log")" || exit 1

# Prompt logprobs are arrays of token-ID maps; the first token has no score.
# Accept either the shared nvext field or per-choice fields for batch responses.
check_response() {
  local kind="$1"
  jq -e --arg kind "$kind" '
    def score: type == "number" and . <= 0 and . > -1e30;
    def prompt_scores:
      type == "array" and length > 1 and .[0] == null and
      all(.[1:][]; type == "object" and length > 0 and
        all(.[]; type == "object" and (.logprob | score)));
    def generated_scores:
      type == "array" and length > 0 and
      all(.[]; (.token | type == "string") and (.logprob | score));
    .error? == null and
    (.choices | type == "array") and
    if $kind == "prompt" then
      (.choices | length == 1) and (.nvext.prompt_logprobs | prompt_scores)
    elif $kind == "prompt-batch" then
      (.choices | length == 2) and
      ([.choices[].index] | sort == [0, 1]) and
      ((.nvext.prompt_logprobs | prompt_scores) or
       (.nvext.prompt_logprobs | type == "array" and length == 2 and all(.[]; prompt_scores)) or
       all(.choices[]; .nvext.prompt_logprobs | prompt_scores))
    else
      (.choices | length == 1) and
      (.choices[0].logprobs.content | generated_scores) and
      if $kind == "output-top" then
        all(.choices[0].logprobs.content[];
          .top_logprobs | generated_scores and length <= 5)
      else true end
    end
  ' >/dev/null
}

# Keep the examples unchanged while supplying each capability its own .env.
TMP_REPO_ROOT="$(mktemp -d)" || exit 1
TMP_EXAMPLES_DIR="${TMP_REPO_ROOT}/examples"
cleanup() {
  rm -rf -- "$TMP_REPO_ROOT"
}
trap cleanup EXIT
mkdir -p "$TMP_EXAMPLES_DIR" || exit 1
cp "${REPO_ROOT}/examples/"curl-logprobs*.sh "$TMP_EXAMPLES_DIR/" || exit 1

run_example() {
  local capability="$1" alias="$2" reference_script="$3"
  # Shell-quote values so sourcing the temporary file preserves them literally.
  {
    printf 'TUDELFT_TULIP_API_KEY=%q\n' "$TUDELFT_TULIP_API_KEY"
    printf 'TUDELFT_TULIP_BASE_URL=%q\n' "$API_ROOT"
    printf 'TUDELFT_TULIP_CAPABILITY=%q\n' "$capability"
    printf 'TUDELFT_TULIP_MODEL_ALIAS=%q\n' "$alias"
  } > "${TMP_REPO_ROOT}/.env" || return 1
  bash "${TMP_REPO_ROOT}/${reference_script}"
}

run_check() {
  local capability="$1" alias="$2" kind="$3" reference_script="$4"
  local response result
  printf '%-44s' "${capability} ${kind} ..."
  printf '\n== %s %s ==\nreference_example: %s\n' \
    "$capability" "$kind" "$reference_script" >> "$LOG_FILE"
  if ! response="$(run_example "$capability" "$alias" "$reference_script" 2>>"$LOG_FILE")"; then
    printf '%s\nFAIL: request failed\n' "$response" >> "$LOG_FILE"
    echo FAIL
    return 1
  fi
  printf '%s\n' "$response" >> "$LOG_FILE"
  # Slurp first to reject empty bodies and multiple JSON documents.
  if ! printf '%s\n' "$response" | jq -es 'length == 1 and (.[0] | type == "object")' >/dev/null 2>>"$LOG_FILE" ||
     ! check_response "$kind" <<< "$response" 2>>"$LOG_FILE"; then
    echo 'FAIL: invalid response or missing/invalid log probabilities' >> "$LOG_FILE"
    echo FAIL
    return 1
  fi
  result=PASS
  if [[ "$kind" == prompt-batch ]] &&
     jq -e '.nvext.prompt_logprobs | type == "array" and .[0] == null' <<< "$response" >/dev/null; then
    result='WARN: two choices returned, but prompt logprobs cover only one prompt (known limitation)'
    ((WARNED_TOTAL+=1))
  else
    ((PASSED_TOTAL+=1))
  fi
  echo "$result"
  echo "$result" >> "$LOG_FILE"
}

PASSED_TOTAL=0
WARNED_TOTAL=0
FAILED_TOTAL=0
for ((run = 1; run <= LOOP_COUNT; run++)); do
  echo "--- Run ${run}/${LOOP_COUNT} ---"
  printf '\n--- Run %s/%s ---\n' "$run" "$LOOP_COUNT" >> "$LOG_FILE"
  for capability in chat code; do
    alias="$chat_alias"
    [[ "$capability" == code ]] && alias="$code_alias"
    if ! run_check "$capability" "$alias" prompt "examples/curl-logprobs-prompt.sh"; then ((FAILED_TOTAL+=1)); fi
    if ! run_check "$capability" "$alias" prompt-batch "examples/curl-logprobs-prompt-batch.sh"; then ((FAILED_TOTAL+=1)); fi
    if ! run_check "$capability" "$alias" output "examples/curl-logprobs-output.sh"; then ((FAILED_TOTAL+=1)); fi
    if ! run_check "$capability" "$alias" output-top "examples/curl-logprobs-output-top.sh"; then ((FAILED_TOTAL+=1)); fi
  done
done
SUMMARY="Logprobs summary: ${PASSED_TOTAL} PASS, ${WARNED_TOTAL} WARN, ${FAILED_TOTAL} FAIL"
echo "$SUMMARY"
echo "$SUMMARY" >> "$LOG_FILE"
if [[ "$FAILED_TOTAL" -gt 0 ]]; then
  echo "Logprobs smoke tests completed with ${FAILED_TOTAL} failure(s). Log: ${LOG_FILE}"
  exit 1
fi
echo "Logprobs smoke tests passed (see any WARN results above). Log: ${LOG_FILE}"
