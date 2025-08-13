# pbp - LLM Development Instructions

## Project Overview
- **Purpose**: Project lifecycle management tool for developers with side projects. Extract folders from monorepos with git history, create GitHub repos, sync local repos, and manage AI development setup
- **Type**: CLI tool written in Bash
- **Target Users**: Developers with multiple side projects who want to organize, extract utilities, and use AI tools effectively
- **Tech Stack**: Pure Bash shell scripting, GitHub CLI (gh), git

## Code Organization
- **Key Directories**: 
  - `src/` - Source code organized by functionality
  - `src/tasks/` - Individual command implementations (check.sh, migrate.sh, sync.sh, etc.)
  - `src/lib/` - Shared utilities (core.sh, deps.sh, ui.sh)
  - `bin/` - Built executable and build script
  - `project-templates/` - Template files for new projects
- **Entry Points**: 
  - `bin/pbp` - Main executable (built from src/)
  - `src/main.sh` - Command routing and help
- **Configuration**: 
  - Environment variables: `PBP_PROJECTS_DIR` (default ~/Projects), `PBP_LLM_TEMPLATE`
  - No config files - uses conventions and GitHub CLI auth
- **Dependencies**: git (standard), GitHub CLI (`gh auth login` required)

## Development Guidelines
- **Code Style**: 
  - All scripts use `set -euo pipefail` for safety
  - Consistent function naming (snake_case)
  - Error handling with `error()` function from ui.sh
  - Info/success messages with `info()` and `success()` functions
- **Build Process**: Use `./bin/pbp-build` to concatenate src files into single executable
- **Release Process**: Use `./publish.sh {major|minor|patch}` - handles version bumping, building, tagging, and triggers GitHub Actions for release creation
- **Documentation Standards**: Update README for user-facing changes, maintain help text in each command

## Project-Specific Context

### Critical Design Principles
- **Single binary**: All source files are concatenated into one executable for easy distribution
- **Minimal dependencies**: Only git (standard) and GitHub CLI (widely available)
- **Convention over configuration**: Uses ~/Projects by default, follows GitHub naming conventions
- **Preserve git history**: `migrate` command uses git filter-branch to maintain commit history when extracting folders

### Technology Integrations  
- **GitHub integration**: Uses `gh` CLI for repo creation, listing, and authentication
- **Git operations**: Heavy use of git commands for history preservation, status checking, and repo management
- **Build system**: Custom build script concatenates modular source files with source markers for debugging
- **LLM setup**: Embeds instruction templates and creates project-specific AI development files

### Common Gotchas
- **Always use publish.sh for releases** - don't manually create git tags or GitHub releases
- **Build before testing changes** - `./bin/pbp-build` must be run to test changes in `bin/pbp`
- **GitHub CLI auth required** - many commands fail without `gh auth login`
- **Path assumptions** - assumes `~/Projects` structure, uses absolute paths in some places
- **Git repo requirements** - most commands expect to be run in git repositories
