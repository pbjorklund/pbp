# pbp - LLM Development Instructions

## Project Overview
CLI tool for dev project lifecycle management. Extract folders from monorepos with git history, create GitHub repos, sync repos, manage AI development setup. Pure Bash, depends on git + GitHub CLI.

## Code Organization
- `src/tasks/`: Command implementations (check.sh, migrate.sh, sync.sh, etc.)
- `src/lib/`: Shared utilities (core.sh, deps.sh, ui.sh)
- `bin/pbp`: Built executable (concatenated from src/)
- Entry: `src/main.sh` routes commands

## Development Workflow
- Build: `./bin/pbp-build` (required to test changes)
- Commit: Use `git add -A && git commit -m "message" && git push` for all working changes
- Release: `./publish.sh {major|minor|patch}` (tags and triggers CI to build or release)
- Style: All scripts use `set -euo pipefail`, error(), info(), and success() from ui.sh

## Release Management
- Follow Semantic Versioning (SemVer) strictly:
- Patch: Bug fixes, documentation updates, small improvements (0.1.0 to 0.1.1)
- Minor: New features, backward-compatible changes (0.1.1 to 0.2.0)
- Major: Breaking changes, incompatible API changes (0.2.0 to 1.0.0)
- Be conservative with versions. Most changes should be patch or minor.
- Major versions require confirmation. `publish.sh` will warn and ask for confirmation.
- Early stage versioning: Stay in 0.x.x until the API is stable and mature.

## Critical Gotchas
- Always use `publish.sh` for releases. Do not create git tags or releases by hand.
- Only publish when the user asks.
- Build before testing. Changes in `src/` do not affect behavior until `./bin/pbp-build` runs.
- CI builds releases. `publish.sh` only creates and pushes the tag.
- Most commands need `gh auth login`.
- Commands expect to run in git repositories.
