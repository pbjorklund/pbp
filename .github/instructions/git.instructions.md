---
applyTo: "**/{.gitconfig,.gitignore,.git*}"
---

# Git Rules

MANDATORY requirements for all Git operations in this dotfiles repository.

## Commit Message Requirements

- **MUST** keep subject line under 50 characters
- **MUST** use present tense imperative: "Add feature" not "Added feature"

## File Management Requirements

- **SHALL NOT** commit files containing passwords, tokens, API keys, or personal data

## Commit Quality Requirements

- **MUST** make atomic commits (one logical change per commit)

## Security Requirements

- **SHALL NOT** commit any secrets, tokens, or sensitive information

## Violation Consequences

- Commits with secrets **WILL BE REVERTED** and history rewritten
- Non-conventional commit messages **WILL BE REJECTED**
- Commits breaking main branch **WILL BE REVERTED**
- Files with sensitive data **WILL BE REMOVED** from history
