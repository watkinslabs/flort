# Flort - Ways of Working

This document describes the established development practices, workflows, and tooling preferences for the Flort project. AI assistants should follow these patterns when contributing to the codebase.

## Development Philosophy

### Automation via Makefiles
The project heavily uses Makefiles to standardize and automate common development tasks:

- **Primary Makefile**: `Makefile.docs` contains comprehensive development workflows
- **Legacy Makefile**: `Makefile` exists but is outdated (references `wl_version_manager`)
- **Usage**: Always prefer `make` commands over manual command execution
- **Documentation**: Use `make help` to see all available targets

### Key Make Targets
```bash
# Documentation workflow
make docs          # Serve docs locally at http://127.0.0.1:8000
make docs-build    # Build documentation 
make docs-deploy   # Deploy to GitHub Pages
make docs-clean    # Clean documentation build

# Development workflow  
make install       # Install development dependencies
make test          # Run full test suite with coverage
make lint          # Run linting checks (flake8, mypy)
make format        # Format code (black, isort)
make check-all     # Run all checks (lint, test, build)

# Cleanup
make clean         # Clean all build artifacts

# Development environment
make dev           # Start development with live reload
make quick-test    # Quick sanity check of installation
```

## GitHub Actions Workflow

### Continuous Integration
The project uses two main GitHub Actions workflows:

#### Test Workflow (`.github/workflows/test.yml`)
- **Triggers**: Push to main, pull requests to main
- **Matrix testing**: Python 3.8, 3.9, 3.10, 3.11
- **Steps**: Install dependencies → Run tests with coverage → Upload coverage
- **Coverage**: Uses CodeCov for coverage reporting

#### Documentation Workflow (`.github/workflows/docs.yml`)
- **Triggers**: 
  - Push to main (docs/, mkdocs.yml, README.md, flort/ changes)
  - Pull requests (docs/, mkdocs.yml changes)
  - Manual workflow dispatch
- **Process**: Build MkDocs site → Deploy to GitHub Pages
- **Permissions**: Automatically configured for Pages deployment

### Workflow Patterns
- **Build verification**: All workflows verify package installation
- **Dependency isolation**: Each workflow installs its own dependencies
- **Artifact management**: Documentation builds upload to Pages automatically
- **Error handling**: Workflows include debugging steps for troubleshooting

## Testing Strategy

### Test Framework
- **Primary**: pytest with coverage reporting
- **Coverage tools**: pytest-cov, HTML and XML reports
- **Location**: All tests in `tests/` directory
- **Naming**: Test files prefixed with `test_`

### Test Organization
- **Main test file**: `tests/test_flort.py` 
- **Test classes**: `TestUtils`, `TestTraverse`, `TestCLI`
- **UI testing**: `tests/test-ui.py` for interactive components
- **Test data**: Uses `tests/test_ignore/` and `tests/test_no_ignore/` directories

### Testing Workflow
```bash
# Full test suite
make test                                    # Preferred method
python -m pytest tests/ -v --cov=flort      # Direct command

# Specific test classes  
python -m pytest tests/test_flort.py::TestUtils -v
python -m pytest tests/test_flort.py::TestTraverse -v
python -m pytest tests/test_flort.py::TestCLI -v

# Coverage reporting
python -m pytest tests/ --cov=flort --cov-report=html
```

## Documentation Workflow

### MkDocs Configuration
- **Theme**: Material Design with custom styling
- **Features**: Full navigation, search, code highlighting, responsive design
- **Plugins**: Search, minify, mkdocstrings (API docs), git integration
- **Custom styling**: `docs/stylesheets/custom.css`

### Documentation Structure
```
docs/
├── index.md              # Home page
├── installation.md       # Installation guide
├── quickstart.md         # Quick start guide
├── usage.md              # Command line reference
├── ui-guide.md           # Interactive UI guide
├── filtering.md          # File filtering guide
├── output-formats.md     # Output format documentation
├── examples.md           # Use cases and examples
├── api/                  # API reference
├── contributing.md       # Contribution guide
├── changelog.md          # Change history
├── troubleshooting.md    # Common issues
└── stylesheets/
    └── custom.css        # Custom styling
```

### Documentation Deployment
- **Automatic**: Triggered by changes to docs/, mkdocs.yml, README.md, or flort/
- **Manual**: `make docs-deploy` or workflow dispatch
- **Preview**: `make docs` for local development with live reload
- **Build verification**: `make docs-build` checks for errors

## Code Quality Standards

### Linting and Formatting
- **Linting**: flake8 (style) + mypy (types)
- **Formatting**: black (code) + isort (imports)
- **Command**: `make lint` and `make format`
- **CI Integration**: Linting is part of `make check-all`

### Code Style Guidelines
- **Compatibility**: Python 3.6+ support required
- **Dependencies**: Minimal (only `windows-curses` for Windows)
- **Type hints**: Used where established patterns exist
- **Docstrings**: Google-style docstrings for API documentation
- **Error handling**: Graceful failure with user-friendly messages

## Version Management

### Version Control
- **Source of truth**: `VERSION` file in project root
- **Format**: Semantic versioning (e.g., `0.1.23`)
- **Consistency**: Version must be updated across all references
- **Release process**: Update VERSION → Update CHANGELOG.md → Test → Tag → Release

### Release Workflow
1. Update `VERSION` file with new version number
2. Update `CHANGELOG.md` with changes and date
3. Run `make check-all` to ensure all tests pass
4. Build package: `python -m build`
5. Test package locally
6. Create git tag: `git tag v0.1.23`
7. Push to repository (triggers CI/CD)

## File Organization Preferences

### Project Structure Standards
```
flort/                    # Core package
├── __init__.py          # Package initialization
├── __main__.py          # Module entry point  
├── cli.py               # Command-line interface
├── wrapper.py           # Script entry point
├── utils.py             # Utility functions
├── traverse.py          # File system operations
├── concatenate_files.py # File concatenation
├── python_outline.py    # Code analysis
├── validation.py        # Input validation
├── curses_selector.py   # Interactive UI
├── simple_selector.py   # Simple UI utilities
└── assets.py            # Asset handling

tests/                   # Test suite
├── test_flort.py       # Main test file
├── test-ui.py          # UI tests
├── test_ignore/        # Test data (ignored)
└── test_no_ignore/     # Test data (included)

docs/                    # Documentation source
├── *.md                # Documentation pages
├── api/                # API reference
└── stylesheets/        # Custom styling

ai_state/               # AI assistant guidance
├── tasks.md           # Development tasks
├── ways-of-working.md # This file
└── style.md           # Code style guide
```

### Naming Conventions
- **Files**: Snake_case for Python files
- **Directories**: Lowercase with underscores
- **Classes**: PascalCase
- **Functions**: snake_case
- **Variables**: snake_case
- **Constants**: UPPER_SNAKE_CASE

## Build Process Standards

### Package Building
```bash
# Preferred workflow
make build              # Clean → Check all → Build package

# Manual process
make clean              # Clean artifacts
make check-all          # Run all checks
python -m build         # Build wheel and source
twine check dist/*      # Verify package
```

### Documentation Building
```bash
# Development
make docs               # Local development server
make docs-build         # Production build
make docs-deploy        # Deploy to GitHub Pages

# Quality checks
make docs-check         # Verify links and structure
```

## Troubleshooting Patterns

### Common Issue Resolution
- **No files found**: Use `--show-config` to see active filters
- **Files excluded**: Check glob patterns and extension filters
- **Binary files**: Control with `--include-binary` flag
- **Performance**: Use `--max-depth` and `--ignore-dirs`

### Debug Workflow
1. Run with `--verbose` for detailed logging
2. Use `--show-config` to see all active filters
3. Test with minimal arguments first
4. Check file permissions and access
5. Verify Python version compatibility

## AI Assistant Best Practices

When working on Flort, AI assistants should:

### Follow Established Patterns
- **Use Makefiles**: Always prefer `make` commands over manual execution
- **Follow GitHub Actions**: Understand CI/CD workflows and requirements
- **Respect test structure**: Add tests to existing test classes
- **Maintain documentation**: Update relevant documentation with changes

### Code Development Workflow
1. **Understand**: Read existing code and documentation
2. **Test first**: Run `make test` to establish baseline
3. **Develop**: Follow existing patterns and conventions
4. **Quality check**: Run `make check-all` before finishing
5. **Document**: Update relevant documentation and help text

### Quality Assurance
- **Always test**: Use `make test` after any code changes
- **Format consistently**: Use `make format` for code formatting
- **Check comprehensively**: Use `make check-all` before completion
- **Manual verification**: Use `make quick-test` for sanity checks

### Communication Standards
- **Be specific**: Reference file paths and line numbers when discussing code
- **Show commands**: Include exact make/command invocations
- **Explain changes**: Document why changes were made, not just what
- **Test evidence**: Show test results and verification steps