.PHONY: install
## Install for production
## @category Install
install:
	pip install --update pip
	poetry install --no-root

.PHONY: install-dev
## Install dev requirements
## @category Install
install-dev:
	poetry install  --no-root --extras=dev

.PHONY: install-all
## Install all extras
## @category Install
install-all:
	poetry install --no-root --all-extras

.PHONY: clean
## Clean pycaches
## @category Build
clean:
	 ./bin/clean-pycache.sh

.PHONY: build
## Build package
## @category Build
build:
	poetry build

.PHONY: publish
## Publish package to pypi
## @category Deploy
publish:
	poetry publish

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

## version
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
## @category Tests
T :=
.PHONY: test
## Run Tests
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
