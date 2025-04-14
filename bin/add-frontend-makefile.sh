#!/bin/bash
# Add frontend options to Makefile
set -euo pipefail

cat Makefile ../boilerplate/Makefile.frontend > Makefile.both
mv Makefile.both Makefile
sed -i '' -e 's/fix: fix-backend/fix: fix-frontend fix-backend/' Makefile
sed -i '' -e 's/lint: lint-backend/lint: lint-frontend lint-backend/' Makefile
cat "frontend/bin/update-deps.sh" > bin/update-deps.sh
