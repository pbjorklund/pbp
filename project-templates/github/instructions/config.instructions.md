---
applyTo: "**/{.*rc,.*conf,.*config}"
---

# Configuration Files Rules

MANDATORY requirements for all dotfiles and configuration files in this repository.

## File Structure Requirements

- **MUST** place most critical settings at the top of each section

## Security Requirements

- **SHALL NOT** include tokens, passwords, API keys, or secrets
- **MUST** use environment variables: `${HOME}`, `${USER}` instead of hardcoded paths
- **MAY** include personal usernames, emails, and device names in configuration files
- **MUST** ensure personal data inclusion is intentional for repository maintainer

## Violation Consequences

- Files with syntax errors **WILL BE REJECTED**
- Files containing real personal data **WILL BE REJECTED**
- Files without proper comments **WILL BE REJECTED**
- Files failing validation **WILL BE REJECTED**
