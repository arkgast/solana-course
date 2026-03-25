SHELL := /bin/bash

# Fail fast inside recipes
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

# ---- configurable bits ----
CLUSTER_URL  ?= http://127.0.0.1:8899
TEST_TIMEOUT ?= 1000000
TS_MOCHA     ?= ./node_modules/.bin/ts-mocha
TS_CONFIG    ?= ./tsconfig.json
WALLET       ?= $(HOME)/.config/solana/id.json
DAY          ?= day_1
PROGRAM      := $(DAY)

# Verbosity:
#   make test DAY=day_6 V=1
ifeq ($(V),1)
Q :=
else
Q := @
endif

.PHONY: help status check-validator check-test-file \
        deploy mocha test test-% deploy-% mocha-% \
        print-test-cmd print-deploy-cmd

help:
	$(Q)echo "Targets:"
	$(Q)echo "  make test DAY=day_1        # deploy selected program and run tests/day_1.ts"
	$(Q)echo "  make test-day_1            # shortcut for day_1"
	$(Q)echo "  make deploy-day_1          # build + deploy only that program"
	$(Q)echo "  make mocha-day_1           # run only that test file (assumes deployed)"
	$(Q)echo "  make status                # show validator status"
	$(Q)echo "  make print-test-cmd DAY=day_1"
	$(Q)echo ""
	$(Q)echo "Options:"
	$(Q)echo "  V=1                        # show commands as they execute"

status:
	$(Q)solana cluster-version --url "$(CLUSTER_URL)"

check-validator:
	$(Q)solana cluster-version --url "$(CLUSTER_URL)" >/dev/null

check-test-file:
	$(Q)test -f "tests/$(PROGRAM).ts" || { \
		echo "missing test file: tests/$(PROGRAM).ts"; \
		exit 1; \
	}

# ---- build & deploy selected program ----
deploy-%: check-validator
	$(Q)echo "building program: $*"
	$(Q)anchor build -p "$*"
	$(Q)echo "deploying program: $*"
	$(Q)anchor deploy -p "$*"

# ---- run mocha for selected day ----
mocha-%: check-validator
	$(Q)test -f "tests/$*.ts" || { \
		echo "missing test file: tests/$*.ts"; \
		exit 1; \
	}
	$(Q)ANCHOR_PROVIDER_URL="$(CLUSTER_URL)" \
	    ANCHOR_WALLET="$(WALLET)" \
	    "$(TS_MOCHA)" -p "$(TS_CONFIG)" -t "$(TEST_TIMEOUT)" "tests/$*.ts"

# ---- convenience targets ----
test: deploy-$(PROGRAM) mocha-$(PROGRAM)

test-%: deploy-% mocha-%

print-deploy-cmd:
	@echo anchor build -p "$(PROGRAM)"
	@echo anchor deploy -p "$(PROGRAM)"

print-test-cmd: check-test-file
	@echo ANCHOR_PROVIDER_URL="$(CLUSTER_URL)" \
	     ANCHOR_WALLET="$(WALLET)" \
	     "$(TS_MOCHA)" -p "$(TS_CONFIG)" -t "$(TEST_TIMEOUT)" "tests/$(PROGRAM).ts"
