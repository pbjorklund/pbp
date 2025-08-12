# pbproject — LLM Development Instructions

## Project Overview
- **Purpose**: Bootstrap and manage projects with consistent, shareable LLM instruction files and repo scaffolding.
- **Type**: CLI tooling (bash scripts)
- **Target Users**: Developers maintaining many repos with unified AI assistant configs
- **Tech Stack**: bash, git, GitHub CLI (gh), standard Unix tools

## Development Environment
- **Prerequisites**: bash, git, gh, readlink, ln, cp; optional wl-copy/xclip for clipboard
- **Setup**: ensure `bin/` is on PATH or symlink `pbproject` and `llm-setup` into a directory on PATH
- **Build**: none (shell scripts); make files executable
- **Testing**: manual smoke tests by invoking commands in a temp directory

## Code Organization
- **Key Directories**:
  - `bin/`: CLI scripts (`pbproject`, `llm-setup`)
  - `project-templates/`: LLM template (`LLM_INSTRUCTIONS.md`) and directory structures (`github/`, `roo/`)
  - `.github/`, `.roo/`: project-specific instruction files for pbproject development
- **Entry Points**: `bin/pbproject`, `bin/llm-setup`
- **Configuration**: auto-detects template root relative to script path
- **Dependencies**: external tools only; no package manager

## Common Tasks
- **Initialize project**:
  - `pbproject init <name> [path]` → creates repo, writes README.md and .gitignore (minimal structure)
- **Add LLM support to existing project**:
  - `llm-setup` → copies `LLM_INSTRUCTIONS.md` template; creates independent copies for all AI tools
  - `llm-setup --status` → shows present/missing instruction files
- **Project management**:
  - `pbproject status` → shows project info and LLM instruction file status
  - `pbproject migrate <folder> [source_path]` → move folder to new repo in ~/Projects
  - `pbproject newghrepo` → create GitHub repo for current project

## Development Guidelines
- **Shell style**: `set -euo pipefail`; quote paths; prefer absolute paths via `readlink -f`
- **UX**: print clear info/success/error lines; provide backups to /tmp before operations
- **Security**: do not commit secrets; `gh` auth must be explicit; verify SSH keys
- **Docs**: keep README and this file in sync with script behavior

## Project-Specific Context
- **Template structure**: simplified to single `LLM_INSTRUCTIONS.md` with basic directory structures
- **Independent copies**: `llm-setup` creates independent files, no symlinks back to templates
- **Workflow separation**: `pbproject init` creates minimal structure; `llm-setup` adds AI support when needed
- **Self-bootstrapping**: this project uses its own `llm-setup` for AI development support
