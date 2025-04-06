#!/usr/bin/env bash
set -euo pipefail

# Script to generate a makefile for the project

# Takes in args:
# $1 = name of the project
# $2 = python version

# Set variables
PROJECT_NAME=$1
PYTHON_VERSION=$2
PROJECT_DESCRIPTION=$3
AUTHORS=$4

########################
#### BUILD MAKEFILE ####
########################

echo '
#### Before doing anything else: if on Windows set SHELL ####
# Use Git "bash" instead of Git "sh" like so:' > ./"$PROJECT_NAME"/Makefile

echo '
ifeq ($(OS),Windows_NT)
SHELL = $(shell which bash)
@echo "Using shell: $(info $(SHELL))"
PYTHON_INTERPRETER = python
else # if on Linux/OSX try bash
SHELL = /bin/bash
@echo "Using shell: $(info $(SHELL))"
PYTHON_INTERPRETER = python
endif
' >> ./"$PROJECT_NAME"/Makefile

echo "
.PHONY: clean data lint requirements setup update export help


######################
#### List globals ####
######################

PROJECT_NAME = $PROJECT_NAME
PYTHON_VERSION = $PYTHON_VERSION" >> ./"$PROJECT_NAME"/Makefile

echo '
# Check if conda exists
ifeq (,$(shell ! command -v conda &> /dev/null))
HAS_CONDA=True
else
HAS_CONDA=False
endif

# Check if poetry exists
ifeq (,$(shell ! command -v poetry &> /dev/null))
HAS_POETRY=True
else
HAS_POETRY=False
endif' >> ./"$PROJECT_NAME"/Makefile

printf '

##############################
#### Setup / Dependencies ####
##############################

#### List dependencies and packages ####

# Development dependencies
DEVPCKGS := coverage pynvim pytest pytest-cov python-dotenv black isort flake8
# Standard dependencies
PCKGS := packaging toml

# Optional packages
EXTRAS :=

#### Setup recipes ####

## Bump project semantinc version with poetry
bump-version:
	@if [ -z "$(type)" ]; then \
		echo "Error: type argument is required"; \
		exit 1; \
	fi
	@poetry version $(type)
	@python scripts/update_version.py
	@echo "Version bumped ($(type)) and synced."

## Sync package semantic version manually
sync-version:
	@python scripts/update_version.py
	@echo "Version synced to __init__.py"

## Lock current dependencies
lock: pyproject.toml
		@echo "Locking dependencies without updating..."
		poetry lock --no-update

lock-update: poetry.lock
		@echo "Locking dependencies and updating..."
		poetry lock

## Install all dependencies and packages
setup-all: setup setup-dev setup-extras

## Install standard dependencies only
setup:
ifeq (True,$(HAS_POETRY))
		@echo "Poetry found, using Poetry to install standard dependencies"
		poetry install
		@echo "Installing standard dependencies..."
		$(foreach var,$(PCKGS),poetry add $(var);)
else
		@echo "Poetry not found, installing dependencies with pip"
		pip install -e
		$(foreach var,$(PCKGS),pip install $(var);)
		pip freeze > ./requirements.in
endif

## Install standard and development dependencies
setup-dev:
ifeq (True,$(HAS_POETRY))
		@echo "Poetry found, using Poetry to install development dependencies"
		@echo "Installing development dependencies..."
		poetry install
		$(foreach var,$(DEVPCKGS),poetry add -G dev $(var);)
else
		@echo "Poetry not found, installing development dependencies with pip"
		$(foreach var,$(DEVPCKGS),pip install $(var);)
		pip freeze > ./requirements-dev.in
endif

## Install non-dependencies
setup-extras:
ifeq (True,$(HAS_POETRY))
		@echo "Poetry found, using Poetry to install extras"
		@echo "Installing optional packages..."
		$(foreach var,$(EXTRAS),poetry add --optional $(var);)
else
		@echo "Poetry not found, installing extras with pip"
		$(foreach var,$(EXTRAS),pip install $(var);)
		pip freeze > ./requirements-extras.in
endif

## Install from an existing requirements.txt file
setup-reqs:
		poetry add `cat ./requirements.txt`

## Update all packages
update-all: update-dev update-extras

## Update standard dependencies (no dev or extras)
update:
ifeq (True,$(HAS_POETRY))
		@echo "Poetry found, using Poetry to update..."
		@echo "Updating standard dependencies..."
		poetry update --only main
else
		@echo "Poetry not found, updating packages with pip"
		touch ./requirements.in
		$(foreach var,$(PCKGS),pip install --upgrade $(var);)
		$(foreach var,$(PCKGS),$(var); >> ./requirements.in)
endif

## Update development dependencies
update-dev:
ifeq (True,$(HAS_POETRY))
		@echo "Poetry found, using Poetry to update..."
		@echo "Updating development dependencies..."
		poetry update
else
		@echo "Poetry not found, updating development dependencies with pip"
		touch ./requirements-dev.in
		$(foreach var,$(DEVPCKGS),pip install --upgrade $(var);)
		$(foreach var,$(DEVPCKGS),$(var); >> ./requirements-dev.in)
endif

## Update non-dependencies
update-extras:
ifeq (True,$(HAS_POETRY))
		@echo "Poetry found, using Poetry to update..."
		@echo "Updating optional packages..."
		$(foreach var,$(EXTRAS),poetry update $(var);)
else
		@echo "Poetry not found, updating extras with pip"
		touch ./requirements-extras.in
		$(foreach var,$(EXTRAS),pip install --upgrade $(var);)
		$(foreach var,$(EXTRAS),$(var); >> ./requirements-extras.in)
endif

## Make dependency tree
dep-tree:
ifeq (True,$(HAS_POETRY))
		@echo "Poetry found, using Poetry to make dependency tree"
		poetry show --tree > ./dep-tree.txt
else
		@echo "Poetry not found, making dependency tree with pip"
		pip freeze | sort > ./dep-tree.txt
endif

## Make project dirtree
tree:
		tree > ./dirtree.txt
' >> ./"$PROJECT_NAME"/Makefile

echo '
######################
#### HOUSEKEEPING ####
######################

## Lint files in ./src using flake8
lint:
		flake8 src

## Format files and sort imports in ./src using black/isort
format-src:
		isort --profile black src
		black --line-length 79 src

## Format all files and sort imports
format:
		isort --profile black src
		isort --profile black .
		black --line-length 79 src
		black --line-length 79 .

## Delete all compiled Python files
clean:
		find . -type f -name "*.py[co]" -delete
		find . -type d -name "__pycache__" -delete


######################
#### Environments ####
######################

## Create fresh project environment
create-env:
ifeq (True,$(HAS_CONDA))
		@echo "Detected conda, creating conda environment."
		conda create --name $(PROJECT_NAME) python=$(PYTHON_VERSION)
else
		@echo "No conda detected, skipping conda environment creation."
		@echo "Check poetry env info for environment details."
endif

## Test if environment is setup correctly
test-env:
		$(PYTHON_INTERPRETER) ./scripts/check_environment.py

## Write QUARTO environment variables to .env
quarto:
		@echo "Exporting QUARTO environment variable to ./.env..."
		echo "QUARTO_PYTHON=$(shell poetry env info --path)" >> ./.env
		echo "QUARTO_PROJECT_DIR=./reports" >> ./.env
		@echo "Creating quarto project to the ./notebooks directory..."
		quarto create-project ./notebooks
		@echo "Setting output dir to ../reports/ ..."
		echo "  output-dir: ../reports" >> ./notebooks/_quarto.yml


###############
### Exports ###
###############

## Export dependencies in all formats
export: export-poet export-conda export-pip-tools

## Export poetry dependencies to a pip requirements.txt file
export-poet:
		@echo "Exporting poetry env to requirements.txt..."
		poetry export --dev -f requirements.txt --output ./requirements.txt

## Export conda env dependencies to an environment.yml file
export-conda:
		@echo "Exporting conda env to environment.yml..."
		conda env export --no-builds | grep -v "prefix" > ./environment.yml

## Export pip requirements directly to requirements.txt
export-pip:
		@echo "Exporting pip requirements to requirements.txt..."
		pip list --format=freeze > ./requirements.txt

## Export pip requirements with pip-tools (requires "requirements.in" file)
export-pip-tools:
		@echo "Exporting pip requirements.in to requirements.txt"
		pip-compile requirements.in

' >> ./"$PROJECT_NAME"/Makefile

## Write in automated help function
cat ./helper.txt >> ./"$PROJECT_NAME"/Makefile
