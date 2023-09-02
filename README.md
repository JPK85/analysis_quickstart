# analysis_quickstart

## Summary

A template creator for Python-based analytics projects.

This is highly untested and will probably destroy everything inside your computer. While it hasn't broken my Debian or OSX yet, there are probably some edge cases that will break things. **Use at your own risk**.

The repo contains two primary scripts for creating project templates:

1. `project-init` -- creates a somewhat overkill project template with a bunch of submodules and a bunch of other stuff typical of model based analytics projects
2. `project-minit` -- creates a minimal project template with a single module and a few other things, good for iterating on small scripts and such

The ideal usage is to symlink the scripts to some `/bin/` so that you can call them from anywhere and create a new project wireframe at will, with some nice utilities and metadata based on some prompted details. This is heavily influenced by the [cookiecutter data science template](https://drivendata.github.io/cookiecutter-data-science/), with my attempt at this being more of a personalized version that better fits my own workflow and tooling.

## Features

Some core features included in both scripts are:

- [x] `poetry` project initialization (manual `setuptools` initialization if `poetry` is not available)
- [x] `pyproject.toml` file with project metadata
- [x] `README.md` with a wireframe project description template
- [x] `LICENSE` file with MIT/Unlicense text generation options and metadata
- [x] `.gitignore` with some basic python-related ignores
- [x] `.env` for local environmental variables (`.gitignored`)
- [x] `Makefile` for running project related tasks (e.g., creating environment, running tests, etc.)
- [x] `__init__.py` files in the main module and submodules (only in the main module for `project-minit`)
- [x] `test` directory intended for `coverage` and `pytest` testing
- [x] `src/<project_name>` directory for the main module
- [x] `data` directory
- [x] `scripts/check_environment.py` script for testing base needs for the environment

Some additional features included in the full setup (`aq-init`) are:

- [x] `docs` directory with a basic Sphinx template
- [x] `notebooks` directory for Jupyter/quarto notebooks
- [x] `src/<project_name>` directory with a basic module structure
- [x] `data` subdirectories for raw, interim, processed, and external data
- [x] `reports` directory (with subdirectories for figures and tables)
- [x] `references` directory
- [x] `configs` directory
- [x] `assets` directory
- [x] `build` directory (with subdirectories for models and temporary build files)

## Dependencies

This probably mostly works more or less right on UNIX-like systems (e.g., Linux, OSX, etc.). I haven't tested it properly on Windows, but it probably won't work there. It requires mostly access to a proper `bash`-like interpreter, some `python`, and ideally you'd also have access to `make` to be able to benefit from the created project utilities.

Some `python` packages you'll need to have for project initiation are:

- `toml`
- `packaging`

The created project templates will prioritize / prefer:

- `conda` for environment creation for specific python versions
- `poetry` for project initialization and package management
- `pytest` for unit testing
- `coverage` for test coverage reporting
- `sphinx` for documentation generation
- `quarto` for notebooks
- `black` for code formatting
- `isort` for import sorting
- `flake8` for linting
- `pyright` for static type checking

Some of these have fallback alternatives set, others do not.

## Usage

If you really want to risk trying it, it is recommended to test it first in a docker container or something before deploying anywhere real so that you're aware of how it works and what it might break. For the brave, to get started first clone the repo:

```bash
git clone https://github.com/JPK85/analysis_quickstart
```

`cd` to the project root and make the main script executable:

```bash
chmod +x ./aq-init
```

Or if you wish to use the lite-version `aq-minit`, make that executable:

```bash
chmod +x ./aq-minit
```

Both of these will make the subscripts executable as well, and using both is okay too.

I would strongly recommend symlinking whichever script you wish to use to a directory in your path for ease of use e.g.,:

```bash
ln -s /path/to/repo/aq-init /usr/local/bin/aq-init
```

or, for the lite-version:

```bash
ln -s /path/to/repo/aq-minit /usr/local/bin/aq-minit
```

The script will attempt to handle paths relative to the current working directory, so you can run the symlinked script from anywhere you have access to. `cd` into the desired parent folder of where you want your newfound project, and run:

```bash
aq-init <my_project>
```

where `<my_project>` is the name of the project you want to create. This will prompt you for some metadata and create the project template in a subdirectory with the project name and initialize a local `git` repository with all the generated files committed. If you want to use the lite-version, just replace `aq-init` with `aq-minit` in the above command.

Once you've prompted the wireframe, `cd` into the project directory. The ideal start sequence (assuming `conda`) is:

1. `make create_env` -- creates a virtual `conda` environment for the project using the python version stated on metadata creation;
2. `conda activate <project_name>` -- activates the environment before other setup procedures;
3. `make setup-all` -- installs the project in editable mode with all dependencies including some standard `dev` dependencies like `pynvim` and `python-dotenv`;
4. `make test_env` -- runs the `scripts/check_environment.py` script to check that the environment is set up correctly;
5. `make help` -- lists all the available `make` commands for the project so you can see what's what
6. Go to `src/<project_name>` and start going to town.

If you don't have access to `make`, you can also setup the environment manually for more control, which is useful if you don't like poetry and want to have more control over your environment.

### Directory tree for folders in the full setup looks like so

```bash
.
├── .env                        # for local environmental variables (.gitignore)
├── .git
├── .gitignore                  # for gitignore (basic ignores and template related files)
├── LICENSE
├── Makefile                    # for project utilities (e.g., environment creation, testing, etc.)
├── README.md                   # for project description, initialized with metadata
├── assets                      # for images, etc.
├── build                       # for build artifacts (consider .gitignoring)
│   ├── models                  # for production model artifacts and versions (consider .gitignoring)
│   └── tmp                     # for temporary build files (.gitignored by default)
├── configs                     # for local config files (.gitignored by default)
├── data                        # for data files (.gitignored by default; use dvc for data)
│   ├── external                # from external sources
│   ├── interim                 # for intermediate/transformed data
│   ├── processed               # for final, canonical data
│   └── raw                     # for raw immutable source data
├── docs                        # Sphinx documentation
│   ├── Makefile
│   ├── _build
│   ├── make.bat
│   └── source
│       ├── _static
│       ├── _templates
│       ├── conf.py
│       └── index.rst
├── notebooks                   # exploratory notebooks
├── pyproject.toml              # project metadata
├── references                  # local project references (.gitignored by default)
├── reports                     # for project reports and their assets
│   ├── figures
│   └── tables
├── src                         # source code
│   └── <project_name>          # main module
│       ├── __init__.py
│       ├── data                # scripts for data processing
│       │   ├── README.md
│       │   ├── __init__.py
│       ├── features            # scripts for features/transformations
│       │   ├── README.md
│       │   ├── __init__.py
│       ├── models              # scripts for model training and evaluation
│       │   ├── README.md
│       │   ├── __init__.py
├── test_env.py                 # test check for environment handling
└── tests                       # unit tests
    └── __init__.py
```

And for the lite-version we have a little less gunk:

```bash
.
├── .env
├── .git
├── .gitignore
├── LICENSE
├── Makefile
├── README.md
├── data
│   └── .gitkeep
├── pyproject.toml
├── scripts
│   └── check_environment.py
├── src
│   └── <project_name>
│       └── __init__.py
└── tests
   └── __init__.py
```

## References & attributions

- [cookiecutter data science template](https://drivendata.github.io/cookiecutter-data-science/) -- for the original idea, and the contents of the created .env file + the Makefile help function
