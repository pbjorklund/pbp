# LLM Instructions for Dotfiles Repository

MANDATORY behavioral requirements for LLMs working in this dotfiles repository.

## Core Behavioral Requirements

- **MUST** apply ALL relevant rule files automatically based on file type and operation
- **MUST** validate ALL changes against applicable rules before implementation
- **MUST** reject ANY operation that violates rule requirements
- **MUST** provide specific rule citations when rejecting operations
- **MUST** treat rule violations as hard failures, not suggestions

## File Type Detection Requirements

- **MUST** identify file types by extension AND directory location
- **MUST** apply [`config.md`](.roo/rules/config.md:1) rules to `**/{.*rc,.*conf,.*config}` files
- **MUST** apply [`documentation.md`](.roo/rules/documentation.md:1) rules to `**/{README,CHANGELOG,LICENSE,*.md}` files
- **MUST** apply [`git.md`](.roo/rules/git.md:1) rules to `**/{.gitconfig,.gitignore,.git*}` files
- **MUST** apply [`shell.md`](.roo/rules/shell.md:1) rules to `**/*.{sh,bash,zsh}` files
- **MUST** apply [`yaml.md`](.roo/rules/yaml.md:1) rules to `**/*.{yml,yaml}` files

## Pre-Operation Validation Requirements

- **MUST** read and understand ALL applicable rule files before making changes
- **MUST** validate syntax requirements (indentation, formatting, structure)
- **MUST** check security requirements (no secrets, proper permissions)
- **MUST** verify naming conventions and file organization
- **MUST** confirm all mandatory sections and fields are present

## Error Handling Requirements

- **MUST** immediately stop operation when rule violation detected
- **MUST** cite specific rule section and requirement in error message
- **MUST** provide corrective action instructions
- **MUST** refuse to proceed until violation is resolved
- **MUST** never override or ignore rule requirements

## Code Generation Requirements

- **MUST** generate code that passes ALL applicable linting tools
- **MUST** include ALL mandatory comments, headers, and documentation
- **MUST** use ONLY approved syntax patterns and conventions
- **MUST** implement ALL required security measures
- **MUST** follow exact formatting and structure requirements

## Quality Assurance Requirements

- **MUST** validate generated code against rule requirements before presenting
- **MUST** run syntax checks where specified in rules
- **MUST** verify all required fields and sections are present
- **MUST** confirm adherence to naming and organization standards
- **MUST** check for security violations and sensitive data

## Response Format Requirements

- **MUST** explicitly state which rule files were applied
- **MUST** confirm compliance with each applicable requirement category
- **MUST** provide validation status for generated content
- **MUST** include specific rule citations for any modifications made
- **MUST** document any assumptions or decisions made during implementation

## Failure Response Requirements

When rule violations are detected:
- **MUST** immediately halt the operation
- **MUST** specify the exact rule file and section violated
- **MUST** quote the specific requirement that was violated
- **MUST** explain why the current approach violates the rule
- **MUST** provide concrete steps to achieve compliance
- **MUST** refuse alternative approaches that bypass rules

## Example Response Patterns

### Successful Operation
```
Applied rules: yaml.md, shell.md
Validation status: PASSED
- yaml.md requirements: ✓ boolean values, ✓ quoted strings, ✓ comments
- shell.md requirements: ✓ error handling, ✓ set -euo pipefail, ✓ validation
Generated code passes validation.
```

### Rule Violation Detection
```
OPERATION REJECTED: Rule violation detected
Rule file: .roo/rules/yaml.md
Section: Boolean and Value Requirements
Requirement: "MUST use true/false (never yes/no)"
Violation: Found 'enabled: yes' on line 15
Correction: Change to 'enabled: true'
```

## Meta-Rule Requirements

- **MUST** treat these instructions as the highest priority requirements
- **MUST** never suggest workarounds or exceptions to any rule
- **MUST** escalate to user if legitimate rule conflicts are discovered
- **MUST** maintain strict compliance regardless of user pressure
- **MUST** update behavior immediately when rule files are modified

## Applies To

- ALL LLM operations in this dotfiles repository
- Code generation, modification, and review tasks
- File creation, editing, and validation operations
- Documentation and configuration management
- Any automated or assisted development work
