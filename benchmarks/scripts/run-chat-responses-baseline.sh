#!/bin/bash

set -x

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/benchmark-config.sh"
load_benchmark_config "${SCRIPT_DIR}" "${1:-}"

: "${CAPABILITY:=chat}"
: "${MODEL_ALIAS:=chat}"
: "${RUN_DATE:=$(date +%F)}"
: "${LIMIT_MODE:=prod-limits}"
: "${ENDPOINT_TYPE:=responses}"
: "${TOKENIZER:=openai/gpt-oss-20b}"
: "${ISL:=1000}"
: "${OSL:=300}"
: "${SCENARIO:=isl${ISL}-osl${OSL}}"
: "${CONCURRENCY_LEVELS:=1 2 4 8 16 32 64 120 240 480}"
: "${REQUEST_MULTIPLIER:=10}"
: "${ENDPOINT_PATH:=/v1/responses}"

RESULTS_DIR="${RESULTS_DIR:-${SCRIPT_DIR}/../artifacts/${LIMIT_MODE}/${RUN_DATE}/${MODEL_ALIAS}/${ENDPOINT_TYPE}/${SCENARIO}}"
mkdir -p "${RESULTS_DIR}"

echo URL: ${TUDELFT_TULIP_BASE_URL}
echo API KEY: ${TUDELFT_TULIP_API_KEY}

for conc in ${CONCURRENCY_LEVELS}; do
  pixi run aiperf profile \
    --model ${MODEL_ALIAS} \
    --tokenizer "${TOKENIZER}" \
    --url "${TUDELFT_TULIP_BASE_URL}/${CAPABILITY}" \
    --api-key "${TUDELFT_TULIP_API_KEY}" \
    --streaming \
    --endpoint-type template \
    --endpoint "${ENDPOINT_PATH}" \
    --synthetic-input-tokens-mean "${ISL}" \
    --synthetic-input-tokens-stddev 0 \
    --output-tokens-mean "${OSL}" \
    --output-tokens-stddev 0 \
    --concurrency "${conc}" \
    --request-count "$((conc * REQUEST_MULTIPLIER))" \
    --output-artifact-dir "${RESULTS_DIR}/concurrency-${conc}"
  echo "Finished concurrency ${conc}, sleeping for 10 seconds before next run"
  sleep 10
done

# pixi run aiperf plot \
#   --paths "${RESULTS_DIR}" \
#   --output "${RESULTS_DIR}/plots"

bash "${SCRIPT_DIR}/extract-errors-from-scenario.sh" "${1:-}"
bash "${SCRIPT_DIR}/extract-metrics-from-scenario.sh" "${1:-}"