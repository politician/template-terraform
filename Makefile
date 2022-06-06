#--------------------------------------------------------------------------------------------------
# Configuration
#--------------------------------------------------------------------------------------------------
JS_INSTALLER := "yarn" # Could be "npm"

#--------------------------------------------------------------------------------------------------
# Computed variables
#--------------------------------------------------------------------------------------------------
.DEFAULT_GOAL := setup
HOMEBREW_INSTALLED := $(shell command -v brew 2> /dev/null)
JS_INSTALLER_INSTALLED := $(shell command -v $(JS_INSTALLER) 2> /dev/null)
GIT_URL := $(shell git config --get remote.origin.url)

#--------------------------------------------------------------------------------------------------
# Setup dev tools and pre-commit hooks
#--------------------------------------------------------------------------------------------------
.PHONY: setup
setup:
	@echo -- Installing dev dependencies

ifdef HOMEBREW_INSTALLED
	brew bundle
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
test:
	@echo --------------------------------------------------------------------------------
	@echo -- Testing project
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
# Watch {{project_name}} for changes
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