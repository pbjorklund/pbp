# YAML Rules

MANDATORY requirements for all YAML files in this dotfiles repository.

## Syntax Requirements

- **MUST** use exactly 2 spaces for indentation (no tabs)
- **MUST** use spaces only (tabs are forbidden)
- **MUST** quote strings containing special characters: `:`, `{`, `}`, `[`, `]`, `,`, `&`, `*`, `#`, `?`, `|`, `-`, `<`, `>`, `=`, `!`, `%`, `@`, `` ` ``
- **MUST** use lowercase boolean values: `true`/`false` (not `True`/`False` or `YES`/`NO`)
- **MUST** end files with newline character

## Security Requirements

- **SHALL NOT** include passwords, tokens, API keys, or sensitive data
- **MUST** use environment variable references: `${ENV_VAR}` or `!env ENV_VAR`
- **MUST** quote all user-provided strings to prevent injection
- **MUST** validate all external references

## Violation Consequences

- Files failing YAML syntax validation **WILL BE REJECTED**
- Files with tab indentation **WILL BE REJECTED**
- Files containing sensitive data **WILL BE REJECTED**
- Files without proper comments **WILL BE REJECTED**

## Applies To

- `**/*.{yml,yaml}`
- YAML configuration files
- Configuration files like CI/CD configs and other YAML configs
