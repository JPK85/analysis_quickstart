#!/bin/bash

# Script for creating a .gitignore for a templated project
# Takes in a project name as an argument

PROJECT=$1

echo "# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]

# C extensions
*.so

# Distribution / packaging
.Python
env/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
*.egg-info/
.installed.cfg
*.egg

# PyInstaller
#  Usually these files are written by a python script from a template
#  before PyInstaller builds the exe, so as to inject date/other infos into it.
*.manifest
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

# Unit test / coverage reports
htmlcov/
.tox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover

# Translations
*.mo
*.pot

# Django stuff:
*.log

# Sphinx documentation
docs/_build/

# PyBuilder
target/

# DotEnv configuration
.env

# Database
*.db
*.rdb

# Pycharm
.idea

# VS Code
.vscode/

# Spyder
.spyproject/

# Jupyter NB Checkpoints
.ipynb_checkpoints/

# exclude data
/data/

# exclude references
references/

# exclude local config files
/configs/

# exclude temporary builds
/build/tmp/

# Mac OS-specific storage files
.DS_Store

# vim
*.swp
*.swo

# quarto support and build file dirs
/.quarto/
reports/.quarto/

# Mypy cache
.mypy_cache/" > ./$PROJECT/.gitignore
