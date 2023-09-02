#!/bin/env/python

# We need to adjust this to accept the project name as an argument
# and then use that to find the pyproject.toml file

# This is a temporary solution to parse the pyproject.toml file
# and export the data to the environment

# Let's set the argument to be the project name

import sys
import os

# Get current working directory
project_path = os.getcwd()
project_name = sys.argv[1]

# Check if the project exists
if not os.path.exists(project_path):
    raise FileNotFoundError("Project path not found.")

# Check if the pyproject.toml file exists
if not os.path.exists(project_path + "/pyproject.toml"):
    raise FileNotFoundError("pyproject.toml not found.")


# import toml parser
try:
    import toml
except Exception:
    raise ModuleNotFoundError(
        "Using this template requires the 'toml' package."
    )

# load config data from the path + pyproject.toml
vardict = toml.load(project_path + "/pyproject.toml")
# vardict = toml.load("./pyproject.toml")

# Fetch some globals to export to the environment
AUTHORS = vardict["tool"]["poetry"]["authors"]
PYTHON_VERSION = vardict["tool"]["poetry"]["dependencies"]["python"]

# clean the PYTHON_VERSION from extra characters
PYTHON_VERSION = "".join(char for char in PYTHON_VERSION if char not in "^=*:")

PROJECT_VERSION = vardict["tool"]["poetry"]["version"]
PROJECT = vardict["tool"]["poetry"]["name"]

# Check for LICENSE
try:
    LICENSE = vardict["tool"]["poetry"]["license"]
# If license is empty, set license to Unlicense
except KeyError:
    print("No license specified. Setting license to 'Unlicense'.")
    LICENSE = "Unlicense"

try:
    PROJECT_DESCRIPTION = [vardict["tool"]["poetry"]["description"]]
# if no description is provided, set description to a reminder instead
except KeyError:
    print("No description given, setting reminder.")
    PROJECT_DESCRIPTION = "Write your project description to pyproject.toml"

# Prepare for export
conc = [
    str(PROJECT),
    str(LICENSE),
    str(AUTHORS),
    str(PROJECT_VERSION),
    str(PROJECT_DESCRIPTION),
    str(PYTHON_VERSION),
]

labs = [
    "PROJECT",
    "LICENSE",
    "AUTHORS",
    "PROJECT_VERSION",
    "PROJECT_DESCRIPTION",
    "PYTHON_VERSION",
]

# For line in output, write to a temporary text file
with open(os.path.join(project_path, "tmp.txt"), "w") as f:
    for index, line in enumerate(conc):
        f.write("".join(f"{labs[index]}=" + line) + "\n")
