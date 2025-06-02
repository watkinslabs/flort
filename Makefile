# Makefile for wl_version_manager
# BSD 3-Clause License

PYTHON := python3
PIP := pip3
VERSION_MANAGER := wl_version_manager
VERSION := $(shell cat VERSION)
PKG_MGR := dnf

.PHONY: build tests clean setup

# Clean build artifacts
clean:
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info/
	rm -rf .pytest_cache/
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

# Build the package
build: clean increment-version
	$(PYTHON) setup.py sdist

# Version management using self (bootstrapped)
increment-version:
	@if [ ! -f VERSION ]; then $(PYTHON) -m ${VERSION_MANAGER} init; fi
	$(VERSION_MANAGER) patch

upload: 
	twine upload dist/*

# Set up the test environment
setup:
	chmod +x tests/setup.sh
	bash tests/setup.sh

# Build the package and then run tests
test: setup build
	pytest tests/test_cli.py
