# -------------------------------------------------------------------------------------------------
# This makefile sets the most common targets found in a typical Makefile.
#
# This file has been initially created for https://github.com/politician/template-repo
#
# Copyright 2022 Romain Barissat. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# -------------------------------------------------------------------------------------------------
.DEFAULT_GOAL:=build

#--------------------------------------------------------------------------------------------------
# Configuration
#--------------------------------------------------------------------------------------------------
JS_INSTALLER:=yarn# Could be "npm"
THIS_FILE:=$(lastword $(MAKEFILE_LIST))
SKIP_CHECKOV:=true# Checkov is slow, so skip it by default
DIR:=.

#--------------------------------------------------------------------------------------------------
# Setup dev tools and pre-commit hooks
#--------------------------------------------------------------------------------------------------
HOMEBREW_INSTALLED:=$(shell command -v brew 2> /dev/null)
JS_INSTALLER_INSTALLED:=$(shell command -v $(JS_INSTALLER) 2> /dev/null)
.PHONY: setup
setup:
	@echo -- Installing dev dependencies

ifdef HOMEBREW_INSTALLED
ifeq ($(CI),true)
	brew bundle
else
	@echo "Do you want to install dependencies with Homebrew? [Y/n] "; read ANSWER; \
	if [[ $${ANSWER:-Y} == Y ]]; then brew bundle; fi;
endif
else
	@echo "Homebrew is not installed. Skipping automated dependencies installation."
endif

ifdef JS_INSTALLER_INSTALLED
	$(JS_INSTALLER) install
else
	@echo "$(JS_INSTALLER) is not installed. Skipping JS dependencies installation."
endif

	pre-commit install --install-hooks -t pre-commit -t commit-msg

	terraform init $${TERRAFORM_ARGS}

	@echo
	
#--------------------------------------------------------------------------------------------------
# Build {{project_name}}
#--------------------------------------------------------------------------------------------------
.PHONY: build
build:
	@echo --------------------------------------------------------------------------------
	@echo -- Building project
	@echo --------------------------------------------------------------------------------
	terraform init $${TERRAFORM_ARGS}
	@echo

#--------------------------------------------------------------------------------------------------
# Remove all build files
#--------------------------------------------------------------------------------------------------
.PHONY: clean
clean: docs-clean
	@echo --------------------------------------------------------------------------------
	@echo -- Cleaning up build/test files
	@echo --------------------------------------------------------------------------------
	@rm -rf $(wildcard .terraform ./*/*/.terraform)
	@rm -f $(wildcard plan.out ./*/*/plan.out)
	@rm -f $(wildcard plan.out.json ./*/*/plan.out.json)
	@rm -f $(wildcard plan.out.pretty.json ./*/*/plan.out.pretty.json)
	@rm -f $(wildcard ./tests/*/.terraform.lock.hcl)
	@echo Done.
	@echo

#--------------------------------------------------------------------------------------------------
# Remove all build + state files
#--------------------------------------------------------------------------------------------------
.PHONY: clean-state
clean-state: clean
	@echo --------------------------------------------------------------------------------
	@echo -- Cleaning up state files
	@echo --------------------------------------------------------------------------------
	@rm -f $(wildcard terraform.tfstate ./*/*/terraform.tfstate)
	@rm -f $(wildcard terraform.tfstate.backup ./*/*/terraform.tfstate.backup)
	@echo Done.
	@echo

#--------------------------------------------------------------------------------------------------
# Lint source code
#--------------------------------------------------------------------------------------------------
.PHONY: lint
lint:
	@echo --------------------------------------------------------------------------------
	@echo -- Linting project
	@echo --------------------------------------------------------------------------------
	terraform fmt -recursive $${TERRAFORM_ARGS} $${TERRAFORM_FMT_ARGS}
	tflint --init --config .config/tflint.hcl $${TFLINT_ARGS}
	tflint --format=compact --config .config/tflint.hcl $${TFLINT_ARGS}
	@echo

#--------------------------------------------------------------------------------------------------
# Run ALL test suites (unit tests fo main module and examples, integration tests)
#--------------------------------------------------------------------------------------------------
.PHONY: test
test: clean lint
	@$(MAKE) -f $(THIS_FILE) test-static DIR=. SKIP_CHECKOV=false
	@for example in ./examples/* ; do \
		$(MAKE) -f $(THIS_FILE) test-static DIR=$${example} SKIP_CHECKOV=false; \
	done

	@$(MAKE) -f $(THIS_FILE) test-runtime DIR=. SKIP_CHECKOV=false
	@for example in ./examples/* ; do \
		$(MAKE) -f $(THIS_FILE) test-runtime DIR=$${example} SKIP_CHECKOV=false; \
	done

	@$(MAKE) -f $(THIS_FILE) test-integration

#--------------------------------------------------------------------------------------------------
# Run unit tests for a given module. Use it like:
# make test-unit DIR=./examples/minimal
#--------------------------------------------------------------------------------------------------
.PHONY: test-unit
test-unit: test-static test-runtime

#--------------------------------------------------------------------------------------------------
# Static code analysis for a given directory
#--------------------------------------------------------------------------------------------------
.PHONY: test-static
test-static:
	@echo --------------------------------------------------------------------------------
	@echo -- Static testing $(DIR)
	@echo --------------------------------------------------------------------------------
	tfsec $(DIR) --concise-output $${TFSEC_ARGS}
	terraform -chdir="$(DIR)" init $${TERRAFORM_ARGS}
	terraform -chdir="$(DIR)" validate $${TERRAFORM_ARGS}
	
ifneq ($(SKIP_CHECKOV),true)
	checkov $${CHECKOV_ARGS} --quiet --framework terraform -d "$(DIR)"
endif

	@echo

#--------------------------------------------------------------------------------------------------
# Run tests for a given directory
#--------------------------------------------------------------------------------------------------
.PHONY: test-runtime
test-runtime:
	@echo --------------------------------------------------------------------------------
	@echo -- Runtime testing $(DIR)
	@echo --------------------------------------------------------------------------------
	terraform -chdir="$(DIR)" init $${TERRAFORM_ARGS}
	terraform -chdir="$(DIR)" plan $${TERRAFORM_ARGS} -input=false -out="plan.out"

ifneq ($(SKIP_CHECKOV),true)
	terraform -chdir="$(DIR)" show $${TERRAFORM_ARGS} -json "plan.out" > "$(DIR)/plan.out.json"
ifeq ($(GITHUB_ACTIONS),true)
# A weird GH actions bug injects actions metadata in the output so we filter only the lines containing JSON
	grep '^{"' "$(DIR)/plan.out.json" | jq . > "$(DIR)/plan.out.pretty.json"
else
	cat "$(DIR)/plan.out.json" | jq . > "$(DIR)/plan.out.pretty.json"
endif
	checkov $${CHECKOV_ARGS} --quiet --framework terraform_plan --repo-root-for-plan-enrichment . --file "$(DIR)/plan.out.pretty.json" --config-file .config/checkov.yml
endif
	
	@echo

#--------------------------------------------------------------------------------------------------
# Run integration tests
#--------------------------------------------------------------------------------------------------
GOTESTSUM_INSTALLED := $(shell command -v gotestsum 2> /dev/null)
GO_TESTS:=$(shell find ./tests -maxdepth 1 -name '*_test.go' -print -quit)
.PHONY: test-integration
test-integration:
	@echo --------------------------------------------------------------------------------
	@echo -- Integration testing
	@echo --------------------------------------------------------------------------------
	terraform test $${TERRAFORM_ARGS}

ifneq ($(strip $(GO_TESTS)),)
ifdef GOTESTSUM_INSTALLED
	cd ./tests \
	&& go mod tidy \
	&& gotestsum --format testname --max-fails 1
else
	cd ./tests \
	&& go mod tidy \
	&& go test -v -timeout 30m
endif
endif
	
	@echo

#--------------------------------------------------------------------------------------------------
# Run {{project_name}} in debug mode
#--------------------------------------------------------------------------------------------------
.PHONY: debug
debug:
	@echo --------------------------------------------------------------------------------
	@echo -- Running in debug mode
	@echo --------------------------------------------------------------------------------
	TF_LOG=DEBUG terraform plan
	@echo

#--------------------------------------------------------------------------------------------------
# Run {{project_name}}
#--------------------------------------------------------------------------------------------------
.PHONY: run
run:
	@echo --------------------------------------------------------------------------------
	@echo -- Running project
	@echo --------------------------------------------------------------------------------
	terraform plan
	@echo

#--------------------------------------------------------------------------------------------------
# Release new version of {{project_name}}
#--------------------------------------------------------------------------------------------------
.PHONY: release
release:
	@echo --------------------------------------------------------------------------------
	@echo -- Releasing new version
	@echo --------------------------------------------------------------------------------
	@echo "ℹ️  The release step has not been configured yet."
	@echo

#--------------------------------------------------------------------------------------------------
# Deploy latest version of {{project_name}}
#--------------------------------------------------------------------------------------------------
.PHONY: deploy
deploy:
	@echo --------------------------------------------------------------------------------
	@echo -- Deploying latest version
	@echo --------------------------------------------------------------------------------
	terraform apply
	@echo

#--------------------------------------------------------------------------------------------------
# Watch documentation site
#--------------------------------------------------------------------------------------------------
.PHONY: docs
docs: docs-clean docs-watch

#--------------------------------------------------------------------------------------------------
# Build documentation site
#--------------------------------------------------------------------------------------------------
.PHONY: docs-build
docs-build: docs-clean
	@echo --------------------------------------------------------------------------------
	@echo -- Building documentation site
	@echo --------------------------------------------------------------------------------
	terraform-docs .
	npx vitepress build
	@echo

#--------------------------------------------------------------------------------------------------
# Watch documentation site
#--------------------------------------------------------------------------------------------------
.PHONY: docs-watch
docs-watch:
	@echo --------------------------------------------------------------------------------
	@echo -- Watch documentation site
	@echo --------------------------------------------------------------------------------
	terraform-docs .
	npx vitepress dev
	@echo

#--------------------------------------------------------------------------------------------------
# Remove all build files
#--------------------------------------------------------------------------------------------------
.PHONY: docs-clean
docs-clean:
	@echo --------------------------------------------------------------------------------
	@echo -- Clean documentation site build
	@echo --------------------------------------------------------------------------------
	rm -rf .vitepress/dist
	@echo

#--------------------------------------------------------------------------------------------------
# Run documentation site
#--------------------------------------------------------------------------------------------------
.PHONY: docs-run
docs-run: docs-build
	@echo --------------------------------------------------------------------------------
	@echo -- Run documentation site
	@echo --------------------------------------------------------------------------------
# Using port 5001 because 5000 is already taken on MacOS Monterey.
	npx vitepress serve --port 5001
	@echo

#--------------------------------------------------------------------------------------------------
# Deploy documentation site
#--------------------------------------------------------------------------------------------------
GIT_URL:=$(shell git config --get remote.origin.url)
.PHONY: docs-deploy
docs-deploy: docs-build
	@echo --------------------------------------------------------------------------------
	@echo -- Deploying documentation site
	@echo --------------------------------------------------------------------------------
	@$(shell [[ -e "CNAME" ]] && cp "CNAME" ".vitepress/dist/CNAME")
	@$(shell [[ -e "docs/CNAME" ]] && cp "docs/CNAME" ".vitepress/dist/CNAME")
ifeq ($(GITHUB_ACTIONS),true)
	cd .vitepress/dist\
	&& git init --initial-branch gh-pages\
	&& git remote add origin https://x-access-token:$(GITHUB_TOKEN)@github.com/$(GITHUB_REPOSITORY)\
	&& git add --all\
	&& git commit --message 'chore: deploy documentation site'\
	&& git push --force origin gh-pages:gh-pages
else
	cd .vitepress/dist\
	&& git init --initial-branch gh-pages\
	&& git add --all\
	&& git commit --message 'chore: deploy documentation site'\
	&& git push --force $(GIT_URL) gh-pages:gh-pages
endif
	@echo

#--------------------------------------------------------------------------------------------------
# Test a typical developer workflow by running all non-destructive commands.
# These are commands that don't change a remote state (eg. deploy) nor hang the shell (eg. watch).
#--------------------------------------------------------------------------------------------------
.PHONY: test-dev-workflow
test-dev-workflow: setup lint build test-unit install uninstall docs-build docs-clean clean
	@echo --------------------------------------------------------------------------------
	@echo -- Testing dev workflow
	@echo --------------------------------------------------------------------------------
	@git stash || true

	temp_file=$$(mktemp ./XXXX) \
		&& echo "Test\n" > $$temp_file \
		&& git add $$temp_file \
		&& git commit -m"chore: test dev workflow" \
		&& git reset --soft HEAD^ \
		&& git restore --staged $$temp_file \
		&& rm -f $$temp_file

	@git stash apply --index || true
	@echo
