# Documentation Rules

MANDATORY requirements for all documentation files in this dotfiles repository.

## Structure Requirements

- **MUST** start with clear one-sentence project description
- **MUST** include table of contents for files longer than 50 lines
- **MUST** use consistent heading hierarchy (H1 for title, H2 for sections, H3 for subsections)
- **MUST** separate sections with exactly one blank line
- **MUST** end files with newline character

## Content Requirements

- **MUST** include "Prerequisites" section listing required software/versions
- **MUST** include "Installation" section with copy-pastable commands
- **MUST** include "Usage" section with concrete examples
- **MUST** write in present tense and active voice
- **MUST** target audience: users with basic command-line knowledge

## Code Block Requirements

- **MUST** use triple backticks with language specification: ```bash, ```yaml, ```json
- **MUST** include `$` prompt for shell commands that users should run
- **MUST** exclude `$` prompt for command output examples
- **MUST** use relative paths starting with `./` when referencing repository files
- **MUST** test all commands before documenting them

## Formatting Requirements

- **MUST** use **bold** for UI elements, filenames, and important terms
- **MUST** use `inline code` for commands, variables, and code snippets
- **MUST** use > blockquotes for warnings and important notes
- **MUST** limit lines to 100 characters maximum
- **MUST** use numbered lists for sequential steps, bullet lists for options

## Link Requirements

- **MUST** use descriptive link text (not "click here" or "this link")
- **MUST** verify all external links are accessible
- **MUST** use relative links for internal repository references
- **MUST** include link titles for external references: `[text](url "title")`

## Error Prevention Requirements

- **MUST** include common troubleshooting section for complex installations
- **MUST** document known limitations and workarounds
- **MUST** specify supported operating systems and versions
- **MUST** include rollback instructions for destructive operations

## Maintenance Requirements

- **MUST** update documentation immediately when code changes affect usage
- **MUST** remove outdated information rather than leaving deprecated content
- **MUST** use consistent terminology throughout all documentation
- **MUST** validate markdown syntax before committing

## Violation Consequences

- Files with broken links **WILL BE REJECTED**
- Files without proper code block formatting **WILL BE REJECTED**
- Files with untested commands **WILL BE REJECTED**
- Files exceeding line length limits **WILL BE REJECTED**

## Applies To

- `**/{README,CHANGELOG,LICENSE,*.md}`
- Documentation files like [`README.md`](README.md:1)
- Markdown files and documentation
