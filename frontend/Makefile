.PHONY: install
## Upgrade npm
## @category Install
install:
	npm install

.PHONY: build
## Build package
## @category build
build: clean
	npm run build

.PHONY: clean
## Remove static_build contents
## @category build
clean:
	rm -rf ../proj/static_build/*

.PHONY: fix
## Fix only frontend lint errors
## @category Lint
fix:
	./bin/fix-lint.sh

.PHONY: lint
## Lint front and back end
## @category Lint
lint:
	./bin/lint.sh

.PHONY: test
## Run All Tests
## @category Test
test:
	./bin/test.sh

.PHONY: all

include ../bin/makefile-help.mk
