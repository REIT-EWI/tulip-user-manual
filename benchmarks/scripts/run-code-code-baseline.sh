#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/benchmark-config.sh"
load_benchmark_config "${SCRIPT_DIR}" "${1:-}"

: "${CAPABILITY:=code}"
: "${MODEL_ALIAS:=code}"
: "${RUN_DATE:=$(date +%F)}"
: "${LIMIT_MODE:=prod-limits}"
: "${ENDPOINT_TYPE:=chat}"
: "${TOKENIZER:=Qwen/Qwen3-Coder-30B-A3B-Instruct-FP8}"
: "${ISL:=1000}"
: "${OSL:=300}"
: "${SCENARIO:=isl${ISL}-osl${OSL}}"
: "${CONCURRENCY_LEVELS:=80 90 100}"
: "${REQUEST_MULTIPLIER:=10}"

RESULTS_DIR="${RESULTS_DIR:-${SCRIPT_DIR}/../artifacts/${LIMIT_MODE}/${RUN_DATE}/${MODEL_ALIAS}/${ENDPOINT_TYPE}/${SCENARIO}}"
mkdir -p "${RESULTS_DIR}"

echo URL: ${TUDELFT_TULIP_BASE_URL}

for conc in ${CONCURRENCY_LEVELS}; do
  echo "Running for concurrency ${conc}..."
  pixi run aiperf profile \
    --model-names ${MODEL_ALIAS} \
    --tokenizer "${TOKENIZER}" \
    --url ${TUDELFT_TULIP_BASE_URL}/${CAPABILITY} \
    --api-key ${TUDELFT_TULIP_API_KEY} \
    --streaming \
    --endpoint-type ${ENDPOINT_TYPE} \
    --concurrency "${conc}" \
    --request-count "$((conc * REQUEST_MULTIPLIER))" \
    --isl "${ISL}" \
    --osl "${OSL}" \
    --output-artifact-dir "${RESULTS_DIR}/concurrency-${conc}"
done

echo "All profiling runs completed, now generating plots..."
pixi run aiperf plot \
  --paths "${RESULTS_DIR}" \
  --output "${RESULTS_DIR}/plots"

bash "${SCRIPT_DIR}/extract-errors-from-scenario.sh" "${1:-}"
bash "${SCRIPT_DIR}/extract-metrics-from-scenario.sh" "${1:-}"
