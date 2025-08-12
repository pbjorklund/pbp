# pbproject — LLM Development Instructions

## Project Overview
- Purpose: Bootstrap and manage projects with consistent, shareable LLM instruction files and repo scaffolding.
- Type: CLI tooling (bash scripts)
- Target Users: Developers maintaining many repos with unified AI assistant configs
- Tech Stack: bash, git, GitHub CLI (gh), standard Unix tools

## Development Environment
- Prerequisites: bash, git, gh, readlink, ln, cp; optional wl-copy/xclip for clipboard
- Setup: ensure `bin/` is on PATH or symlink `pbproject` and `llm-link` into a directory on PATH
- Build: none (shell scripts); make files executable
- Testing: manual smoke tests by invoking commands in a temp directory

## Code Organization
- Key Directories:
  - bin/: CLI scripts (`pbproject`, `llm-link`)
  - project-templates/: LLM templates and scaffolding (github/, roo/, LLM_INSTRUCTIONS.md)
  - .github/, .roo/: example/template instruction trees
- Entry Points: `bin/pbproject`, `bin/llm-link`
- Configuration: auto-detects dotfiles root relative to script path
- Dependencies: external tools only; no package manager

## Common Tasks
- Initialize project:
  - `pbproject init <name> [path]` → creates repo, writes README.md and .gitignore, runs `llm-link`
- Manage LLM files:
  - `llm-link` → copies project `LLM_INSTRUCTIONS.md`; symlinks `AGENTS.md`, `CLAUDE.md`, `GEMINI.md` to it; copies `.github/` and `.roo/`
  - `llm-link --status` → shows copied/symlinked/missing
  - `llm-link --detach` → converts internal symlinks into local copies
- Project status: `pbproject status`
- Detach in project: `pbproject detach`
- Migrate folder to new repo in `~/Projects`: `pbproject migrate <folder> [source_path]`
- Create GitHub repo: `pbproject newghrepo`

## Development Guidelines
- Shell style: `set -euo pipefail`; quote paths; prefer absolute paths via `readlink -f`
- UX: print clear info/success/error lines; provide backups to /tmp before linking
- Security: do not commit secrets; `gh` auth must be explicit; verify SSH keys
- Docs: keep README and this file in sync with script behavior

## Project-Specific Context
- `llm-link` expects global templates in dotfiles: `project-templates/LLM_INSTRUCTIONS.md`, `project-templates/github`, `project-templates/roo`, and `dotfiles/claude/CLAUDE.md`
- `pbproject migrate` commits and pushes a new repo, then removes the original folder from the source repo and commits that change
