# pbp - LLM Development Instructions

## Project Overview
CLI tool for dev project lifecycle management. Extract folders from monorepos with git history, create GitHub repos, sync repos, manage AI development setup. Pure Bash, depends on git + GitHub CLI.

## Code Organization
- `src/tasks/` - Command implementations (check.sh, migrate.sh, sync.sh, etc.)
- `src/lib/` - Shared utilities (core.sh, deps.sh, ui.sh)  
- `bin/pbp` - Built executable (concatenated from src/)
- Entry: `src/main.sh` routes commands

## Development Workflow
- **Build**: `./bin/pbp-build` (required to test changes)
- **Commit**: Use `git add -A && git commit -m "message" && git push` for all working changes
- **Release**: `./publish.sh {major|minor|patch}` (tags and triggers CI to build/release)
- **Style**: All scripts use `set -euo pipefail`, error()/info()/success() functions from ui.sh

## Release Management
- **Follow Semantic Versioning (SemVer)** strictly:
  - **patch**: Bug fixes, documentation updates, small improvements (0.1.0 → 0.1.1)
  - **minor**: New features, backward-compatible changes (0.1.1 → 0.2.0)
  - **major**: Breaking changes, incompatible API changes (0.2.0 → 1.0.0)
- **Be conservative with versions** - most changes should be patch or minor
- **Major versions require confirmation** - publish.sh will warn and ask for confirmation
- **Early stage versioning**: Stay in 0.x.x until the API is stable and mature

## Critical Gotchas
- **Always use publish.sh for releases** - never manually create git tags or releases
- **Only publish when explicitly asked** - don't create releases without user request
- **Must build to test** - changes in src/ don't work until `./bin/pbp-build`
- **CI builds releases** - publish.sh only tags, GitHub Actions builds the final binary
- **GitHub CLI required** - most commands need `gh auth login`
- **Git repo assumptions** - commands expect to run in git repositories
