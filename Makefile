SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -O globstar -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: default clean test test-nmm2xml test-nmm2txt bin

default:
	@echo 'no default target'

clean:
	# remove anything in .gitignore, including directories
	git clean -fdX
	cd implementations
	make clean
	cd -
	cd bin
	make clean
	cd -

readme:
	cd readme-template
	make
	cd -

test: test-nmm2xml test-nmm2txt
	cd implementations
	make test
	cd -
	nix build

bin:
	cd bin
	make
	cd -

test-nmm2xml: bin test-data-nmm2xml
	./test-nmm2xml.sh

test-nmm2txt: bin test-data-nmm2txt
	./test-nmm2txt.sh

share: share/bash-completion/completions share/fish/completions share/zsh/site-functions

share/bash-completion/completions:                           \
	implementations/ocaml/scripts/nmm-ocaml-bash-completion.sh \
	bin/nmm-cli-experimental
	#
	mkdir -p share/bash-completion/completions
	cp implementations/ocaml/scripts/nmm-ocaml-bash-completion.sh share/bash-completion/completions/nmm-ocaml
	_TYPER_COMPLETE_TEST_DISABLE_SHELL_DETECTION=1 ./bin/nmm-cli-experimental --show-completion bash > share/bash-completion/completions/nmm-cli-experimental

share/fish/completions: bin/nmm-cli-experimental
	mkdir -p share/fish/completions
	_TYPER_COMPLETE_TEST_DISABLE_SHELL_DETECTION=1 ./bin/nmm-cli-experimental --show-completion fish > share/fish/completions/_nmm-cli-experimental

share/zsh/site-functions: bin/nmm-cli-experimental
	mkdir -p share/zsh/site-functions
	_TYPER_COMPLETE_TEST_DISABLE_SHELL_DETECTION=1 ./bin/nmm-cli-experimental --show-completion zsh  > share/zsh/site-functions/_nmm-cli-experimental
