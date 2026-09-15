# Benchmarks

This folder contains the Tulip benchmarking workspace. It is used for heavier performance checks against deployed endpoints, separate from the quick examples and smoke tests in the rest of the repo.

## Layout

- `pixi.toml`: local benchmark environment and tasks
- `scripts/`: baseline benchmark runners
- `scripts/scenario.conf`: shared experiment parameters used by the scripts
- `artifacts/`: raw results, plots, and dashboard data

## Setup

Benchmark scripts source `../../.env` when present. At minimum, set:

- `TUDELFT_TULIP_BASE_URL`
- `TUDELFT_TULIP_API_KEY`: your SRAM application token, used as the TULIP API key

From this directory, update `scripts/scenario.conf` for the scenario you want to run, then run the benchmark scripts directly:

```shell
bash scripts/run-chat-completions-baseline.sh
bash scripts/run-code-code-baseline.sh
bash scripts/run-embed-embeddings-baseline.sh
```

`scripts/scenario.conf` is a shell-style config file, so comments are allowed. The file includes commented parameter blocks for the chat, code, embeddings, and responses scenarios; uncomment one block or mix the values you need for the current run.

These scripts are still fixed baselines, not a general CLI. If the benchmark matrix changes in a way that the current variables cannot express, update the script rather than this README.

## Workflow

The usual benchmark workflow is:

1. Customize `scripts/scenario.conf` for the scenario you want to test, then run one of the baseline scripts, for example:

	```shell
	bash scripts/run-code-code-baseline.sh
	```

	The run script generates the raw artifacts, plots that scenario directory, and then calls `scripts/extract-errors-from-scenario.sh` and `scripts/extract-metrics-from-scenario.sh` automatically for that same scenario.

2. If you want to rerun extraction by itself for the same scenario, reuse the same `scripts/scenario.conf` values, then run:

	```shell
	bash scripts/extract-errors-from-scenario.sh
	bash scripts/extract-metrics-from-scenario.sh
	```

	This writes an `error-summary.tsv` into that scenario directory.
	The extractor scans every `concurrency-*` subdirectory currently present there, so it summarizes the full scenario directory contents, not only the most recent benchmark invocation.
	The metrics extractor writes `metrics-summary.tsv` with p95 TTFT, p95 end-to-end latency, aggregate output tokens/sec, error rate, error count, and request count per concurrency.

3. If you ran multiple scenarios that should be summarized together, keep `LIMIT_MODE` and `RUN_DATE` in `scripts/scenario.conf` aligned to that run set, then run:

	```shell
	bash scripts/collate-errors.sh
	```

	This writes a combined summary under `artifacts/<limit-mode>/<run-date>/summary/`.

4. Open the dashboard from the same run directory so the plots and the collated summary describe the same scenario set:

	```shell
	AIPERF_DIR="artifacts/<limit-mode>/<run-date>" pixi run plot-dashboard
	```

If step 3 collates results for `artifacts/<limit-mode>/<run-date>/`, step 4 should point to that same directory. You can set `AIPERF_DIR` in `scripts/scenario.conf` or inline on the command. Avoid running the dashboard on the top-level `artifacts/` directory when you only want a single run window.

## Results

Runs write output under `artifacts/`, typically grouped by limit mode, date, model alias, endpoint type, and scenario.

To explore collected results as a dashboard, point `AIPERF_DIR` at the directory you want to summarize. It defaults to `artifacts`.

```shell
pixi run plot-dashboard
```
