#!/bin/bash
# Enable linting options
set -euo pipefail
while getopts "cdj" opt; do
  case $opt in
    d)
      echo "Project uses Dockerfiles"
      ENABLE_DOCKERFILES=1
      ;;
    c)
      echo "Project uses circleci"
      ENABLE_CIRCLECLI=1
      ;;
    j)
      echo "Project uses DJLint"
      ENABLE_DJLINT=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

FIX_SCRIPT=bin/fix-backend.sh
LINT_SCRIPT=bin/lint-backend.sh

if [ "${ENABLE_DOCKERFILES:-}" ]; then
  sed -i '' -e 's/# hadolint/hadolint/g' "$LINT_SCRIPT"
fi
if [ "${ENABLE_CIRCLECLI:-}" ]; then
  sed -i '' -e 's/# circleci/circleci/g' "$LINT_SCRIPT"
fi
if [ "${ENABLE_DJLINT:-}" ]; then
  sed -i '' -e 's/# djlint/djlint/g' "$FIX_SCRIPT"
  sed -i '' -e 's/# djlint/djlint/g' "$LINT_SCRIPT"
fi
