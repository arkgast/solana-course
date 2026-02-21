SHELL := /bin/bash

# ---- configurable bits ----
CLUSTER_URL ?= http://127.0.0.1:8899
WS_URL ?= ws://127.0.0.1:8900
TEST_TIMEOUT ?= 1000000
TS_MOCHA := ./node_modules/.bin/ts-mocha
TS_CONFIG := ./tsconfig.json

# Pick the day like: make test DAY=day_2
DAY ?= day_2

# Anchor program-name flag expects the program name as in Anchor.toml / workspace
PROGRAM := $(DAY)

# Test file naming convention (RareSkills style)
TEST_FILE := tests/$(DAY).ts

# Logs / pid tracking
PID_DIR := .localnet
VALIDATOR_PID := $(PID_DIR)/validator.pid
VALIDATOR_LOG := $(PID_DIR)/validator.log

.PHONY: help test test-% localnet-up localnet-down deploy-% mocha-% status

help:
	@echo "Targets:"
	@echo "  make test DAY=day_2        # start/reuse localnet, deploy program, run tests/day_2.ts"
	@echo "  make test-day_2            # shortcut for day_2"
	@echo "  make localnet-up           # start local validator (reused if already running)"
	@echo "  make localnet-down         # stop local validator"
	@echo "  make deploy-day_2          # build+deploy only that program"
	@echo "  make mocha-day_2           # run only that test file (assumes deployed)"
	@echo "  make status                # show validator status"

status:
	@mkdir -p $(PID_DIR)
	@if [ -f "$(VALIDATOR_PID)" ] && kill -0 $$(cat "$(VALIDATOR_PID)") 2>/dev/null; then \
		echo "local validator: RUNNING (pid $$(cat $(VALIDATOR_PID)))"; \
	else \
		echo "local validator: NOT running"; \
	fi
	@echo "cluster url: $(CLUSTER_URL)"

# ---- local validator management ----
localnet-up:
	@mkdir -p $(PID_DIR)
	@# If already running, reuse it
	@if [ -f "$(VALIDATOR_PID)" ] && kill -0 $$(cat "$(VALIDATOR_PID)") 2>/dev/null; then \
		echo "local validator already running (pid $$(cat $(VALIDATOR_PID)))"; \
	else \
		echo "starting local validator..."; \
		( solana-test-validator --reset --quiet --rpc-port 8899 --ws-port 8900 >"$(VALIDATOR_LOG)" 2>&1 & echo $$! >"$(VALIDATOR_PID)" ); \
		echo "pid=$$(cat $(VALIDATOR_PID)) log=$(VALIDATOR_LOG)"; \
		echo "waiting for RPC..."; \
		for i in $$(seq 1 60); do \
			if solana cluster-version -u "$(CLUSTER_URL)" >/dev/null 2>&1; then \
				echo "validator ready"; \
				break; \
			fi; \
			sleep 0.25; \
		done; \
	fi
	@# ensure CLI points to localnet
	@solana config set -u "$(CLUSTER_URL)" >/dev/null

localnet-down:
	@if [ -f "$(VALIDATOR_PID)" ]; then \
		PID=$$(cat "$(VALIDATOR_PID)"); \
		if kill -0 $$PID 2>/dev/null; then \
			echo "stopping validator pid $$PID"; \
			kill $$PID; \
		fi; \
		rm -f "$(VALIDATOR_PID)"; \
	else \
		echo "no pid file found"; \
	fi

# ---- build & deploy selected program ----
deploy-%: localnet-up
	@echo "building program: $*"
	@anchor build -p $*
	@echo "deploying program: $*"
	@anchor deploy -p $*

# ---- run mocha for selected day ----
mocha-%:
	@if [ ! -f "tests/$*.ts" ]; then \
		echo "missing test file: tests/$*.ts"; \
		exit 1; \
	fi
	@ANCHOR_PROVIDER_URL=$(CLUSTER_URL) \
		ANCHOR_WALLET=$$HOME/.config/solana/id.json \
		$(TS_MOCHA) -p $(TS_CONFIG) -t $(TEST_TIMEOUT) tests/$*.ts

# ---- convenience targets ----
test: deploy-$(PROGRAM) mocha-$(PROGRAM)

test-%: deploy-% mocha-%
