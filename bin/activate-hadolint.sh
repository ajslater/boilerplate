#!/bin/bash
set -eo pipefail
sed -i '' -e 's/# hadolint/hadolint/' bin/lint-backend.sh
