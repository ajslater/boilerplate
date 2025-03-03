#!/bin/bash
# Convert a poetry project to uv
set -euo pipefail
poetry add -D hatchling toml-cli
poetry remove wheel || true
uvx pdm import pyproject.toml

BUILD_INCLUDE=$(uvx toml get --toml-path=pyproject.toml tool.pdm.build.includes)
BUILD_EXCLUDE=$(uvx toml get --toml-path=pyproject.toml tool.pdm.build.excludes)
uvx toml unset --toml-path=pyproject.toml tool.pdm
uvx toml unset --toml-path=pyproject.toml tool.poetry
uvx toml unset --toml-path=pyproject.toml build-system
uvx toml add_section --toml-path=pyproject.toml build-system
uvx toml set --toml-path=pyproject.toml build-system.requires --to-array '["hatchling"]'
uvx toml set --toml-path=pyproject.toml build-system.build-backend hatchling.build
uvx toml add_section --toml-path=pyproject.toml tool.hatch.build.targets.sdist
uvx toml set --toml-path=pyproject.toml tool.hatch.build.targets.sdist.include "$BUILD_INCLUDE"
uvx toml set --toml-path=pyproject.toml tool.hatch.build.targets.sdist.exclude "$BUILD_EXCLUDE"
uvx toml set --toml-path=pyproject.toml tool.pyright.venvPath '.'
uvx toml set --toml-path=pyproject.toml tool.pyright.venv '.venv'

rm -rf builder-requirements.txt bin/update-builder-requirement.sh __pycache__ .venv uv.lock
find . \( -path "./bin" -o -path "./node_modules" -o -path "./frontend" -o -path "./test-results" -o -path "./.git" -o -path "./.venv" \) -prune -o -type f -exec sed -i '' -e 's/poetry.lock/uv.lock/g' {} \;

uv sync --all-extras --no-install-project
