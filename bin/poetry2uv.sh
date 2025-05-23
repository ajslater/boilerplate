#!/bin/bash
# Convert a poetry project to uv
set -euxo pipefail
echo "Changing build dependencies to hatchling..."
poetry remove wheel || true
poetry add -D hatchling toml-cli pyclean

TOML_PATH=--toml-path=pyproject.toml
toml_get() {
  uv run toml get "$TOML_PATH" "$@"
}

toml_set() {
  uv run toml set "$TOML_PATH" "$@"
}
toml_unset() {
  uv run toml unset "$TOML_PATH" "$@"
}
toml_add_section() {
  uv run toml add_section "$TOML_PATH" "$@"
}
pdm_toml_set() {
  uvx --with pdm toml set "$TOML_PATH" "$@"
}
yq_eval() {
  uv run yq eval "$@"
}

echo "Converting pyproject.toml..."
uvx pdm import pyproject.toml

printf "\tSaving build configuration..."
BUILD_INCLUDE=$(toml_get tool.pdm.build.includes) || true
BUILD_INCLUDE=${BUILD_INCLUDE//\'/\"}
BUILD_EXCLUDE=$(toml_get tool.pdm.build.excludes) || true
BUILD_EXCLUDE=${BUILD_EXCLUDE//\'/\"}
printf "\tRemoving old sections..."
printf "\tConfigure new build system..."
toml_add_section build-system
if [ "$BUILD_INCLUDE" != "" ] || [ "$BUILD_EXCLUDE" != "" ]; then
  toml_add_section tool.hatch.build.targets.sdist
fi
if [ "$BUILD_INCLUDE" != "" ]; then
  toml_set tool.hatch.build.targets.sdist.include --to-array "$BUILD_INCLUDE"
fi
if [ "$BUILD_EXCLUDE" != "" ]; then
  toml_set tool.hatch.build.targets.sdist.exclude --to-array "$BUILD_EXCLUDE"
fi
toml_unset tool.pdm
toml_unset tool.poetry
echo "Configure pyright for venv..."
toml_set tool.pyright.venvPath '.'
toml_set tool.pyright.venv '.venv'

# Hatchling build system gets set last because it may interfere with uv run before this
pdm_toml_set build-system.requires --to-array '["hatchling"]'
pdm_toml_set build-system.build-backend hatchling.build

CCI_CONFIG=.circleci/config.yml
if [ -f "$CCI_CONFIG" ]; then
  echo "Configure circleci for uv..."
  yq_eval '.jobs.deploy.docker[0].image = "ghcr.io/astral-sh/uv:bookworm-slim"' -i "$CCI_CONFIG"
  yq_eval '.jobs.deploy.steps[1].run = "uv publish"' -i "$CCI_CONFIG"
fi

echo "Moving [project] to top of pyproject.toml"
bin/reorg-pyproject.awk pyproject.toml > pyproject.temp && mv pyproject.temp pyproject.toml

echo "Remove old files..."
rm -rf .pytest_cache .ruff_cache .venv* builder-requirements.txt bin/publish-pypi.sh bin/update-builder-requirement.sh poetry.lock test-results uv.lock
mkdir test-results

echo "Update project dependencies"
uv sync --all-extras --no-install-project

pyclean .

echo "Replace referenecs to poetry.lock with uv.lock"
find . \( -path "*~" -o -path "./.venv*" -o -path "./dist" -o -path "./node_modules" -o -path "./frontend" -o -path "./test-results" -o -path "./.git" \) -prune -o -type f -exec sed -i '' -e 's/poetry.lock/uv.lock/g' {} \;
find . \( -path "*~" -o -path "./.venv*" -o -path "./dist" -o -path "./node_modules" -o -path "./frontend" -o -path "./test-results" -o -path "./.git" \) -prune -o -type f -name "*.sh" -exec sed -i '' -e 's/poetry run/uv run/g' {} \;

bin/enable-lints.sh "$@"

echo "Done!"
echo

echo 1. Scripts
echo 1.1. Copy new bin scripts from boilerplate
echo 1.2. Copy Makefile from boilerplate.
echo 3. Build
echo 3.1. Fix Dockerfiles to use nikolaik/python-nodejs:latest
echo 3.2. Fix docker-compose.yaml
echo 3.3. Create new token on pypi for circleci
