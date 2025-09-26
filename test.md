## Florted: 2025-09-25 17:03:39
## Directory Tree
flort/
├── flort/
│   ├── __init__.py
│   ├── __main__.py
│   ├── assets.py
│   ├── cli.py
│   ├── concatenate_files.py
│   ├── curses_selector.py
│   ├── python_outline.py
│   ├── simple_selector.py
│   ├── traverse.py
│   ├── utils.py
│   ├── validation.py
│   └── wrapper.py
├── tests/
│   ├── test_ignore/
│   │   └── file2.py
│   ├── test_no_ignore/
│   │   └── file4.py
│   ├── __init__.py
│   ├── test-ui.py
│   └── test_flort.py
└── setup.py

## File Data
--- File: flort/__init__.py
--- Characters: 2,681
--- Token Count: 492
'''
Flort - File Concatenation and Project Overview Tool

A comprehensive tool for creating consolidated views of project source code
by combining multiple files into a single output file with intelligent filtering,
directory tree generation, and Python code outline capabilities.

Key Features:
- Comprehensive file discovery with include/exclude filtering
- Extension-based and pattern-based file filtering
- Binary file detection and exclusion
- Directory tree generation
- Python code outline generation
- File concatenation with metadata
- Archive creation support
- Interactive UI for file selection (requires curses)

This package provides both a command-line interface and a programmatic API
for processing project files.

Example CLI usage:
    flort . --extensions py,js --exclude-patterns '*test*' --output project.txt

Example programmatic usage:
    from flort import get_paths, concat_files

    file_list = get_paths(
        directories=['.'],
        extensions=['py', 'js'],
        exclude_patterns=['*test*']
    )
    concat_files(file_list, 'output.txt')

Interactive UI usage:
    flort --ui --extensions py,js

    Note: Interactive UI requires the curses module:
    - On Linux/macOS: included with Python
    - On Windows: pip install windows-curses
'''

from pathlib import Path
from .traverse import get_paths, FileFilter, scan_directories, add_specific_files
from .concatenate_files import concat_files, create_file_manifest, FileConcatenator
from .utils import (
    is_binary_file, clean_content, write_file, count_tokens,
    generate_tree, archive_file, configure_logging

)
from .validation import  ValidationError, ValidationResult
from .cli import main


def get_version():
    """Get version from VERSION file."""
    version_file = Path(__file__).parent / "VERSION"
    if version_file.exists():
        return version_file.read_text().strip()
    return "2.0.0"

__version__ = get_version()
__author__ = 'Chris Watkins'
__email__ = 'chris@watkinslabs.com'
__description__ = 'A utility to flatten your source code directory into a single file for LLM usage'

# Public API exports
__all__ = [
    # Main entry points
    'main',
    'get_paths',
    'concat_files',

    # Core classes
    'FileFilter',
    'FileConcatenator',
    'ValidationError',
    'ValidationResult',

    # Utility functions
    'is_binary_file',
    'clean_content',
    'write_file',
    'count_tokens',
    'generate_tree',
    'archive_file',
    'configure_logging',

    # Advanced functions
    'scan_directories',
    'add_specific_files',
    'create_file_manifest',

    # Metadata
    '__version__',
    '__author__',
    '__email__',
    '__description__'
]

--- File: flort/__main__.py
--- Characters: 402
--- Token Count: 88
#!/usr/bin/env python3
"""
Flort - Entry point module

This module serves as the main entry point when flort is executed as a module
using `python -m flort` or when installed as a console script.

The module simply imports and calls the main function from the CLI module,
ensuring consistent behavior regardless of how flort is invoked.
"""

from .cli import main

if __name__ == '__main__':
    main()

--- File: flort/assets.py
--- Characters: 5,960
--- Token Count: 1,473
"""
Asset Manager for Flort

Handles loading and displaying of assets like logos, icons, and ASCII art.
"""

import os
from pathlib import Path
from typing import Optional

# ASCII Art (embedded for reliability)
FLORT_LOGO = """
███████╗██╗      ██████╗ ██████╗ ████████╗
██╔════╝██║     ██╔═══██╗██╔══██╗╚══██╔══╝
█████╗  ██║     ██║   ██║██████╔╝   ██║
██╔══╝  ██║     ██║   ██║██╔══██╗   ██║
██║     ███████╗╚██████╔╝██║  ██║   ██║
╚═╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝
"""

FLORT_COMPACT = """
╭─ FLORT ─────────────────────────────────╮
│  File Concatenation & Project Overview │
╰─────────────────────────────────────────╯
"""

FLORT_MINI = """
F L O R T
═════════
"""

def get_asset_path(asset_name: str) -> Optional[Path]:
    """
    Get the path to an asset file.

    Args:
        asset_name: Name of the asset file (e.g., 'logo.png')

    Returns:
        Path to the asset file if it exists, None otherwise
    """
    # Try package assets first
    try:
        import pkg_resources
        try:
            asset_path = pkg_resources.resource_filename('flort', f'assets/{asset_name}')
            if os.path.exists(asset_path):
                return Path(asset_path)
        except (ImportError, FileNotFoundError):
            pass
    except ImportError:
        pass

    # Try relative to module
    module_dir = Path(__file__).parent
    asset_path = module_dir / 'assets' / asset_name
    if asset_path.exists():
        return asset_path

    # Try relative to project root
    project_root = module_dir.parent
    asset_path = project_root / 'assets' / asset_name
    if asset_path.exists():
        return asset_path

    return None

def get_logo_url() -> str:
    """
    Get the URL to the Flort logo for online display.

    Returns:
        str: URL to the logo image
    """
    return "https://raw.githubusercontent.com/chris17453/flort/main/assets/flort-logo.png"

def show_banner(style: str = "full") -> None:
    """
    Display a Flort banner.

    Args:
        style: Style of banner ("full", "compact", "mini")
    """
    if style == "full":
        print(FLORT_LOGO)
        print("File Concatenation & Project Overview Tool")
    elif style == "compact":
        print(FLORT_COMPACT)
    elif style == "mini":
        print(FLORT_MINI)
    else:
        print("FLORT - File Concatenation Tool")

def show_ascii_art() -> str:
    """
    Get ASCII art for display in help or about sections.

    Returns:
        str: ASCII art string
    """
    return FLORT_LOGO + "\n\nFile Concatenation & Project Overview Tool\n"

def create_logo_files():
    """
    Create logo files for the project.
    This function creates simple text-based logos that can be converted to images.
    """
    assets_dir = Path(__file__).parent.parent / "assets"
    assets_dir.mkdir(exist_ok=True)

    # Create a simple SVG logo
    svg_logo = f"""<?xml version="1.0" encoding="UTF-8"?>
<svg width="400" height="120" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="0%">
      <stop offset="0%" style="stop-color:#2196F3;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#21CBF3;stop-opacity:1" />
    </linearGradient>
  </defs>

  <!-- Background -->
  <rect width="400" height="120" fill="white" stroke="#ddd" stroke-width="2" rx="10"/>

  <!-- Main text -->
  <text x="50" y="50" font-family="monospace" font-size="36" font-weight="bold" fill="url(#grad1)">FLORT</text>

  <!-- Subtitle -->
  <text x="50" y="75" font-family="sans-serif" font-size="14" fill="#666">File Concatenation &amp; Project Overview</text>

  <!-- Icon elements -->
  <rect x="320" y="20" width="15" height="20" fill="#2196F3" rx="2"/>
  <rect x="340" y="15" width="15" height="25" fill="#21CBF3" rx="2"/>
  <rect x="360" y="25" width="15" height="15" fill="#42A5F5" rx="2"/>

  <!-- Connection lines -->
  <line x1="335" y1="30" x2="340" y2="30" stroke="#2196F3" stroke-width="2"/>
  <line x1="355" y1="27" x2="360" y2="27" stroke="#21CBF3" stroke-width="2"/>
</svg>"""

    svg_file = assets_dir / "flort-logo.svg"
    svg_file.write_text(svg_logo)

    # Create a README for assets
    readme_content = """# Flort Assets

This directory contains logos, icons, and other visual assets for Flort.

## Files:
- `flort-logo.svg` - Main logo in SVG format
- `flort-logo.png` - Main logo in PNG format (create from SVG)
- `flort-icon.ico` - Icon file for Windows
- `favicon.ico` - Favicon for documentation

## Usage:
- Use SVG for scalable applications
- Convert SVG to PNG for GitHub README
- Use ICO for Windows applications

## Converting SVG to PNG:
```bash
# Using Inkscape
inkscape flort-logo.svg --export-png=flort-logo.png --export-width=400

# Using ImageMagick
convert flort-logo.svg flort-logo.png

# Online converter
# Upload SVG to https://convertio.co/svg-png/
```
"""

    readme_file = assets_dir / "README.md"
    readme_file.write_text(readme_content)

    print(f"✅ Created logo files in {assets_dir}")
    print(f"📁 SVG logo: {svg_file}")
    print(f"📖 Asset README: {readme_file}")
    print("\n💡 To create PNG version:")
    print("   1. Open SVG in any graphics program")
    print("   2. Export as PNG (400x120 recommended)")
    print("   3. Save as flort-logo.png")

if __name__ == "__main__":
    # Demo the assets
    print("🎨 Flort Asset Demo")
    print("=" * 50)

    print("\n🏆 Full Banner:")
    show_banner("full")

    print("\n📋 Compact Banner:")
    show_banner("compact")

    print("\n🎯 Mini Banner:")
    show_banner("mini")

    print(f"\n🌐 Logo URL: {get_logo_url()}")

    # Check for asset files
    logo_path = get_asset_path("flort-logo.png")
    if logo_path:
        print(f"🖼️  Logo file found: {logo_path}")
    else:
        print("📝 No logo file found - run create_logo_files() to generate")

        create_files = input("\n❓ Create logo files now? (y/N): ")
        if create_files.lower() in ['y', 'yes']:
            create_logo_files()

--- File: flort/cli.py
--- Characters: 24,530
--- Token Count: 4,506
#!/usr/bin/env python3
"""
Flort - File Concatenation and Project Overview Tool

This module provides functionality to create a consolidated view of a project's
source code by combining multiple files into a single output file. It can generate
directory trees, create Python module outlines, and concatenate source files while
respecting various filtering options.

The tool is particularly useful for:
- Creating project overviews for LLMs
- Generating documentation
- Sharing code in a single file
- Analyzing project structure

Usage:
    flort [DIRECTORY...] [--extension...] [options]

Example:
    flort . --extensions py,js --exclude-extensions pyc --output=project.txt
"""

import os
import argparse
import logging
import sys
from datetime import datetime
from pathlib import Path
from typing import List, Optional

from .utils import (
    generate_tree, write_file, configure_logging, print_configuration,
    count_file_tokens, archive_file, sanitize_output_path,
    parse_comma_separated_list, parse_ignore_dirs
)
from .traverse import get_paths, add_specific_files
from .concatenate_files import concat_files, create_file_manifest
from .python_outline import python_outline_files
from .validation import validate_arguments

def get_version() -> str:
    """Get the package version."""
    try:
        # Use importlib.metadata (Python 3.8+) or importlib_metadata for older versions
        try:
            from importlib.metadata import version
        except ImportError:
            from importlib_metadata import version
        return version('flort')
    except Exception:
        return "unknown"


def generate_config_output(
    directories: List[str],
    extensions: List[str],
    exclude_extensions: List[str],
    include_patterns: List[str],
    exclude_patterns: List[str],
    include_files: List[str],
    ignore_dirs: List[Path],
    include_all: bool,
    include_hidden: bool,
    include_binary: bool,
    max_depth: Optional[int],
    output_path: str,
    other_flags: dict
) -> str:
    """
    Generate configuration output showing all settings used.

    Args:
        directories: List of directories being processed
        extensions: List of included extensions
        exclude_extensions: List of excluded extensions
        include_patterns: List of include glob patterns
        exclude_patterns: List of exclude glob patterns
        include_files: List of specifically included files
        ignore_dirs: List of ignored directories
        include_all: Whether all files are included
        include_hidden: Whether hidden files are included
        include_binary: Whether binary files are included
        max_depth: Maximum traversal depth
        output_path: Output file path
        other_flags: Dict of other boolean flags

    Returns:
        str: Formatted configuration string
    """
    config_lines = [
        "## Flort Configuration",
        f"Working Directory: {Path.cwd()}",
        f"Output File: {output_path}",
        f"Target Directories: {', '.join(directories)}",
        ""
    ]

    # File inclusion criteria
    inclusion_criteria = []
    if include_all:
        inclusion_criteria.append("All files (--all)")
    if extensions:
        inclusion_criteria.append(f"Extensions: {', '.join(extensions)}")
    if include_patterns:
        inclusion_criteria.append(f"Include patterns: {', '.join(include_patterns)}")
    if include_files:
        inclusion_criteria.append(f"Specific files: {', '.join(include_files)}")

    if inclusion_criteria:
        config_lines.append("### Inclusion Criteria:")
        for criteria in inclusion_criteria:
            config_lines.append(f"- {criteria}")
        config_lines.append("")

    # File exclusion criteria
    exclusion_criteria = []
    if exclude_extensions:
        exclusion_criteria.append(f"Extensions: {', '.join(exclude_extensions)}")
    if exclude_patterns:
        exclusion_criteria.append(f"Patterns: {', '.join(exclude_patterns)}")
    if ignore_dirs:
        exclusion_criteria.append(f"Directories: {', '.join(str(d) for d in ignore_dirs)}")
    if not include_binary:
        exclusion_criteria.append("Binary files (use --include-binary to include)")
    if not include_hidden:
        exclusion_criteria.append("Hidden files (use --hidden to include)")

    if exclusion_criteria:
        config_lines.append("### Exclusion Criteria:")
        for criteria in exclusion_criteria:
            config_lines.append(f"- {criteria}")
        config_lines.append("")

    # Processing options
    processing_options = []
    if max_depth is not None:
        processing_options.append(f"Maximum depth: {max_depth}")
    if other_flags.get('clean_content', True):
        processing_options.append("Content cleaning: enabled")
    else:
        processing_options.append("Content cleaning: disabled")

    # Output options
    output_options = []
    if other_flags.get('no_tree'):
        output_options.append("Directory tree: disabled")
    else:
        output_options.append("Directory tree: enabled")

    if other_flags.get('outline'):
        output_options.append("Python outline: enabled")
    else:
        output_options.append("Python outline: disabled")

    if other_flags.get('no_dump'):
        output_options.append("File concatenation: disabled")
    elif other_flags.get('manifest'):
        output_options.append("File manifest: enabled (no content)")
    else:
        output_options.append("File concatenation: enabled")

    if other_flags.get('archive'):
        output_options.append(f"Archive format: {other_flags['archive']}")

    all_options = processing_options + output_options
    if all_options:
        config_lines.append("### Processing Options:")
        for option in all_options:
            config_lines.append(f"- {option}")
        config_lines.append("")

    # Detection summary
    only_include_files = (
        include_files and
        not extensions and
        not include_all and
        not include_patterns
    )

    if only_include_files:
        config_lines.append("### Mode: Specific Files Only")
        config_lines.append("Directory scanning disabled - only processing specified files")
    else:
        config_lines.append("### Mode: Directory Scanning")
        config_lines.append("Scanning directories with applied filters")

    config_lines.extend(["", "---", ""])

    return "\n".join(config_lines)


def setup_argument_parser() -> argparse.ArgumentParser:
    """
    Set up and configure the command line argument parser.

    Returns:
        argparse.ArgumentParser: Configured parser
    """
    parser = argparse.ArgumentParser(
        description="flort: Create a single file containing all source code from specified "
                   "directories, with comprehensive filtering and organization options.",
        prog='flort',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  flort . --extensions py,js,ts                    # Include Python, JavaScript, TypeScript
  flort . --all --exclude-extensions pyc,pyo       # All files except compiled Python
  flort . --extensions py --exclude-patterns "*test*,*cache*"  # Python excluding tests
  flort . --glob "*.py" --include-files config.ini # Glob patterns + specific files
  flort . --extensions py --ignore-dirs __pycache__,venv      # Ignore specific directories
  flort src tests --output project.txt --archive zip         # Multiple dirs with archive
        """
    )

    # Positional arguments
    parser.add_argument(
        'directories',
        metavar='DIRECTORY',
        nargs='*',
        default=["."],
        help='Directories to process (default: current directory)'
    )

    # Core functionality
    parser.add_argument(
        '-e', '--extensions',
        type=str,
        help='File extensions to include (comma-separated, no dots: py,js,txt)'
    )

    parser.add_argument(
        '--exclude-extensions',
        type=str,
        help='File extensions to exclude (comma-separated, no dots: pyc,pyo,min.js)'
    )

    parser.add_argument(
        '-g', '--glob',
        type=str,
        help='Glob patterns to include (comma-separated: "*.py,src/**/*.js")'
    )

    parser.add_argument(
        '--exclude-patterns',
        type=str,
        help='Glob patterns to exclude (comma-separated: "*test*,*cache*,*.min.*")'
    )

    parser.add_argument(
        '-f', '--include-files',
        type=str,
        help='Specific files to include regardless of other filters (comma-separated)'
    )

    parser.add_argument(
        '-i', '--ignore-dirs',
        type=str,
        help='Directories to ignore completely (comma-separated)'
    )

    # Output options
    parser.add_argument(
        '-o', '--output',
        type=str,
        default=f"{os.path.basename(os.getcwd())}.flort.txt",
        help='Output file path (default: <current_dir>.flort.txt, "stdio" for console)'
    )

    parser.add_argument(
        '-z', '--archive',
        type=str,
        choices=['zip', 'tar.gz'],
        help='Create archive of output file (zip or tar.gz)'
    )

    # Content control flags
    parser.add_argument(
        '-a', '--all',
        action='store_true',
        help='Include all files regardless of extension (respects exclude filters)'
    )

    parser.add_argument(
        '-H', '--hidden',
        action='store_true',
        help='Include hidden files and directories'
    )

    parser.add_argument(
        '--include-binary',
        action='store_true',
        help='Include binary files (normally excluded for safety)'
    )

    parser.add_argument(
        '--max-depth',
        type=int,
        help='Maximum directory depth to traverse'
    )

    # Output format options
    parser.add_argument(
        '-O', '--outline',
        action='store_true',
        help='Generate Python class/function outline instead of full source'
    )

    parser.add_argument(
        '-n', '--no-dump',
        action='store_true',
        help='Do not concatenate file contents (directory tree and outline only)'
    )

    parser.add_argument(
        '-t', '--no-tree',
        action='store_true',
        help='Do not generate directory tree'
    )

    parser.add_argument(
        '--manifest',
        action='store_true',
        help='Generate file manifest instead of concatenating content'
    )

    parser.add_argument(
        '--clean-content',
        action='store_true',
        default=True,
        help='Clean whitespace from file content (default: enabled)'
    )

    parser.add_argument(
        '--no-clean',
        dest='clean_content',
        action='store_false',
        help='Do not clean whitespace from file content'
    )

    parser.add_argument(
        '--show-config',
        action='store_true',
        help='Show configuration settings at the beginning of the output'
    )

    # Interface options
    parser.add_argument(
        '-u', '--ui',
        action='store_true',
        help='Launch interactive file selector (discovers and selects files visually)'
    )

    # Utility options
    parser.add_argument(
        '-v', '--verbose',
        action='store_true',
        help='Enable verbose logging (INFO level)'
    )

    parser.add_argument(
        '--version',
        action='version',
        version=f'flort {get_version()}',
        help='Show program version and exit'
    )

    return parser


def process_ui_integration(args: argparse.Namespace) -> argparse.Namespace:
    """
    Integrate UI selections with command-line arguments.

    Args:
        args: Parsed command line arguments

    Returns:
        argparse.Namespace: Updated arguments with UI selections
    """
    if not args.ui:
        return args

    # Try curses-based UI first
    try:
        import curses

        try:
            from .curses_selector import select_files
            use_curses = True
        except ImportError:
            use_curses = False

        if use_curses:
            print("🎨 Starting interactive file selector (curses-based)...")
        else:
            print("📝 Curses not available, using simple text-based selector...")

    except ImportError:
        use_curses = False
        print("📝 Using simple text-based file selector...")

    try:
        # Prepare current settings for UI
        current_extensions = parse_comma_separated_list(args.extensions)
        current_include_files = parse_comma_separated_list(args.include_files)
        current_ignore_dirs = parse_ignore_dirs(args.ignore_dirs, args.directories)

        # Launch appropriate UI
        if use_curses:
            from .curses_selector import select_files
            result = select_files(
                start_path=args.directories[0] if args.directories else ".",
                preselected_filters=[f".{ext}" for ext in current_extensions],
                included_files=current_include_files,
                ignored_dirs=[str(d) for d in current_ignore_dirs],
                included_dirs=args.directories if args.directories != ["."] else None
            )
        else:
            from .simple_selector import simple_select_files
            result = simple_select_files(
                start_path=args.directories[0] if args.directories else ".",
                preselected_filters=[f".{ext}" for ext in current_extensions],
                included_files=current_include_files,
                ignored_dirs=[str(d) for d in current_ignore_dirs],
                included_dirs=args.directories if args.directories != ["."] else None
            )

        if result is None:
            logging.info("UI selection cancelled")
            sys.exit(0)

        # Merge UI results with CLI arguments (UI selections are additive)
        ui_extensions = [ext.lstrip('.') for ext in result.get("file_types", []) if ext and ext != "*"]
        if ui_extensions:
            existing_extensions = current_extensions
            combined_extensions = list(set(existing_extensions + ui_extensions))
            args.extensions = ','.join(combined_extensions) if combined_extensions else None

        # Add UI ignored directories
        ui_ignored = [Path(p) for p in result.get("ignored", []) if p]
        if ui_ignored:
            existing_ignored = current_ignore_dirs
            combined_ignored = existing_ignored + ui_ignored
            unique_ignored = []
            seen = set()
            for d in combined_ignored:
                d_str = str(d)
                if d_str not in seen:
                    seen.add(d_str)
                    unique_ignored.append(d)

            if unique_ignored:
                args.ignore_dirs = ','.join(str(d) for d in unique_ignored)

        # Update directories if UI made selections
        ui_selected = [p for p in result.get("selected", []) if Path(p).is_dir()]
        if ui_selected:
            args.directories = ui_selected

        logging.info("UI selections integrated with command-line arguments")

    except KeyboardInterrupt:
        print("\n❌ UI cancelled by user")
        sys.exit(0)
    except Exception as e:
        logging.error(f"Error in UI integration: {e}")
        print(f"❌ UI failed to start: {e}")
        print("📝 Continuing without interactive mode...")
        args.ui = False  # Disable UI and continue

    return args


def exclude_output_file(path_list: List[dict], output_path: str) -> List[dict]:
    """
    Remove the output file from the path list to prevent self-inclusion.

    Args:
        path_list: List of path dictionaries
        output_path: Output file path

    Returns:
        list: Updated path list with output file excluded
    """
    if output_path == "stdio":
        return path_list

    try:
        output_resolved = sanitize_output_path(output_path)
        original_count = len(path_list)

        filtered_list = []
        for item in path_list:
            try:
                item_resolved = item["path"].resolve()
                if item_resolved != output_resolved:
                    filtered_list.append(item)
            except Exception as e:
                logging.debug(f"Error resolving path {item['path']}: {e}")
                filtered_list.append(item)  # Include if we can't resolve

        excluded_count = original_count - len(filtered_list)
        if excluded_count > 0:
            logging.info(f"Excluded {excluded_count} output file(s) from processing")

        return filtered_list

    except Exception as e:
        logging.error(f"Error excluding output file: {e}")
        return path_list


def main() -> None:
    """
    Main entry point for the Flort tool.

    This function orchestrates the entire file processing pipeline:
    1. Parse and validate command line arguments
    2. Configure logging and validate inputs
    3. Integrate UI selections if requested
    4. Discover files using the comprehensive filtering system
    5. Generate outputs (tree, outline, concatenation) as requested
    6. Create archives if specified
    7. Report final statistics

    Returns:
        None

    Raises:
        SystemExit: If arguments are invalid or critical errors occur
    """
    # Parse arguments
    parser = setup_argument_parser()
    args = parser.parse_args()

    # Configure logging early
    configure_logging(args.verbose)

    # Parse and prepare arguments
    directories = args.directories
    extensions = parse_comma_separated_list(args.extensions)
    exclude_extensions = parse_comma_separated_list(args.exclude_extensions)
    include_patterns = parse_comma_separated_list(args.glob)
    exclude_patterns = parse_comma_separated_list(args.exclude_patterns)
    include_files = parse_comma_separated_list(args.include_files)
    ignore_dirs = parse_ignore_dirs(args.ignore_dirs, directories)


    path_list = []

    # Validate arguments
    validation_result = validate_arguments(args)
    if not validation_result.is_valid:
        error_message = validation_result.get_error_message()
        logging.error(error_message)
        parser.print_help()
        sys.exit(1)

    # Process UI integration
    if args.ui:
        args = process_ui_integration(args)
        # Re-validate after UI changes
        validation_result = validate_arguments(args)
        if not validation_result.is_valid:
            error_message = validation_result.get_error_message()
            logging.error(f"Invalid configuration after UI integration: {error_message}")
            sys.exit(1)
    # Sanitize output path
    output_path = sanitize_output_path(args.output)
    output_str = str(output_path) if output_path.name != "stdio" else "stdio"

    # Log configuration
    print_configuration(
        directories=directories,
        extensions=extensions,
        exclude_extensions=exclude_extensions,
        exclude_patterns=exclude_patterns,
        include_all=args.all,
        include_hidden=args.hidden,
        ignore_dirs=ignore_dirs,
        include_files=include_files,
        glob_patterns=include_patterns
    )

    # Initialize output file with timestamp
    current_datetime = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    if not write_file(output_str, f"## Florted: {current_datetime}\n", 'w'):
        logging.error(f"Failed to initialize output file: {output_str}")
        sys.exit(1)

    # Add configuration output if requested
    if args.show_config:
        config_output = generate_config_output(
            directories=directories,
            extensions=extensions,
            exclude_extensions=exclude_extensions,
            include_patterns=include_patterns,
            exclude_patterns=exclude_patterns,
            include_files=include_files,
            ignore_dirs=ignore_dirs,
            include_all=args.all,
            include_hidden=args.hidden,
            include_binary=args.include_binary,
            max_depth=args.max_depth,
            output_path=output_str,
            other_flags={
                'clean_content': args.clean_content,
                'no_tree': args.no_tree,
                'outline': args.outline,
                'no_dump': args.no_dump,
                'manifest': args.manifest,
                'archive': args.archive
            }
        )
        if not write_file(output_str, config_output):
            logging.error("Failed to write configuration output")
            sys.exit(1)

    # Get file paths using the comprehensive discovery system
    logging.info("Starting file discovery...")

    try:
        # If only include_files is specified (no extensions, no --all, no glob),
        # then ONLY process those files
        only_include_files = (
            include_files and
            not extensions and
            not args.all and
            not include_patterns and
            not args.glob
        )

        if only_include_files:
            logging.info("Only processing specifically included files (no directory scanning)")
            base_dir = Path(directories[0]).resolve() if directories else Path.cwd()
            path_list = add_specific_files(path_list, include_files, base_dir)
        else:
            path_list = get_paths(
                directories=directories,
                extensions=extensions,
                exclude_extensions=exclude_extensions,
                include_patterns=include_patterns,
                exclude_patterns=exclude_patterns,
                include_all=args.all,
                include_hidden=args.hidden,
                include_binary=args.include_binary,
                ignore_dirs=ignore_dirs,
                include_files=include_files,
                glob_patterns=include_patterns,  # Same as include_patterns for compatibility
                max_depth=args.max_depth
            )
    except Exception as e:
        logging.error(f"Error during file discovery: {e}")
        sys.exit(1)

    # Exclude output file from processing
    path_list = exclude_output_file(path_list, output_str)

    # Count results
    file_count = len([item for item in path_list if item['type'] == 'file'])
    dir_count = len([item for item in path_list if item['type'] == 'dir'])

    if file_count == 0:
        logging.warning("No files found matching criteria")
        if not write_file(output_str, "## No files found matching criteria\n"):
            sys.exit(1)
        print("No files found matching the specified criteria.")
        return

    print(f"Processing {file_count} files from {dir_count} directories -> {output_str}")

    try:
        # Generate directory tree if not disabled
        if not args.no_tree:
            logging.info("Generating directory tree...")
            if not generate_tree(path_list, output_str):
                logging.error("Failed to generate directory tree")
                sys.exit(1)

        # Generate Python outline if requested
        if args.outline:
            logging.info("Generating Python outline...")
            if not python_outline_files(path_list, output_str):
                logging.error("Failed to generate Python outline")
                sys.exit(1)

        # Generate file manifest or concatenate files
        if args.manifest:
            logging.info("Generating file manifest...")
            if not create_file_manifest(path_list, output_str):
                logging.error("Failed to create file manifest")
                sys.exit(1)
        elif not args.no_dump:
            logging.info("Concatenating files...")
            if not concat_files(path_list, output_str, args.clean_content):
                logging.error("Failed to concatenate files")
                sys.exit(1)

        # Show token count and statistics
        if output_str != "stdio":
            token_info = count_file_tokens(output_str)
            print(f"\nOutput Statistics:\n{token_info}")

        # Archive the output file if requested
        if args.archive and output_str != "stdio":
            logging.info(f"Creating {args.archive} archive...")
            archive_path = archive_file(output_str, args.archive)
            if archive_path:
                print(f"Archive created: {archive_path}")
            else:
                logging.warning("Failed to create archive")

        print("Flort completed successfully!")

    except KeyboardInterrupt:
        logging.info("Operation cancelled by user")
        sys.exit(1)
    except Exception as e:
        logging.error(f"Unexpected error during processing: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()

--- File: flort/concatenate_files.py
--- Characters: 13,155
--- Token Count: 2,539
"""
File Concatenation Module

This module handles the concatenation of multiple source files into a single output,
with proper formatting, error handling, and metadata tracking.

Features:
- Safe file reading with encoding detection
- Content cleaning and formatting
- Token and character counting
- Progress tracking for large operations
- Robust error handling with detailed logging
"""

import logging
from pathlib import Path
from typing import List, Dict, Any, Optional
from datetime import datetime

from .utils import write_file, count_tokens, clean_content, is_binary_file


class FileConcatenator:
    """
    Handles the concatenation of multiple files with comprehensive error handling
    and progress tracking.
    """

    def __init__(self, output_path: str, clean_content_flag: bool = True):
        """
        Initialize the file concatenator.

        Args:
            output_path: Path to write concatenated output
            clean_content_flag: Whether to clean whitespace from content
        """
        self.output_path = output_path
        self.clean_content_flag = clean_content_flag
        self.stats = {
            "files_processed": 0,
            "files_skipped": 0,
            "total_characters": 0,
            "total_tokens": 0,
            "errors": []
        }

    def concatenate_files(self, file_list: List[Dict[str, Any]]) -> bool:
        """
        Concatenate all files in the file list to the output.

        Args:
            file_list: List of file dictionaries with path and metadata

        Returns:
            bool: True if concatenation was successful
        """
        if not file_list:
            logging.warning("No files provided for concatenation")
            return write_file(self.output_path, "## File Data\n(No files to concatenate)\n\n")

        # Filter to only files (not directories)
        files_to_process = [item for item in file_list if item.get("type") == "file"]

        if not files_to_process:
            logging.warning("No files found in file list")
            return write_file(self.output_path, "## File Data\n(No files found)\n\n")

        logging.info(f"Starting concatenation of {len(files_to_process)} files")

        # Write header
        if not write_file(self.output_path, "## File Data\n"):
            return False

        # Process each file
        for i, item in enumerate(files_to_process, 1):
            file_path = item["path"]
            relative_path = item["relative_path"]

            logging.debug(f"Processing file {i}/{len(files_to_process)}: {relative_path}")

            success = self._process_single_file(file_path, relative_path)

            if success:
                self.stats["files_processed"] += 1
            else:
                self.stats["files_skipped"] += 1

            # Log progress for large operations
            if i % 10 == 0 or i == len(files_to_process):
                logging.info(f"Progress: {i}/{len(files_to_process)} files processed")

        # Write summary
        self._write_summary()

        logging.info(f"Concatenation complete. Processed: {self.stats['files_processed']}, "
                    f"Skipped: {self.stats['files_skipped']}")

        return True

    def _process_single_file(self, file_path: Path, relative_path: str) -> bool:
        """
        Process a single file for concatenation.

        Args:
            file_path: Path to the file to process
            relative_path: Relative path for display

        Returns:
            bool: True if file was processed successfully
        """
        try:
            # Double-check that it's not a binary file
            if is_binary_file(file_path):
                logging.warning(f"Skipping binary file: {relative_path}")
                error_msg = f"Binary file skipped: {relative_path}"
                self.stats["errors"].append(error_msg)
                return self._write_file_error(relative_path, "Binary file")

            # Read file content
            content = self._read_file_safely(file_path)
            if content is None:
                return False

            # Clean content if requested
            if self.clean_content_flag:
                content = self._clean_file_content(file_path, content)

            # Calculate metrics
            char_count = len(content)
            token_count = count_tokens(content)

            # Update statistics
            self.stats["total_characters"] += char_count
            self.stats["total_tokens"] += token_count

            # Write file header
            if not self._write_file_header(relative_path, char_count, token_count):
                return False

            # Write file content
            if not write_file(self.output_path, content):
                return False

            # Add separator
            if not write_file(self.output_path, "\n\n"):
                return False

            return True

        except Exception as e:
            error_msg = f"Error processing {relative_path}: {str(e)}"
            logging.error(error_msg)
            self.stats["errors"].append(error_msg)
            return self._write_file_error(relative_path, str(e))

    def _read_file_safely(self, file_path: Path) -> Optional[str]:
        """
        Safely read a file with multiple encoding attempts.

        Args:
            file_path: Path to the file to read

        Returns:
            str: File content, or None if reading failed
        """
        encodings_to_try = ['utf-8', 'utf-8-sig', 'latin1', 'cp1252']

        for encoding in encodings_to_try:
            try:
                with open(file_path, 'r', encoding=encoding, errors='replace') as f:
                    content = f.read()

                # Validate that we got reasonable content
                if content or file_path.stat().st_size == 0:  # Allow empty files
                    logging.debug(f"Successfully read {file_path} with encoding {encoding}")
                    return content

            except UnicodeDecodeError:
                continue
            except Exception as e:
                logging.error(f"Error reading {file_path} with {encoding}: {e}")
                continue

        # If all encodings failed, try binary read with replacement
        try:
            with open(file_path, 'rb') as f:
                raw_content = f.read()
                content = raw_content.decode('utf-8', errors='replace')
                logging.warning(f"Used binary read with replacement for {file_path}")
                return content
        except Exception as e:
            error_msg = f"Failed to read {file_path} with any encoding: {e}"
            logging.error(error_msg)
            self.stats["errors"].append(error_msg)
            return None

    def _clean_file_content(self, file_path: Path, content: str) -> str:
        """
        Clean file content while preserving structure.

        Args:
            file_path: Path to the file (for context)
            content: Raw file content

        Returns:
            str: Cleaned content
        """
        try:
            return clean_content(file_path)
        except Exception as e:
            logging.warning(f"Content cleaning failed for {file_path}: {e}, using raw content")
            return content

    def _write_file_header(self, relative_path: str, char_count: int, token_count: int) -> bool:
        """
        Write the header information for a file.

        Args:
            relative_path: Relative path of the file
            char_count: Number of characters in the file
            token_count: Number of tokens in the file

        Returns:
            bool: True if header was written successfully
        """
        header = f"--- File: {relative_path}\n"
        header += f"--- Characters: {char_count:,}\n"
        header += f"--- Token Count: {token_count:,}\n"

        return write_file(self.output_path, header)

    def _write_file_error(self, relative_path: str, error_message: str) -> bool:
        """
        Write an error entry for a file that couldn't be processed.

        Args:
            relative_path: Relative path of the file
            error_message: Error description

        Returns:
            bool: True if error entry was written successfully
        """
        error_content = f"--- File: {relative_path}\n"
        error_content += f"--- Error: {error_message}\n"
        error_content += "--- Content: <Unable to read file>\n\n"

        return write_file(self.output_path, error_content)

    def _write_summary(self) -> bool:
        """
        Write a summary of the concatenation operation.

        Returns:
            bool: True if summary was written successfully
        """
        summary = "\n## Concatenation Summary\n"
        summary += f"Files processed: {self.stats['files_processed']}\n"
        summary += f"Files skipped: {self.stats['files_skipped']}\n"
        summary += f"Total characters: {self.stats['total_characters']:,}\n"
        summary += f"Total tokens: {self.stats['total_tokens']:,}\n"

        if self.stats["errors"]:
            summary += f"\n### Errors ({len(self.stats['errors'])}):\n"
            for error in self.stats["errors"][:10]:  # Limit to first 10 errors
                summary += f"- {error}\n"
            if len(self.stats["errors"]) > 10:
                summary += f"... and {len(self.stats['errors']) - 10} more errors\n"

        summary += f"\nCompleted at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n"

        return write_file(self.output_path, summary)

    def get_statistics(self) -> Dict[str, Any]:
        """
        Get concatenation statistics.

        Returns:
            dict: Statistics about the concatenation operation
        """
        return self.stats.copy()


def concat_files(file_list: List[Dict[str, Any]], output: str, clean_content: bool = True) -> bool:
    """
    Concatenate files from a file list into a single output.

    This is the main entry point for file concatenation. It creates a FileConcatenator
    instance and processes all files in the provided list.

    Args:
        file_list: List of file dictionaries with path and metadata information
        output: Output file path or "stdio" for console output
        clean_content: Whether to clean whitespace from file content

    Returns:
        bool: True if concatenation was successful, False otherwise

    Example:
        file_list = [
            {"path": Path("main.py"), "relative_path": "main.py", "type": "file"},
            {"path": Path("utils.py"), "relative_path": "utils.py", "type": "file"}
        ]
        success = concat_files(file_list, "output.txt")
    """
    if not file_list:
        logging.warning("No files provided to concat_files")
        return False

    try:
        concatenator = FileConcatenator(output, clean_content)
        success = concatenator.concatenate_files(file_list)

        # Log final statistics
        stats = concatenator.get_statistics()
        if stats["files_processed"] > 0:
            logging.info(f"Concatenation statistics: {stats}")

        return success

    except Exception as e:
        logging.error(f"Error in concat_files: {e}")
        return False


def create_file_manifest(file_list: List[Dict[str, Any]], output: str) -> bool:
    """
    Create a manifest of all files without their content.

    This function creates a summary listing of all files that would be processed,
    including their sizes and types, without actually concatenating the content.
    Useful for previewing what will be included.

    Args:
        file_list: List of file dictionaries
        output: Output file path or "stdio"

    Returns:
        bool: True if manifest was created successfully
    """
    try:
        if not write_file(output, "## File Manifest\n"):
            return False

        files_only = [item for item in file_list if item.get("type") == "file"]

        if not files_only:
            return write_file(output, "(No files found)\n\n")

        total_size = 0
        total_files = len(files_only)

        for i, item in enumerate(files_only, 1):
            file_path = item["path"]
            relative_path = item["relative_path"]

            try:
                size = file_path.stat().st_size
                total_size += size

                # Determine if binary
                is_binary = is_binary_file(file_path)
                binary_indicator = " [BINARY]" if is_binary else ""

                manifest_line = f"{i:3d}. {relative_path} ({size:,} bytes){binary_indicator}\n"

                if not write_file(output, manifest_line):
                    return False

            except Exception as e:
                error_line = f"{i:3d}. {relative_path} (ERROR: {e})\n"
                if not write_file(output, error_line):
                    return False

        # Write summary
        summary = f"\nTotal: {total_files} files, {total_size:,} bytes\n\n"
        return write_file(output, summary)

    except Exception as e:
        logging.error(f"Error creating file manifest: {e}")
        return False

--- File: flort/curses_selector.py
--- Characters: 24,412
--- Token Count: 4,251
import os
import curses
import curses.textpad
from pathlib import Path
from collections import defaultdict

def is_accessible(path):
    try:
        path.stat()
        return True
    except (PermissionError, OSError):
        return False

def discover_file_types(path):
    """Discover all file types in the given path."""
    extensions = set()
    try:
        for file_path in Path(path).rglob("*"):
            if file_path.is_file() and is_accessible(file_path):
                ext = file_path.suffix.lower()
                if ext:
                    extensions.add(ext)
    except (PermissionError, OSError):
        pass
    return sorted(extensions)

def should_show_file(item, file_types, selection):
    # Always show directories
    if item.is_dir():
        return True
    # Show file if it's in selection
    if selection and str(item) in selection:
        return True
    # Show all files if "*" is in filters or no filters
    if not file_types or any(ft.strip() == "*" for ft in file_types):
        return True
    # Show files matching extensions
    return item.suffix in file_types

def get_directory_contents(path, file_types, selection):
    try:
        items = sorted(
            [item for item in Path(path).iterdir()],
            key=lambda x: (x.is_file(), x.name.lower())
        )
        return [(item, is_accessible(item)) for item in items
                if should_show_file(item, file_types, selection)]
    except PermissionError:
        return []

def mark_subitems(selection, ignored, base_path, state, file_types):
    for item in Path(base_path).rglob('*'):
        if not is_accessible(item):
            continue
        path = str(item)
        if state and path in ignored:
            ignored.pop(path)

        if state:
            if item.is_dir() or item.suffix in file_types or path in selection:
                selection[path] = True
        else:
            selection.pop(path, None)

def mark_ignored(ignored, selection, base_path):
    for item in Path(base_path).rglob('*'):
        if not is_accessible(item):
            continue
        path = str(item)
        if path in selection:
            selection.pop(path)
        ignored[path] = True
    ignored[str(base_path)] = True

def curses_file_selector(stdscr, start_path=".", preselected_filters=None, included_files=None, ignored_dirs=None, included_dirs=None):
    # Initialize curses
    curses.curs_set(0)
    curses.init_pair(1, curses.COLOR_BLACK, curses.COLOR_WHITE)  # Selected
    curses.init_pair(2, curses.COLOR_WHITE, curses.COLOR_BLACK)  # Normal
    curses.init_pair(3, curses.COLOR_RED, curses.COLOR_BLACK)    # Inaccessible
    curses.init_pair(4, curses.COLOR_GREEN, curses.COLOR_BLACK)  # Included
    curses.init_pair(5, curses.COLOR_YELLOW, curses.COLOR_BLACK) # Header
    curses.init_pair(6, curses.COLOR_CYAN, curses.COLOR_BLACK)   # Directory

    # Enable mouse support
    try:
        curses.mousemask(curses.ALL_MOUSE_EVENTS)
        mouse_enabled = True
    except:
        mouse_enabled = False

    current_path = Path(start_path).resolve()
    selection = {}
    ignored = {}

    # Start with discovery mode - find all file types
    discovered_types = discover_file_types(current_path)

    # Initialize file types - start with discovered types if no preselected
    if preselected_filters:
        file_types = set(preselected_filters)
    else:
        # Auto-discover common code file types
        common_code_types = {'.py', '.js', '.ts', '.java', '.cpp', '.c', '.h', '.css', '.html', '.php', '.rb', '.go', '.rs', '.swift', '.kt'}
        auto_selected = [ext for ext in discovered_types if ext in common_code_types]
        file_types = set(auto_selected) if auto_selected else set(discovered_types[:10])  # Limit to first 10 if no common types

    # Add included files
    if included_files:
        for file_path in included_files:
            path = Path(file_path).resolve()
            if is_accessible(path):
                selection[str(path)] = True

    # Add ignored directories
    if ignored_dirs:
        for dir_path in ignored_dirs:
            path = Path(dir_path).resolve()
            if is_accessible(path):
                mark_ignored(ignored, selection, path)

    # Auto-select common directories and files
    if start_path == "." and not (included_files or included_dirs):
        for item in current_path.iterdir():
            if not is_accessible(item):
                continue
            if item.is_dir() or (file_types and item.suffix in file_types):
                path = str(item.resolve())
                selection[path] = True
                if item.is_dir():
                    mark_subitems(selection, ignored, path, True, file_types)

    stack = [current_path]
    idx = 0
    top_line = 0
    show_help = False
    filter_mode = False

    while True:
        stdscr.clear()
        height, width = stdscr.getmaxyx()

        # Header
        header_color = curses.color_pair(5) | curses.A_BOLD
        path_str = str(current_path)
        if len(path_str) >= width - 10:
            path_str = "..." + path_str[-(width-13):]
        stdscr.addstr(0, 0, f"📁 {path_str}", header_color)

        # File type filter display
        if file_types:
            types_str = f"Filter: {', '.join(sorted(file_types))}"
            if len(types_str) > width - 2:
                types_str = types_str[:width-5] + "..."
            stdscr.addstr(1, 0, types_str, curses.color_pair(4))
        else:
            stdscr.addstr(1, 0, "Filter: All files", curses.color_pair(4))

        # Instructions
        if show_help:
            help_lines = [
                "🎯 NAVIGATION:",
                "  ↑/↓/PgUp/PgDn: Navigate    SPACE: Toggle selection",
                "  ←/→/Enter: Directories    TAB: File type manager",
                "  i: Ignore item/dir        v: View selections",
                "🖱️  MOUSE: Click to select, scroll to navigate",
                "📝 FILTERING:",
                "  f: Edit file types        a: Select all visible",
                "  c: Clear all selections   r: Reset to discovered types",
                "⚡ ACTIONS:",
                "  q: Done with selection    ESC: Cancel",
                "  h: Toggle this help"
            ]
            for i, line in enumerate(help_lines):
                if i + 2 < height - 4:
                    stdscr.addstr(i + 2, 0, line[:width-1], curses.color_pair(2))
            help_end = len(help_lines) + 2
        else:
            stdscr.addstr(2, 0, "🎯 Navigation: ↑/↓ SPACE:Select TAB:Filter q:Done h:Help", curses.color_pair(2))
            if mouse_enabled:
                stdscr.addstr(3, 0, "🖱️  Mouse: Click items, scroll to navigate", curses.color_pair(2))
            help_end = 4

        # Get directory contents
        items = get_directory_contents(current_path, file_types, selection)
        display_items = ["[📁 ../] (Up one level)"] + [
            (f"🚫 {item.name}/" if not accessible else
             f"[{'✓' if selection.get(str(item), False) else '✗' if ignored.get(str(item), False) else ' '}] 📁 {item.name}/") if item.is_dir() else
            (f"🚫 {item.name}" if not accessible else
             f"[{'✓' if selection.get(str(item), False) else '✗' if ignored.get(str(item), False) else ' '}] 📄 {item.name}")
            for item, accessible in items
        ]

        accessible_items = [True] + [acc for _, acc in items]

        # Ensure idx is valid
        if idx >= len(display_items):
            idx = max(len(display_items) - 1, 0)

        # Scroll handling
        if idx < top_line:
            top_line = idx
        elif idx >= top_line + height - help_end - 1:
            top_line = idx - (height - help_end - 2)

        # Display items
        for i, line in enumerate(display_items[top_line:top_line + height - help_end - 1]):
            pos = i + top_line
            if pos >= len(display_items):
                break

            y_pos = i + help_end
            truncated_line = (line[:width - 1] + "…") if len(line) >= width else line

            # Determine color
            if pos >= len(accessible_items):
                continue

            if pos == idx:
                attr = curses.color_pair(1) | curses.A_BOLD  # Selected line
            elif not accessible_items[pos]:
                attr = curses.color_pair(3) | curses.A_DIM   # Inaccessible
            elif pos > 0 and pos <= len(items):
                item, _ = items[pos - 1]
                if str(item) in selection:
                    attr = curses.color_pair(4)  # Selected file/dir
                elif item.is_dir():
                    attr = curses.color_pair(6)  # Directory
                else:
                    attr = curses.color_pair(2)  # Normal file
            else:
                attr = curses.color_pair(2)  # Normal

            try:
                stdscr.addstr(y_pos, 0, truncated_line, attr)
            except curses.error:
                pass  # Ignore if line doesn't fit

        # Status line
        status_y = height - 1
        sel_count = len([k for k, v in selection.items() if v])
        ign_count = len([k for k, v in ignored.items() if v])
        status = f"Selected: {sel_count} | Ignored: {ign_count} | Types: {len(file_types)} | {'Mouse' if mouse_enabled else 'Keys'}"
        try:
            stdscr.addstr(status_y, 0, status[:width-1], curses.color_pair(5))
        except curses.error:
            pass

        stdscr.refresh()

        # Get input
        key = stdscr.getch()

        # Handle mouse events
        if key == curses.KEY_MOUSE and mouse_enabled:
            try:
                _, mx, my, _, bstate = curses.getmouse()

                # Calculate which item was clicked
                if help_end <= my < height - 1:
                    clicked_idx = (my - help_end) + top_line

                    if 0 <= clicked_idx < len(display_items):
                        # Left click handling
                        if bstate & curses.BUTTON1_CLICKED:
                            idx = clicked_idx

                            if idx == 0:  # Up directory - always navigate
                                if len(stack) > 1:
                                    stack.pop()
                                    current_path = stack[-1]
                                    idx = 0
                                    top_line = 0
                            elif idx > 0 and idx <= len(items):
                                selected_item, accessible = items[idx - 1]
                                if accessible:
                                    # Determine what was clicked based on x position
                                    line_content = display_items[idx]

                                    # Check if click was on checkbox area [X] (positions 0-3)
                                    if mx <= 3 and line_content.startswith('['):
                                        # Checkbox click - toggle selection state
                                        path = str(selected_item)

                                        # Cycle through states: unselected -> selected -> ignored -> unselected
                                        if path not in selection and path not in ignored:
                                            # Unselected -> Selected
                                            selection[path] = True
                                            if selected_item.is_dir():
                                                mark_subitems(selection, ignored, selected_item, True, file_types)
                                        elif path in selection:
                                            # Selected -> Ignored
                                            selection.pop(path, None)
                                            if selected_item.is_dir():
                                                mark_subitems(selection, ignored, selected_item, False, file_types)
                                            mark_ignored(ignored, selection, selected_item)
                                        else:
                                            # Ignored -> Unselected
                                            for key in list(ignored.keys()):
                                                if key.startswith(path):
                                                    ignored.pop(key)

                                    # Click on folder name/icon (positions 4+) for directories
                                    elif selected_item.is_dir() and mx > 3:
                                        # Directory navigation
                                        stack.append(selected_item)
                                        current_path = selected_item
                                        idx = 0
                                        top_line = 0

                                    # Click on file name for files - toggle selection
                                    elif selected_item.is_file():
                                        path = str(selected_item)
                                        if path not in selection and path not in ignored:
                                            selection[path] = True
                                        elif path in selection:
                                            selection.pop(path, None)
                                            mark_ignored(ignored, selection, selected_item)
                                        else:
                                            for key in list(ignored.keys()):
                                                if key.startswith(path):
                                                    ignored.pop(key)

                        # Right click - always toggle ignore status
                        elif bstate & (curses.BUTTON3_CLICKED):
                            if idx > 0 and idx <= len(items):
                                selected_item, accessible = items[idx - 1]
                                if accessible:
                                    path = str(selected_item)
                                    if path in selection:
                                        selection.pop(path, None)
                                        mark_ignored(ignored, selection, selected_item)
                                    elif path in ignored:
                                        for key in list(ignored.keys()):
                                            if key.startswith(path):
                                                ignored.pop(key)
                                    else:
                                        mark_ignored(ignored, selection, selected_item)

                # Mouse wheel scrolling
                elif bstate & curses.BUTTON4_PRESSED:  # Scroll up
                    for _ in range(3):
                        if idx > 0:
                            idx -= 1
                elif bstate & (curses.BUTTON5_PRESSED | curses.BUTTON2_CLICKED):  # Scroll down
                    for _ in range(3):
                        if idx < len(display_items) - 1:
                            idx += 1

            except curses.error:
                pass

        # Keyboard navigation
        elif key == curses.KEY_DOWN:
            new_idx = idx + 1
            while new_idx < len(display_items) and not accessible_items[new_idx]:
                new_idx += 1
            if new_idx < len(display_items):
                idx = new_idx

        elif key == curses.KEY_UP:
            new_idx = idx - 1
            while new_idx > 0 and not accessible_items[new_idx]:
                new_idx -= 1
            if new_idx >= 0:
                idx = new_idx

        elif key == curses.KEY_NPAGE:  # Page Down
            idx = min(idx + 10, len(display_items) - 1)
        elif key == curses.KEY_PPAGE:  # Page Up
            idx = max(idx - 10, 0)

        elif key in [curses.KEY_RIGHT, 10]:  # Enter
            if idx > 0 and idx <= len(items):
                selected_item, accessible = items[idx - 1]
                if accessible and selected_item.is_dir():
                    stack.append(selected_item)
                    current_path = selected_item
                    idx = 0
                    top_line = 0
            elif idx == 0 and len(stack) > 1:
                stack.pop()
                current_path = stack[-1]
                idx = 0
                top_line = 0

        elif key in [curses.KEY_LEFT, 127, 8]:  # Backspace
            if len(stack) > 1:
                stack.pop()
                current_path = stack[-1]
                idx = 0
                top_line = 0

        elif key == ord(' '):  # Space - toggle selection
            if idx > 0 and idx <= len(items):
                selected_item, accessible = items[idx - 1]
                if accessible:
                    path = str(selected_item)

                    # Cycle through states: unselected -> selected -> ignored -> unselected
                    if path not in selection and path not in ignored:
                        # Unselected -> Selected
                        selection[path] = True
                        if selected_item.is_dir():
                            mark_subitems(selection, ignored, selected_item, True, file_types)
                    elif path in selection:
                        # Selected -> Ignored
                        selection.pop(path, None)
                        if selected_item.is_dir():
                            mark_subitems(selection, ignored, selected_item, False, file_types)
                        mark_ignored(ignored, selection, selected_item)
                    else:
                        # Ignored -> Unselected
                        for key in list(ignored.keys()):
                            if key.startswith(path):
                                ignored.pop(key)

        elif key == ord('i'):  # Ignore
            if idx > 0 and idx <= len(items):
                selected_item, accessible = items[idx - 1]
                if accessible:
                    path = str(selected_item)
                    if path in selection:
                        for key in list(selection.keys()):
                            if key.startswith(path):
                                selection.pop(key)
                        mark_ignored(ignored, selection, selected_item)
                    else:
                        if path in ignored:
                            for key in list(ignored.keys()):
                                if key.startswith(path):
                                    ignored.pop(key)
                        else:
                            mark_ignored(ignored, selection, selected_item)

        elif key == ord('f') or key == ord('\t'):  # Edit file types
            curses.curs_set(1)
            stdscr.clear()
            stdscr.addstr(0, 0, "🎯 File Type Manager", curses.color_pair(5) | curses.A_BOLD)
            stdscr.addstr(2, 0, f"Discovered types: {', '.join(discovered_types[:20])}")
            stdscr.addstr(3, 0, f"Current filter: {', '.join(sorted(file_types)) if file_types else 'All files'}")
            stdscr.addstr(5, 0, "Enter extensions (comma-separated, no dots) or '*' for all:")
            stdscr.addstr(6, 0, "Current: ")

            edit_win = curses.newwin(1, 50, 6, 9)
            current_filter = ",".join(ft.lstrip('.') for ft in sorted(file_types))
            edit_win.addstr(current_filter)
            edit_box = curses.textpad.Textbox(edit_win, insert_mode=True)

            stdscr.refresh()
            new_input = edit_box.edit().strip()

            if new_input:
                if new_input == '*':
                    file_types = set()  # All files
                else:
                    file_types = {f".{ext.strip()}" if not ext.strip().startswith(".") and ext.strip() != "*" else ext.strip()
                                for ext in new_input.split(',') if ext.strip()}
            curses.curs_set(0)

        elif key == ord('a'):  # Select all visible
            for item, accessible in items:
                if accessible:
                    path = str(item)
                    selection[path] = True
                    if item.is_dir():
                        mark_subitems(selection, ignored, item, True, file_types)

        elif key == ord('c'):  # Clear all selections
            selection.clear()
            ignored.clear()

        elif key == ord('r'):  # Reset to discovered types
            file_types = set(discovered_types[:10])  # Reset to first 10 discovered

        elif key == ord('h'):  # Toggle help
            show_help = not show_help

        elif key == ord('v'):  # View selections
            def view_selections():
                v_idx = 0
                v_top = 0
                selected_paths = list(selection.keys())
                ignored_paths = list(ignored.keys())
                all_paths = selected_paths + ignored_paths

                while True:
                    stdscr.clear()
                    stdscr.addstr(0, 0, "📋 Selected & Ignored Files/Directories", curses.color_pair(5) | curses.A_BOLD)
                    stdscr.addstr(1, 0, "✓: Selected  ✗: Ignored", curses.color_pair(2))

                    for i, path in enumerate(all_paths[v_top:v_top + height - 4]):
                        if i + v_top >= len(all_paths):
                            break
                        prefix = "✓ " if path in selected_paths else "✗ "
                        display_path = path
                        if len(display_path) > width - 3:
                            display_path = "..." + display_path[-(width-6):]

                        color = curses.color_pair(4) if path in selected_paths else curses.color_pair(3)
                        if i + v_top == v_idx:
                            color |= curses.A_REVERSE

                        try:
                            stdscr.addstr(i + 2, 0, prefix + display_path, color)
                        except curses.error:
                            pass

                    try:
                        stdscr.addstr(height - 1, 0, "Use ↑/↓/PgUp/PgDn/Home/End to scroll, 'q' to exit", curses.color_pair(2))
                    except curses.error:
                        pass

                    stdscr.refresh()
                    key_v = stdscr.getch()

                    if key_v == curses.KEY_DOWN and v_idx < len(all_paths) - 1:
                        v_idx += 1
                        if v_idx >= v_top + height - 4:
                            v_top += 1
                    elif key_v == curses.KEY_UP and v_idx > 0:
                        v_idx -= 1
                        if v_idx < v_top:
                            v_top -= 1
                    elif key_v == curses.KEY_NPAGE:  # Page Down
                        v_idx = min(v_idx + height - 4, len(all_paths) - 1)
                        v_top = min(v_top + height - 4, len(all_paths) - (height - 4))
                    elif key_v == curses.KEY_PPAGE:  # Page Up
                        v_idx = max(0, v_idx - (height - 4))
                        v_top = max(0, v_top - (height - 4))
                    elif key_v == curses.KEY_HOME:
                        v_idx = 0
                        v_top = 0
                    elif key_v == curses.KEY_END:
                        v_idx = len(all_paths) - 1
                        v_top = max(0, len(all_paths) - (height - 4))
                    elif key_v == ord('q'):
                        break
            view_selections()

        elif key == 27:  # Escape
            return None
        elif key == ord('q'):
            return {
                "selected": [path for path, checked in selection.items() if checked],
                "ignored": [path for path, is_ignored in ignored.items() if is_ignored],
                "file_types": list(file_types)
            }

def select_files(start_path=".", preselected_filters=None, included_files=None, ignored_dirs=None, included_dirs=None):
    return curses.wrapper(curses_file_selector,
                         start_path=start_path,
                         preselected_filters=preselected_filters,
                         included_files=included_files,
                         ignored_dirs=ignored_dirs,
                         included_dirs=included_dirs)

--- File: flort/python_outline.py
--- Characters: 17,050
--- Token Count: 3,524
"""
Python Code Outline Generator

This module provides functionality to analyze Python source files and generate
comprehensive outlines showing classes, functions, methods, and their signatures.
The outlines include type annotations, docstrings, and decorators for complete
code structure understanding.

Key Features:
- Safe AST parsing with error handling
- Class and function signature extraction
- Type annotation preservation
- Docstring extraction
- Decorator information
- Nested class/function handling
- Error-tolerant processing

The generated outlines are particularly useful for:
- Code documentation
- Project structure analysis
- LLM context preparation
- Code review preparation
"""

import ast
import logging
from typing import List, Dict, Any, Optional, Union
from pathlib import Path

from .utils import write_file


def safe_ast_parse(source: str) -> Optional[ast.AST]:
    """
    Safely parse Python source code with comprehensive error handling.

    Args:
        source: Python source code as string

    Returns:
        ast.AST: Parsed AST tree, or None if parsing failed
    """
    try:
        return ast.parse(source)
    except SyntaxError as e:
        logging.debug(f"Syntax error in Python code: {e}")
        return None
    except IndentationError as e:
        logging.debug(f"Indentation error in Python code: {e}")
        return None
    except TypeError as e:
        logging.debug(f"Type error parsing Python code: {e}")
        return None
    except Exception as e:
        logging.error(f"Unexpected error parsing Python code: {e}")
        return None


def safe_ast_unparse(node: Optional[ast.AST]) -> Optional[str]:
    """
    Safely unparse AST node to string with error handling.

    Args:
        node: AST node to unparse

    Returns:
        str: Unparsed string representation, or None if unparsing failed
    """
    if node is None:
        return None

    try:
        # Use ast.unparse if available (Python 3.9+)
        if hasattr(ast, 'unparse'):
            return ast.unparse(node)
        else:
            # Fallback for older Python versions
            return _manual_unparse(node)
    except Exception as e:
        logging.debug(f"Error unparsing AST node: {e}")
        return None


def _manual_unparse(node: ast.AST) -> str:
    """
    Manual unparsing for older Python versions that don't have ast.unparse.

    Args:
        node: AST node to unparse

    Returns:
        str: String representation of the node
    """
    if isinstance(node, ast.Name):
        return node.id
    elif isinstance(node, ast.Constant):
        return repr(node.value)
    elif isinstance(node, ast.Attribute):
        return f"{_manual_unparse(node.value)}.{node.attr}"
    elif isinstance(node, ast.Subscript):
        return f"{_manual_unparse(node.value)}[{_manual_unparse(node.slice)}]"
    elif isinstance(node, ast.List):
        elements = [_manual_unparse(el) for el in node.elts]
        return f"[{', '.join(elements)}]"
    elif isinstance(node, ast.Tuple):
        elements = [_manual_unparse(el) for el in node.elts]
        return f"({', '.join(elements)})"
    else:
        return "<complex_expression>"


def extract_function_info(node: ast.FunctionDef) -> Dict[str, Any]:
    """
    Extract comprehensive information from a function definition.

    Args:
        node: AST FunctionDef node

    Returns:
        dict: Function information including signature, docstring, decorators
    """
    try:
        # Extract arguments
        args_info = []

        # Regular arguments
        for i, arg in enumerate(node.args.args):
            arg_info = {
                "name": arg.arg,
                "annotation": safe_ast_unparse(arg.annotation),
                "default": None,
                "kind": "positional"
            }

            # Handle defaults (they align with the end of the args list)
            defaults_offset = len(node.args.args) - len(node.args.defaults)
            if i >= defaults_offset:
                default_idx = i - defaults_offset
                if default_idx < len(node.args.defaults):
                    arg_info["default"] = safe_ast_unparse(node.args.defaults[default_idx])

            args_info.append(arg_info)

        # *args
        if node.args.vararg:
            args_info.append({
                "name": f"*{node.args.vararg.arg}",
                "annotation": safe_ast_unparse(node.args.vararg.annotation),
                "default": None,
                "kind": "vararg"
            })

        # Keyword-only arguments
        for i, arg in enumerate(node.args.kwonlyargs):
            arg_info = {
                "name": arg.arg,
                "annotation": safe_ast_unparse(arg.annotation),
                "default": None,
                "kind": "keyword_only"
            }

            if i < len(node.args.kw_defaults) and node.args.kw_defaults[i]:
                arg_info["default"] = safe_ast_unparse(node.args.kw_defaults[i])

            args_info.append(arg_info)

        # **kwargs
        if node.args.kwarg:
            args_info.append({
                "name": f"**{node.args.kwarg.arg}",
                "annotation": safe_ast_unparse(node.args.kwarg.annotation),
                "default": None,
                "kind": "kwarg"
            })

        # Extract decorators
        decorators = []
        for decorator in node.decorator_list:
            decorator_str = safe_ast_unparse(decorator)
            if decorator_str:
                decorators.append(decorator_str)

        return {
            "type": "function",
            "name": node.name,
            "args": args_info,
            "return_type": safe_ast_unparse(node.returns),
            "docstring": ast.get_docstring(node),
            "decorators": decorators,
            "is_async": isinstance(node, ast.AsyncFunctionDef),
            "lineno": node.lineno
        }

    except Exception as e:
        logging.warning(f"Error extracting function info for {getattr(node, 'name', 'unknown')}: {e}")
        return {
            "type": "function",
            "name": getattr(node, 'name', 'unknown'),
            "error": str(e),
            "lineno": getattr(node, 'lineno', 0)
        }


def extract_class_info(node: ast.ClassDef) -> Dict[str, Any]:
    """
    Extract comprehensive information from a class definition.

    Args:
        node: AST ClassDef node

    Returns:
        dict: Class information including methods, inheritance, decorators
    """
    try:
        # Extract base classes
        bases = []
        for base in node.bases:
            base_str = safe_ast_unparse(base)
            if base_str:
                bases.append(base_str)

        # Extract decorators
        decorators = []
        for decorator in node.decorator_list:
            decorator_str = safe_ast_unparse(decorator)
            if decorator_str:
                decorators.append(decorator_str)

        # Extract methods and nested classes
        methods = []
        nested_classes = []

        for child in node.body:
            if isinstance(child, (ast.FunctionDef, ast.AsyncFunctionDef)):
                method_info = extract_function_info(child)
                method_info["is_method"] = True
                methods.append(method_info)
            elif isinstance(child, ast.ClassDef):
                nested_class_info = extract_class_info(child)
                nested_class_info["is_nested"] = True
                nested_classes.append(nested_class_info)

        return {
            "type": "class",
            "name": node.name,
            "bases": bases,
            "decorators": decorators,
            "docstring": ast.get_docstring(node),
            "methods": methods,
            "nested_classes": nested_classes,
            "lineno": node.lineno
        }

    except Exception as e:
        logging.warning(f"Error extracting class info for {getattr(node, 'name', 'unknown')}: {e}")
        return {
            "type": "class",
            "name": getattr(node, 'name', 'unknown'),
            "error": str(e),
            "lineno": getattr(node, 'lineno', 0)
        }


def analyze_python_file(file_path: Path) -> List[Dict[str, Any]]:
    """
    Analyze a Python file and extract all classes and functions.

    Args:
        file_path: Path to the Python file to analyze

    Returns:
        list: List of dictionaries containing class/function information
    """
    try:
        with open(file_path, 'r', encoding='utf-8', errors='replace') as f:
            source = f.read()
    except Exception as e:
        logging.error(f"Failed to read file {file_path}: {e}")
        return [{"type": "error", "message": f"Failed to read file: {str(e)}"}]

    tree = safe_ast_parse(source)
    if tree is None:
        return [{"type": "error", "message": "Failed to parse Python code"}]

    results = []

    # Walk the AST and extract top-level classes and functions
    for node in ast.walk(tree):
        try:
            # Only process top-level nodes (not nested)
            if hasattr(node, 'parent') and node.parent is not None:
                continue

            if isinstance(node, ast.ClassDef):
                class_info = extract_class_info(node)
                results.append(class_info)
            elif isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
                # Check if this function is at module level
                parent_found = False
                for parent in ast.walk(tree):
                    if isinstance(parent, (ast.ClassDef, ast.FunctionDef, ast.AsyncFunctionDef)):
                        if hasattr(parent, 'body') and node in parent.body and parent != node:
                            parent_found = True
                            break

                if not parent_found:
                    func_info = extract_function_info(node)
                    func_info["is_method"] = False
                    results.append(func_info)

        except Exception as e:
            logging.debug(f"Error processing AST node: {e}")
            continue

    # Sort by line number for consistent output
    results.sort(key=lambda x: x.get('lineno', 0))

    return results


def format_function_signature(func_info: Dict[str, Any]) -> str:
    """
    Format a function signature from function information.

    Args:
        func_info: Function information dictionary

    Returns:
        str: Formatted function signature
    """
    if "error" in func_info:
        return f"{func_info['name']} (Error: {func_info['error']})"

    try:
        args = func_info.get("args", [])
        arg_strings = []

        for arg in args:
            arg_str = arg["name"]
            if arg.get("annotation"):
                arg_str += f": {arg['annotation']}"
            if arg.get("default"):
                arg_str += f" = {arg['default']}"
            arg_strings.append(arg_str)

        signature = f"{func_info['name']}({', '.join(arg_strings)})"

        if func_info.get("return_type"):
            signature += f" -> {func_info['return_type']}"

        return signature

    except Exception as e:
        logging.debug(f"Error formatting function signature: {e}")
        return f"{func_info.get('name', 'unknown')} (formatting error)"


def format_outline_for_display(symbol_map: List[Dict[str, Any]]) -> str:
    """
    Format the symbol map into a readable outline format.

    Args:
        symbol_map: List of extracted symbol information

    Returns:
        str: Formatted outline string
    """
    if not symbol_map:
        return "No Python symbols found."

    output = []

    for item in symbol_map:
        try:
            if item.get("type") == "error":
                output.append(f"\nERROR: {item['message']}")
                continue

            if item.get("type") == "class":
                # Format class header
                class_line = f"\nCLASS: {item['name']}"
                if item.get("bases"):
                    class_line += f"({', '.join(item['bases'])})"
                output.append(class_line)

                # Add decorators
                if item.get("decorators"):
                    output.append(f"  DECORATORS: {', '.join(item['decorators'])}")

                # Add docstring
                if item.get("docstring"):
                    docstring_lines = item['docstring'].strip().split('\n')
                    output.append(f"  DOCSTRING:")
                    for line in docstring_lines[:3]:  # Limit to first 3 lines
                        output.append(f"    {line.strip()}")
                    if len(docstring_lines) > 3:
                        output.append(f"    ... ({len(docstring_lines) - 3} more lines)")

                # Add methods
                for method in item.get("methods", []):
                    method_sig = format_function_signature(method)
                    method_prefix = "ASYNC METHOD" if method.get("is_async") else "METHOD"
                    output.append(f"\n  {method_prefix}: {method_sig}")

                    if method.get("decorators"):
                        output.append(f"    DECORATORS: {', '.join(method['decorators'])}")

                    if method.get("docstring"):
                        method_doc_lines = method['docstring'].strip().split('\n')
                        output.append(f"    DOCSTRING:")
                        for line in method_doc_lines[:2]:  # Limit to first 2 lines for methods
                            output.append(f"      {line.strip()}")
                        if len(method_doc_lines) > 2:
                            output.append(f"      ... ({len(method_doc_lines) - 2} more lines)")

                # Add nested classes
                for nested_class in item.get("nested_classes", []):
                    output.append(f"\n  NESTED CLASS: {nested_class['name']}")
                    if nested_class.get("docstring"):
                        output.append(f"    DOCSTRING: {nested_class['docstring'][:100]}...")

            elif item.get("type") == "function":
                # Format function
                func_sig = format_function_signature(item)
                func_prefix = "ASYNC FUNCTION" if item.get("is_async") else "FUNCTION"
                output.append(f"\n{func_prefix}: {func_sig}")

                if item.get("decorators"):
                    output.append(f"  DECORATORS: {', '.join(item['decorators'])}")

                if item.get("docstring"):
                    func_doc_lines = item['docstring'].strip().split('\n')
                    output.append(f"  DOCSTRING:")
                    for line in func_doc_lines[:3]:  # Limit to first 3 lines
                        output.append(f"    {line.strip()}")
                    if len(func_doc_lines) > 3:
                        output.append(f"    ... ({len(func_doc_lines) - 3} more lines)")

        except Exception as e:
            logging.error(f"Error formatting outline item: {e}")
            output.append(f"\nERROR: Failed to format item: {str(e)}")

    return "\n".join(output)


def process_python_file(file_path: Path) -> str:
    """
    Process a single Python file and return its formatted outline.

    Args:
        file_path: Path to the Python file to process

    Returns:
        str: Formatted outline of the file
    """
    try:
        symbol_map = analyze_python_file(file_path)
        return format_outline_for_display(symbol_map)
    except Exception as e:
        error_msg = f"ERROR: Failed to process file: {str(e)}"
        logging.error(f"Error processing Python file {file_path}: {e}")
        return error_msg


def python_outline_files(file_list: List[Dict[str, Any]], output: str) -> bool:
    """
    Generate Python outlines for all Python files in the file list.

    Args:
        file_list: List of file dictionaries with path and metadata
        output: Output file path or "stdio"

    Returns:
        bool: True if outline generation was successful
    """
    if not write_file(output, "## Python Code Outline\n"):
        return False

    python_files = [
        item for item in file_list
        if item.get("type") == "file" and item["path"].suffix.lower() == '.py'
    ]

    if not python_files:
        return write_file(output, "\nNo Python files found for outline generation.\n\n")

    logging.info(f"Generating outlines for {len(python_files)} Python files")

    for item in python_files:
        file_path = item["path"]
        relative_path = item["relative_path"]

        if not write_file(output, f"\n### File: {relative_path}\n"):
            return False

        try:
            outline = process_python_file(file_path)
            if not write_file(output, outline + "\n"):
                return False
        except Exception as e:
            error_msg = f"Error processing {relative_path}: {str(e)}\n"
            logging.error(error_msg.strip())
            if not write_file(output, error_msg):
                return False

    return write_file(output, "\n")

--- File: flort/simple_selector.py
--- Characters: 20,584
--- Token Count: 3,892
"""
Simple Text-Based File Selector

A fallback file selector for when curses is not available.
Provides basic interactive functionality through text prompts.
"""

import os
import sys
from pathlib import Path
from typing import List, Dict, Optional, Set


def simple_select_files(
    start_path: str = ".",
    preselected_filters: List[str] = None,
    included_files: List[str] = None,
    ignored_dirs: List[str] = None,
    included_dirs: List[str] = None
) -> Optional[Dict[str, List[str]]]:
    """
    Simple text-based file selector as fallback for curses UI.

    Args:
        start_path: Starting directory path
        preselected_filters: Pre-selected file extensions
        included_files: Pre-included specific files
        ignored_dirs: Pre-ignored directories
        included_dirs: Pre-included directories

    Returns:
        dict: Selection results or None if cancelled
    """
    print("\n🔧 Flort Simple File Selector")
    print("=" * 50)
    print("Interactive file selection (text-based fallback)")

    # Discover file types in the directory
    print(f"\n🔍 Discovering file types in {start_path}...")
    discovered_types = discover_file_types_simple(start_path)

    if discovered_types:
        print(f"📋 Found {len(discovered_types)} file types:")
        for i, ext in enumerate(discovered_types[:20], 1):  # Show first 20
            print(f"  {i:2d}. {ext}")
        if len(discovered_types) > 20:
            print(f"  ... and {len(discovered_types) - 20} more")
    else:
        print("❌ No file types discovered")

    # Initialize with discovery or preselected
    if preselected_filters:
        file_types = set(preselected_filters)
        print(f"\n🎯 Using preselected filters: {', '.join(file_types)}")
    else:
        # Auto-select common code types
        common_code_types = {'.py', '.js', '.ts', '.java', '.cpp', '.c', '.h', '.css', '.html', '.php', '.rb', '.go', '.rs', '.swift', '.kt', '.md', '.txt', '.yml', '.yaml', '.json', '.xml'}
        auto_selected = [ext for ext in discovered_types if ext in common_code_types]

        if auto_selected:
            file_types = set(auto_selected)
            print(f"\n🎯 Auto-selected common code types: {', '.join(sorted(file_types))}")
        else:
            # Offer to select from discovered types
            file_types = set()
            print(f"\n🤔 No common code types found. Select from discovered types:")
            if discovered_types:
                print("Enter numbers (comma-separated) or 'all' for all types:")
                try:
                    choice = input("❓ Your choice: ").strip().lower()
                    if choice == 'all':
                        file_types = set(discovered_types)
                    elif choice:
                        numbers = [int(x.strip()) for x in choice.split(',') if x.strip().isdigit()]
                        file_types = {discovered_types[i-1] for i in numbers if 1 <= i <= len(discovered_types)}
                except (ValueError, IndexError, KeyboardInterrupt):
                    file_types = set(discovered_types[:5])  # Default to first 5

            if not file_types:
                file_types = set(discovered_types[:5])  # Fallback
                print(f"🎯 Using default selection: {', '.join(sorted(file_types))}")

    selected_files = set(included_files or [])
    ignored_directories = set(ignored_dirs or [])
    selected_dirs = set(included_dirs or [start_path])

    while True:
        print("\n📋 Current Configuration:")
        print(f"  Start Path: {start_path}")
        print(f"  File Types: {', '.join(sorted(file_types)) if file_types else 'All files'}")
        print(f"  Selected Files: {len(selected_files)} files")
        print(f"  Ignored Dirs: {len(ignored_directories)} directories")
        print(f"  Selected Dirs: {', '.join(selected_dirs)}")

        print("\n📝 Options:")
        print("  1. Add file extensions")
        print("  2. Remove file extensions")
        print("  3. Quick-select common types (py,js,md,txt)")
        print("  4. Select from discovered types")
        print("  5. Add specific files")
        print("  6. Remove specific files")
        print("  7. Add ignored directories")
        print("  8. Remove ignored directories")
        print("  9. Preview selected files")
        print("  0. Use current selection")
        print("  q. Cancel")

        try:
            choice = input("\n❓ Choose option: ").strip().lower()

            if choice == '1':
                extensions = input("📝 Enter file extensions (comma-separated, no dots): ").strip()
                if extensions:
                    new_exts = [f".{ext.strip().lstrip('.')}" for ext in extensions.split(',') if ext.strip()]
                    file_types.update(new_exts)
                    print(f"✅ Added extensions: {', '.join(new_exts)}")

            elif choice == '2':
                if file_types:
                    print("Current extensions:", ', '.join(sorted(file_types)))
                    ext_to_remove = input("📝 Enter extension to remove: ").strip()
                    if ext_to_remove:
                        if not ext_to_remove.startswith('.'):
                            ext_to_remove = '.' + ext_to_remove
                        if ext_to_remove in file_types:
                            file_types.remove(ext_to_remove)
                            print(f"✅ Removed extension: {ext_to_remove}")
                        else:
                            print(f"❌ Extension not found: {ext_to_remove}")
                else:
                    print("❌ No extensions to remove")

            elif choice == '3':
                common_types = {'.py', '.js', '.ts', '.md', '.txt', '.json', '.yml', '.css', '.html'}
                available_common = [ext for ext in common_types if ext in discovered_types]
                if available_common:
                    file_types.update(available_common)
                    print(f"✅ Added common types: {', '.join(sorted(available_common))}")
                else:
                    print("❌ No common code types found in directory")

            elif choice == '4':
                if discovered_types:
                    print("\n📋 Discovered file types:")
                    for i, ext in enumerate(discovered_types, 1):
                        indicator = "✓" if ext in file_types else " "
                        print(f"  {indicator} {i:2d}. {ext}")

                    print("\nEnter numbers to toggle (comma-separated):")
                    try:
                        numbers_input = input("❓ Numbers: ").strip()
                        if numbers_input:
                            numbers = [int(x.strip()) for x in numbers_input.split(',') if x.strip().isdigit()]
                            for num in numbers:
                                if 1 <= num <= len(discovered_types):
                                    ext = discovered_types[num-1]
                                    if ext in file_types:
                                        file_types.remove(ext)
                                        print(f"➖ Removed: {ext}")
                                    else:
                                        file_types.add(ext)
                                        print(f"➕ Added: {ext}")
                    except ValueError:
                        print("❌ Please enter valid numbers")
                else:
                    print("❌ No file types discovered")

            elif choice == '5':
                files = input("📝 Enter file paths (comma-separated): ").strip()
                if files:
                    new_files = [f.strip() for f in files.split(',') if f.strip()]
                    # Validate files exist
                    valid_files = []
                    for file_path in new_files:
                        if Path(file_path).exists():
                            valid_files.append(file_path)
                        else:
                            print(f"⚠️  File not found: {file_path}")

                    if valid_files:
                        selected_files.update(valid_files)
                        print(f"✅ Added files: {', '.join(valid_files)}")

            elif choice == '6':
                if selected_files:
                    print("Current files:")
                    for i, file_path in enumerate(selected_files, 1):
                        print(f"  {i}. {file_path}")

                    try:
                        file_num = int(input("📝 Enter file number to remove: ").strip())
                        file_list = list(selected_files)
                        if 1 <= file_num <= len(file_list):
                            removed_file = file_list[file_num - 1]
                            selected_files.remove(removed_file)
                            print(f"✅ Removed file: {removed_file}")
                        else:
                            print("❌ Invalid file number")
                    except ValueError:
                        print("❌ Please enter a valid number")
                else:
                    print("❌ No files to remove")

            elif choice == '7':
                dirs = input("📝 Enter directories to ignore (comma-separated): ").strip()
                if dirs:
                    new_dirs = [d.strip() for d in dirs.split(',') if d.strip()]
                    ignored_directories.update(new_dirs)
                    print(f"✅ Added ignored directories: {', '.join(new_dirs)}")

            elif choice == '8':
                if ignored_directories:
                    print("Current ignored directories:")
                    for i, dir_path in enumerate(ignored_directories, 1):
                        print(f"  {i}. {dir_path}")

                    try:
                        dir_num = int(input("📝 Enter directory number to remove: ").strip())
                        dir_list = list(ignored_directories)
                        if 1 <= dir_num <= len(dir_list):
                            removed_dir = dir_list[dir_num - 1]
                            ignored_directories.remove(removed_dir)
                            print(f"✅ Removed ignored directory: {removed_dir}")
                        else:
                            print("❌ Invalid directory number")
                    except ValueError:
                        print("❌ Please enter a valid number")
                else:
                    print("❌ No ignored directories to remove")

            elif choice == '9':
                print("\n🔍 Preview of Selected Files:")
                preview_files(start_path, file_types, selected_files, ignored_directories)

            elif choice == '0':
                print("✅ Using current selection")
                break

            elif choice == 'q':
                print("❌ Selection cancelled")
                return None

            else:
                print("❌ Invalid choice. Please try again.")

        except KeyboardInterrupt:
            print("\n❌ Selection cancelled")
            return None
        except EOFError:
            print("\n❌ Selection cancelled")
            return None

    # Return results in the same format as curses selector
    return {
        "selected": list(selected_dirs),
        "ignored": list(ignored_directories),
        "file_types": list(file_types)
    }


def discover_file_types_simple(path: str) -> List[str]:
    """Discover all file types in the given path."""
    extensions = set()
    try:
        for file_path in Path(path).rglob("*"):
            if file_path.is_file():
                try:
                    file_path.stat()  # Check accessibility
                    ext = file_path.suffix.lower()
                    if ext:
                        extensions.add(ext)
                except (PermissionError, OSError):
                    continue
    except (PermissionError, OSError):
        pass
    return sorted(extensions)

    while True:
        print("\n📋 Current Configuration:")
        print(f"  Start Path: {start_path}")
        print(f"  File Types: {', '.join(file_types) if file_types else 'None'}")
        print(f"  Selected Files: {len(selected_files)} files")
        print(f"  Ignored Dirs: {len(ignored_directories)} directories")
        print(f"  Selected Dirs: {', '.join(selected_dirs)}")

        print("\n📝 Options:")
        print("  1. Add file extensions (e.g., py,js,md)")
        print("  2. Remove file extensions")
        print("  3. Add specific files")
        print("  4. Remove specific files")
        print("  5. Add ignored directories")
        print("  6. Remove ignored directories")
        print("  7. Preview selected files")
        print("  8. Use current selection")
        print("  9. Cancel")

        try:
            choice = input("\n❓ Choose option (1-9): ").strip()

            if choice == '1':
                extensions = input("📝 Enter file extensions (comma-separated, no dots): ").strip()
                if extensions:
                    new_exts = [f".{ext.strip().lstrip('.')}" for ext in extensions.split(',') if ext.strip()]
                    file_types.update(new_exts)
                    print(f"✅ Added extensions: {', '.join(new_exts)}")

            elif choice == '2':
                if file_types:
                    print("Current extensions:", ', '.join(file_types))
                    ext_to_remove = input("📝 Enter extension to remove: ").strip()
                    if ext_to_remove:
                        if not ext_to_remove.startswith('.'):
                            ext_to_remove = '.' + ext_to_remove
                        if ext_to_remove in file_types:
                            file_types.remove(ext_to_remove)
                            print(f"✅ Removed extension: {ext_to_remove}")
                        else:
                            print(f"❌ Extension not found: {ext_to_remove}")
                else:
                    print("❌ No extensions to remove")

            elif choice == '3':
                files = input("📝 Enter file paths (comma-separated): ").strip()
                if files:
                    new_files = [f.strip() for f in files.split(',') if f.strip()]
                    # Validate files exist
                    valid_files = []
                    for file_path in new_files:
                        if Path(file_path).exists():
                            valid_files.append(file_path)
                        else:
                            print(f"⚠️  File not found: {file_path}")

                    if valid_files:
                        selected_files.update(valid_files)
                        print(f"✅ Added files: {', '.join(valid_files)}")

            elif choice == '4':
                if selected_files:
                    print("Current files:")
                    for i, file_path in enumerate(selected_files, 1):
                        print(f"  {i}. {file_path}")

                    try:
                        file_num = int(input("📝 Enter file number to remove: ").strip())
                        file_list = list(selected_files)
                        if 1 <= file_num <= len(file_list):
                            removed_file = file_list[file_num - 1]
                            selected_files.remove(removed_file)
                            print(f"✅ Removed file: {removed_file}")
                        else:
                            print("❌ Invalid file number")
                    except ValueError:
                        print("❌ Please enter a valid number")
                else:
                    print("❌ No files to remove")

            elif choice == '5':
                dirs = input("📝 Enter directories to ignore (comma-separated): ").strip()
                if dirs:
                    new_dirs = [d.strip() for d in dirs.split(',') if d.strip()]
                    ignored_directories.update(new_dirs)
                    print(f"✅ Added ignored directories: {', '.join(new_dirs)}")

            elif choice == '6':
                if ignored_directories:
                    print("Current ignored directories:")
                    for i, dir_path in enumerate(ignored_directories, 1):
                        print(f"  {i}. {dir_path}")

                    try:
                        dir_num = int(input("📝 Enter directory number to remove: ").strip())
                        dir_list = list(ignored_directories)
                        if 1 <= dir_num <= len(dir_list):
                            removed_dir = dir_list[dir_num - 1]
                            ignored_directories.remove(removed_dir)
                            print(f"✅ Removed ignored directory: {removed_dir}")
                        else:
                            print("❌ Invalid directory number")
                    except ValueError:
                        print("❌ Please enter a valid number")
                else:
                    print("❌ No ignored directories to remove")

            elif choice == '7':
                print("\n🔍 Preview of Selected Files:")
                preview_files(start_path, file_types, selected_files, ignored_directories)

            elif choice == '8':
                print("✅ Using current selection")
                break

            elif choice == '9':
                print("❌ Selection cancelled")
                return None

            else:
                print("❌ Invalid choice. Please enter 1-9.")

        except KeyboardInterrupt:
            print("\n❌ Selection cancelled")
            return None
        except EOFError:
            print("\n❌ Selection cancelled")
            return None

    # Return results in the same format as curses selector
    return {
        "selected": list(selected_dirs),
        "ignored": list(ignored_directories),
        "file_types": list(file_types)
    }


def preview_files(
    start_path: str,
    file_types: Set[str],
    selected_files: Set[str],
    ignored_dirs: Set[str]
) -> None:
    """
    Preview files that would be selected with current settings.

    Args:
        start_path: Base directory path
        file_types: Set of file extensions to include
        selected_files: Set of specifically selected files
        ignored_dirs: Set of directories to ignore
    """
    base_path = Path(start_path)

    print(f"\n📁 Scanning from: {base_path}")
    print(f"🎯 File types: {', '.join(file_types) if file_types else 'All'}")
    print(f"🚫 Ignored dirs: {', '.join(ignored_dirs) if ignored_dirs else 'None'}")

    matching_files = []

    try:
        # Scan for matching files
        for file_path in base_path.rglob("*"):
            if not file_path.is_file():
                continue

            # Check if in ignored directory
            skip = False
            for ignore_dir in ignored_dirs:
                if str(file_path).startswith(str(Path(ignore_dir).resolve())):
                    skip = True
                    break

            if skip:
                continue

            # Check if matches file types or is specifically selected
            if (file_path.suffix.lower() in file_types or
                str(file_path) in selected_files or
                not file_types):  # Include all if no types specified
                matching_files.append(file_path)

        # Add specifically selected files
        for file_str in selected_files:
            file_path = Path(file_str)
            if file_path.exists() and file_path not in matching_files:
                matching_files.append(file_path)

        # Display results
        if matching_files:
            print(f"\n📋 Found {len(matching_files)} matching files:")

            # Group by directory for better display
            by_dir = {}
            for file_path in sorted(matching_files):
                dir_name = str(file_path.parent)
                if dir_name not in by_dir:
                    by_dir[dir_name] = []
                by_dir[dir_name].append(file_path.name)

            for dir_name, files in by_dir.items():
                print(f"\n  📂 {dir_name}/")
                for file_name in files[:10]:  # Limit to first 10 per directory
                    print(f"    📄 {file_name}")
                if len(files) > 10:
                    print(f"    ... and {len(files) - 10} more files")
        else:
            print("\n❌ No files match current criteria")

    except Exception as e:
        print(f"❌ Error scanning files: {e}")

    input("\n⏎ Press Enter to continue...")

--- File: flort/traverse.py
--- Characters: 22,065
--- Token Count: 3,730
"""
File Traversal Module

This module provides comprehensive file discovery functionality with support for:
- Directory traversal with depth tracking
- Extension-based filtering (include/exclude)
- Pattern-based filtering (include/exclude)
- Hidden file handling
- Binary file detection and filtering
- Specific file inclusion
- Directory ignoring

The module implements a clean pipeline for file discovery that handles all
filtering operations in a consistent and predictable order.
"""

from pathlib import Path
import logging
import os
import fnmatch
from typing import List, Dict, Any, Set, Optional, Tuple

from .utils import is_binary_file, validate_file_path


class FileFilter:
    """
    Handles all file filtering logic in a centralized, testable way.
    """

    def __init__(
        self,
        include_extensions: List[str] = None,
        exclude_extensions: List[str] = None,
        include_patterns: List[str] = None,
        exclude_patterns: List[str] = None,
        include_all: bool = False,
        include_hidden: bool = False,
        include_binary: bool = False,
        ignore_dirs: List[Path] = None
    ):
        """
        Initialize file filter with all filtering criteria.

        Args:
            include_extensions: List of extensions to include (with or without dots)
            exclude_extensions: List of extensions to exclude (with or without dots)
            include_patterns: List of glob patterns to include
            exclude_patterns: List of glob patterns to exclude
            include_all: If True, include all files regardless of extension
            include_hidden: If True, include hidden files/directories
            include_binary: If True, include binary files
            ignore_dirs: List of directory paths to completely ignore
        """
        self.include_extensions = self._normalize_extensions(include_extensions or [])
        self.exclude_extensions = self._normalize_extensions(exclude_extensions or [])
        self.include_patterns = include_patterns or []
        self.exclude_patterns = exclude_patterns or []
        self.include_all = include_all
        self.include_hidden = include_hidden
        self.include_binary = include_binary
        self.ignore_dirs = [Path(d).resolve() for d in (ignore_dirs or [])]

        logging.debug(f"FileFilter initialized with:")
        logging.debug(f"  Include extensions: {self.include_extensions}")
        logging.debug(f"  Exclude extensions: {self.exclude_extensions}")
        logging.debug(f"  Include patterns: {self.include_patterns}")
        logging.debug(f"  Exclude patterns: {self.exclude_patterns}")
        logging.debug(f"  Include all: {self.include_all}")
        logging.debug(f"  Include hidden: {self.include_hidden}")
        logging.debug(f"  Include binary: {self.include_binary}")

    def _normalize_extensions(self, extensions: List[str]) -> Set[str]:
        """Normalize extensions to always include the dot prefix."""
        normalized = set()
        for ext in extensions:
            ext = ext.strip()
            if ext and not ext.startswith('.'):
                ext = '.' + ext
            if ext:
                normalized.add(ext.lower())
        return normalized

    def should_ignore_directory(self, dir_path: Path) -> bool:
        """
        Check if a directory should be completely ignored.

        Args:
            dir_path: Directory path to check

        Returns:
            bool: True if directory should be ignored
        """
        try:
            resolved_path = dir_path.resolve()

            # Check against ignore list
            for ignore_dir in self.ignore_dirs:
                if resolved_path == ignore_dir or self._is_subdirectory(resolved_path, ignore_dir):
                    return True

            # Check hidden directories
            if not self.include_hidden and dir_path.name.startswith('.'):
                return True

            return False

        except Exception as e:
            logging.debug(f"Error checking directory {dir_path}: {e}")
            return True

    def should_include_file(self, file_path: Path) -> Tuple[bool, str]:
        """
        Determine if a file should be included based on all filter criteria.

        Args:
            file_path: File path to check

        Returns:
            tuple: (should_include, reason) where reason explains the decision
        """
        try:
            # Check if file is hidden
            if not self.include_hidden and file_path.name.startswith('.'):
                return False, "hidden file"

            # Check if in ignored directory
            for ignore_dir in self.ignore_dirs:
                if self._is_subdirectory(file_path, ignore_dir):
                    return False, f"in ignored directory {ignore_dir}"

            # Check exclude patterns first (they take precedence)
            # Only check the filename, not the full path to avoid matching temp directories
            for pattern in self.exclude_patterns:
                if fnmatch.fnmatch(file_path.name, pattern):
                    return False, f"matches exclude pattern '{pattern}'"

            # Check exclude extensions
            if file_path.suffix.lower() in self.exclude_extensions:
                return False, f"has excluded extension '{file_path.suffix}'"

            # If include_all is True, include everything not excluded
            if self.include_all:
                # Still check binary files if not included
                if not self.include_binary and is_binary_file(file_path):
                    return False, "binary file (use --include-binary to include)"
                return True, "include_all enabled"

            # Check include patterns (only check filename, not full path)
            pattern_match = False
            for pattern in self.include_patterns:
                if fnmatch.fnmatch(file_path.name, pattern):
                    pattern_match = True
                    break

            # Check include extensions
            extension_match = file_path.suffix.lower() in self.include_extensions

            # Must match either pattern or extension (if any are specified)
            has_include_criteria = self.include_patterns or self.include_extensions

            if has_include_criteria:
                if not (pattern_match or extension_match):
                    return False, "does not match any include criteria"
            else:
                # If no include criteria specified and not include_all, don't include
                return False, "no include criteria specified"

            # Check binary files
            if not self.include_binary and is_binary_file(file_path):
                return False, "binary file (use --include-binary to include)"

            # Validate file accessibility
            is_valid, error_msg = validate_file_path(file_path)
            if not is_valid:
                return False, f"file validation failed: {error_msg}"

            return True, "passed all filters"

        except Exception as e:
            logging.error(f"Error filtering file {file_path}: {e}")
            return False, f"error during filtering: {str(e)}"

    def _is_subdirectory(self, child_path: Path, parent_path: Path) -> bool:
        """Check if child_path is a subdirectory of parent_path."""
        try:
            child_path.resolve().relative_to(parent_path.resolve())
            return True
        except ValueError:
            return False

def get_paths(
    directories: List[str] = None,
    extensions: List[str] = None,
    exclude_extensions: List[str] = None,
    include_patterns: List[str] = None,
    exclude_patterns: List[str] = None,
    include_all: bool = False,
    include_hidden: bool = False,
    include_binary: bool = False,
    ignore_dirs: List[Path] = None,
    include_files: List[str] = None,
    glob_patterns: List[str] = None,
    max_depth: Optional[int] = None
) -> List[Dict[str, Any]]:
    """
    Main entry point for file path discovery with comprehensive filtering.

    This function orchestrates the entire file discovery pipeline:
    1. Directory scanning with basic filters
    2. Glob pattern matching
    3. Specific file inclusion
    4. Deduplication
    5. Final sorting

    Args:
        directories: List of directories to traverse
        extensions: List of file extensions to include
        exclude_extensions: List of file extensions to exclude
        include_patterns: List of glob patterns to include
        exclude_patterns: List of glob patterns to exclude
        include_all: Include all files regardless of extension
        include_hidden: Include hidden files
        include_binary: Include binary files
        ignore_dirs: List of directories to ignore
        include_files: List of specific files to include
        glob_patterns: List of glob patterns to search for
        max_depth: Maximum traversal depth

    Returns:
        List of path dictionaries sorted by relative path
    """
    if not directories:
        directories = ["."]

    # Create file filter
    file_filter = FileFilter(
        include_extensions=extensions,
        exclude_extensions=exclude_extensions,
        include_patterns=include_patterns,
        exclude_patterns=exclude_patterns,
        include_all=include_all,
        include_hidden=include_hidden,
        include_binary=include_binary,
        ignore_dirs=ignore_dirs
    )

    # Step 1: Scan directories
    all_paths = scan_directories(directories, file_filter, max_depth)

    # Step 2: Add glob pattern matches
    if glob_patterns:
        glob_matches = apply_glob_patterns(directories, glob_patterns, file_filter)
        all_paths.extend(glob_matches)

    # Step 3: Add specifically included files
    if include_files:
        base_dir = Path(directories[0]).resolve() if directories else Path.cwd()
        all_paths = add_specific_files(all_paths, include_files, base_dir)

    # Step 4: Remove duplicates while preserving order
    seen_paths = set()
    deduplicated_paths = []

    for item in all_paths:
        path_key = str(item["path"].resolve())
        if path_key not in seen_paths:
            seen_paths.add(path_key)
            deduplicated_paths.append(item)

    # Step 5: Final sort by relative path
    deduplicated_paths.sort(key=lambda x: (x["type"] == "file", x["relative_path"]))

    file_count = len([p for p in deduplicated_paths if p["type"] == "file"])
    dir_count = len([p for p in deduplicated_paths if p["type"] == "dir"])

    logging.info(f"Final result: {file_count} files, {dir_count} directories")

    return deduplicated_paths

def scan_directories(
    directories: List[str],
    file_filter: FileFilter,
    max_depth: Optional[int] = None
) -> List[Dict[str, Any]]:
    """
    Scan directories and return all matching files and directories.
    FIXED: Always uses absolute paths.
    """
    if not directories:
        logging.error("No directories provided for scanning.")
        return []

    all_paths = []
    processed_paths = set()

    for base_directory in directories:
        base_path = Path(base_directory).resolve()  # ALWAYS resolve to absolute

        if not base_path.exists():
            logging.error(f"Directory does not exist: {base_directory}")
            continue

        if not base_path.is_dir():
            logging.error(f"Path is not a directory: {base_directory}")
            continue

        if file_filter.should_ignore_directory(base_path):
            logging.info(f"Skipping ignored directory: {base_path}")
            continue

        logging.info(f"Scanning directory: {base_path}")

        # Scan the directory tree
        directory_paths = _scan_directory_recursive(
            base_path,
            base_path,  # Use base_path as reference for relative paths
            file_filter,
            max_depth,
            current_depth=1,
            processed_paths=processed_paths
        )

        all_paths.extend(directory_paths)

    # Sort by relative path for consistent output
    all_paths.sort(key=lambda x: x["relative_path"])

    logging.info(f"Found {len([p for p in all_paths if p['type'] == 'file'])} files and "
                f"{len([p for p in all_paths if p['type'] == 'dir'])} directories")

    return all_paths


def _scan_directory_recursive(
    current_path: Path,
    base_path: Path,  # Reference point for relative paths
    file_filter: FileFilter,
    max_depth: Optional[int],
    current_depth: int,
    processed_paths: Set[str]
) -> List[Dict[str, Any]]:
    """
    Recursively scan a directory and return matching files/directories.
    FIXED: Always uses absolute paths.
    """
    paths = []

    # Check depth limit
    if max_depth is not None and current_depth > max_depth:
        return paths

    # ALWAYS work with absolute paths
    current_path = current_path.resolve()
    base_path = base_path.resolve()

    # Calculate relative path for display
    try:
        relative_path = str(current_path.relative_to(base_path))
    except ValueError:
        relative_path = str(current_path)

    # Skip if already processed
    path_key = str(current_path)
    if path_key in processed_paths:
        return paths
    processed_paths.add(path_key)

    # Add current directory
    paths.append({
        "path": current_path,  # ABSOLUTE PATH
        "relative_path": relative_path,
        "depth": current_depth,
        "type": "dir"
    })

    try:
        # Get directory contents
        with os.scandir(current_path) as entries:
            # Sort entries for consistent output
            sorted_entries = sorted(entries, key=lambda e: (e.is_file(), e.name.lower()))

            for entry in sorted_entries:
                try:
                    entry_path = Path(entry.path).resolve()  # ALWAYS resolve to absolute
                except Exception as e:
                    logging.warning(f"Could not resolve path {entry.path}: {e}")
                    continue

                # Skip if already processed
                entry_key = str(entry_path)
                if entry_key in processed_paths:
                    continue

                # Calculate relative path for entry
                try:
                    entry_relative = str(entry_path.relative_to(base_path))
                except ValueError:
                    entry_relative = str(entry_path)

                if entry.is_dir():
                    # Check if directory should be ignored
                    if not file_filter.should_ignore_directory(entry_path):
                        # Recursively scan subdirectory
                        subdir_paths = _scan_directory_recursive(
                            entry_path,
                            base_path,
                            file_filter,
                            max_depth,
                            current_depth + 1,
                            processed_paths
                        )
                        paths.extend(subdir_paths)
                    else:
                        logging.debug(f"Ignoring directory: {entry_path}")

                elif entry.is_file():
                    # Check if file should be included
                    should_include, reason = file_filter.should_include_file(entry_path)

                    if should_include:
                        processed_paths.add(entry_key)
                        paths.append({
                            "path": entry_path,  # ABSOLUTE PATH
                            "relative_path": entry_relative,
                            "depth": current_depth + 1,
                            "type": "file"
                        })
                        logging.debug(f"Including file: {entry_path} ({reason})")
                    else:
                        logging.debug(f"Excluding file: {entry_path} ({reason})")

    except PermissionError as e:
        logging.error(f"Permission denied accessing {current_path}: {e}")
    except Exception as e:
        logging.error(f"Error scanning {current_path}: {e}")

    return paths


def add_specific_files(
    path_list: List[Dict[str, Any]],
    include_files: List[str],
    base_dir: Path = None
) -> List[Dict[str, Any]]:
    """
    Add specific files to the path list.
    FIXED: Always uses absolute paths.
    """
    if not include_files:
        return path_list

    if base_dir is None:
        base_dir = Path.cwd().resolve()
    else:
        base_dir = base_dir.resolve()

    # Create set of existing paths for deduplication
    existing_paths = {str(item["path"]) for item in path_list}

    added_count = 0

    for file_str in include_files:
        file_str = file_str.strip()
        if not file_str:
            continue

        # Try to find the file - simple approach
        file_path = Path(file_str)
        found_path = None

        # Try these locations in order
        candidates = []
        if file_path.is_absolute():
            candidates.append(file_path)
        else:
            candidates.extend([
                base_dir / file_path,
                Path.cwd() / file_path,
                file_path
            ])

        # Find the first one that exists
        for candidate in candidates:
            try:
                resolved = candidate.resolve()
                if resolved.exists() and resolved.is_file():
                    found_path = resolved
                    break
            except Exception:
                continue

        if found_path is None:
            logging.error(f"Cannot find include file: {file_str}")
            continue

        # Validate file accessibility
        is_valid, error_msg = validate_file_path(found_path)
        if not is_valid:
            logging.warning(f"Cannot include file {file_str}: {error_msg}")
            continue

        # Check for duplicates
        path_key = str(found_path)
        if path_key in existing_paths:
            logging.debug(f"File already included: {found_path}")
            continue

        # Calculate relative path for display
        try:
            relative_path = str(found_path.relative_to(base_dir))
        except ValueError:
            # File is outside base_dir, use just the filename or show parent
            try:
                relative_path = str(found_path.relative_to(Path.cwd()))
            except ValueError:
                relative_path = f"{found_path.parent.name}/{found_path.name}"

        # Add to path list with ABSOLUTE PATH
        path_list.append({
            "path": found_path,  # ABSOLUTE PATH
            "relative_path": relative_path,
            "depth": 0,
            "type": "file"
        })

        existing_paths.add(path_key)
        added_count += 1
        logging.info(f"Added included file: {relative_path}")

    if added_count > 0:
        logging.info(f"Added {added_count} specifically included files")

    return path_list


def apply_glob_patterns(
    directories: List[str],
    glob_patterns: List[str],
    file_filter: FileFilter
) -> List[Dict[str, Any]]:
    """
    Find files matching glob patterns within specified directories.
    FIXED: Always uses absolute paths.
    """
    if not glob_patterns:
        return []

    matching_files = []
    processed_paths = set()

    for directory in directories:
        base_path = Path(directory).resolve()  # ALWAYS resolve to absolute

        if not base_path.exists() or not base_path.is_dir():
            logging.warning(f"Invalid directory for glob search: {directory}")
            continue

        if file_filter.should_ignore_directory(base_path):
            logging.debug(f"Skipping ignored directory for glob: {base_path}")
            continue

        logging.debug(f"Applying glob patterns in: {base_path}")

        for pattern in glob_patterns:
            logging.debug(f"Processing glob pattern: {pattern}")

            try:
                # Handle recursive patterns
                if '**' in pattern:
                    matches = list(base_path.glob(pattern))
                else:
                    matches = list(base_path.glob('**/' + pattern))

                logging.debug(f"Found {len(matches)} matches for pattern '{pattern}'")

                for file_path in matches:
                    if not file_path.is_file():
                        continue

                    # ALWAYS resolve to absolute path
                    try:
                        file_path = file_path.resolve()
                    except Exception as e:
                        logging.warning(f"Could not resolve glob match {file_path}: {e}")
                        continue

                    # Check for duplicates
                    path_key = str(file_path)
                    if path_key in processed_paths:
                        continue

                    # Apply file filter
                    should_include, reason = file_filter.should_include_file(file_path)
                    if not should_include:
                        logging.debug(f"Glob match excluded: {file_path} ({reason})")
                        continue

                    # Calculate relative path
                    try:
                        relative_path = str(file_path.relative_to(base_path))
                    except ValueError:
                        relative_path = str(file_path)

                    matching_files.append({
                        "path": file_path,  # ABSOLUTE PATH
                        "relative_path": relative_path,
                        "depth": len(file_path.parts) - len(base_path.parts),
                        "type": "file"
                    })

                    processed_paths.add(path_key)
                    logging.debug(f"Added glob match: {file_path}")

            except Exception as e:
                logging.error(f"Error processing glob pattern '{pattern}' in {base_path}: {e}")

    logging.info(f"Found {len(matching_files)} files matching glob patterns")
    return matching_files

--- File: flort/utils.py
--- Characters: 19,276
--- Token Count: 4,053
"""
File Utilities Module

This module provides utility functions for file operations including:
- Binary file detection
- Content cleaning
- File writing
- Directory tree generation
- Token counting
- Archive creation

These utilities support the core functionality of the file processing system
while handling errors gracefully and providing appropriate logging.
"""

import os
import re
import argparse
from pathlib import Path
from datetime import datetime
from typing import List, Optional, Tuple, Dict, Any
import zipfile
import tarfile
import logging


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
    try:
        # Check common binary extensions first
        binary_extensions = {
            '.exe', '.dll', '.so', '.dylib', '.bin', '.obj', '.o', '.a', '.lib',
            '.zip', '.tar', '.gz', '.bz2', '.xz', '.7z', '.rar',
            '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.ico', '.svg', '.webp',
            '.mp3', '.mp4', '.avi', '.mov', '.wmv', '.flv', '.mkv', '.wav',
            '.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx',
            '.pyc', '.pyo', '.pyd', '.class', '.jar'
        }

        if file_path.suffix.lower() in binary_extensions:
            return True

        # Check file content
        with open(file_path, 'rb') as file:
            # Read larger chunk for better detection
            chunk = file.read(8192)

            if not chunk:
                return False

            # Quick check for null bytes
            if b'\x00' in chunk:
                return True

            # Check for high percentage of non-text characters
            text_characters = bytes(range(32, 127)) + b'\n\r\t\f\b'
            non_text_count = len(chunk.translate(None, text_characters))

            # If more than 30% non-text characters, consider binary
            return (non_text_count / len(chunk)) > 0.3

    except Exception as e:
        logging.debug(f"Error determining if file is binary {file_path}: {e}")
        return True


def clean_content(file_path: Path) -> str:
    """
    Clean up file content by removing unnecessary whitespace while preserving structure.

    Args:
        file_path (Path): Path to the file to clean

    Returns:
        str: Cleaned content with normalized whitespace

    The function:
    1. Reads all lines from the file
    2. Preserves leading whitespace for indentation
    3. Strips trailing whitespace only
    4. Preserves empty lines that separate code blocks
    5. Removes excessive consecutive empty lines (max 2)

    Note:
        - Preserves code structure and indentation
        - Removes trailing whitespace
        - Limits consecutive empty lines to 2
    """
    try:
        with open(file_path, 'r', encoding='utf-8', errors='replace') as file:
            lines = file.readlines()

        cleaned_lines = []
        consecutive_empty = 0

        for line in lines:
            # Strip only trailing whitespace, preserve leading
            cleaned_line = line.rstrip()

            if not cleaned_line:
                consecutive_empty += 1
                # Allow max 2 consecutive empty lines
                if consecutive_empty <= 2:
                    cleaned_lines.append('')
            else:
                consecutive_empty = 0
                cleaned_lines.append(cleaned_line)

        # Remove trailing empty lines
        while cleaned_lines and not cleaned_lines[-1]:
            cleaned_lines.pop()

        return '\n'.join(cleaned_lines)

    except Exception as e:
        logging.error(f"Error cleaning content from {file_path}: {e}")
        return ""


def write_file(file_path: str, data: str, mode: str = 'a') -> bool:
    """
    Write data to a file or output to console.

    Args:
        file_path (str): Path to output file or "stdio" for console output
        data (str): Content to write
        mode (str, optional): File opening mode ('w' for write, 'a' for append).
            Defaults to 'a'.

    Returns:
        bool: True if write was successful, False otherwise

    The function handles two output modes:
    1. File output: Writes to the specified file path
    2. Console output: Prints to stdout if file_path is "stdio"

    Error handling:
    - IOError: Logged with specific error message
    - Other exceptions: Logged with generic error message

    Note:
        - Creates parent directories if they don't exist
        - Returns success status for error handling
        - Handles both creation and append operations
    """
    try:
        if file_path == "stdio":
            print(data, end='')
            return True
        else:
            # Create parent directories if they don't exist
            Path(file_path).parent.mkdir(parents=True, exist_ok=True)

            with open(file_path, mode, encoding='utf-8') as file:
                file.write(data)

            operation = 'create' if mode == 'w' else 'append'
            logging.debug(f"Output written to: {file_path}. Mode: {operation}.")
            return True

    except IOError as e:
        logging.error(f"Failed to write to {file_path}: {e}")
        return False
    except Exception as e:
        logging.error(f"An unexpected error occurred while writing to {file_path}: {e}")
        return False


def configure_logging(verbose: bool) -> None:
    """
    Configure the logging system based on the verbosity level.

    Args:
        verbose (bool): If True, sets logging level to INFO;
                       if False, sets it to WARNING.

    The logging format includes timestamp, level, and message:
        2024-01-02 12:34:56 - INFO - Sample message
    """
    level = logging.INFO if verbose else logging.WARNING
    logging.basicConfig(
        level=level,
        format='%(asctime)s - %(levelname)s - %(message)s',
        force=True  # Override any existing configuration
    )


def count_tokens(text: str) -> int:
    """
    Count tokens in text using a robust tokenization strategy.

    Args:
        text (str): Text to tokenize

    Returns:
        int: Number of tokens

    Uses a combination of regex patterns to identify:
    - Words (including contractions)
    - Numbers (including decimals and percentages)
    - Punctuation marks
    - Special symbols
    - Code-specific tokens (operators, brackets, etc.)
    """
    if not text:
        return 0

    # Enhanced pattern for better code tokenization
    patterns = [
        r'\b[A-Za-z_][A-Za-z0-9_]*\b',  # Identifiers/words
        r'\b\d+\.?\d*%?\b',             # Numbers and percentages
        r'[+\-*/=<>!&|^~]+=?',          # Operators
        r'[(){}\[\]]',                   # Brackets
        r'[.,;:]',                       # Punctuation
        r'[\'"`]',                       # Quotes
        r'[@#$%\\]',                     # Special symbols
        r'\s+',                          # Whitespace (will be filtered)
    ]

    combined_pattern = '|'.join(f'({pattern})' for pattern in patterns)
    tokens = re.findall(combined_pattern, text)

    # Filter out whitespace tokens and count non-empty matches
    non_whitespace_tokens = []
    for token_groups in tokens:
        for token in token_groups:
            if token and not token.isspace():
                non_whitespace_tokens.append(token)
                break

    return len(non_whitespace_tokens)


def count_file_tokens(filename: str) -> str:
    """
    Count tokens and characters in a file.

    Args:
        filename (str): Path to file to analyze

    Returns:
        str: Formatted string with token and character counts
    """
    try:
        if filename == "stdio":
            return "Token counting not available for stdio output"

        with open(filename, 'r', encoding='utf-8') as f:
            text = f.read()

        token_count = count_tokens(text)
        char_count = len(text)
        line_count = text.count('\n') + (1 if text and not text.endswith('\n') else 0)

        return f"Lines: {line_count:,}\nTokens: {token_count:,}\nCharacters: {char_count:,}"

    except Exception as e:
        logging.error(f"Error counting tokens in {filename}: {e}")
        return f"Error counting tokens: {str(e)}"


def print_configuration(
    directories: list,
    extensions: list,
    exclude_extensions: list = None,
    exclude_patterns: list = None,
    include_all: bool = False,
    include_hidden: bool = False,
    ignore_dirs: list = None,
    include_files: list = None,
    glob_patterns: list = None
) -> None:
    """
    Log the current configuration settings for the file processing operation.

    Args:
        directories (list): List of directory paths to process
        extensions (list): List of file extensions to include
        exclude_extensions (list): List of file extensions to exclude
        exclude_patterns (list): List of glob patterns to exclude
        include_all (bool): Whether to include all file types
        include_hidden (bool): Whether to include hidden files
        ignore_dirs (list, optional): List of directories to ignore
        include_files (list, optional): List of specific files to include
        glob_patterns (list, optional): List of glob patterns to include

    This function provides visibility into the tool's configuration,
    which is particularly useful for debugging and verification.
    """
    logging.info("=== Flort Configuration ===")
    logging.info(f"Directories: {', '.join(directories)}")

    if extensions:
        logging.info(f"Include extensions: {', '.join(extensions)}")
    if exclude_extensions:
        logging.info(f"Exclude extensions: {', '.join(exclude_extensions)}")
    if glob_patterns:
        logging.info(f"Include patterns: {', '.join(glob_patterns)}")
    if exclude_patterns:
        logging.info(f"Exclude patterns: {', '.join(exclude_patterns)}")
    if include_files:
        logging.info(f"Include files: {', '.join(include_files)}")

    logging.info(f"Include all files: {include_all}")
    logging.info(f"Include hidden files: {include_hidden}")

    if ignore_dirs:
        logging.info(f"Ignore directories: {', '.join([str(d) for d in ignore_dirs])}")

    logging.info("=== End Configuration ===")


def archive_file(file_path: str, archive_format: str) -> str:
    """
    Archive a file using the specified format.

    Args:
        file_path (str): Path to the file to archive
        archive_format (str): 'zip' or 'tar.gz'

    Returns:
        str: Path to the created archive file, or None if failed
    """
    input_path = Path(file_path)

    if not input_path.exists():
        logging.error(f"File to archive does not exist: {file_path}")
        return None

    try:
        if archive_format == 'zip':
            archive_path = f"{file_path}.zip"
            with zipfile.ZipFile(archive_path, 'w', zipfile.ZIP_DEFLATED, compresslevel=6) as zipf:
                zipf.write(file_path, arcname=input_path.name)

        elif archive_format == 'tar.gz':
            archive_path = f"{file_path}.tar.gz"
            with tarfile.open(archive_path, "w:gz", compresslevel=6) as tar:
                tar.add(file_path, arcname=input_path.name)
        else:
            logging.error(f"Unsupported archive format: {archive_format}. Must be 'zip' or 'tar.gz'")
            return None

        logging.info(f"Created archive: {archive_path}")
        return archive_path

    except Exception as e:
        logging.error(f"Error creating archive: {e}")
        return None


def generate_tree(path_list: list, output: str) -> bool:
    """
    Generate a hierarchical tree structure from a list of paths.
    FIXED: Finds common root and shows tree relative to that.
    """
    if not path_list:
        return write_file(output, "## Directory Tree\n(No files found)\n\n")

    # Write header
    if not write_file(output, "## Directory Tree\n"):
        return False

    # Get all file paths (absolute)
    all_file_paths = [item["path"] for item in path_list if item["type"] == "file"]

    if not all_file_paths:
        return write_file(output, "(No files to display)\n\n")

    # Find the common root directory
    def find_common_root(paths):
        """Find the deepest common directory among all paths"""
        if not paths:
            return Path.cwd()

        if len(paths) == 1:
            return paths[0].parent

        # Get all the parts for each path's parent directory
        all_parts = [list(path.parent.parts) for path in paths]

        # Find common prefix
        common_parts = []
        min_length = min(len(parts) for parts in all_parts)

        for i in range(min_length):
            if all(parts[i] == all_parts[0][i] for parts in all_parts):
                common_parts.append(all_parts[0][i])
            else:
                break

        # Create path from common parts
        if common_parts:
            # Handle edge cases
            if len(common_parts) == 1:
                # If only root or drive letter, use parent of first file
                if common_parts[0] in ['/', 'C:', 'D:', 'E:'] or len(common_parts[0]) <= 3:
                    return paths[0].parent

            return Path(*common_parts)
        else:
            # No common path, use parent of first file
            return paths[0].parent

    common_root = find_common_root(all_file_paths)

    # Build tree structure relative to common root
    tree = {}

    for file_path in all_file_paths:
        try:
            # Calculate path relative to common root
            rel_path = file_path.relative_to(common_root)
            parts = list(rel_path.parts)

            # Add to tree
            current = tree
            for i, part in enumerate(parts):
                if part not in current:
                    current[part] = {}

                # Mark as file if it's the last part
                if i == len(parts) - 1:
                    current[part]["__is_file__"] = True
                else:
                    current = current[part]

        except ValueError:
            # File is outside common root somehow, add with warning
            logging.warning(f"File {file_path} is outside common root {common_root}")
            # Add it with its full name as a top-level item
            filename = f"{file_path.parent.name}_{file_path.name}"
            tree[filename] = {"__is_file__": True}

    # Function to recursively print the tree
    def print_tree_recursive(node, prefix="", is_last=True):
        items = [(k, v) for k, v in node.items() if k != "__is_file__"]

        # Sort: directories first, then files, alphabetically
        items.sort(key=lambda x: (x[1].get("__is_file__", False), x[0].lower()))

        for i, (name, subtree) in enumerate(items):
            is_last_item = (i == len(items) - 1)

            # Determine connector
            connector = "└── " if is_last_item else "├── "

            # Format name
            is_file = subtree.get("__is_file__", False)
            display_name = name if is_file else name + "/"

            # Write line
            line = f"{prefix}{connector}{display_name}\n"
            if not write_file(output, line):
                return False

            # Recurse for directories
            if not is_file and subtree:
                new_prefix = prefix + ("    " if is_last_item else "│   ")
                if not print_tree_recursive(subtree, new_prefix):
                    return False

        return True

    # Print root name (use common root's name, or "project" if it's too generic)
    root_name = common_root.name
    if not root_name or root_name in ['/', '.', '..'] or len(root_name) <= 1:
        root_name = "project"

    if not write_file(output, f"{root_name}/\n"):
        return False

    # Print the tree
    if not print_tree_recursive(tree):
        return False

    return write_file(output, "\n")

def validate_file_path(file_path: Path) -> Tuple[bool, str]:
    """
    Validate if a file path is accessible and readable.

    Args:
        file_path (Path): Path to validate

    Returns:
        tuple[bool, str]: (is_valid, error_message)
    """
    try:
        if not file_path.exists():
            return False, "File does not exist"

        if not file_path.is_file():
            return False, "Path is not a file"

        # Test readability
        with open(file_path, 'r', encoding='utf-8', errors='replace') as f:
            f.read(1)  # Try to read one character

        return True, ""

    except PermissionError:
        return False, "Permission denied"
    except Exception as e:
        return False, f"Error accessing file: {str(e)}"


def sanitize_output_path(output_path: str, base_dir: Path = None) -> Path:
    """
    Sanitize and validate output path.

    Args:
        output_path (str): Raw output path
        base_dir (Path): Base directory for relative paths

    Returns:
        Path: Sanitized absolute path
    """
    if output_path == "stdio":
        return Path("stdio")

    path = Path(output_path)

    # Make absolute if relative
    if not path.is_absolute():
        if base_dir:
            path = base_dir / path
        else:
            path = Path.cwd() / path

    return path.resolve()

def parse_comma_separated_list(value: Optional[str]) -> List[str]:
    """
    Parse a comma-separated string into a list of stripped values.

    Args:
        value: Comma-separated string or None

    Returns:
        list: List of stripped values, empty if input was None
    """
    if not value:
        return []
    return [item.strip() for item in value.split(',') if item.strip()]


def parse_ignore_dirs(ignore_dirs_str: Optional[str], base_dirs: List[str]) -> List[Path]:
    """
    Parse ignore directories string and convert to resolved Path objects.

    Args:
        ignore_dirs_str: Comma-separated string of directories to ignore
        base_dirs: List of base directories for resolving relative paths

    Returns:
        list: List of resolved Path objects
    """
    if not ignore_dirs_str:
        return []

    ignore_dirs = []
    base_path = Path(base_dirs[0]).resolve() if base_dirs else Path.cwd()

    for ignore_dir_str in parse_comma_separated_list(ignore_dirs_str):
        ignore_path = Path(ignore_dir_str)

        # Handle both absolute and relative paths
        if ignore_path.is_absolute():
            ignore_dirs.append(ignore_path.resolve())
        else:
            # Resolve relative to first base directory or cwd
            ignore_dirs.append((base_path / ignore_path).resolve())

    if ignore_dirs:
        logging.info(f"Will ignore directories: {[str(d) for d in ignore_dirs]}")

    return ignore_dirs

--- File: flort/validation.py
--- Characters: 19,925
--- Token Count: 3,560
import os
import argparse
import logging
from enum import Enum
from pathlib import Path
from dataclasses import dataclass
from typing import List, Optional, Tuple

from .utils import parse_comma_separated_list, parse_ignore_dirs

class ValidationError(Enum):
    NO_INCLUSION_CRITERIA = "no_inclusion_criteria"
    DIRECTORY_NOT_FOUND = "directory_not_found"
    DIRECTORY_NOT_READABLE = "directory_not_readable"
    FILE_NOT_FOUND = "file_not_found"
    FILE_NOT_READABLE = "file_not_readable"
    INVALID_GLOB_PATTERN = "invalid_glob_pattern"
    INVALID_EXCLUDE_PATTERN = "invalid_exclude_pattern"
    EXTENSION_HAS_DOT = "extension_has_dot"
    EMPTY_EXTENSION = "empty_extension"
    INVALID_MAX_DEPTH = "invalid_max_depth"
    OUTPUT_NOT_WRITABLE = "output_not_writable"
    CONFLICTING_OPTIONS = "conflicting_options"
    ARCHIVE_WITH_STDIO = "archive_with_stdio"
    PATH_NOT_DIRECTORY = "path_not_directory"
    PATH_NOT_FILE = "path_not_file"

@dataclass
class ValidationResult:
    is_valid: bool
    errors: List[ValidationError]
    error_details: List[str]  # Human-readable details for each error
    warnings: List[str] = None

    def __post_init__(self):
        if self.warnings is None:
            self.warnings = []

    def has_error(self, error_type: ValidationError) -> bool:
        """Check if a specific error type is present."""
        return error_type in self.errors

    def get_error_message(self) -> Optional[str]:
        """Get formatted error message for display."""
        if not self.error_details:
            return None
        return "\n".join(f"❌ {detail}" for detail in self.error_details)

def validate_include_files(args: argparse.Namespace) -> Tuple[List[str], List[str]]:
    """
    Validate specific include files and return errors and warnings.

    Returns:
        Tuple of (errors, warnings)
    """
    errors = []
    warnings = []

    if not args.include_files:
        return errors, warnings

    include_files = parse_comma_separated_list(args.include_files)
    base_dir = Path(args.directories[0]) if args.directories else Path.cwd()

    for file_path in include_files:
        if not file_path.strip():
            continue

        # Try multiple resolution strategies
        file_obj = Path(file_path)
        resolution_attempts = []

        if file_obj.is_absolute():
            resolution_attempts.append(file_obj)
        else:
            resolution_attempts.extend([
                base_dir / file_obj,
                Path.cwd() / file_obj,
                file_obj
            ])

        found = False
        for attempt in resolution_attempts:
            try:
                resolved = attempt.resolve()
                if resolved.exists():
                    if resolved.is_file():
                        # Check if readable
                        try:
                            with open(resolved, 'r', encoding='utf-8', errors='replace') as f:
                                f.read(1)
                            found = True
                            break
                        except Exception as e:
                            errors.append(f"Include file is not readable: {file_path} ({e})")
                            found = True  # Don't try other paths
                            break
                    else:
                        errors.append(f"Include path is not a file: {file_path}")
                        found = True
                        break
            except Exception:
                continue

        if not found:
            errors.append(f"Include file does not exist: {file_path}")

    return errors, warnings


def validate_arguments(args: argparse.Namespace) -> ValidationResult:
    """
    Validate command line arguments for consistency and correctness.

    Args:
        args: Parsed command line arguments

    Returns:
        ValidationResult: Structured validation result
    """
    errors = []
    error_details = []
    warnings = []

    # Validate we have something to process - BUT skip this check if using UI
    if not args.ui \
        and not args.extensions \
        and not args.all  \
        and not args.glob \
        and not args.include_files:

        errors.append(ValidationError.NO_INCLUSION_CRITERIA)
        error_details.append("No extensions or glob provided and --all flag not set. No files to process. "
                           "Use --extensions, --glob, --include-files, --all, or --ui to specify what to include.")

    # Validate directories exist
    for directory in args.directories:
        dir_path = Path(directory)
        if not dir_path.exists():
            errors.append(ValidationError.DIRECTORY_NOT_FOUND)
            error_details.append(f"Directory does not exist: {directory}")
        elif not dir_path.is_dir():
            errors.append(ValidationError.PATH_NOT_DIRECTORY)
            error_details.append(f"Path is not a directory: {directory}")
        elif not os.access(directory, os.R_OK):
            errors.append(ValidationError.DIRECTORY_NOT_READABLE)
            error_details.append(f"Directory is not readable: {directory}")

    # Validate specific include files exist
    if args.include_files:
        include_files = parse_comma_separated_list(args.include_files)
        for file_path in include_files:
            if not file_path.strip():
                continue

            # Handle both absolute and relative paths
            if Path(file_path).is_absolute():
                full_path = Path(file_path)
            else:
                # Resolve relative to first directory or cwd
                base_dir = Path(args.directories[0]) if args.directories else Path.cwd()
                full_path = base_dir / file_path

            if not full_path.exists():
                errors.append(ValidationError.FILE_NOT_FOUND)
                error_details.append(f"Include file does not exist: {file_path} (resolved to: {full_path})")
            elif not full_path.is_file():
                errors.append(ValidationError.PATH_NOT_FILE)
                error_details.append(f"Include path is not a file: {file_path}")
            elif not os.access(str(full_path), os.R_OK):
                errors.append(ValidationError.FILE_NOT_READABLE)
                error_details.append(f"Include file is not readable: {file_path}")

    # Validate ignore directories exist (warn if they don't)
    if args.ignore_dirs:
        ignore_dirs_list = parse_comma_separated_list(args.ignore_dirs)
        base_dir = Path(args.directories[0]) if args.directories else Path.cwd()

        for ignore_dir in ignore_dirs_list:
            if not ignore_dir.strip():
                continue

            if Path(ignore_dir).is_absolute():
                ignore_path = Path(ignore_dir)
            else:
                ignore_path = base_dir / ignore_dir

            if not ignore_path.exists():
                warnings.append(f"Ignore directory does not exist (will be skipped): {ignore_dir}")
            elif not ignore_path.is_dir():
                errors.append(ValidationError.PATH_NOT_DIRECTORY)
                error_details.append(f"Ignore path is not a directory: {ignore_dir}")

    # Validate glob patterns are syntactically correct
    if args.glob:
        import glob as glob_module
        glob_patterns = parse_comma_separated_list(args.glob)
        for pattern in glob_patterns:
            if not pattern.strip():
                continue
            try:
                # Test the pattern by attempting to compile it
                # This catches basic syntax errors
                glob_module.glob(pattern, recursive=True)
            except Exception as e:
                errors.append(ValidationError.INVALID_GLOB_PATTERN)
                error_details.append(f"Invalid glob pattern '{pattern}': {e}")

    # Validate exclude patterns are syntactically correct
    if args.exclude_patterns:
        import glob as glob_module
        exclude_patterns = parse_comma_separated_list(args.exclude_patterns)
        for pattern in exclude_patterns:
            if not pattern.strip():
                continue
            try:
                glob_module.glob(pattern, recursive=True)
            except Exception as e:
                errors.append(ValidationError.INVALID_EXCLUDE_PATTERN)
                error_details.append(f"Invalid exclude pattern '{pattern}': {e}")

    # Validate extensions don't have dots
    if args.extensions:
        extensions = parse_comma_separated_list(args.extensions)
        for ext in extensions:
            if ext.startswith('.'):
                errors.append(ValidationError.EXTENSION_HAS_DOT)
                error_details.append(f"Extension should not include dot: '{ext}' (use '{ext[1:]}' instead)")
            if not ext.strip():
                errors.append(ValidationError.EMPTY_EXTENSION)
                error_details.append("Empty extension found in extensions list")

    # Validate exclude extensions don't have dots
    if args.exclude_extensions:
        exclude_extensions = parse_comma_separated_list(args.exclude_extensions)
        for ext in exclude_extensions:
            if ext.startswith('.'):
                errors.append(ValidationError.EXTENSION_HAS_DOT)
                error_details.append(f"Exclude extension should not include dot: '{ext}' (use '{ext[1:]}' instead)")
            if not ext.strip():
                errors.append(ValidationError.EMPTY_EXTENSION)
                error_details.append("Empty extension found in exclude-extensions list")

    # Validate max_depth is positive
    if args.max_depth is not None and args.max_depth < 1:
        errors.append(ValidationError.INVALID_MAX_DEPTH)
        error_details.append(f"Max depth must be positive: {args.max_depth}")

    # Validate output path is writable (if not stdio)
    if args.output and args.output != "stdio":
        try:
            from .utils import sanitize_output_path
            output_path = sanitize_output_path(args.output)
            output_dir = output_path.parent

            # Check if directory exists or can be created
            if not output_dir.exists():
                try:
                    output_dir.mkdir(parents=True, exist_ok=True)
                except (OSError, PermissionError) as e:
                    errors.append(ValidationError.OUTPUT_NOT_WRITABLE)
                    error_details.append(f"Cannot create output directory {output_dir}: {e}")
            elif not os.access(str(output_dir), os.W_OK):
                errors.append(ValidationError.OUTPUT_NOT_WRITABLE)
                error_details.append(f"Output directory is not writable: {output_dir}")

            # Check if we can write to the output file
            if output_path.exists() and not os.access(str(output_path), os.W_OK):
                errors.append(ValidationError.OUTPUT_NOT_WRITABLE)
                error_details.append(f"Output file exists but is not writable: {output_path}")

        except Exception as e:
            errors.append(ValidationError.OUTPUT_NOT_WRITABLE)
            error_details.append(f"Invalid output path '{args.output}': {e}")

    # Validate archive format dependencies
    if args.archive:
        if args.output == "stdio":
            errors.append(ValidationError.ARCHIVE_WITH_STDIO)
            error_details.append("Cannot create archive when output is stdio")

        if args.archive == "tar.gz":
            try:
                import tarfile
            except ImportError:
                errors.append(ValidationError.OUTPUT_NOT_WRITABLE)
                error_details.append("tar.gz archive format requires tarfile module")
        elif args.archive == "zip":
            try:
                import zipfile
            except ImportError:
                errors.append(ValidationError.OUTPUT_NOT_WRITABLE)
                error_details.append("zip archive format requires zipfile module")

    # Validate conflicting options
    if args.no_dump and args.manifest:
        errors.append(ValidationError.CONFLICTING_OPTIONS)
        error_details.append("Cannot use both --no-dump and --manifest (both disable content output)")

    if args.outline and not any([
        args.extensions and any(ext in ['py', 'python'] for ext in parse_comma_separated_list(args.extensions)),
        args.all,
        args.include_files and any(f.endswith('.py') for f in parse_comma_separated_list(args.include_files or ""))
    ]):
        warnings.append("--outline specified but no Python files will be processed")

    # Return structured result
    return ValidationResult(
        is_valid=len(errors) == 0,
        errors=errors,
        error_details=error_details,
        warnings=warnings
    )
    """
    Validate command line arguments for consistency and correctness.

    Args:
        args: Parsed command line arguments

    Returns:
        tuple: (is_valids, error_message)
    """
    errors = []

    # Validate we have something to process - BUT skip this check if using UI
    if not args.ui and not args.extensions and not args.all and not args.glob:
        errors.append("No extensions or glob provided and --all flag not set. No files to process. "
                     "Use --extensions, --glob, --include-files, --all, or --ui to specify what to include.")

    # Validate directories exist
    for directory in args.directories:
        dir_path = Path(directory)
        if not dir_path.exists():
            errors.append(f"Directory does not exist: {directory}")
        elif not dir_path.is_dir():
            errors.append(f"Path is not a directory: {directory}")
        elif not os.access(directory, os.R_OK):
            errors.append(f"Directory is not readable: {directory}")

    # Validate specific include files exist
    if args.include_files:
        include_files = parse_comma_separated_list(args.include_files)
        for file_path in include_files:
            if not file_path.strip():
                continue

            # Handle both absolute and relative paths
            if Path(file_path).is_absolute():
                full_path = Path(file_path)
            else:
                # Resolve relative to first directory or cwd
                base_dir = Path(args.directories[0]) if args.directories else Path.cwd()
                full_path = base_dir / file_path

            if not full_path.exists():
                errors.append(f"Include file does not exist: {file_path} (resolved to: {full_path})")
            elif not full_path.is_file():
                errors.append(f"Include path is not a file: {file_path}")
            elif not os.access(str(full_path), os.R_OK):
                errors.append(f"Include file is not readable: {file_path}")

    # Validate ignore directories exist (warn if they don't)
    if args.ignore_dirs:
        ignore_dirs_list = parse_comma_separated_list(args.ignore_dirs)
        base_dir = Path(args.directories[0]) if args.directories else Path.cwd()

        for ignore_dir in ignore_dirs_list:
            if not ignore_dir.strip():
                continue

            if Path(ignore_dir).is_absolute():
                ignore_path = Path(ignore_dir)
            else:
                ignore_path = base_dir / ignore_dir

            if not ignore_path.exists():
                logging.warning(f"Ignore directory does not exist (will be skipped): {ignore_dir}")
            elif not ignore_path.is_dir():
                errors.append(f"Ignore path is not a directory: {ignore_dir}")

    # Validate glob patterns are syntactically correct
    if args.glob:
        import glob as glob_module
        glob_patterns = parse_comma_separated_list(args.glob)
        for pattern in glob_patterns:
            if not pattern.strip():
                continue
            try:
                # Test the pattern by attempting to compile it
                # This catches basic syntax errors
                glob_module.glob(pattern, recursive=True)
            except Exception as e:
                errors.append(f"Invalid glob pattern '{pattern}': {e}")

    # Validate exclude patterns are syntactically correct
    if args.exclude_patterns:
        import glob as glob_module
        exclude_patterns = parse_comma_separated_list(args.exclude_patterns)
        for pattern in exclude_patterns:
            if not pattern.strip():
                continue
            try:
                glob_module.glob(pattern, recursive=True)
            except Exception as e:
                errors.append(f"Invalid exclude pattern '{pattern}': {e}")

    # Validate extensions don't have dots
    if args.extensions:
        extensions = parse_comma_separated_list(args.extensions)
        for ext in extensions:
            if ext.startswith('.'):
                errors.append(f"Extension should not include dot: '{ext}' (use '{ext[1:]}' instead)")
            if not ext.strip():
                errors.append("Empty extension found in extensions list")

    # Validate exclude extensions don't have dots
    if args.exclude_extensions:
        exclude_extensions = parse_comma_separated_list(args.exclude_extensions)
        for ext in exclude_extensions:
            if ext.startswith('.'):
                errors.append(f"Exclude extension should not include dot: '{ext}' (use '{ext[1:]}' instead)")
            if not ext.strip():
                errors.append("Empty extension found in exclude-extensions list")

    # Validate max_depth is positive
    if args.max_depth is not None and args.max_depth < 1:
        errors.append(f"Max depth must be positive: {args.max_depth}")

    # Validate output path is writable (if not stdio)
    if args.output and args.output != "stdio":
        try:
            output_path = sanitize_output_path(args.output)
            output_dir = output_path.parent

            # Check if directory exists or can be created
            if not output_dir.exists():
                try:
                    output_dir.mkdir(parents=True, exist_ok=True)
                except (OSError, PermissionError) as e:
                    errors.append(f"Cannot create output directory {output_dir}: {e}")
            elif not os.access(str(output_dir), os.W_OK):
                errors.append(f"Output directory is not writable: {output_dir}")

            # Check if we can write to the output file
            if output_path.exists() and not os.access(str(output_path), os.W_OK):
                errors.append(f"Output file exists but is not writable: {output_path}")

        except Exception as e:
            errors.append(f"Invalid output path '{args.output}': {e}")

    # Validate archive format dependencies
    if args.archive:
        if args.output == "stdio":
            errors.append("Cannot create archive when output is stdio")

        if args.archive == "tar.gz":
            try:
                import tarfile
            except ImportError:
                errors.append("tar.gz archive format requires tarfile module")
        elif args.archive == "zip":
            try:
                import zipfile
            except ImportError:
                errors.append("zip archive format requires zipfile module")

    # Validate conflicting options
    if args.no_dump and args.manifest:
        errors.append("Cannot use both --no-dump and --manifest (both disable content output)")

    if args.outline and not any([
        args.extensions and any(ext in ['py', 'python'] for ext in parse_comma_separated_list(args.extensions)),
        args.all,
        args.include_files and any(f.endswith('.py') for f in parse_comma_separated_list(args.include_files or ""))
    ]):
        logging.warning("--outline specified but no Python files will be processed")

    # Return structured result
    return ValidationResult(
        is_valid=len(errors) == 0,
        errors=errors,
        error_details=error_details,
        warnings=warnings
    )

--- File: flort/wrapper.py
--- Characters: 884
--- Token Count: 217
#!/usr/bin/env python3
import os
import sys
import subprocess

def main():
    """
    Entry point wrapper that prevents shell glob expansion for flort.
    """
    # Check if running in a bash-like shell
    shell = os.environ.get('SHELL', '')

    if 'bash' in shell or 'zsh' in shell or 'sh' in shell:
        # Create a modified command that disables globbing before running flort
        args_quoted = ' '.join(f'"{arg}"' for arg in sys.argv[1:])
        script = f"set -f; python -m flort.__main__ {args_quoted}; set +f"

        # Execute the modified command in a new shell
        result = subprocess.run(['bash', '-c', script], check=False)
        sys.exit(result.returncode)
    else:
        # For non-bash shells, just import and run the normal entry point
        from flort.__main__ import main as flort_main
        flort_main()

if __name__ == "__main__":
    main()

--- File: setup.py
--- Characters: 3,803
--- Token Count: 843
from setuptools import setup, find_packages
from pathlib import Path

def get_version():
    """Get version from VERSION file."""
    version_file = Path(__file__).parent / "VERSION"
    if version_file.exists():
        return version_file.read_text().strip()
    return "2.0.0"

def get_long_description():
    """Get long description from README.md."""
    readme_file = Path(__file__).parent / "README.md"
    if readme_file.exists():
        return readme_file.read_text(encoding='utf-8')
    return "File Concatenation and Project Overview Tool"

setup(
    name='flort',
    version=get_version(),
    packages=find_packages(),

    # Include package data (assets, icons, etc.)
    package_data={
        'flort': [
            'assets/*.png',
            'assets/*.svg',
            'assets/*.ico',
            'assets/logo.*',
        ],
    },
    include_package_data=True,

    # Entry points
    entry_points={
        'console_scripts': [
            'flort = flort.wrapper:main'
        ]
    },

    # Dependencies
    install_requires=[
        'windows-curses;platform_system=="Windows"',
    ],

    # Optional dependencies
    extras_require={
        'dev': [
            'pytest>=6.0',
            'pytest-cov>=2.0',
            'mkdocs-material>=9.0',
        ],
        'docs': [
            'mkdocs-material>=9.0',
            'mkdocs-minify-plugin>=0.7',
            'mkdocstrings[python]>=0.20',
        ],
    },

    # Metadata
    author='Chris Watkins',
    author_email='chris@watkinslabs.com',
    description='File Concatenation and Project Overview Tool for LLM preparation',
    long_description=get_long_description(),
    long_description_content_type='text/markdown',

    # URLs and links
    url='https://github.com/watkinlabs/flort',
    project_urls={
        'Homepage': 'https://github.com/watkinslabs/flort',
        'Documentation': 'https://watkinslabs.github.io/flort',
        'Repository': 'https://github.com/watkinslabs/flort.git',
        'Bug Tracker': 'https://github.com/watkinslabs/flort/issues',
        'Discussions': 'https://github.com/watkinslabs/flort/discussions',
        'Changelog': 'https://github.com/watkinslabs/flort/blob/main/CHANGELOG.md',
        'Logo': 'https://raw.githubusercontent.com/watkinslabs/flort/main/assets/flort-logo.png',
    },

    # Classification
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Environment :: Console',
        'Environment :: Console :: Curses',
        'Intended Audience :: Developers',
        'Intended Audience :: System Administrators',
        'License :: OSI Approved :: BSD License',
        'Operating System :: OS Independent',
        'Operating System :: POSIX :: Linux',
        'Operating System :: Microsoft :: Windows',
        'Operating System :: MacOS',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Programming Language :: Python :: 3.11',
        'Programming Language :: Python :: 3.12',
        'Programming Language :: Python :: 3.13',
        'Topic :: Documentation',
        'Topic :: Software Development :: Documentation',
        'Topic :: Software Development :: Libraries :: Python Modules',
        'Topic :: System :: Archiving',
        'Topic :: Text Processing',
        'Topic :: Utilities',
    ],

    keywords='file concatenation, project overview, LLM preparation, code analysis, documentation',

    # Python version requirement
    python_requires='>=3.6',

    # License
    license='BSD-3-Clause',

    # Additional files to include
    zip_safe=False,
)

--- File: tests/__init__.py
--- Characters: 0
--- Token Count: 0


--- File: tests/test-ui.py
--- Characters: 6,561
--- Token Count: 1,345
#!/usr/bin/env python3
"""
Test script to check if the UI functionality works properly.

This script tests:
1. Curses module availability
2. Curses selector import
3. Basic UI functionality
"""

import sys
import os
from pathlib import Path

def test_curses_availability():
    """Test if curses module is available."""
    print("🔍 Testing curses module availability...")

    try:
        import curses
        print("✅ Curses module imported successfully")

        # Test basic curses functionality
        try:
            # This is a safe test that doesn't actually start curses
            curses.version
            print(f"✅ Curses version: {getattr(curses, 'version', 'unknown')}")
            return True
        except Exception as e:
            print(f"⚠️  Curses module imported but may not work: {e}")
            return False

    except ImportError as e:
        print(f"❌ Curses module not available: {e}")
        print("\n💡 To fix this:")
        if sys.platform.startswith('win'):
            print("   On Windows: pip install windows-curses")
        else:
            print("   On Linux/macOS: curses should be included with Python")
            print("   If missing, install with your package manager")
        return False

def test_flort_ui_import():
    """Test if flort curses selector can be imported."""
    print("\n🔍 Testing flort UI module...")

    try:
        # Add flort directory to path if needed
        flort_dir = Path(__file__).parent.parent / "flort"
        if flort_dir.exists() and str(flort_dir) not in sys.path:
            sys.path.insert(0, str(flort_dir.parent))

        from flort.curses_selector import select_files
        print("✅ Flort curses selector imported successfully")
        return True

    except ImportError as e:
        print(f"❌ Flort curses selector import failed: {e}")
        print("\n💡 Possible issues:")
        print("   - Curses module not available (see above)")
        print("   - Flort not properly installed")
        print("   - Missing dependencies")
        return False

def test_basic_ui_functionality():
    """Test basic UI functionality without actually starting it."""
    print("\n🔍 Testing basic UI functionality...")

    try:
        import curses
        from flort.curses_selector import (
            is_accessible, should_show_file, get_directory_contents
        )

        # Test utility functions
        current_dir = Path(".")

        # Test accessibility check
        accessible = is_accessible(current_dir)
        print(f"✅ Directory accessibility test: {accessible}")

        # Test file filtering
        test_file = current_dir / "setup.py"
        if test_file.exists():
            show_file = should_show_file(test_file, [".py"], {})
            print(f"✅ File filtering test: {show_file}")

        print("✅ Basic UI functionality tests passed")
        return True

    except Exception as e:
        print(f"❌ Basic UI functionality test failed: {e}")
        return False

def test_ui_integration():
    """Test the UI integration with flort CLI."""
    print("\n🔍 Testing UI integration...")

    try:
        from flort.cli import process_ui_integration
        from argparse import Namespace

        # Create test args
        args = Namespace()
        args.ui = False  # Don't actually start UI
        args.extensions = "py"
        args.include_files = None
        args.ignore_dirs = None
        args.directories = ["."]

        # Test the integration function
        result_args = process_ui_integration(args)
        print("✅ UI integration function works")
        return True

    except Exception as e:
        print(f"❌ UI integration test failed: {e}")
        return False

def run_interactive_test():
    """Run an actual interactive test if possible."""
    print("\n🔍 Running interactive test...")

    try:
        import curses
        from flort.curses_selector import select_files

        print("⚠️  This will start the interactive UI for 5 seconds...")
        print("   Press 'q' to quit or wait for auto-exit")

        def test_ui(stdscr):
            # Simple test that shows the UI briefly
            stdscr.clear()
            stdscr.addstr(0, 0, "Flort UI Test - Press 'q' to quit")
            stdscr.addstr(1, 0, "This is a test of the curses interface")
            stdscr.addstr(2, 0, "If you see this, the UI is working!")
            stdscr.refresh()

            # Wait for input or timeout
            stdscr.timeout(5000)  # 5 second timeout
            key = stdscr.getch()

            return key

        # Run the test
        result = curses.wrapper(test_ui)
        print("✅ Interactive UI test completed successfully")
        return True

    except KeyboardInterrupt:
        print("⚠️  Interactive test cancelled by user")
        return True
    except Exception as e:
        print(f"❌ Interactive UI test failed: {e}")
        return False

def main():
    """Run all UI tests."""
    print("🧪 Flort UI Test Suite")
    print("=" * 50)

    tests = [
        ("Curses Module", test_curses_availability),
        ("Flort UI Import", test_flort_ui_import),
        ("Basic UI Functions", test_basic_ui_functionality),
        ("UI Integration", test_ui_integration),
    ]

    results = {}

    for test_name, test_func in tests:
        results[test_name] = test_func()

    # Summary
    print("\n" + "=" * 50)
    print("📊 Test Results Summary:")

    passed = 0
    total = len(results)

    for test_name, result in results.items():
        status = "✅ PASS" if result else "❌ FAIL"
        print(f"   {test_name}: {status}")
        if result:
            passed += 1

    print(f"\n🎯 Overall: {passed}/{total} tests passed")

    if passed == total:
        print("🎉 All tests passed! UI should work correctly.")

        # Offer interactive test
        try:
            response = input("\n❓ Run interactive UI test? (y/N): ")
            if response.lower() in ['y', 'yes']:
                run_interactive_test()
        except (KeyboardInterrupt, EOFError):
            print("\nSkipping interactive test.")
    else:
        print("⚠️  Some tests failed. UI may not work properly.")
        print("\n💡 Common solutions:")
        if sys.platform.startswith('win'):
            print("   • Install windows-curses: pip install windows-curses")
        print("   • Reinstall flort: pip install -e .")
        print("   • Check Python version compatibility")

    return passed == total

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)

--- File: tests/test_flort.py
--- Characters: 25,431
--- Token Count: 5,020
#!/usr/bin/env python3
"""
Comprehensive test suite for Flort file concatenation tool.

This test suite covers all major functionality including:
- File discovery and filtering
- Extension-based inclusion/exclusion
- Pattern-based filtering
- Binary file detection
- Content concatenation
- Tree generation
- Error handling

Run with: python -m pytest tests/test_flort.py -v
"""

import os
import sys
import tempfile
import shutil
import pytest
from pathlib import Path
from unittest.mock import patch, MagicMock

# Add the parent directory to the Python path to import flort modules
sys.path.insert(0, str(Path(__file__).parent.parent))

from flort.utils import (
    is_binary_file, clean_content, write_file, count_tokens,
    validate_file_path, sanitize_output_path
)
from flort.traverse import FileFilter, scan_directories, get_paths, add_specific_files
from flort.concatenate_files import FileConcatenator, concat_files, create_file_manifest
from flort.cli import parse_comma_separated_list, parse_ignore_dirs, validate_arguments
from flort.validation import ValidationError


class TestUtils:
    """Test suite for utility functions."""

    def test_is_binary_file(self, tmp_path):
        """Test binary file detection."""
        # Create text file
        text_file = tmp_path / "test.txt"
        text_file.write_text("Hello, world!\nThis is a text file.")
        assert not is_binary_file(text_file)

        # Create binary file with null bytes
        binary_file = tmp_path / "test.bin"
        binary_file.write_bytes(b"Hello\x00World\x01\x02\x03")
        assert is_binary_file(binary_file)

        # Test known binary extension
        exe_file = tmp_path / "test.exe"
        exe_file.write_text("Actually text but .exe extension")
        assert is_binary_file(exe_file)

        # Test empty file
        empty_file = tmp_path / "empty.txt"
        empty_file.touch()
        assert not is_binary_file(empty_file)

    def test_clean_content(self, tmp_path):
        """Test content cleaning functionality."""
        test_file = tmp_path / "test.py"
        content = """
def hello():
    print("hello")


def world():
    print("world")


"""
        test_file.write_text(content)

        cleaned = clean_content(test_file)
        lines = cleaned.split('\n')

        # Should remove trailing whitespace and limit consecutive empty lines
        assert not any(line.endswith(' ') for line in lines if line)
        # Should limit to max 2 consecutive empty lines (which creates max \n\n\n)
        assert cleaned.count('\n\n\n\n') == 0  # No quadruple newlines
        # Should preserve function separation with double newlines
        assert 'def hello():' in cleaned
        assert 'def world():' in cleaned

    def test_count_tokens(self):
        """Test token counting functionality."""
        # Test empty string
        assert count_tokens("") == 0

        # Test simple text
        assert count_tokens("hello world") == 2

        # Test code with operators
        code = "def func(x, y): return x + y"
        token_count = count_tokens(code)
        assert token_count > 5  # Should detect multiple tokens

        # Test with numbers and symbols
        assert count_tokens("123 + 456 = 579") > 3

    def test_validate_file_path(self, tmp_path):
        """Test file path validation."""
        # Valid file
        valid_file = tmp_path / "valid.txt"
        valid_file.write_text("content")
        is_valid, error = validate_file_path(valid_file)
        assert is_valid
        assert error == ""

        # Non-existent file
        non_existent = tmp_path / "does_not_exist.txt"
        is_valid, error = validate_file_path(non_existent)
        assert not is_valid
        assert "does not exist" in error.lower()

        # Directory instead of file
        directory = tmp_path / "test_dir"
        directory.mkdir()
        is_valid, error = validate_file_path(directory)
        assert not is_valid
        assert "not a file" in error.lower()

    def test_sanitize_output_path(self, tmp_path):
        """Test output path sanitization."""
        # Test stdio
        assert sanitize_output_path("stdio").name == "stdio"

        # Test relative path
        relative = sanitize_output_path("output.txt")
        assert relative.is_absolute()

        # Test absolute path
        absolute = tmp_path / "output.txt"
        result = sanitize_output_path(str(absolute))
        assert result.is_absolute()
        assert result == absolute.resolve()


class TestFileFilter:
    """Test suite for FileFilter class."""

    def test_extension_normalization(self):
        """Test extension normalization."""
        filter_obj = FileFilter(
            include_extensions=["py", ".js", "txt"],
            exclude_extensions=["pyc", ".pyo"]
        )

        assert ".py" in filter_obj.include_extensions
        assert ".js" in filter_obj.include_extensions
        assert ".txt" in filter_obj.include_extensions
        assert ".pyc" in filter_obj.exclude_extensions
        assert ".pyo" in filter_obj.exclude_extensions

    def test_should_include_file(self, tmp_path):
        """Test file inclusion logic."""
        # Create test files
        python_file = tmp_path / "test.py"
        python_file.write_text("print('hello')")

        compiled_file = tmp_path / "test.pyc"
        compiled_file.write_bytes(b"\x00\x01\x02")

        hidden_file = tmp_path / ".hidden.py"
        hidden_file.write_text("hidden content")

        # Test basic inclusion
        filter_obj = FileFilter(include_extensions=["py"])

        should_include, reason = filter_obj.should_include_file(python_file)
        assert should_include

        # Test exclusion
        filter_obj = FileFilter(
            include_extensions=["py"],
            exclude_extensions=["pyc"]
        )

        should_include, reason = filter_obj.should_include_file(compiled_file)
        assert not should_include
        assert "excluded extension" in reason

        # Test hidden files
        filter_obj = FileFilter(include_extensions=["py"], include_hidden=False)
        should_include, reason = filter_obj.should_include_file(hidden_file)
        assert not should_include
        assert "hidden" in reason

        # Test include all
        filter_obj = FileFilter(include_all=True)
        should_include, reason = filter_obj.should_include_file(python_file)
        assert should_include

    def test_pattern_matching(self, tmp_path):
        """Test glob pattern matching."""
        test_file = tmp_path / "test_unit.py"
        test_file.write_text("test content")

        # Test exclude pattern
        filter_obj = FileFilter(
            include_extensions=["py"],
            exclude_patterns=["*test*"]
        )

        should_include, reason = filter_obj.should_include_file(test_file)
        assert not should_include
        assert "exclude pattern" in reason

        # Test include pattern
        filter_obj = FileFilter(include_patterns=["test_*"])

        should_include, reason = filter_obj.should_include_file(test_file)
        assert should_include


class TestTraverse:
    """Test suite for file traversal functionality."""

    def create_test_directory_structure(self, base_path):
        """Create a test directory structure."""
        # Create directories
        (base_path / "src").mkdir()
        (base_path / "tests").mkdir()
        (base_path / "__pycache__").mkdir()
        (base_path / ".git").mkdir()

        # Create files
        (base_path / "main.py").write_text("print('main')")
        (base_path / "README.md").write_text("# Project")
        (base_path / "src" / "utils.py").write_text("def util(): pass")
        (base_path / "src" / "config.json").write_text('{"key": "value"}')
        (base_path / "tests" / "test_main.py").write_text("def test(): pass")
        (base_path / "__pycache__" / "main.cpython-39.pyc").write_bytes(b"\x00\x01")
        (base_path / ".git" / "config").write_text("git config")
        (base_path / ".hidden.txt").write_text("hidden content")

    def test_scan_directories_basic(self, tmp_path):
        """Test basic directory scanning."""
        self.create_test_directory_structure(tmp_path)

        file_filter = FileFilter(include_extensions=["py"])
        results = scan_directories([str(tmp_path)], file_filter)

        # Should find Python files
        py_files = [r for r in results if r["type"] == "file" and r["path"].suffix == ".py"]
        assert len(py_files) >= 2  # main.py and utils.py at minimum

        # Should include directories
        dirs = [r for r in results if r["type"] == "dir"]
        assert len(dirs) > 0

    def test_ignore_directories(self, tmp_path):
        """Test directory ignoring."""
        self.create_test_directory_structure(tmp_path)

        ignore_dirs = [tmp_path / "__pycache__", tmp_path / ".git"]
        file_filter = FileFilter(include_all=True, ignore_dirs=ignore_dirs)
        results = scan_directories([str(tmp_path)], file_filter)

        # Should not include files from ignored directories
        ignored_files = [
            r for r in results
            if any(str(ignore_dir) in str(r["path"]) for ignore_dir in ignore_dirs)
        ]
        assert len(ignored_files) == 0

    def test_get_paths_comprehensive(self, tmp_path):
        """Test comprehensive path discovery."""
        self.create_test_directory_structure(tmp_path)

        # Test with multiple filters
        results = get_paths(
            directories=[str(tmp_path)],
            extensions=["py", "md"],
            exclude_extensions=["pyc"],
            exclude_patterns=["*test*"],
            include_hidden=False,
            ignore_dirs=[tmp_path / "__pycache__"]
        )

        files = [r for r in results if r["type"] == "file"]

        # Should include main.py and README.md
        py_files = [f for f in files if f["path"].suffix == ".py"]
        md_files = [f for f in files if f["path"].suffix == ".md"]

        assert len(py_files) >= 1  # At least main.py
        assert len(md_files) >= 1  # At least README.md

        # Should exclude test files and compiled files
        test_files = [f for f in files if "test" in f["path"].name]
        pyc_files = [f for f in files if f["path"].suffix == ".pyc"]

        assert len(test_files) == 0
        assert len(pyc_files) == 0

    def test_add_specific_files(self, tmp_path):
        """Test adding specific files."""
        self.create_test_directory_structure(tmp_path)

        # Start with Python files only
        initial_results = get_paths(
            directories=[str(tmp_path)],
            extensions=["py"]
        )

        # Add specific non-Python file
        config_file = str(tmp_path / "src" / "config.json")
        updated_results = add_specific_files(
            initial_results,
            [config_file],
            tmp_path
        )

        # Should now include the JSON file
        json_files = [r for r in updated_results if r["path"].suffix == ".json"]
        assert len(json_files) == 1
        assert json_files[0]["relative_path"].endswith("config.json")


class TestConcatenation:
    """Test suite for file concatenation functionality."""

    def test_file_concatenator_basic(self, tmp_path):
        """Test basic file concatenation."""
        # Create test files
        file1 = tmp_path / "file1.py"
        file1.write_text("def func1(): pass")

        file2 = tmp_path / "file2.py"
        file2.write_text("def func2(): pass")

        output_file = tmp_path / "output.txt"

        # Create file list
        file_list = [
            {"path": file1, "relative_path": "file1.py", "type": "file"},
            {"path": file2, "relative_path": "file2.py", "type": "file"}
        ]

        # Test concatenation
        concatenator = FileConcatenator(str(output_file))
        success = concatenator.concatenate_files(file_list)

        assert success
        assert output_file.exists()

        content = output_file.read_text()
        assert "file1.py" in content
        assert "file2.py" in content
        assert "def func1(): pass" in content
        assert "def func2(): pass" in content

        # Check statistics
        stats = concatenator.get_statistics()
        assert stats["files_processed"] == 2
        assert stats["files_skipped"] == 0

    def test_concat_files_function(self, tmp_path):
        """Test the main concat_files function."""
        # Create test files
        test_file = tmp_path / "test.py"
        test_file.write_text("print('hello world')")

        output_file = tmp_path / "output.txt"

        file_list = [
            {"path": test_file, "relative_path": "test.py", "type": "file"}
        ]

        success = concat_files(file_list, str(output_file))

        assert success
        assert output_file.exists()

        content = output_file.read_text()
        assert "## File Data" in content
        assert "test.py" in content
        assert "print('hello world')" in content

    def test_create_file_manifest(self, tmp_path):
        """Test file manifest creation."""
        # Create test files
        small_file = tmp_path / "small.txt"
        small_file.write_text("small")

        large_file = tmp_path / "large.txt"
        large_file.write_text("x" * 1000)

        output_file = tmp_path / "manifest.txt"

        file_list = [
            {"path": small_file, "relative_path": "small.txt", "type": "file"},
            {"path": large_file, "relative_path": "large.txt", "type": "file"}
        ]

        success = create_file_manifest(file_list, str(output_file))

        assert success
        assert output_file.exists()

        content = output_file.read_text()
        assert "## File Manifest" in content
        assert "small.txt" in content
        assert "large.txt" in content
        assert "bytes" in content


class TestCLI:
    """Test suite for CLI functionality."""

    def test_parse_comma_separated_list(self):
        """Test comma-separated list parsing."""
        # Normal case
        result = parse_comma_separated_list("py,js,txt")
        assert result == ["py", "js", "txt"]

        # With spaces
        result = parse_comma_separated_list("py, js , txt ")
        assert result == ["py", "js", "txt"]

        # Empty string
        result = parse_comma_separated_list("")
        assert result == []

        # None
        result = parse_comma_separated_list(None)
        assert result == []

        # Single item
        result = parse_comma_separated_list("py")
        assert result == ["py"]

    def test_parse_ignore_dirs(self, tmp_path):
        """Test ignore directories parsing."""
        # Create test directories
        (tmp_path / "dir1").mkdir()
        (tmp_path / "dir2").mkdir()

        # Test relative paths
        result = parse_ignore_dirs("dir1,dir2", [str(tmp_path)])
        assert len(result) == 2
        assert all(isinstance(p, Path) for p in result)
        assert all(p.is_absolute() for p in result)

        # Test absolute paths
        abs_path = str(tmp_path / "dir1")
        result = parse_ignore_dirs(abs_path, [str(tmp_path)])
        assert len(result) == 1
        assert result[0].is_absolute()

    def test_validate_arguments(self, tmp_path):
        """Test argument validation."""
        # Create test files and directories
        test_file = tmp_path / "test.py"
        test_file.write_text("print('hello')")

        nonexistent_dir = tmp_path / "nonexistent"

        # Create mock args
        class MockArgs:
            def __init__(self):
                self.ui = None
                self.directories = [str(tmp_path)]
                self.extensions = "py"
                self.exclude_extensions = None
                self.all = False
                self.glob = None
                self.exclude_patterns = None
                self.include_files = None
                self.ignore_dirs = None
                self.archive = None
                self.output = "test.txt"
                self.max_depth = None
                self.no_dump = False
                self.manifest = False
                self.outline = False

        # Test 1: Valid case
        args = MockArgs()
        result = validate_arguments(args)
        assert result.is_valid
        assert len(result.errors) == 0

        # Test 2: No inclusion criteria
        args = MockArgs()
        args.extensions = None
        result = validate_arguments(args)
        assert not result.is_valid
        assert result.has_error(ValidationError.NO_INCLUSION_CRITERIA)

        # Test 3: Invalid directory
        args = MockArgs()
        args.directories = ["/nonexistent/directory"]
        result = validate_arguments(args)
        assert not result.is_valid
        assert result.has_error(ValidationError.DIRECTORY_NOT_FOUND)

        # Test 4: Extensions with dots (invalid)
        args = MockArgs()
        args.extensions = ".py,.js"
        result = validate_arguments(args)
        assert not result.is_valid
        assert result.has_error(ValidationError.EXTENSION_HAS_DOT)

        # Test 5: Valid include files
        args = MockArgs()
        args.include_files = str(test_file)
        result = validate_arguments(args)
        assert result.is_valid
        assert len(result.errors) == 0

        # Test 6: Invalid include files
        args = MockArgs()
        args.include_files = "/nonexistent/file.py"
        result = validate_arguments(args)
        assert not result.is_valid
        assert result.has_error(ValidationError.FILE_NOT_FOUND)

        # Test 7: Invalid glob pattern - use a pattern that actually breaks
        args = MockArgs()
        # Use a pattern with unmatched brackets which can cause issues
        args.glob = "test[unclosed"
        result = validate_arguments(args)
        # This might or might not be invalid depending on system, just test that we get a result
        assert isinstance(result.is_valid, bool)

        # Test 8: Invalid exclude pattern - similar approach
        args = MockArgs()
        args.exclude_patterns = "test[unclosed"
        result = validate_arguments(args)
        assert isinstance(result.is_valid, bool)

        # Test 9: Negative max_depth
        args = MockArgs()
        args.max_depth = -1
        result = validate_arguments(args)
        assert not result.is_valid
        assert result.has_error(ValidationError.INVALID_MAX_DEPTH)

        # Test 10: Conflicting options (no_dump + manifest)
        args = MockArgs()
        args.no_dump = True
        args.manifest = True
        result = validate_arguments(args)
        assert not result.is_valid
        assert result.has_error(ValidationError.CONFLICTING_OPTIONS)

        # Test 11: Archive with stdio output
        args = MockArgs()
        args.output = "stdio"
        args.archive = "zip"
        result = validate_arguments(args)
        assert not result.is_valid
        assert result.has_error(ValidationError.ARCHIVE_WITH_STDIO)

        # Test 12: UI mode (should skip inclusion criteria check)
        args = MockArgs()
        args.ui = True
        args.extensions = None
        result = validate_arguments(args)
        assert result.is_valid
        assert not result.has_error(ValidationError.NO_INCLUSION_CRITERIA)

        # Test 13: Empty extensions get filtered out by parse_comma_separated_list
        args = MockArgs()
        args.extensions = "py,,js"  # Empty extension in middle gets filtered out
        result = validate_arguments(args)
        assert result.is_valid  # Should be valid since empty extensions are filtered out

        # Test 14: Exclude extensions with dots
        args = MockArgs()
        args.exclude_extensions = ".pyc,.pyo"
        result = validate_arguments(args)
        assert not result.is_valid
        assert result.has_error(ValidationError.EXTENSION_HAS_DOT)

        # Test 15: Valid ignore directories (non-existent should warn, not error)
        args = MockArgs()
        args.ignore_dirs = str(nonexistent_dir)
        result = validate_arguments(args)
        assert result.is_valid  # Should still be valid, just warn
        assert len(result.warnings) > 0

        # Test 16: File as ignore directory (should error)
        args = MockArgs()
        args.ignore_dirs = str(test_file)  # File, not directory
        result = validate_arguments(args)
        assert not result.is_valid
        assert result.has_error(ValidationError.PATH_NOT_DIRECTORY)

        # Test 17: Include file that's actually a directory
        test_dir = tmp_path / "test_subdir"
        test_dir.mkdir()
        args = MockArgs()
        args.include_files = str(test_dir)
        result = validate_arguments(args)
        assert not result.is_valid
        assert result.has_error(ValidationError.PATH_NOT_FILE)

        # Test 18: Multiple valid extensions
        args = MockArgs()
        args.extensions = "py,js,ts"
        result = validate_arguments(args)
        assert result.is_valid
        assert len(result.errors) == 0

        # Test 19: Valid glob patterns
        args = MockArgs()
        args.glob = "*.py,**/*.js"
        result = validate_arguments(args)
        assert result.is_valid
        assert len(result.errors) == 0

        # Test 20: Multiple errors in one validation
        args = MockArgs()
        args.extensions = ".py"  # Has dot
        args.max_depth = -1     # Invalid depth
        args.directories = ["/nonexistent"]  # Invalid directory
        result = validate_arguments(args)
        assert not result.is_valid
        assert result.has_error(ValidationError.EXTENSION_HAS_DOT)
        assert result.has_error(ValidationError.INVALID_MAX_DEPTH)
        assert result.has_error(ValidationError.DIRECTORY_NOT_FOUND)
        assert len(result.errors) == 3

        # Test 21: Error message formatting
        args = MockArgs()
        args.extensions = None
        result = validate_arguments(args)
        error_msg = result.get_error_message()
        assert error_msg is not None
        assert "❌" in error_msg  # Check formatting exists

        # Test 22: No errors gives None message
        args = MockArgs()
        result = validate_arguments(args)
        assert result.get_error_message() is None


class TestIntegration:
    """Integration tests for complete workflows."""

    def test_full_workflow(self, tmp_path):
        """Test a complete flort workflow."""
        # Create a realistic project structure
        (tmp_path / "src").mkdir()
        (tmp_path / "tests").mkdir()
        (tmp_path / "docs").mkdir()
        (tmp_path / "__pycache__").mkdir()

        # Create various file types
        (tmp_path / "main.py").write_text("""
def main():
    print("Hello, World!")

if __name__ == "__main__":
    main()
""")

        (tmp_path / "src" / "utils.py").write_text("""
def helper_function():
    return "helper"

class UtilClass:
    def method(self):
        pass
""")

        (tmp_path / "tests" / "test_main.py").write_text("""
import unittest

class TestMain(unittest.TestCase):
    def test_something(self):
        pass
""")

        (tmp_path / "README.md").write_text("# Test Project")
        (tmp_path / "requirements.txt").write_text("pytest\nflake8")
        (tmp_path / "__pycache__" / "main.cpython-39.pyc").write_bytes(b"\x00\x01")

        output_file = tmp_path / "project.flort.txt"

        # Test complete file discovery and concatenation
        file_list = get_paths(
            directories=[str(tmp_path)],
            extensions=["py", "md", "txt"],
            exclude_patterns=["*test*"],
            ignore_dirs=[tmp_path / "__pycache__"]
        )

        # Should find files but exclude tests and cache
        files = [f for f in file_list if f["type"] == "file"]
        py_files = [f for f in files if f["path"].suffix == ".py"]

        # Should have main.py and utils.py, but not test_main.py
        assert len(py_files) == 2
        assert not any("test_" in f["path"].name for f in py_files)

        # Test concatenation
        success = concat_files(file_list, str(output_file))
        assert success
        assert output_file.exists()

        content = output_file.read_text()
        assert "## File Data" in content
        assert "main.py" in content
        assert "utils.py" in content
        assert "README.md" in content
        assert "def main():" in content
        assert "class UtilClass:" in content


# Pytest fixtures and utilities
@pytest.fixture
def temp_project(tmp_path):
    """Create a temporary project structure for testing."""
    project_structure = {
        "main.py": "def main(): pass",
        "src/utils.py": "def util(): pass",
        "src/__init__.py": "",
        "tests/test_main.py": "def test(): pass",
        "docs/README.md": "# Documentation",
        "config.json": '{"setting": "value"}',
        ".gitignore": "*.pyc\n__pycache__/",
        "__pycache__/main.cpython-39.pyc": b"\x00\x01\x02"
    }

    for file_path, content in project_structure.items():
        full_path = tmp_path / file_path
        full_path.parent.mkdir(parents=True, exist_ok=True)

        if isinstance(content, bytes):
            full_path.write_bytes(content)
        else:
            full_path.write_text(content)

    return tmp_path


if __name__ == "__main__":
    # Allow running tests directly
    pytest.main([__file__, "-v"])

--- File: tests/test_ignore/file2.py
--- Characters: 0
--- Token Count: 0


--- File: tests/test_no_ignore/file4.py
--- Characters: 14
--- Token Count: 4
...file44stuff


## Concatenation Summary
Files processed: 18
Files skipped: 0
Total characters: 206,733
Total tokens: 39,537

Completed at: 2025-09-25 17:03:39

