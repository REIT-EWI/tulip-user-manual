#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
EXAMPLES_DIR="$(cd -- "${SCRIPT_DIR}/../examples" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

if [ -f "${REPO_ROOT}/.env" ]; then
  # shellcheck disable=SC1090
  source "${REPO_ROOT}/.env"
fi

: "${TUDELFT_TULIP_API_KEY:?Set TUDELFT_TULIP_API_KEY in .env or environment}"

export TUDELFT_TULIP_BASE_URL="${TUDELFT_TULIP_BASE_URL:-https://api.tulip.tudelft.nl}"

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
LOG_FILE="${LOG_DIR}/smoke-full-$(date +%d%m%y-%H%M).log"
 : > "${LOG_FILE}"

TMP_REPO_ROOT="$(mktemp -d)"
TMP_EXAMPLES_DIR="${TMP_REPO_ROOT}/examples"
mkdir -p "${TMP_EXAMPLES_DIR}"
cp -a "${EXAMPLES_DIR}/." "${TMP_EXAMPLES_DIR}/"

cleanup() {
  rm -rf "${TMP_REPO_ROOT}"
}
trap cleanup EXIT

write_example_env() {
  local capability="$1"
  local alias="$2"

  cat > "${TMP_REPO_ROOT}/.env" <<EOF
TUDELFT_TULIP_API_KEY=${TUDELFT_TULIP_API_KEY}
TUDELFT_TULIP_BASE_URL=${TUDELFT_TULIP_BASE_URL}
TUDELFT_TULIP_CAPABILITY=${capability}
TUDELFT_TULIP_MODEL_ALIAS=${alias}
EOF
}
run_example() {
  local capability="$1"
  local alias="$2"
  local runner="$3" # e.g. "bash" or "python"
  local script_path="$4"
  local relative_script_path
  local temp_script_path

  write_example_env "${capability}" "${alias}"
  relative_script_path="${script_path#${EXAMPLES_DIR}/}"
  temp_script_path="${TMP_EXAMPLES_DIR}/${relative_script_path}"

  "${runner}" "${temp_script_path}"
}

run_and_expect_success() {
  local title="$1"
  local reference_script="$2"
  shift 2
  local output_file

  output_file="$(mktemp)"
  printf '%-40s' "${title} ..."
  printf '\n== %s ==\n' "${title}" >> "${LOG_FILE}"
  printf 'reference_example: %s\n' "${reference_script}" >> "${LOG_FILE}"

  if ! "$@" >"${output_file}" 2>&1; then
    cat "${output_file}" >> "${LOG_FILE}"
    rm -f "${output_file}"
    echo "FAIL"
    return 1
  fi

  cat "${output_file}" >> "${LOG_FILE}"

  rm -f "${output_file}"
  echo "PASS"
}

FAILED_TOTAL=0

for ((run = 1; run <= LOOP_COUNT; run++)); do
  FAILED_RUN=0
  [ "${LOOP_COUNT}" -gt 1 ] && echo "--- Run ${run}/${LOOP_COUNT} ---"
  printf '\n--- Run %s/%s ---\n' "${run}" "${LOOP_COUNT}" >> "${LOG_FILE}"

  if ! run_and_expect_success "Bash hello (chat)"             "examples/curl-hello-tulip.sh"        run_example chat  "${chat_alias}"  bash   "${EXAMPLES_DIR}/curl-hello-tulip.sh"; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi
  if ! run_and_expect_success "Bash models"                   "examples/curl-check-models.sh"       run_example chat  "${chat_alias}"  bash   "${EXAMPLES_DIR}/curl-check-models.sh"; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi
  if ! run_and_expect_success "Bash responses"                "examples/curl-responses-basic.sh"    run_example chat  "${chat_alias}"  bash   "${EXAMPLES_DIR}/curl-responses-basic.sh"; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi
  if ! run_and_expect_success "Bash chat completion (code)"   "examples/curl-chat-completions.sh"   run_example code  "${code_alias}"  bash   "${EXAMPLES_DIR}/curl-chat-completions.sh"; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi
  if ! run_and_expect_success "Bash tool-call emission"       "examples/curl-tool-call-emission.sh" run_example code  "${code_alias}"  bash   "${EXAMPLES_DIR}/curl-tool-call-emission.sh"; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi
  if ! run_and_expect_success "Bash tool-call loop"           "examples/curl-tool-call-loop.sh"     run_example code  "${code_alias}"  bash   "${EXAMPLES_DIR}/curl-tool-call-loop.sh"; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi
  if ! run_and_expect_success "Bash embeddings"               "examples/curl-embedding.sh"          run_example embed "${embed_alias}" bash   "${EXAMPLES_DIR}/curl-embedding.sh"; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi

  if ! run_and_expect_success "Python hello (chat)"           "examples/python_hello_tulip.py"      run_example chat  "${chat_alias}"  python "${EXAMPLES_DIR}/python_hello_tulip.py"; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi
  if ! run_and_expect_success "Python responses basic"        "examples/python_responses_basic.py"  run_example chat  "${chat_alias}"  python "${EXAMPLES_DIR}/python_responses_basic.py"; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi
  if ! run_and_expect_success "Python responses async"        "examples/python_responses_async.py"  run_example chat  "${chat_alias}"  python "${EXAMPLES_DIR}/python_responses_async.py"; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi
  if ! run_and_expect_success "Python responses stream"       "examples/python_responses_stream.py" run_example chat  "${chat_alias}"  python "${EXAMPLES_DIR}/python_responses_stream.py"; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi
  if ! run_and_expect_success "Python chat completion (code)" "examples/python_chat_completions.py" run_example code  "${code_alias}"  python "${EXAMPLES_DIR}/python_chat_completions.py"; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi
  if ! run_and_expect_success "Python tool-call emission"     "examples/python_tool_call_emission.py" run_example code "${code_alias}"  python "${EXAMPLES_DIR}/python_tool_call_emission.py"; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi
  if ! run_and_expect_success "Python tool-call loop"         "examples/python_tool_call_loop.py"   run_example code  "${code_alias}"  python "${EXAMPLES_DIR}/python_tool_call_loop.py"; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi
  if ! run_and_expect_success "Python embeddings"             "examples/python_embedding.py"        run_example embed "${embed_alias}" python "${EXAMPLES_DIR}/python_embedding.py"; then ((FAILED_RUN+=1)); ((FAILED_TOTAL+=1)); fi

  if [[ "${FAILED_RUN}" -gt 0 ]]; then
    echo "Run ${run}/${LOOP_COUNT}: ${FAILED_RUN} failed test(s)."
  fi
done

echo
if [[ "${FAILED_TOTAL}" -gt 0 ]]; then
  echo "Full smoke tests completed with ${FAILED_TOTAL} failure(s).  Log: ${LOG_FILE}"
  exit 1
elif [[ "${LOOP_COUNT}" -gt 1 ]]; then
  echo "${LOOP_COUNT}/${LOOP_COUNT} runs passed.  Log: ${LOG_FILE}"
else
  echo "Full smoke tests passed.  Log: ${LOG_FILE}"
fi
