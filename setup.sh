#!/bin/bash

# Script for setting up setup.py in case Poetry does not exist for package handling
# Takes in args: name, project version, author(s), description, and license information

PROJECT_NAME=$1
PROJECT_VERSION=$2
AUTHORS=$3
PROJECT_DESCRIPTION=$4
LICENSE=$5

echo "from setuptools import find_packages, setup

setup(
	name='$PROJECT_NAME',
	version='$PROJECT_VERSION',
	author='$AUTHORS',
	description='$PROJECT_DESCRIPTION',
	license='$LICENSE',
	packages=find_packages(),
)
" > ./"$PROJECT_NAME"/setup.py
