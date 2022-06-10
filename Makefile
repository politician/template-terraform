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

	@echo
	
#--------------------------------------------------------------------------------------------------
# Build {{project_name}}
#--------------------------------------------------------------------------------------------------
.PHONY: build
build:
	@echo --------------------------------------------------------------------------------
	@echo -- Building project
	@echo --------------------------------------------------------------------------------
	@echo "ℹ️  The build step has not been configured yet."
	@echo

#--------------------------------------------------------------------------------------------------
# Remove all build files
#--------------------------------------------------------------------------------------------------
.PHONY: clean
clean: docs-clean
	@echo --------------------------------------------------------------------------------
	@echo -- Cleaning up build files
	@echo --------------------------------------------------------------------------------
	@echo "ℹ️  The clean step has not been configured yet."
	@echo

#--------------------------------------------------------------------------------------------------
# Lint source code
#--------------------------------------------------------------------------------------------------
.PHONY: lint
lint:
	@echo --------------------------------------------------------------------------------
	@echo -- Linting project files
	@echo --------------------------------------------------------------------------------
	@echo "ℹ️  The lint step has not been configured yet."
	@echo

#--------------------------------------------------------------------------------------------------
# Run test suites
#--------------------------------------------------------------------------------------------------
.PHONY: test
test: test-unit test-integration

.PHONY: test-unit
test-unit:
	@echo --------------------------------------------------------------------------------
	@echo -- Unit testing
	@echo --------------------------------------------------------------------------------
	@echo "ℹ️  The test step has not been configured yet."
	@echo

.PHONY: test-integration
test-integration:
	@echo --------------------------------------------------------------------------------
	@echo -- Integration testing
	@echo --------------------------------------------------------------------------------
	@echo "ℹ️  The test step has not been configured yet."
	@echo

#--------------------------------------------------------------------------------------------------
# Run {{project_name}} in debug mode
#--------------------------------------------------------------------------------------------------
.PHONY: debug
debug:
	@echo --------------------------------------------------------------------------------
	@echo -- Running in debug mode
	@echo --------------------------------------------------------------------------------
	@echo "ℹ️  The debug step has not been configured yet."
	@echo

#--------------------------------------------------------------------------------------------------
# Run {{project_name}} and watch for changes
#--------------------------------------------------------------------------------------------------
.PHONY: watch
watch:
	@echo --------------------------------------------------------------------------------
	@echo -- Running project and watching for changes
	@echo --------------------------------------------------------------------------------
	@echo "ℹ️  The watch step has not been configured yet."
	@echo

#--------------------------------------------------------------------------------------------------
# Run {{project_name}}
#--------------------------------------------------------------------------------------------------
.PHONY: run
run:
	@echo --------------------------------------------------------------------------------
	@echo -- Running project
	@echo --------------------------------------------------------------------------------
	@echo "ℹ️  The run step has not been configured yet."
	@echo

#--------------------------------------------------------------------------------------------------
# Install {{project_name}} locally
#--------------------------------------------------------------------------------------------------
.PHONY: install
install:
	@echo --------------------------------------------------------------------------------
	@echo -- Installing project locally
	@echo --------------------------------------------------------------------------------
	@echo "ℹ️  The install step has not been configured yet."
	@echo It is used for projects that can be installed on a computer.
	@echo

#--------------------------------------------------------------------------------------------------
# Uninstall {{project_name}} locally
#--------------------------------------------------------------------------------------------------
.PHONY: uninstall
uninstall:
	@echo --------------------------------------------------------------------------------
	@echo -- Uninstalling project locally
	@echo --------------------------------------------------------------------------------
	@echo "ℹ️  The uninstall step has not been configured yet."
	@echo It is used for projects that can be installed on a computer.
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
	@echo "ℹ️  The deploy step has not been configured yet."
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
docs-run:
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
