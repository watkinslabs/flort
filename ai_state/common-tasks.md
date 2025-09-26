# Flort - Common Development Tasks

This document codifies the standard development tasks and workflows for AI assistants working on the Flort project. It reflects existing patterns and established practices.

## Development Environment Tasks

### Testing
- **Run all tests**: `python -m pytest tests/ -v`
- **Run with coverage**: `python -m pytest tests/ --cov=flort --cov-report=html`
- **Run specific test modules**: 
  - `python -m pytest tests/test_flort.py::TestUtils -v`
  - `python -m pytest tests/test_flort.py::TestTraverse -v`
  - `python -m pytest tests/test_flort.py::TestCLI -v`

### Documentation
- **Build docs**: `mkdocs build`
- **Serve docs locally**: `mkdocs serve`
- **Build production docs**: `mkdocs build --clean`
- **Deploy docs**: Docs are deployed via GitHub Pages from the `site/` directory

### Package Management
- **Install in development mode**: `pip install -e .`
- **Install with dev dependencies**: `pip install -e .[dev]`
- **Build package**: `python -m build`

### Code Quality
- **Manual testing**: `python -m flort --help`
- **Test core functionality**: `python -m flort . --extensions py --show-config`
- **Test UI mode**: `python -m flort --ui --extensions py`

## Build Process

### Package Building
1. Ensure `VERSION` file contains correct version number
2. Run tests: `python -m pytest tests/ -v`
3. Build package: `python -m build`
4. Check distribution: `twine check dist/*`

### Documentation Publishing
1. Update documentation files in `docs/` directory
2. Build site: `mkdocs build`
3. Serve locally for testing: `mkdocs serve`
4. Deploy to GitHub Pages: Files in `site/` directory are served at `https://watkinslabs.github.io/flort/`

### Version Release Process
1. Update `VERSION` file
2. Update `CHANGELOG.md` with changes
3. Ensure all tests pass
4. Build and test package locally
5. Create git tag for version
6. Push to repository (triggers CI/CD)

## Feature Development Workflow

### 1. Understanding the Codebase
- Read `README.md` for project overview and features
- Examine `flort/cli.py` for command-line interface patterns
- Check `flort/utils.py` for utility functions and helpers
- Review `tests/test_flort.py` for test patterns and examples

### 2. Adding New Features
- Follow existing argument parsing patterns in `cli.py`
- Add utility functions to appropriate modules (`utils.py`, `traverse.py`, etc.)
- Maintain backward compatibility
- Update help text and documentation
- Add comprehensive tests

### 3. Modifying Core Functionality
- **File filtering**: Modify `traverse.py` and `validation.py`
- **Output generation**: Modify `concatenate_files.py` and `utils.py`
- **CLI options**: Modify `cli.py` and argument parser
- **Python analysis**: Modify `python_outline.py`

### 4. Testing Strategy
- Add unit tests to `tests/test_flort.py`
- Test both positive and negative cases
- Include edge cases and error conditions
- Test CLI integration with various argument combinations
- Verify output formatting and file handling

## Project Structure Tasks

### Core Module Organization
- `flort/__init__.py`: Package initialization
- `flort/__main__.py`: Module entry point
- `flort/cli.py`: Command-line interface and argument parsing
- `flort/wrapper.py`: Script entry point wrapper
- `flort/utils.py`: Utility functions and helpers
- `flort/traverse.py`: File system traversal and filtering
- `flort/concatenate_files.py`: File concatenation and manifest creation
- `flort/python_outline.py`: Python code analysis and outline generation
- `flort/validation.py`: Input validation and error checking
- `flort/curses_selector.py`: Interactive UI implementation
- `flort/simple_selector.py`: Simple file selection utilities
- `flort/assets.py`: Asset file handling

### Documentation Structure
- `docs/`: MkDocs documentation source
- `README.md`: Primary project documentation
- `CHANGELOG.md`: Version history and changes
- `LICENSE`: BSD 3-Clause license
- `TODO.md`: Development roadmap

### Configuration Files
- `pyproject.toml`: Modern Python packaging configuration
- `setup.py`: Legacy setuptools configuration
- `mkdocs.yml`: Documentation site configuration
- `VERSION`: Single source of truth for version number

### File Organization Rules
- **Python modules**: All core functionality in `flort/` directory
- **Tests**: All test files in `tests/` directory, prefixed with `test_`
- **Documentation**: MkDocs source in `docs/`, built site in `site/`
- **Assets**: Images, logos, and static files in `assets/`
- **Build artifacts**: Generated files in `dist/`, `build/`, `.egg-info/`
- **Configuration**: Root-level config files (`.gitignore`, `pyproject.toml`, etc.)

## Common Maintenance Tasks

### Version Management
- Update `VERSION` file for releases
- Update `CHANGELOG.md` with changes
- Ensure version consistency across all files

### Documentation Updates
- Keep `README.md` synchronized with features
- Update command examples and usage patterns
- Maintain API documentation in docstrings
- Update MkDocs site content in `docs/` directory

### Code Maintenance
- Follow existing code style and patterns
- Maintain Python 3.6+ compatibility
- Keep dependencies minimal (only `windows-curses` for Windows)
- Use type hints where established patterns exist

### Error Handling Patterns
- Use logging for debug information
- Provide user-friendly error messages
- Handle file system errors gracefully
- Validate inputs early and clearly

## AI Assistant Guidelines

When working on Flort:

1. **Always run tests** after making changes: `python -m pytest tests/ -v`
2. **Test the CLI manually** to ensure changes work as expected
3. **Follow existing patterns** in code organization and style
4. **Maintain backward compatibility** unless explicitly breaking changes are needed
5. **Update documentation** when adding or changing features
6. **Use the existing project structure** - don't create unnecessary new files
7. **Respect the minimal dependency philosophy** - avoid adding new dependencies
8. **Follow the established CLI argument patterns** when adding new options