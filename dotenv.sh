#!/usr/bin/env bash
set -euo pipefail
# shellcheck disable=2140

# Script for writing an .env file readable by python-dotenv to the project directory
# Takes in the PROJECT_NAME as an argument

PROJECT_NAME=$1
SCRIPTPATH=$2

echo "
#### The contents of this file were shamelessly copied from the cookiecutter template .env file ####
## See: https://drivendata.github.io/cookiecutter-data-science/

# Environment variables go here, can be read by \`python-dotenv\` package:
#
#   \`src/$PROJECT_NAME/script.py\`
#   ----------------------------------------------------------------
#    import dotenv
#
#    project_dir = os.path.join(os.path.dirname(__file__), os.pardir)
#    dotenv_path = os.path.join(project_dir, ".env")
#    dotenv.load_dotenv(dotenv_path)
#   ----------------------------------------------------------------
#
# DO NOT ADD THIS FILE TO VERSION CONTROL!" > "$SCRIPTPATH"/"$PROJECT_NAME"/.env
