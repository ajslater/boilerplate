#!/bin/bash
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
            echo "Project uses Dockerfiles"
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

if [ "$ENABLE_DOCKERFILES" ]; then
    sed -i '' -e 's/# hadolint/hadolint' "$LINT_SCRIPT"
fi
if [ "$ENABLE_CIRCLECLI" ]; then
    sed -i '' -e 's/# circleci/circleci' "$LINT_SCRIPT"
fi
if [ "$ENABLE_DJLINT" ]; then
    sed -i '' -e 's/# djlint/djlint' "$FIX_SCRIPT"
    sed -i '' -e 's/# djlint/djlint' "$LINT_SCRIPT"
fi
