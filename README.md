# Flort - File Concatenation and Project Overview Tool

[![License](https://img.shields.io/badge/license-BSD%203--Clause-blue.svg)](LICENSE)
[![Python](https://img.shields.io/badge/python-3.6%2B-blue.svg)](https://python.org)
[![Tests](https://github.com/watkinslabs/flort/actions/workflows/test.yml/badge.svg)](https://github.com/watkinslabs/flort/actions/workflows/test.yml)


![Flort Logo](assets/flort-logo.png)



## FLORT — Flattened Layout for Organized Repo Transpilation

**Flort** is a powerful command-line tool for creating consolidated views of your project's source code. It intelligently combines multiple files into a single, well-organized output file with comprehensive filtering, directory tree generation, and Python code analysis capabilities.

Perfect for preparing codebases for LLM analysis, documentation generation, code reviews, or sharing complete project overviews.

- LLM training & fine-tuning
- Source code summarization
- Project documentation
- Codebase visualization

## ✨ Features

### 🎯 **Smart File Discovery**
- **Extension-based filtering**: Include/exclude by file type
- **Pattern-based filtering**: Advanced glob pattern matching
- **Binary file detection**: Automatic exclusion with override option
- **Hidden file handling**: Control visibility of dotfiles
- **Directory traversal limits**: Set maximum depth
- **Specific file inclusion**: Add individual files regardless of filters

### 🌲 **Project Structure Visualization**
- **Directory tree generation**: Clean, `tree`-like output
- **Python code outline**: Detailed class/function signatures with docstrings
- **File manifest**: Size and type information without content

### ⚙️ **Advanced Configuration**
- **Configuration display**: See exactly what filters were applied
- **Multiple output formats**: File concatenation, manifest, or outline
- **Archive creation**: Generate ZIP or tar.gz archives
- **Content cleaning**: Normalize whitespace while preserving structure

### 🔧 **Robust Processing**
- **Comprehensive error handling**: Graceful failure with detailed logging
- **Performance optimized**: Efficient processing of large codebases
- **Cross-platform**: Works on Linux, macOS, and Windows
- **Extensive testing**: 19 test cases covering all functionality

## 🚀 Quick Start

### Installation

```bash
# Install from source
git clone https://github.com/watkinslabs/flort.git
cd flort
pip install -e .

# Or install from PyPI (when published)
pip install flort
```

### Basic Usage

```bash
# Include all Python files in current directory
flort --extensions py

# Include multiple file types, exclude tests
flort --extensions py,js,ts --exclude-patterns "*test*"

# Process specific files only
flort -f README.md,setup.py,requirements.txt

# Complex filtering with configuration display
flort --extensions py,md --exclude-extensions pyc \
      --exclude-patterns "*test*,*cache*" \
      --ignore-dirs __pycache__,node_modules \
      --show-config
```

## 📖 Command Reference

### Core Options

| Option | Description | Example |
|--------|-------------|---------|
| `--extensions` `-e` | File extensions to include | `--extensions py,js,ts` |
| `--exclude-extensions` | File extensions to exclude | `--exclude-extensions pyc,pyo` |
| `--glob` `-g` | Glob patterns to include | `--glob "*.py,src/**/*.js"` |
| `--exclude-patterns` | Glob patterns to exclude | `--exclude-patterns "*test*,*.min.*"` |
| `--include-files` `-f` | Specific files to include | `--include-files config.ini,VERSION` |
| `--ignore-dirs` `-i` | Directories to skip | `--ignore-dirs __pycache__,node_modules` |

### Behavior Modifiers

| Option | Description |
|--------|-------------|
| `--all` `-a` | Include all files (respects exclude filters) |
| `--hidden` `-H` | Include hidden files/directories |
| `--include-binary` | Include binary files (normally excluded) |
| `--max-depth` | Maximum directory traversal depth |

### Output Control

| Option | Description |
|--------|-------------|
| `--output` `-o` | Output file path (default: `<dir>.flort.txt`) |
| `--show-config` | Display configuration at start of output |
| `--no-tree` `-t` | Skip directory tree generation |
| `--outline` `-O` | Generate Python code outline |
| `--manifest` | Create file listing without content |
| `--no-dump` `-n` | Skip file concatenation |
| `--archive` `-z` | Create ZIP or tar.gz archive |

### Utility Options

| Option | Description |
|--------|-------------|
| `--verbose` `-v` | Enable detailed logging |
| `--ui` `-u` | Launch interactive file selector |
| `--version` | Show version information |
| `--help` `-h` | Display help message |

## 💡 Usage Examples

### 📁 **Project Documentation**
```bash
# Create comprehensive project overview
flort . --extensions py,md,txt,yml \
        --exclude-patterns "*test*,*cache*" \
        --show-config \
        --outline \
        --archive zip
```

### 🤖 **LLM Context Preparation**
```bash
# Prepare codebase for AI analysis
flort src/ --extensions py,js \
           --exclude-patterns "*test*,*.min.*" \
           --max-depth 3 \
           --show-config
```

### 📊 **Code Review Package**
```bash
# Generate review-ready code package
flort --extensions py,js,ts,md \
      --exclude-extensions pyc,pyo \
      --ignore-dirs __pycache__,node_modules,dist \
      --manifest \
      --show-config
```

### 🔍 **Specific Analysis**
```bash
# Analyze only configuration and main files
flort -f setup.py,requirements.txt,config.py,main.py \
      --show-config \
      --outline
```

### 🎯 **Filtered Processing**
```bash
# Python files only, exclude tests and cache
flort --extensions py \
      --exclude-patterns "*test*,*cache*,*__pycache__*" \
      --exclude-extensions pyc,pyo \
      --hidden \
      --show-config
```

## 📋 Output Format

Flort generates well-structured output with clear sections:

```
## Florted: 2025-06-01 16:45:30

## Flort Configuration
Working Directory: /path/to/project
Output File: project.flort.txt
Target Directories: .

### Inclusion Criteria:
- Extensions: py, js, md
- Exclude patterns: *test*, *cache*

### Exclusion Criteria:
- Binary files (use --include-binary to include)
- Hidden files (use --hidden to include)

---

## Directory Tree
project/
├── README.md
├── setup.py
├── src/
│   ├── main.py
│   └── utils.py
└── tests/
    └── test_main.py

## Python Code Outline
### File: src/main.py

FUNCTION: main() -> None
  DOCSTRING:
    Main entry point for the application.

CLASS: Application
  DOCSTRING:
    Core application class.

  METHOD: __init__(self, config: dict)
  METHOD: run(self) -> int

## File Data
--- File: README.md
--- Characters: 1,234
--- Token Count: 456
# Project Title
...file content...

--- File: src/main.py  
--- Characters: 2,345
--- Token Count: 567
def main():
    """Main entry point."""
    ...
```

## 🔧 Advanced Features

### Interactive File Selection
```bash
# Launch curses-based file selector
flort --ui --extensions py,js
```

The interactive UI allows you to:
- Navigate directory structure
- Toggle file/directory selection
- Filter by extensions
- Preview selections
- Combine with command-line options

### Python Code Analysis
```bash
# Generate detailed code outline
flort --extensions py --outline --show-config
```

Extracts and displays:
- Class definitions with inheritance
- Method signatures with type annotations
- Function parameters and return types
- Docstrings and decorators
- Nested classes and methods

### Configuration Transparency
```bash
# See exactly what filters are applied
flort --extensions py,js --exclude-patterns "*test*" --show-config
```

Shows complete configuration including:
- Working directory and output file
- All inclusion/exclusion criteria
- Processing options and modes
- Applied filters and their effects

## 🧪 Development & Testing

### Running Tests
```bash
# Run all tests
python -m pytest tests/ -v

# Run specific test categories
python -m pytest tests/test_flort.py::TestUtils -v
python -m pytest tests/test_flort.py::TestTraverse -v
python -m pytest tests/test_flort.py::TestCLI -v

# Run with coverage
python -m pytest tests/ --cov=flort --cov-report=html
```

### Contributing
1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes and add tests
4. Run the test suite: `python -m pytest`
5. Submit a pull request

## 📚 API Usage

Flort can also be used programmatically:

```python
from flort import get_paths, concat_files, FileFilter

# Discover files with custom filtering
file_list = get_paths(
    directories=["src/"],
    extensions=["py", "js"],
    exclude_patterns=["*test*"],
    ignore_dirs=[Path("__pycache__")]
)

# Concatenate to output file
success = concat_files(file_list, "output.txt")

# Advanced filtering with FileFilter
filter_obj = FileFilter(
    include_extensions=["py"],
    exclude_patterns=["*test*"],
    include_binary=False
)
```

## 🔍 Troubleshooting

### Common Issues

**No files found:**
```bash
# Check what files exist
flort --all --show-config

# Verify extensions
flort --extensions py --verbose
```

**Files being excluded unexpectedly:**
```bash
# Use show-config to see active filters
flort --extensions py --show-config --verbose
```

**Binary files included:**
```bash
# Explicitly exclude binary files (default behavior)
flort --extensions py  # Binary files auto-excluded

# Or explicitly include them
flort --extensions py --include-binary
```

### Performance Tips

- Use `--max-depth` for deep directory structures
- Use `--exclude-patterns` to skip large generated directories
- Use `--ignore-dirs` for node_modules, .git, etc.
- Use `--manifest` instead of `--no-dump` for large codebases

## 📄 License

Licensed under the BSD 3-Clause License. See [LICENSE](LICENSE) for details.

## 🤝 Support

- **Issues**: [GitHub Issues](https://github.com/watkinslabs/flort/issues)
- **Discussions**: [GitHub Discussions](https://github.com/watkinslabs/flort/discussions)
- **Email**: chris@watkinslabs.com

## 📈 Changelog

### v 0.1.23 (2025-06-01)
- ✨ Added exclude functionality (`--exclude-extensions`, `--exclude-patterns`)
- ✨ Added configuration display (`--show-config`)
- ✨ Added binary file control (`--include-binary`)
- ✨ Added depth limiting (`--max-depth`)
- ✨ Added file manifest mode (`--manifest`)
- 🐛 Fixed `-f/--include-files` behavior
- 🐛 Fixed directory tree generation
- 🐛 Fixed pattern matching logic
- 🧪 Added comprehensive test suite (19 tests)
- 📚 Complete documentation rewrite

### v 0.1.1
- Basic file concatenation functionality
- Directory tree generation
- Python outline support