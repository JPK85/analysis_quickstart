import os
import sys
import platform
from pathlib import Path

# We need to parse command args for PROJECT_NAME, PYTHON_VERSION, and
# PROJECT_PATH
PROJECT_NAME = sys.argv[1]
PYTHON_VERSION = sys.argv[2]
PROJECT_PATH = Path(sys.argv[3]).resolve()

# Resolve OS
OS = platform.system()


def main():
    """
    This script is used to append the pyright configuration to pyproject.toml
    for use with the `aq-init` or `aq-minit` bash scripts.

    No need to call this standalone ever.

    Args:
        PROJECT_NAME (str): Name of the parsed from metadata
        PYTHON_VERSION (str): Python version parsed from metadata
        PROJECT_PATH (str): Path to the project root parsed from metadata

    Returns:
        None
    """
    # Determine conda base path
    conda_base = os.path.expanduser(os.environ.get("CONDA_PREFIX", ""))

    # Format path string based on OS
    if OS == "Windows":
        extra_path = f"{conda_base}\\envs\\{PROJECT_NAME}\\Lib\\site-packages"
    else:
        extra_path = f"{conda_base}/envs/{PROJECT_NAME}/lib/python{PYTHON_VERSION}/site-packages"

    # Get full path
    extra_path = Path(extra_path).resolve()

    # Construct TOML content
    content = f"""
[tool.pyright]
pythonVersion = "{PYTHON_VERSION}"
extraPaths = [
    "{extra_path}"
]
"""

    # Check if PROJECT_PATH is a PATH
    if PROJECT_PATH.is_dir():
        # Check if a pyproject.toml file exists
        toml_file_path = PROJECT_PATH / "pyproject.toml"
        if toml_file_path.exists():
            # If yes, append TOML content to file
            with open(toml_file_path, "a") as f:
                f.write(content)
        else:
            # If no pyproject.toml exists, print a warning
            print(f"pyproject.toml does not exist at {PROJECT_PATH}...")
            print("Skipping config appending step...")
    else:
        # If it's not a path, error out with a warning that the path is wrong
        print(f"PROJECT_PATH: {PROJECT_PATH} is not a valid path")
        sys.exit(1)


if __name__ == "__main__":
    main()

