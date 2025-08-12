# Shell Script Rules

MANDATORY requirements for all shell scripts in this dotfiles repository.

## Script Header Requirements

- **MUST** use `#!/bin/bash` as shebang line
- **MUST** include `set -euo pipefail` for error handling and safety
- **MUST** include comment block with script purpose and usage
- **MUST** set executable permissions: `chmod +x script.sh`

## Variable and Path Requirements

- **MUST** quote all variables: `"${variable}"` not `$variable`
- **MUST** use uppercase for environment variables: `SCRIPT_DIR`
- **MUST** use lowercase for local variables: `local_var`
- **MUST** use absolute paths or validate relative paths exist
- **MUST** check file/directory existence before operations: `[[ -f file ]]`

## Installation Script Requirements

- **MUST** check for existing installations using `command -v` or `which`
- **MUST** create backups before overwriting: `cp file file.backup.$(date +%Y%m%d)`
- **MUST** provide progress feedback: `echo "Installing package..."`
- **MUST** handle multiple Linux distributions with OS detection
- **MUST** validate prerequisites before proceeding

## Error Handling Requirements

- **MUST** use `set -e` to exit on any command failure
- **MUST** use `set -u` to exit on undefined variables
- **MUST** use `set -o pipefail` to catch pipe failures
- **MUST** provide cleanup function with `trap cleanup EXIT`
- **MUST** include meaningful error messages with line numbers

## Symlink Management Requirements

- **MUST** check source file exists before creating symlinks
- **MUST** use absolute paths for symlink targets
- **MUST** provide `--force` option to overwrite existing files
- **MUST** log all symlink operations for debugging
- **MUST** verify symlinks are created successfully

## Function Requirements

- **MUST** declare functions before use
- **MUST** use `local` for function variables
- **MUST** include function documentation comments
- **MUST** return meaningful exit codes: `return 0` for success, `return 1` for failure
- **MUST** validate function parameters: `[[ $# -eq 2 ]] || { echo "Usage: func arg1 arg2"; return 1; }`

## User Interface Requirements

- **MUST** provide `--help` option showing usage and examples
- **MUST** provide `--dry-run` option for destructive operations
- **MUST** use colors with fallbacks: `[[ -t 1 ]] && RED='\033[0;31m' || RED=''`
- **MUST** show progress for operations taking >5 seconds
- **MUST** confirm destructive operations unless `--force` specified

## Security Requirements

- **SHALL NOT** include passwords, tokens, or secrets in scripts
- **MUST** validate all user inputs before processing
- **MUST** use `mktemp` for temporary files: `temp_file=$(mktemp)`
- **MUST** set restrictive permissions on created files: `chmod 600`
- **SHALL NOT** use `eval` or execute user-provided code

## Testing Requirements

- **MUST** test scripts on clean systems before deploying
- **MUST** verify all external commands exist before using
- **MUST** include example usage in script comments
- **MUST** handle edge cases (empty inputs, missing files, etc.)
- **MUST** validate script syntax: `bash -n script.sh`

## Violation Consequences

- Scripts failing syntax check **WILL BE REJECTED**
- Scripts without proper error handling **WILL BE REJECTED**
- Scripts with unquoted variables **WILL BE REJECTED**
- Scripts containing secrets **WILL BE REJECTED**

## Applies To

- `**/*.{sh,bash,zsh}`
- Shell scripts like [`install.sh`](install.sh:1)
- Executable shell scripts and utilities
