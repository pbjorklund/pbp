# Project Analysis and Documentation TODOs

## Initial Project Understanding
- [ ] Explore repository structure using LS and Read tools to understand codebase organization
- [ ] Read existing README.md to understand current project description and identify gaps
- [ ] Identify main directories and their purposes (src/, docs/, config/, etc.)
- [ ] Check for package.json, Cargo.toml, pyproject.toml, or other dependency files to understand tech stack
- [ ] Look for build/deployment scripts to understand project workflow

## Technology Stack Analysis
- [ ] Identify primary programming languages used (via file extensions and directory structure)
- [ ] Determine frameworks, libraries, and tools from dependency files
- [ ] Check for configuration files that indicate specific technologies (docker-compose.yml, CI/CD configs, etc.)
- [ ] Identify build systems, test frameworks, and development tools
- [ ] Note any special requirements or environment dependencies

## Project Purpose and Scope
- [ ] Determine if this is: application, library, tooling, configuration, documentation, or mixed
- [ ] Identify target audience: developers, end-users, system administrators, etc.
- [ ] Understand deployment model: CLI tool, web app, desktop app, system service, etc.
- [ ] Check for any domain-specific terminology or business logic

## Documentation Quality Assessment
- [ ] Evaluate README.md completeness: installation, usage, examples, contribution guidelines
- [ ] Check for inline code documentation and comments
- [ ] Identify missing sections that would help new contributors or users
- [ ] Look for outdated information that needs updating

## Development Workflow Analysis
- [ ] Check for CI/CD configuration (.github/workflows/, .gitlab-ci.yml, etc.)
- [ ] Identify testing strategy and test file locations
- [ ] Look for development scripts (package.json scripts, Makefile targets, etc.)
- [ ] Check for linting, formatting, and code quality tools

## Project-Specific Instructions Template
Once analysis is complete, replace this section with:

```markdown
# [Project Name] - LLM Development Instructions

## Project Overview
- **Purpose**: [Brief description of what this project does]
- **Type**: [CLI tool/Web app/Library/Configuration/etc.]
- **Target Users**: [Who uses this project]
- **Tech Stack**: [Primary languages, frameworks, tools]

## Development Environment
- **Prerequisites**: [Required software, versions, accounts]
- **Setup Commands**: [How to get development environment running]
- **Build Process**: [How to build/compile the project]
- **Testing**: [How to run tests, what test frameworks are used]

## Code Organization
- **Key Directories**: [Brief description of main folders and their purposes]
- **Entry Points**: [Main files where execution begins]
- **Configuration**: [Where settings/config files are located]
- **Dependencies**: [How dependencies are managed]

## Development Guidelines
- **Code Style**: [Formatting, naming conventions, patterns used]
- **Testing Requirements**: [When to write tests, coverage expectations]
- **Documentation Standards**: [How to document code, APIs, features]
- **Review Process**: [How changes are reviewed and merged]

## Common Tasks
- **Adding Features**: [Typical workflow for new functionality]
- **Bug Fixes**: [How to approach debugging and fixes]
- **Updating Dependencies**: [Process for dependency management]
- **Deployment**: [How releases/deployments work]

## Project-Specific Context
[Any domain-specific knowledge, business rules, architectural decisions, or special considerations that would help an AI assistant work effectively on this codebase]
```
