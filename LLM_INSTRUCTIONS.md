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
- **Release**: `./publish.sh {major|minor|patch}` (handles versioning, building, tagging, GitHub Actions)
- **Style**: All scripts use `set -euo pipefail`, error()/info()/success() functions from ui.sh

## Critical Gotchas
- **Always use publish.sh for releases** - never manually create git tags or releases
- **Must build to test** - changes in src/ don't work until `./bin/pbp-build`
- **GitHub CLI required** - most commands need `gh auth login`
- **Git repo assumptions** - commands expect to run in git repositories
