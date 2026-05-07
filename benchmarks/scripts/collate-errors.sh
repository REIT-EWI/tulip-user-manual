#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}/.."
source "${SCRIPT_DIR}/benchmark-config.sh"
load_benchmark_config "${SCRIPT_DIR}" "${1:-}"

: "${LIMIT_MODE:=prod-limits}"
: "${RUN_DATE:=$(date +%F)}"

OUT="${OUT:-${REPO_ROOT}/artifacts/${LIMIT_MODE}/${RUN_DATE}/summary/error-summary-all.tsv}"
mkdir -p "$(dirname "${OUT}")"

echo -e "model\tendpoint\tscenario\tconcurrency\tcode\tcount" > "${OUT}"

RUN_ROOT="${RUN_ROOT:-${REPO_ROOT}/artifacts/${LIMIT_MODE}/${RUN_DATE}}"

while IFS= read -r -d '' f; do
    echo "Processing $f..."

    # Assuming the path structure is: artifacts/limit_mode/date/model/endpoint/scenario/error-summary.tsv
    clean_path="${f#${RUN_ROOT}/}"
    echo "Clean path: $clean_path"

    model=$(echo "$clean_path" | cut -d/ -f1)
    endpoint=$(echo "$clean_path" | cut -d/ -f2)
    scenario=$(echo "$clean_path" | cut -d/ -f3)

    tail -n +2 "$f" | while IFS=$'\t' read -r conc code type count; do
    echo -e "${model}\t${endpoint}\t${scenario}\t${conc}\t${code}\t${count}" >> "$OUT"
    done
done
< <(find "${RUN_ROOT}" -type f -name "error-summary.tsv" -print0)

#sort -k1,1 -k2,2 -k3,3 -k4,4n "$OUT" -o "$OUT"

echo "Collated error summary written to ${OUT}"