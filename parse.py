#!/bin/env/python

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

# Import toml parser
try:
    import toml
except Exception:
    raise ModuleNotFoundError(
        "Using this template requires the 'toml' package."
    )

# Load config data from the path + pyproject.toml
vardict = toml.load(project_path + "/pyproject.toml")

# ===== FETCH FROM NEW PYPROJECT FORMAT =====
# Flatten AUTHORS to a single line
raw_authors = vardict["project"]["authors"]
if isinstance(raw_authors, list):
    safe_authors = []
    for a in raw_authors:
        if isinstance(a, dict):
            name = a.get("name", "").strip()
            email = a.get("email", "").strip()
            safe_authors.append(f"{name} <{email}>" if email else name)
        else:
            safe_authors.append(str(a).strip())
    AUTHORS = ", ".join(safe_authors)
else:
    AUTHORS = str(raw_authors)

# Strip newlines and whitespace
AUTHORS = AUTHORS.replace("\n", " ").replace("\r", "").strip()

print("authors:", AUTHORS)
PYTHON_VERSION = vardict["project"]["requires-python"]
print("python:", PYTHON_VERSION)
PROJECT_VERSION = vardict["project"]["version"]
print("version:", PROJECT_VERSION)
PROJECT = vardict["project"]["name"]
print("project name:", PROJECT)

# LICENSE handling
try:
    LICENSE = vardict["project"]["license"]
except KeyError:
    print("No license specified. Setting license to 'Unlicense'.")
    LICENSE = "Unlicense"

# DESCRIPTION handling
try:
    PROJECT_DESCRIPTION = (
        str(vardict["project"].get("description", ""))
        .replace("\n", " ")
        .strip()
    )
except KeyError:
    print("No description given, setting reminder.")
    PROJECT_DESCRIPTION = "Write your project description to pyproject.toml"

# ===== CLEANUP & SANITIZATION =====

# Flatten and sanitize AUTHORS
if isinstance(AUTHORS, list) and isinstance(AUTHORS[0], dict):
    AUTHORS = [f"{a.get('name', '')} <{a.get('email', '')}>" for a in AUTHORS]
    AUTHORS = ", ".join(AUTHORS)
else:
    AUTHORS = str(AUTHORS)
AUTHORS = AUTHORS.replace("\n", " ").strip()

# Strip all fields from newlines/spaces
PROJECT = str(PROJECT).replace("\n", " ").strip()
LICENSE = str(LICENSE).replace("\n", " ").strip()
PROJECT_VERSION = str(PROJECT_VERSION).replace("\n", " ").strip()
PYTHON_VERSION = str(PYTHON_VERSION).replace("\n", " ").strip()
if isinstance(PROJECT_DESCRIPTION, list):
    PROJECT_DESCRIPTION = " ".join(PROJECT_DESCRIPTION)
PROJECT_DESCRIPTION = PROJECT_DESCRIPTION.replace("\n", " ").strip()

# ===== EXPORT PREPARATION =====

conc = [
    PROJECT,
    LICENSE,
    AUTHORS,
    PROJECT_VERSION,
    PROJECT_DESCRIPTION,
    PYTHON_VERSION,
]

labs = [
    "PROJECT",
    "LICENSE",
    "AUTHORS",
    "PROJECT_VERSION",
    "PROJECT_DESCRIPTION",
    "PYTHON_VERSION",
]

print("\n🧪 Final values to be written:")
for k, v in zip(labs, conc):
    print(f"{k}: {repr(v)}")

# Write to tmp.txt
with open(os.path.join(project_path, "tmp.txt"), "w") as f:
    for index, line in enumerate(conc):
        # f.write(f"{labs[index]}={line}\n")
        f.write(f'{labs[index]}="{line}"\n')
