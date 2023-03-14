#!/bin/bash
# Fix common linting errors
set -euo pipefail
./sortignore.sh
####################
###### Python ######
###################
poetry run ruff --fix .
poetry run black .

############################################
##### Javascript, JSON, Markdown, YAML #####
############################################
npm run fix

###################
###### Shell ######
###################
shellharden --replace ./*.sh # ./**/*.sh
