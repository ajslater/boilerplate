#!/bin/bash
# Get version or set version in Frontend & API.
set -euo pipefail
VERSION="${1:-}"
TOML_PATH="--toml-path=pyproject.toml"
if [ "$VERSION" = "" ]; then
  uvx toml get "$TOML_PATH" project.version
else
  uvx toml set "$TOML_PATH" project.version "$VERSION"
  cd frontend
  npm version --allow-same-version "$VERSION"
fi
