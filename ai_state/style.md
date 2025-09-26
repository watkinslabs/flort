# Flort - Code Style Guide

This document codifies the existing code style patterns and conventions used in the Flort project. AI assistants should follow these established patterns when contributing code.

## Naming Conventions

### Variables and Functions
- **snake_case** for all variables, functions, and methods
- **Descriptive names** that clearly indicate purpose
- **Avoid abbreviations** unless they're standard (e.g., `args`, `kwargs`, `dir`)

```python
# Good examples from codebase
file_path: Path
include_extensions: List[str]
output_file: Optional[str]
is_binary_file(file_path: Path) -> bool
clean_content(file_path: Path) -> str
generate_tree(directory: Path, ignore_dirs: List[Path]) -> str
```

### Classes and Exceptions
- **PascalCase** for class names
- **Descriptive class names** that indicate functionality
- **Exception classes** end with "Error"

```python
# Examples from codebase
class FileFilter:
class ValidationResult:
class ValidationError(Enum):
```

### Constants and Enums
- **UPPER_SNAKE_CASE** for constants
- **Enum members** use descriptive names

```python
# Examples from codebase
NO_INCLUSION_CRITERIA = "no_inclusion_criteria"
DIRECTORY_NOT_FOUND = "directory_not_found"
binary_extensions = {'.exe', '.dll', '.so', ...}
```

### File and Directory Names
- **snake_case** for Python module files
- **Lowercase** for directories
- **Descriptive names** that indicate module purpose

```python
# Module structure examples
concatenate_files.py    # File concatenation functionality
python_outline.py      # Python code analysis
curses_selector.py     # Interactive UI implementation
simple_selector.py     # Simple selection utilities
```

## Code Organization Patterns

### Import Organization
Follow the established import grouping and ordering:

```python
# 1. Standard library imports (alphabetical)
import os
import re
import argparse
import logging
from pathlib import Path
from datetime import datetime
from typing import List, Optional, Tuple, Dict, Any

# 2. Third-party imports (if any)
import zipfile
import tarfile

# 3. Local imports (relative)
from .utils import is_binary_file, validate_file_path
from .traverse import get_paths, add_specific_files
```

### Function Organization
- **Docstrings**: Google-style docstrings for all public functions
- **Type hints**: Use type hints consistently for parameters and return values
- **Error handling**: Graceful error handling with logging

```python
def is_binary_file(file_path: Path) -> bool:
    """
    Determine if a file is binary by examining its contents.

    Args:
        file_path (Path): Path to the file to check

    Returns:
        bool: True if the file appears to be binary, False otherwise

    The function uses multiple methods to detect binary files:
    1. Checks for null bytes in the first 8192 bytes
    2. Looks for non-text characters outside the ASCII printable range
    3. Checks file extensions for known binary types

    Note:
        - Returns True on any error, assuming binary to be safe
        - Only reads the first 8KB for efficiency
        - Uses both content and extension-based detection
    """
```

### Class Organization
- **dataclass** decorator for simple data containers
- **Enum** for related constants
- **Clear initialization patterns** with type hints

```python
@dataclass
class ValidationResult:
    is_valid: bool
    errors: List[ValidationError]
    error_details: List[str]
    warnings: List[str] = None
    
    def __post_init__(self):
        if self.warnings is None:
            self.warnings = []
```

## Data Structure Patterns

### Type Hints
Use comprehensive type hints following established patterns:

```python
# Function signatures
def get_paths(
    directories: List[Path],
    extensions: Optional[List[str]] = None,
    exclude_extensions: Optional[List[str]] = None,
    glob_patterns: Optional[List[str]] = None,
    exclude_patterns: Optional[List[str]] = None,
    include_files: Optional[List[str]] = None,
    ignore_dirs: Optional[List[Path]] = None,
    include_all: bool = False,
    include_hidden: bool = False,
    include_binary: bool = False,
    max_depth: Optional[int] = None
) -> List[Path]:
```

### Collection Types
- **List[T]** for ordered collections
- **Set[T]** for unique collections
- **Dict[K, V]** for key-value mappings
- **Optional[T]** for nullable values

```python
# Examples from codebase
binary_extensions: Set[str] = {'.exe', '.dll', '.so', ...}
include_extensions: Optional[List[str]] = None
ignore_dirs: Optional[List[Path]] = None
```

### Path Handling
- **Always use Path objects** from pathlib
- **Convert strings to Path early** in processing
- **Use Path methods** instead of os.path operations

```python
# Good patterns
file_path = Path(file_string)
if file_path.exists():
    return file_path.read_text()

# Check extensions
if file_path.suffix.lower() in binary_extensions:
    return True
```

## Error Handling Patterns

### Exception Handling
- **Specific exception catching** where possible
- **Graceful degradation** with user-friendly messages
- **Logging for debugging** but not user errors

```python
try:
    with open(file_path, 'rb') as file:
        chunk = file.read(8192)
        # Process chunk...
except Exception as e:
    logging.debug(f"Error determining if file is binary {file_path}: {e}")
    return True  # Assume binary on error
```

### Validation Patterns
- **Early validation** of inputs
- **Enum-based error types** for consistency
- **Detailed error messages** for user guidance

```python
class ValidationError(Enum):
    NO_INCLUSION_CRITERIA = "no_inclusion_criteria"
    DIRECTORY_NOT_FOUND = "directory_not_found"
    FILE_NOT_READABLE = "file_not_readable"
    # ...

def validate_arguments(args) -> ValidationResult:
    errors = []
    error_details = []
    
    if not has_inclusion_criteria(args):
        errors.append(ValidationError.NO_INCLUSION_CRITERIA)
        error_details.append("No inclusion criteria specified")
    
    return ValidationResult(
        is_valid=len(errors) == 0,
        errors=errors,
        error_details=error_details
    )
```

## CLI Argument Patterns

### Argument Naming
- **Long form**: Descriptive kebab-case names
- **Short form**: Single character when logical
- **Consistency**: Similar options use similar patterns

```python
# Established patterns from cli.py
parser.add_argument('--extensions', '-e', help='File extensions to include')
parser.add_argument('--exclude-extensions', help='File extensions to exclude') 
parser.add_argument('--glob', '-g', help='Glob patterns to include')
parser.add_argument('--exclude-patterns', help='Glob patterns to exclude')
parser.add_argument('--include-files', '-f', help='Specific files to include')
parser.add_argument('--ignore-dirs', '-i', help='Directories to skip')
```

### Argument Processing
- **Comma-separated lists** for multiple values
- **Helper functions** for parsing complex inputs
- **Validation** before processing

```python
# Pattern for processing comma-separated arguments
def parse_comma_separated_list(value: str) -> List[str]:
    """Parse comma-separated string into list of stripped strings."""
    if not value:
        return []
    return [item.strip() for item in value.split(',') if item.strip()]

# Usage in argument parsing
if args.extensions:
    extensions = parse_comma_separated_list(args.extensions)
```

## Output Formatting Patterns

### Console Output
- **Clear section headers** with visual separators
- **Consistent formatting** for similar information
- **Progress indicators** where appropriate

```python
# Established output patterns
print(f"## Florted: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
print("\n## Flort Configuration")
print(f"Working Directory: {os.getcwd()}")
print("---")
```

### File Output
- **Structured format** with clear sections
- **Metadata headers** for context
- **Consistent file separators**

```python
# File output patterns
content += f"--- File: {relative_path}\n"
content += f"--- Characters: {char_count:,}\n"
content += f"--- Token Count: {token_count}\n"
content += file_content + "\n\n"
```

## Logging Patterns

### Log Levels
- **DEBUG**: Detailed debugging information
- **INFO**: General information about program execution
- **WARNING**: Warning about potential issues
- **ERROR**: Error conditions that don't stop execution

```python
# Examples from codebase
logging.debug(f"Error determining if file is binary {file_path}: {e}")
logging.info(f"Processing directory: {directory}")
logging.warning(f"Skipping unreadable file: {file_path}")
logging.error(f"Failed to process file: {file_path}")
```

### Logging Configuration
- **Conditional verbosity** based on command-line flags
- **Consistent formatting** across modules

```python
def configure_logging(verbose: bool = False):
    """Configure logging based on verbosity level."""
    level = logging.DEBUG if verbose else logging.WARNING
    logging.basicConfig(
        level=level,
        format='%(levelname)s: %(message)s'
    )
```

## Documentation Patterns

### Docstring Style
Use Google-style docstrings consistently:

```python
def function_name(param1: Type1, param2: Type2) -> ReturnType:
    """
    Brief description of what the function does.

    Args:
        param1: Description of parameter 1
        param2: Description of parameter 2

    Returns:
        Description of return value

    Raises:
        ExceptionType: Description of when this exception is raised

    Note:
        Additional notes or implementation details
        
    Example:
        >>> result = function_name("value1", "value2")
        >>> print(result)
        expected_output
    """
```

### Module Documentation
- **Module docstring** at the top of each file
- **Clear description** of module purpose
- **List of key functionality** provided

```python
"""
File Traversal Module

This module provides comprehensive file discovery functionality with support for:
- Directory traversal with depth tracking
- Extension-based filtering (include/exclude)
- Pattern-based filtering (include/exclude)
- Hidden file handling
- Binary file detection and filtering

The module implements a clean pipeline for file discovery that handles all
filtering operations in a consistent and predictable order.
"""
```

## Compatibility Requirements

### Python Version Support
- **Minimum Python 3.6** support required
- **Avoid newer syntax** that breaks 3.6 compatibility
- **Use typing module** imports for older Python versions

```python
# Compatible type hint imports
from typing import List, Optional, Dict, Any
# Not: from collections.abc import Sequence (3.9+)
```

### Dependency Management
- **Minimal dependencies**: Only `windows-curses` for Windows
- **Standard library preferred** over third-party packages
- **Cross-platform compatibility** required

## Testing Patterns

### Test Organization
- **Class-based organization** for related tests
- **Descriptive test names** that indicate what's being tested
- **Setup and teardown** when needed

```python
class TestUtils:
    def test_is_binary_file_with_known_binary(self):
        """Test binary file detection with known binary extensions."""
        # Test implementation...
    
    def test_clean_content_preserves_structure(self):
        """Test that content cleaning preserves code structure."""
        # Test implementation...
```

### Test Data Management
- **Separate directories** for test data
- **Clear naming** for test files and directories
- **Minimal test data** that covers edge cases

```python
# Test directory structure
tests/
├── test_ignore/        # Files that should be ignored
├── test_no_ignore/     # Files that should be included
└── test_*.py          # Test modules
```

## AI Assistant Guidelines

When contributing code to Flort:

1. **Follow existing patterns** - Don't invent new conventions
2. **Use established utilities** - Leverage existing helper functions
3. **Maintain type consistency** - Follow existing type hint patterns
4. **Document thoroughly** - Use Google-style docstrings
5. **Handle errors gracefully** - Follow established error handling patterns
6. **Test comprehensively** - Add tests following existing patterns
7. **Preserve compatibility** - Maintain Python 3.6+ support
8. **Keep dependencies minimal** - Avoid adding new dependencies

### Code Review Checklist
- [ ] Follows snake_case naming for functions/variables
- [ ] Uses PascalCase for classes
- [ ] Has comprehensive type hints
- [ ] Includes Google-style docstrings
- [ ] Handles errors gracefully with logging
- [ ] Maintains Python 3.6+ compatibility
- [ ] Adds appropriate tests
- [ ] Uses Path objects for file operations
- [ ] Follows established import patterns
- [ ] Documents any new functionality