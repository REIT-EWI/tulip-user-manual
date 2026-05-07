#!/bin/bash

load_benchmark_config() {
  local script_dir="$1"
  local config_path="${2:-${BENCHMARK_CONFIG:-${script_dir}/scenario.conf}}"

  if [ -f "${script_dir}/../../.env" ]; then
    # shellcheck source=/dev/null
    source "${script_dir}/../../.env"
  fi

  if [ ! -f "${config_path}" ]; then
    if [ -n "${2:-}" ] || [ -n "${BENCHMARK_CONFIG:-}" ]; then
      echo "Benchmark config not found: ${config_path}" >&2
      return 1
    fi

    return 0
  fi

  # shellcheck source=/dev/null
  source "${config_path}"
}