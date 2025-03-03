#!/bin/bash
# Convert a poetry project to uv
set -euo pipefail
poetry add -D hatchling toml-cli
poetry remove wheel || true
uv run pdm import pyproject.toml

TOML_PATH=--toml-path=pyproject.toml
BUILD_INCLUDE=$(uv run toml get "$TOML_PATH" tool.pdm.build.includes)
BUILD_EXCLUDE=$(uv run toml get "$TOML_PATH" tool.pdm.build.excludes)
uv run toml unset "$TOML_PATH" tool.pdm
uv run toml unset "$TOML_PATH" tool.poetry
uv run toml unset "$TOML_PATH" build-system
uv run toml add_section "$TOML_PATH" build-system
uv run toml set "$TOML_PATH" build-system.requires --to-array '["hatchling"]'
uv run toml set "$TOML_PATH" build-system.build-backend hatchling.build
uv run toml add_section "$TOML_PATH" tool.hatch.build.targets.sdist
uv run toml set "$TOML_PATH" tool.hatch.build.targets.sdist.include "$BUILD_INCLUDE"
uv run toml set "$TOML_PATH" tool.hatch.build.targets.sdist.exclude "$BUILD_EXCLUDE"
uv run toml set "$TOML_PATH" tool.pyright.venvPath '.'
uv run toml set "$TOML_PATH" tool.pyright.venv '.venv'

rm -rf builder-requirements.txt bin/update-builder-requirement.sh __pycache__ .venv uv.lock
find . \( -path "./bin" -o -path "./node_modules" -o -path "./frontend" -o -path "./test-results" -o -path "./.git" -o -path "./.venv" \) -prune -o -type f -exec sed -i '' -e 's/poetry.lock/uv.lock/g' {} \;

uv sync --all-extras --no-install-project
