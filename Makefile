.PHONY: install-deps
## Update pip and install node packages
	pip install --upgrade pip
	npm install

.PHONY: install
## Install for production
## @category Install
install-prod: install-deps
	uv sync --no-install-project --no-dev

.PHONY: install-dev
## Install dev requirements
## @category Install
install-dev: install-deps
	uv sync --no-install-project

.PHONY: install-all
## Install with all extras
## @category Install
install-all: install-deps
	uv sync --no-install-project --all-extras

.PHONY: clean
## Clean pycaches
## @category Build
clean:
	 ./bin/clean-pycache.sh

.PHONY: build
## Build package
## @category Build
build:
	uv build

.PHONY: publish
## Publish package to pypi
## @category Deploy
publish:
	UV_PUBLISH_TOKEN=$PYPI_PASS uv publish

.PHONY: update
## Update dependencies
## @category Update
update:
	./bin/update-deps.sh

.PHONY: update-builder
## Update builder requirements
## @category Update
update-builder:
	./bin/update-builder-requirement.sh

## Show version. Use V variable to set version
## @category Update
V :=
.PHONY: version
## Show or set project version
## @category Update
version:
	bin/version.sh $(V)

.PHONY: kill-eslint_d
## Kill eslint daemon
## @category Lint
kill-eslint_d:
	bin/kill-eslint_d.sh

.PHONY: fix
## Fix front and back end lint errors
## @category Lint
fix: fix-frontend fix-backend

.PHONY: fix-backend
## Fix only backend lint errors
## @category Lint
fix-backend:
	./bin/fix-lint-backend.sh

.PHONY: fix-frontend
## Fix only frontend lint errors
## @category Lint
fix-frontend:
	bash -c "cd frontend && make fix"

.PHONY: lint
## Lint front and back end
## @category Lint
lint: lint-frontend lint-backend

.PHONY: lint-backend
## Lint the backend
## @category Lint
lint-backend:
	./bin/lint-backend.sh

.PHONY: lint-frontend
## Lint the frontend
## @category Lint
lint-frontend:
	bash -c "cd frontend && make lint"

## Test
## @category Test
T :=
.PHONY: test
## Run Tests. Use T variable to run specific tests
## @category Test
test:
	./bin/test.sh $(T)

.PHONY: dev-server
## Run the dev webserver
## @category Run
dev-server:
	./bin/dev-server.sh

.PHONY: dev-frontend
## Run the vite dev frontend
## @category Run
dev-frontend-server:
	bash -c "cd frontend && make dev-server"

.PHONY: news
## Show recent NEWS
## @category Deploy
news:
	head -40 NEWS.md

.PHONY: all

include bin/makefile-help.mk
