#!/bin/bash

# Script for creating an index.rst file for a standard Sphinx project
# Takes in PROJECT_NAME and CREATED DATE as arguments.

PROJECT_NAME=$1
CREATED=$2


echo ".. $PROJECT_NAME documentation master file, created
   on $CREATED.
   You can adapt this file completely to your liking, but it should at least
   contain the root \`toctree\` directive.

   run the following command to build the documentation before running make
   html:
   sphinx-apidoc -f -o source/ ../src/$PROJECT_NAME/

Welcome to $PROJECT_NAME's documentation!
=========================================

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   module

Indices and tables
==================

* :ref:\`genindex\`
* :ref:\`modindex\`
* :ref:\`search\`" > ./$PROJECT_NAME/docs/source/index.rst
