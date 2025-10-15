![ZUnit](https://zunit.xyz/img/logo.png)

[![GitHub release](https://img.shields.io/github/release/sandertammesoo/zunit.svg)](https://github.com/sandertammesoo/zunit/releases/latest)

ZUnit is a powerful unit testing framework for ZSH scripts and functions. It provides a comprehensive testing environment with rich assertions, flexible configuration, and multiple output formats.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Writing Tests](#writing-tests)
- [Configuration](#configuration)
- [Command Line Usage](#command-line-usage)
- [Advanced Features](#advanced-features)
- [Output Formats](#output-formats)
- [Project Structure](#project-structure)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)

## Features

- 🧪 **Rich Assertion Library** - Over 25 built-in assertions for comprehensive testing
- 📝 **Multiple Output Formats** - TAP, HTML, and text reporting
- ⚙️ **Flexible Configuration** - Project-level configuration via `.zunit.yml`
- 🔄 **Setup & Teardown** - Per-test and per-file lifecycle hooks
- 🚀 **Test Discovery** - Automatic test file discovery and filtering
- ⏱️ **Time Limits** - Configurable test timeouts
- 🎯 **Selective Testing** - Run specific tests or test files
- 📊 **Detailed Reporting** - Comprehensive test results and statistics

## Installation

> **WARNING**: Although the majority of ZUnit's functionality works as expected, it is in the early stages of
> development, and as such bugs are likely to be present. Please continue with caution, and
> [report any issues](https://github.com/zunit-zsh/zunit/issues/new) you may have.

<!-- ### [Zinit](https://github.com/zdharma-continuum/zinit)

```sh
zinit build for @zdharma-continuum/zunit
``` -->

### Homebrew

```zsh
brew install sandertammesoo/formulae/zunit
```

### Manual

```zsh
git clone https://github.com/sandertammesoo/zunit.git
cd zunit
./configure --prefix=$HOME/.local
make
make install
```

## Quick Start

### Initialize a new project

```zsh
zunit init
```

This creates:
- `.zunit.yml` - Configuration file
- `tests/` - Test directory
- `tests/_support/bootstrap` - Setup script
- `tests/example.zunit` - Example test file

### Writing Tests

Tests in ZUnit have a simple syntax, inspired by the [BATS](https://github.com/sstephenson/bats) framework.

```zsh
#!/usr/bin/env zunit

@test 'basic string assertion' {
  result="hello world"
  assert "$result" same_as "hello world"
}

@test 'testing command output' {
  run echo "test output"
  
  assert $state equals 0
  assert "$output" contains "test"
}

@test 'file system assertions' {
  touch /tmp/testfile
  
  assert "/tmp/testfile" exists
  assert "/tmp/testfile" is_file
  assert "/tmp/testfile" is_readable
  
  rm /tmp/testfile
}
```

The zunit shebang `#!/usr/bin/env zunit` **MUST** appear at the top of each test file.

### Setup and Teardown

```zsh
#!/usr/bin/env zunit

@setup {
  # Run before each test
  TEST_DIR=$(mktemp -d)
  cd "$TEST_DIR"
}

@teardown {
  # Run after each test
  cd /
  rm -rf "$TEST_DIR"
}

@test 'test with setup and teardown' {
  # TEST_DIR is available here
  touch testfile
  assert "testfile" exists
}
```

### Available Assertions

ZUnit provides over 25 built-in assertions:

**String Assertions:**
- `same_as`, `different_to` - String equality
- `contains`, `does_not_contain` - Substring matching
- `matches`, `does_not_match` - Regex matching
- `is_empty`, `is_not_empty` - Empty string checks

**Numeric Assertions:**
- `equals`, `not_equal_to` - Numeric equality
- `is_greater_than`, `is_less_than` - Numeric comparison
- `is_positive`, `is_negative` - Sign checking

**File System Assertions:**
- `exists`, `does_not_exist` - Path existence
- `is_file`, `is_dir`, `is_link` - Type checking
- `is_readable`, `is_writable`, `is_executable` - Permission checking
- `same_as_file`, `different_to_file` - File comparison

**Collection Assertions:**
- `in`, `not_in` - Array membership
- `is_key_in`, `is_not_key_in` - Hash key checking
- `is_value_in`, `is_not_value_in` - Hash value checking

### Running Commands

Use the `run` helper to execute commands and capture their output:

```zsh
@test 'command execution' {
  run ls -la
  
  assert $state equals 0           # Exit status
  assert "$output" contains "total" # Command output
}

@test 'testing failures' {
  run false
  
  assert $state equals 1
}
```

## Configuration

ZUnit can be configured using a `.zunit.yml` file in your project root:

```yaml
# Test execution settings
tap: false                    # Enable TAP output format
fail_fast: true              # Stop on first failure
allow_risky: false           # Allow tests without assertions
verbose: false               # Print full test output
time_limit: 15               # Test timeout in seconds

# Directory structure
directories:
  tests: tests               # Test files location
  output: tests/_output      # Output directory for reports
  support: tests/_support    # Support files directory
```

## Command Line Usage

```zsh
# Run all tests
zunit run

# Run specific test files
zunit run tests/my-test.zunit

# Run with options
zunit run --verbose --fail-fast

# Run specific test within a file
zunit run tests/my-test.zunit@"specific test name"

# Generate reports
zunit run --output-html --output-text
```

### Available Options

- `--fail-fast` / `-f` - Stop execution after first failure
- `--tap` / `-t` - Output in TAP format
- `--verbose` - Show detailed output from each test
- `--allow-risky` - Suppress warnings for tests without assertions
- `--time-limit <seconds>` - Set test timeout
- `--output-html` - Generate HTML report
- `--output-text` - Generate text report (TAP format)

## Advanced Features

### Loading External Scripts

Use the `load` helper to source external scripts:

```zsh
@test 'loading external code' {
  load '../src/my-functions'  # Loads my-functions.zsh
  
  # Now you can test functions from that file
  result=$(my_function "input")
  assert "$result" same_as "expected"
}
```

### Test Helpers

- `pass` - Explicitly pass a test
- `fail "message"` - Explicitly fail with a message  
- `skip "reason"` - Skip a test with a reason
- `error "message"` - Mark test as error

### Bootstrap Script

Place common setup code in `tests/_support/bootstrap`:

```zsh
#!/usr/bin/env zsh
# This runs once before all tests

# Load your application code
load '../src/main'

# Set up test environment
export TEST_ENV=1
```

## Output Formats

### Standard Output
```
==> Launching ZUnit 0.10.1-beta
==> ZSH: zsh 5.9 (x86_64-apple-darwin22.0)

==> Loading tests in tests/example.zunit
[PASS] #1 example test

= ZUnit Results =====
Passed: 1/1
Errors: 0
Failed: 0
Warnings: 0
Skipped: 0

1 tests ran in 42ms
=====================
```

### TAP Output
```zsh
zunit run --tap

TAP version 13
ok 1 - example test
1..1
```

### HTML Report
```zsh
zunit run --output-html
# Generates tests/_output/output.html
```

## Documentation

For a full breakdown of ZUnit's syntax and functionality, check out the
[official documentation](https://zunit.xyz/docs/).

## Project Structure

Understanding ZUnit's structure can help when writing tests:

```
my-project/
├── .zunit.yml              # Configuration file
├── src/                    # Your source code
│   └── functions.zsh
├── tests/                  # Test directory
│   ├── _output/           # Generated reports
│   ├── _support/          # Support files
│   │   └── bootstrap      # Runs before all tests
│   ├── unit/              # Unit tests
│   │   └── functions.zunit
│   └── integration/       # Integration tests
│       └── workflow.zunit
```

## Examples

### Testing ZSH Functions

```zsh
#!/usr/bin/env zunit

# Load the functions to test
load '../src/string-utils'

@test 'string trimming function' {
  result=$(trim_whitespace "  hello world  ")
  assert "$result" same_as "hello world"
}

@test 'string validation' {
  run is_valid_email "user@example.com"
  assert $state equals 0
  
  run is_valid_email "invalid-email"
  assert $state equals 1
}
```

### Testing Shell Scripts

```zsh
#!/usr/bin/env zunit

@test 'script handles missing arguments' {
  run ./my-script.sh
  
  assert $state equals 1
  assert "$output" contains "Usage:"
}

@test 'script processes files correctly' {
  echo "test content" > input.txt
  
  run ./my-script.sh input.txt
  
  assert $state equals 0
  assert "output.txt" exists
  assert "$(cat output.txt)" contains "processed"
  
  rm -f input.txt output.txt
}
```

## Contributing

All contributions are welcome and encouraged! Please read our [contribution guidelines](contributing.md) and
[code of conduct](code-of-conduct.md) for more information.

### Development Environment Setup

#### Prerequisites
- **ZSH 5.0+** - The shell ZUnit is built for
- **Git** - Version control
- **Make** - Build system
- **GPG** (optional) - For signed releases

#### Initial Setup

```zsh
# 1. Fork and clone the repository
git clone https://github.com/YOUR_USERNAME/zunit.git
cd zunit

# 2. Add upstream remote
git remote add upstream https://github.com/sandertammesoo/zunit.git

# 3. Set up authentication (SSH recommended)
git remote set-url origin git@github.com:YOUR_USERNAME/zunit.git

# 4. Configure the build system
./configure --prefix=$HOME/.local

# 5. Build ZUnit
make build

# 6. Run the test suite to verify everything works
make test

# 7. Check development environment status
make check-version

# 8. (Optional) Install locally for testing
make install
```

#### Git Authentication Setup

For contributing and releasing, you'll need proper Git authentication:

```zsh
# Check current authentication status
make check-version

# Option A: SSH Authentication (Recommended)
git remote set-url origin git@github.com:YOUR_USERNAME/zunit.git
# Set up SSH key: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

# Option B: HTTPS with Personal Access Token
# 1. Create token at: https://github.com/settings/tokens
# 2. Use token as password when prompted
# 3. Configure credential helper: git config --global credential.helper store
```

#### GPG Setup (Optional, for Signed Releases)

```zsh
# Get guidance on GPG configuration
make setup-gpg

# Follow the instructions to:
# - Install GPG if needed
# - Generate a GPG key
# - Configure Git to use your key
```

### Development Cycle

#### Making Changes

```zsh
# 1. Create a feature branch
git checkout -b feature/my-new-feature

# 2. Make your changes to source files in src/
# - Core functionality: src/*.zsh
# - Commands: src/commands/*.zsh  
# - Reports: src/reports/*.zsh
# - Assertions: src/assertions.zsh

# 3. Build and test your changes
make build
make test

# 4. Test manually with your changes
./bin/zunit run  # Run ZUnit's own test suite

# 5. Clean build artifacts if needed
make clean
```

#### Testing Your Changes

```zsh
# Run ZUnit's own test suite
make test

# Run specific tests
./bin/zunit run tests/specific-test.zunit

# Test with different options
./bin/zunit run --verbose
./bin/zunit run --tap
./bin/zunit run --output-html

# Check that help and version work
./bin/zunit --help
./bin/zunit --version
```

#### Code Style Guidelines

- Follow existing ZSH coding patterns in the codebase
- Use 4-space indentation (not tabs)
- Add comments for complex logic
- Update tests when adding new assertions or features
- Ensure new features have corresponding documentation

### Pull Request Process

#### Before Submitting

- **Discuss first**: For non-trivial changes, open an issue to discuss your approach
- **Search existing**: Check if someone else is already working on this
- **Use topic branches**: Work on feature branches, not directly on main branches
- **Include tests**: New features should have corresponding tests
- **Update docs**: Document new features and update examples

#### Branch Guidelines

- **Most PRs**: Target the `develop` branch for inclusion in the next release
- **Urgent fixes**: May target `master` for immediate patch releases (ask first)
- **WIP PRs**: Use `[WIP]` prefix for early feedback on ambitious features

#### Submission Steps

```zsh
# 1. Ensure your branch is up to date
git fetch upstream
git rebase upstream/develop

# 2. Build and test one final time
make build
make test

# 3. Push your branch
git push origin feature/my-new-feature

# 4. Create a pull request on GitHub
```

#### Pull Request Requirements

- **Clear title**: Use descriptive, clear titles for PRs and commits
- **Detailed description**: 
  - Explain **why** this change is needed
  - Provide use-cases and examples
  - Reference related issues with `Fixes #123` or `Relates to #456`
- **Single purpose**: Don't include unrelated changes
- **Convincing case**: It's your job to convince reviewers why this should be merged

#### During Review

- **Be responsive**: Address feedback promptly
- **Update existing PR**: Never open a new PR - just push updates to your branch
- **Be patient**: Reviews take time, especially for complex changes
- **Ask questions**: If feedback is unclear, ask for clarification

#### Early Feedback

For ambitious tasks, open a draft PR early:
- Add `[WIP]` to the title
- Describe what you still need to do
- Ask specific questions about your approach
- Don't worry about perfection at this stage

### Release Process (for Maintainers)

#### Preparing a Release

```zsh
# 1. Ensure you're on develop branch with latest changes
git checkout develop
git pull upstream develop

# 2. Check release readiness (includes GPG and git authentication status)
make check-version

# 3. Set up authentication if needed (SSH recommended)
# Follow the guidance from check-version output:
git remote set-url origin git@github.com:sandertammesoo/zunit.git

# 4. Update version number
echo "0.11.0" > VERSION

# 5. Update changelog/release notes if applicable
# Edit CHANGELOG.md or prepare GitHub release notes

# 6. Final status check
make check-version
```

#### Creating the Release

```zsh
# Option A: Complete automated release (recommended)
make full-release

# Option B: Step-by-step release
make release   # Build, test, and commit executable
make publish   # Create and push git tag (with auth guidance)
make deploy    # Create release archives and signatures (GPG optional)

# If any step fails, clean up and retry
make cleanup-release
```

#### Post-Release Tasks

```zsh
# 1. Create GitHub Release
# - Go to: https://github.com/sandertammesoo/zunit/releases/new
# - Select the new tag (v0.11.0)
# - Upload zunit-0.11.0.tar.gz and zunit-0.11.0.tar.gz.asc
# - Write release notes

# 2. Update package managers
# - Update Homebrew formula
# - Update any other distribution methods

# 3. Announce the release
# - Update documentation if needed
# - Post on relevant forums/social media
```

#### Release Troubleshooting

```zsh
# Check what will be included in release (includes GPG and git auth status)
make check-version

# If release fails due to authentication issues
# The Makefile will provide specific guidance for:
# - HTTPS authentication (Personal Access Tokens)
# - SSH key setup
# - Credential helper configuration

# Clean up failed release attempts
make cleanup-release

# Set up GPG for signed releases
make setup-gpg

# Switch to SSH for easier authentication (recommended)
git remote set-url origin git@github.com:sandertammesoo/zunit.git

# View current git status
git status

# See recent commits
git log --oneline -10

# Clean up build artifacts if needed
make clean
```

### Project Structure for Contributors

```
zunit/
├── .zunit.yml              # ZUnit's own test configuration
├── Makefile                # Build system (generated by configure)
├── Makefile.in             # Build system template
├── configure               # Build configuration script
├── VERSION                 # Current version number
├── src/                    # Source code
│   ├── zunit.zsh          # Main entry point (assembled last)
│   ├── assertions.zsh     # All assertion functions
│   ├── events.zsh         # Event handling (success, failure, etc.)
│   ├── helpers.zsh        # Test helpers (run, assert, load, etc.)
│   ├── commands/          # CLI commands
│   │   ├── init.zsh      # 'zunit init' command
│   │   └── run.zsh       # 'zunit run' command  
│   └── reports/           # Output formatters
│       ├── tap.zsh       # TAP format output
│       └── html.zsh      # HTML report generation
├── tests/                 # ZUnit's own test suite
├── bin/                   # Built executable (generated)
└── docs/                  # Documentation
```

### Build Process Details

The build system combines multiple source files into a single executable:

1. **Source Processing Order**:
   - Core libraries (`src/*.zsh` except `zunit.zsh`)
   - Report modules (`src/reports/*.zsh`)
   - Command modules (`src/commands/*.zsh`)
   - Main entry point (`src/zunit.zsh`)

2. **Build Steps**:
   - Removes comments and vim modelines
   - Injects version information and git revision
   - Creates executable with proper shebang
   - Makes file executable

3. **Available Make Targets**:
   - `make build` - Build the executable
   - `make test` - Run test suite
   - `make install` - Install to configured prefix
   - `make clean` - Remove build artifacts
   - `make check-version` - Check release readiness (version, GPG, git auth)
   - `make setup-gpg` - GPG configuration guidance
   - `make cleanup-release` - Clean up failed release attempts
   - `make full-release` - Complete automated release workflow

## License

ZUnit is licensed under The MIT License (MIT)

Copyright (c) 2016 - 2022 James Dinsdale <hi@molovo.co> (molovo.co)

Copyright (c) 2022 zdharma-continuum <https://github.com/zdharma-continuum>

Copyright (c) 2025 Sander Tammesoo <https://github.com/sandertammesoo>
