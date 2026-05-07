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

OUT="${SCENARIO_DIR}/metrics-summary.tsv"

echo -e "concurrency\tp95_ttft_ms\tp95_e2e_latency_ms\toutput_tokens_per_sec\terror_rate_pct\terror_count\trequest_count" > "$OUT"

for f in "${SCENARIO_DIR}"/concurrency-*/profile_export_aiperf.json; do
  conc=$(basename "$(dirname "$f")" | sed 's/concurrency-//')

  jq -r --arg conc "$conc" '
    def error_count: ((.error_summary // []) | map(.count // 0) | add // 0);
    def request_count: (.request_count.avg // 0);
    def error_rate_pct:
      if request_count == 0 then 0
      else ((error_count / request_count) * 100)
      end;

    [
      $conc,
      (.time_to_first_token.p95 // 0),
      (.request_latency.p95 // 0),
      (.output_token_throughput.avg // 0),
      error_rate_pct,
      error_count,
      request_count
    ] | @tsv
  ' "$f" >> "$OUT"
done

sort -n -k1,1 "$OUT" -o "$OUT"

echo "Extracted metrics summary to ${OUT}"