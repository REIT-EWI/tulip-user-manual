#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/benchmark-config.sh"
load_benchmark_config "${SCRIPT_DIR}" "${1:-}"

: "${MODEL_ALIAS:=embed}"
: "${RUN_DATE:=$(date +%F)}"
: "${LIMIT_MODE:=prod-limits}"
: "${ISL:=100}"
: "${SCENARIO:=isl${ISL}${OSL:+-osl${OSL}}}"
: "${ENDPOINT_TYPE:=embeddings}"

SCENARIO_DIR="${SCENARIO_DIR:-${SCRIPT_DIR}/../artifacts/${LIMIT_MODE}/${RUN_DATE}/${MODEL_ALIAS}/${ENDPOINT_TYPE}/${SCENARIO}}"

OUT="${SCENARIO_DIR}/error-summary.tsv"

echo -e "concurrency\tcode\ttype\tcount" > "$OUT"

for f in "${SCENARIO_DIR}"/concurrency-*/profile_export_aiperf.json; do
  conc=$(basename "$(dirname "$f")" | sed 's/concurrency-//')

  jq -r --arg conc "$conc" '
    if (.error_summary // []) == [] then
      [$conc, "none", "none", 0] | @tsv
    else
      .error_summary[] |
      [$conc, .error_details.code, .error_details.type, .count] | @tsv
    end
  ' "$f" >> "$OUT"
done

sort -n -k1,1 "$OUT" -o "$OUT"

echo "Extracted error summary to ${OUT}"