# Git Rules

MANDATORY requirements for all Git operations in this dotfiles repository.

## Commit Message Requirements

- **MUST** use conventional commit format: `type(scope): description`
- **MUST** use one of these types: `feat`, `fix`, `docs`, `style`, `refactor`, `chore`
- **MUST** keep subject line under 50 characters
- **MUST** use present tense imperative: "Add feature" not "Added feature"
- **MUST** capitalize first letter of description
- **MUST** not end subject line with period

## Branch Management Requirements

- **MUST** create feature branches for all non-trivial changes
- **MUST** use descriptive branch names: `type/brief-description`
- **MUST** keep `main` branch in deployable state at all times
- **MUST** use fast-forward merges when possible
- **MUST** delete feature branches after merging

## File Management Requirements

- **SHALL NOT** commit files containing passwords, tokens, API keys, or personal data
- **MUST** use [`.gitignore`](.gitignore:1) for all system-generated and temporary files
- **MUST** remove obsolete files in separate cleanup commits
- **MUST** maintain clean repository structure with logical organization

## Configuration Requirements

- **MUST** test all configuration changes before committing
- **MUST** document breaking changes in commit body
- **MUST** maintain backward compatibility when possible
- **MUST** update documentation when configuration changes affect usage

## Commit Quality Requirements

- **MUST** make atomic commits (one logical change per commit)
- **MUST** review all changes using `git diff --cached` before committing
- **MUST** ensure each commit can be built and tested independently
- **MUST** squash related commits before merging to main

## Security Requirements

- **SHALL NOT** commit any secrets, tokens, or sensitive information
- **MUST** use environment variables or separate config files for sensitive data
- **MUST** review all diffs before pushing to remote
- **MUST** use `git-secrets` or equivalent tool if available
- **MUST** immediately revoke and rotate any accidentally committed secrets

## Validation Requirements

- **MUST** run `git status` to verify staged changes before committing
- **MUST** ensure all staged files are intentionally included
- **MUST** verify commit messages follow format requirements
- **MUST** confirm no sensitive data is included in staged changes

## Violation Consequences

- Commits with secrets **WILL BE REVERTED** and history rewritten
- Non-conventional commit messages **WILL BE REJECTED**
- Commits breaking main branch **WILL BE REVERTED**
- Files with sensitive data **WILL BE REMOVED** from history

## Applies To

- `**/{.gitconfig,.gitignore,.git*}`
- Git configuration and repository files
- [`gitconfig`](gitconfig:1) and related files
