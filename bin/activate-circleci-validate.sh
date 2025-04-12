#!/bin/bash
set -eo pipefail
sed -i '' -e 's/# circleci/circleci/' bin/lint-backend.sh
