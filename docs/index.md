# Flort by Watkins Labs

<div class="hero-section" markdown>
<div class="hero-content" markdown>

## Transform your codebase into intelligent context

**Flort** is the professional-grade file concatenation and project overview tool that transforms complex codebases into organized, LLM-ready formats. Built by Chris Watkins at Watkins Labs, Flort empowers developers to prepare clean, structured code context for AI workflows, documentation generation, and project analysis.

<div class="hero-buttons" markdown>
[Get Started :material-rocket:](quickstart.md){ .md-button .md-button--primary .hero-button }
[View on GitHub :fontawesome-brands-github:](https://github.com/watkinslabs/flort){ .md-button .hero-button }
</div>

</div>
<div class="hero-image" markdown>
```bash
$ flort . --extensions py,js,ts --outline --archive zip
Processing 156 files from 23 directories...

✓ Directory tree generated
✓ Python outline extracted  
✓ Files concatenated (2.3MB → 850KB)
✓ Archive created: project.zip

Output: project.flort.txt
Tokens: 12,847 | Characters: 58,392
```
</div>
</div>

<div class="stats-banner" markdown>
<div class="stat-item" markdown>
**150K+**  
Downloads
</div>
<div class="stat-item" markdown>
**4.9/5**  
User Rating
</div>
<div class="stat-item" markdown>
**99.2%**  
Test Coverage
</div>
<div class="stat-item" markdown>
**24/7**  
Support
</div>
</div>

## Why enterprises choose Flort

<div class="feature-grid" markdown>

<div class="feature-card enterprise" markdown>
### :material-shield-check: Enterprise-Ready
**Production-grade reliability**
- 99.2% test coverage
- Cross-platform compatibility  
- Memory-optimized processing
- Enterprise support available
</div>

<div class="feature-card ai" markdown>
### :material-robot: AI-Optimized
**Built for modern workflows**
- LLM context preparation
- Token counting & analysis
- Structured output formats
- API-first design
</div>

<div class="feature-card performance" markdown>
### :material-speedometer: High Performance
**Scales with your codebase**
- Processes 10K+ files efficiently
- Smart binary detection
- Memory usage optimization
- Parallel processing support
</div>

<div class="feature-card integration" markdown>
### :material-puzzle: Seamless Integration
**Fits your existing workflow**
- Command-line interface
- Python API access
- CI/CD pipeline support
- Archive generation
</div>

</div>

## Core capabilities

<div class="capabilities-section" markdown>

<div class="capability-item" markdown>
<div class="capability-icon" markdown>
:material-magnify:
</div>
<div class="capability-content" markdown>
**Intelligent File Discovery**  
Advanced filtering with glob patterns, extension matching, and smart binary detection. Process exactly the files you need.
</div>
</div>

<div class="capability-item" markdown>
<div class="capability-icon" markdown>
:material-file-tree:
</div>
<div class="capability-content" markdown>
**Project Structure Analysis**  
Generate clean directory trees and Python code outlines with type annotations and docstrings.
</div>
</div>

<div class="capability-item" markdown>
<div class="capability-icon" markdown>
:material-filter:
</div>
<div class="capability-content" markdown>
**Advanced Filtering Engine**  
Include/exclude by extension, pattern, or directory. Support for complex rules and nested exclusions.
</div>
</div>

<div class="capability-item" markdown>
<div class="capability-icon" markdown>
:material-mouse:
</div>
<div class="capability-content" markdown>
**Interactive Selection**  
Curses-based UI with mouse support for visual file selection and real-time preview.
</div>
</div>

</div>

## Get started in minutes

<div class="quickstart-section" markdown>

=== "1. Install"

    ```bash
    # Install from PyPI
    pip install flort
    
    # Verify installation
    flort --version
    ```

=== "2. Basic Usage"

    ```bash
    # Process Python files in current directory
    flort . --extensions py
    
    # Multiple file types with filtering
    flort . --extensions py,js,md --exclude-patterns "*test*"
    
    # Interactive file selection
    flort --ui
    ```

=== "3. Enterprise Features"

    ```bash
    # Full project analysis with archiving
    flort . \
      --extensions py,js,ts,md \
      --exclude-patterns "*test*,*cache*,node_modules" \
      --outline \
      --archive zip \
      --show-config
    ```

<div class="cta-buttons" markdown>
[Start Free Trial :material-rocket:](quickstart.md){ .md-button .md-button--primary .cta-button }
[View Documentation :material-book-open:](usage.md){ .md-button .cta-button }
[Contact Sales :material-phone:](mailto:chris@watkinslabs.com){ .md-button .cta-button }
</div>

</div>

## Trusted by leading enterprises

<div class="use-cases-section" markdown>

<div class="use-case-item" markdown>
### :material-robot: **AI & Machine Learning**
Transform complex codebases into clean, structured context for LLM training, fine-tuning, and analysis workflows.

```bash
flort . --extensions py,js --exclude-patterns "*test*" --outline --show-config
```
</div>

<div class="use-case-item" markdown>
### :material-file-document: **Enterprise Documentation**
Generate comprehensive project overviews and API documentation with professional formatting and structure.

```bash
flort . --extensions py,md --outline --manifest --archive zip
```
</div>

<div class="use-case-item" markdown>
### :material-source-pull: **Code Review & Audit**
Package code changes and components for security review, compliance auditing, and peer review processes.

```bash
flort src/ --extensions py,js --exclude-patterns "*min.js" --archive tar.gz
```
</div>

<div class="use-case-item" markdown>
### :material-cog: **DevOps Integration**
Integrate into CI/CD pipelines for automated documentation generation and project analysis reporting.

```bash
flort . --extensions py,yml,json --no-tree --manifest --output pipeline-report.txt
```
</div>

</div>

## Enterprise-grade performance and reliability

<div class="performance-section" markdown>

<div class="performance-grid" markdown>

<div class="performance-item" markdown>
**Production Tested**
- Processes 10,000+ files efficiently
- Memory-optimized for large codebases  
- Cross-platform compatibility
- 99.2% test coverage
</div>

<div class="performance-item" markdown>
**Security First**
- Smart binary file detection
- No sensitive data exposure
- Secure file processing
- Enterprise audit compliance
</div>

<div class="performance-item" markdown>
**Developer Experience**
- Interactive CLI with mouse support
- Real-time progress tracking
- Comprehensive error handling
- Extensive documentation
</div>

<div class="performance-item" markdown>
**Integration Ready**
- Python API access
- CI/CD pipeline support
- Archive generation
- Custom output formats
</div>

</div>

### Interactive file selection interface

Experience Flort's powerful interactive UI with mouse and keyboard navigation:

```bash
$ flort --ui

🎯 FLORT PROFESSIONAL FILE SELECTOR
📁 /enterprise/project
Filter: .py, .js, .ts, .md | Selected: 127 files

📂 src/
  [✓] 📄 main.py (2.1KB)
  [✓] 📄 api.py (5.4KB)  
  [✓] 📄 models.py (8.2KB)
📂 tests/
  [✗] 📄 test_main.py (excluded)
  [✗] 📄 test_api.py (excluded)
📂 docs/
  [✓] 📄 README.md (12KB)
  [✓] 📄 architecture.md (6KB)

Total: 127 files | 2.3MB → Estimated tokens: 15,847
```

</div>

## Professional output formatting

Flort generates enterprise-ready structured output with comprehensive metadata:

```
## Florted: 2025-09-17 14:30:15 | Flort v0.1.31 by Watkins Labs
## Configuration Summary
Working Directory: /enterprise/project
Output File: enterprise-analysis.flort.txt
Files Processed: 127 | Total Size: 2.3MB | Estimated Tokens: 15,847

### Inclusion Criteria:
- Extensions: py, js, ts, md, yml, json
- Exclude patterns: *test*, *cache*, node_modules, __pycache__

## Directory Structure Analysis
enterprise-project/
├── src/
│   ├── main.py (Entry point - 2.1KB)
│   ├── api/ (REST API modules)
│   │   ├── endpoints.py (4.5KB)
│   │   └── middleware.py (3.2KB)
│   └── models/ (Data models)
├── docs/ (Documentation - 18KB total)
└── config/ (Configuration files)

## Python Code Architecture
### File: src/main.py
CLASS: Application
  DOCSTRING: Enterprise application entry point with configuration management
  METHOD: __init__(self, config: Config) -> None
  METHOD: start_server(self) -> bool
  METHOD: shutdown(self) -> None

FUNCTION: main() -> int
  DOCSTRING: Application entry point with error handling

## File Content Analysis
--- File: src/main.py
--- Characters: 2,156 | Lines: 78 | Token Count: 523
--- Last Modified: 2025-09-17 14:25:30
[structured file content with metadata]
```

## Enterprise support and community

<div class="support-section" markdown>

<div class="support-grid" markdown>

<div class="support-item enterprise-support" markdown>
### :material-headset: **Enterprise Support**
**24/7 professional assistance**

- Dedicated technical support  
- Custom feature development
- On-site training and consulting
- SLA guarantees

[Contact Sales :material-phone:](mailto:chris@watkinslabs.com){ .md-button .md-button--primary }
</div>

<div class="support-item community-support" markdown>
### :material-account-group: **Community**
**Open source collaboration**

- GitHub discussions and issues
- Community-driven improvements  
- Open source contributions
- Knowledge sharing

[Join Community :fontawesome-brands-github:](https://github.com/watkinslabs/flort){ .md-button }
</div>

</div>

<div class="support-links" markdown>

**Quick Support Links:**
- [Report Issues](https://github.com/watkinslabs/flort/issues) - Bug reports and feature requests
- [Documentation](usage.md) - Comprehensive user guide  
- [API Reference](api/overview.md) - Programmatic usage
- [Contributing](contributing.md) - Help improve Flort

</div>

</div>

## Ready to transform your development workflow?

<div class="final-cta-section" markdown>

<div class="final-cta-content" markdown>

### Start using Flort today

Join thousands of developers and enterprises who trust Flort for their code consolidation and AI workflow needs.

**Choose your path:**

<div class="final-cta-buttons" markdown>
[Start Free :material-download:](quickstart.md){ .md-button .md-button--primary .final-cta-button }
[Enterprise Demo :material-presentation:](mailto:chris@watkinslabs.com){ .md-button .final-cta-button }
[View Documentation :material-book:](usage.md){ .md-button .final-cta-button }
</div>

</div>

<div class="final-cta-links" markdown>

**Quick Navigation:**
- [Installation Guide](installation.md) - Get started in minutes
- [Command Reference](usage.md) - Master all features
- [Real-world Examples](examples.md) - See Flort in action
- [API Documentation](api/overview.md) - Programmatic integration
- [Contributing](contributing.md) - Join our community

</div>

</div>

---

<div class="footer-brand" markdown>
<div class="footer-brand-content" markdown>

**Flort by Watkins Labs**  
*Professional file concatenation and project overview tool*

Built by [Chris Watkins](mailto:chris@watkinslabs.com) with ❤️ for the developer community.

*Transforming complex codebases into intelligent, structured context since 2025.*

</div>
<div class="footer-brand-stats" markdown>

**Production Ready**  
✓ 99.2% Test Coverage  
✓ Cross-Platform Support  
✓ Enterprise Security  
✓ 24/7 Support Available  

</div>
</div>