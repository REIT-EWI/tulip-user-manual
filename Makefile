# Makefile for reference-tests
#
# Note:
# This repository now lives independently.
# The `sync` target was used to import `apps/quick-tests` from the main TULIP
# repository during the initial extraction/migration and is not needed for
# normal day-to-day development anymore.
#
# Keep `sync` only if occasional re-imports from `../tulip` are still desired.
# Otherwise, regular work should happen directly in this repository.

MAIN            ?= ../tulip
PREFIX          ?= apps/quick-tests
BRANCH          ?= quick-tests-split

sync: 
	@echo ">> Splitting subtree from $(MAIN):$(PREFIX) → branch $(BRANCH)"
	@git -C "$(MAIN)" subtree split --prefix="$(PREFIX)" -b "$(BRANCH)"
	@echo ">> Pulling split branch into this repo"
	@git pull "$(MAIN)" "$(BRANCH)"
	@echo ">> Pushing to origin"
	@git push origin HEAD:main
	@echo ">> Cleaning up temp branch in MAIN"
	-@git -C "$(MAIN)" branch -D "$(BRANCH)" >/dev/null 2>&1 || true
	@echo "✅ Sync complete."


check:
	@echo ">> Running smoke test"
	pixi run chat

smoke:
	@echo ">> Running smoke gate"
	pixi run smoke

smoke-full:
	@echo ">> Running full smoke gate"
	pixi run smoke-full

push:
	@echo ">> Pushing to origin"
	@git push origin HEAD:main	

serve:
	@echo ">> Serving docs"
	cd docs && uv run zensical serve