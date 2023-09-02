#!/bin/bash

# Script for generating a README.md basic template file for the new project.
# Takes in the name of the project ($1), the license ($2), the creation date
# ($3), and the project short description ($4) as arguments.
#
# Outputs a README.md file in the project directory.


#!/bin/bash

# Function to format license name
format_license_name() {
  case "$1" in
    MIT)
      echo "MIT License"
      ;;
    Unlicense)
      echo "Unlicense"
      ;;
    *)
      echo "$1 License"
      ;;
  esac
}

# Input validation
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
  echo "Usage: $0 <PROJECT> <LICENSE> <CREATION_DATE> <DESCRIPTION>"
  exit 1
fi

# Read in args
PROJECT=$1
LICENSE=$(format_license_name "$2")
CREATION_DATE=$3
DESCRIPTION=$4

# Parse the description brackets out
PARSED_DESCRIPTION="${DESCRIPTION:1:${#DESCRIPTION}-2}"

# Create README.md
# Create README.md
echo "
# ${PROJECT}

> Initially created on ${CREATION_DATE}.

${PARSED_DESCRIPTION}

## Table of Contents

- [Background](#background)
- [Data](#data)
- [Setup](#setup)
- [Usage](#usage)
- [Results](#results)
- [License](#license)
- [Contact](#contact)

## Background

Describe the problem you're solving, the objectives of the project, and any relevant theories or frameworks.
> **DOI/arXiv**: [Insert DOI or arXiv reference here]

## Data

Where does the data come from? How can it be accessed? Include any data cleaning or transformation steps.

## Setup

- Software requirements
- How to install dependencies, if any

## Usage

How to run the code, including examples of inputs and expected outputs.

Use codeblocks with syntax highlighting for documenting usage:

\`\`\`python
import numpy as np

def function():
  return None
\`\`\`

## Results

Summary of the results, possibly including figures, tables, or links to more detailed documents.

## License

The project is licensed under the ${LICENSE}.

## Contact

Your Name – Your Email – Your GitHub Profile
" > "./${PROJECT}/README.md"
