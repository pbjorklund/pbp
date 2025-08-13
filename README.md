# pbproject

CLI tools for project management and AI assistant configuration.

## What it does

**pbproject**: Project lifecycle management
- `init` - Create new project with basic structure 
- `migrate` - Extract folders to new repos with history preservation (git subtree)
- `newghrepo` - Create GitHub repo for current project
- `status` - Show project status and configuration

**llm-setup**: AI instruction file management
- `llm-setup` - Set up AI instruction files (LLM_INSTRUCTIONS.md, CLAUDE.md, etc.)
- `llm-setup --status` - Show which files are present/missing

Each command shows the version and build time when executed.

## Installation

### From GitHub Release (Recommended)
```bash
# Download latest release assets
curl -L https://github.com/pbjorklund/pbproject/releases/latest/download/setup.sh -o setup.sh
curl -L https://github.com/pbjorklund/pbproject/releases/latest/download/pbproject -o pbproject
chmod +x pbproject setup.sh
./setup.sh
```

### From Source
```bash
git clone https://github.com/pbjorklund/pbproject.git
cd pbproject
./setup.sh
```

### Requirements
- bash, git (built-in)
- GitHub CLI (`gh`) for GitHub operations
  - Install: `dnf install gh` or `brew install gh`
  - Auth: `gh auth login`

## Commands

### `pbproject init`
Create new project with basic structure:
```bash
pbproject init my-tool              # Creates ./my-tool/
pbproject init my-tool ~/custom/    # Creates ~/custom/my-tool/
pbproject init .                    # Initialize current directory
```

### `pbproject migrate` 
Extract folders into new repos with history preservation using git subtree:

```bash
# From repo subdirectory - extract current subdir
cd ~/my-experiments/useful_script
pbproject migrate .
# → Creates ~/Projects/useful_script with git history

# Extract specific folder from source repo
pbproject migrate some_folder ~/path/to/source-repo
# → Creates ~/Projects/some_folder with git history

# Flags:
# --no-history    Move without preserving git history
# --force         Bypass safety checks (e.g., repo root migration)
```

**How history works**: Uses `git subtree split` to preserve commits that touched the target folder, creating a clean repo with relevant history.

### `pbproject newghrepo`
Create GitHub repository for current project:
```bash
cd my-project
pbproject newghrepo
# Creates private repo, sets remote, pushes code
```

### `pbproject status`
Show project status, git info, GitHub sync status, and AI file configuration.

## Development Workflow

### Normal Development
```bash
git add src/...
git commit -m "feat: add something"
git push
```

### Release New Version
```bash
./publish.sh {major|minor|patch}
```
- Computes next semver tag from latest
- Builds bin/pbproject with embedded version
- Tags with latest commit message as annotation
- Pushes; GitHub Actions creates release with assets

### AI Development Support
After creating a project:
```bash
llm-setup
# Sets up LLM_INSTRUCTIONS.md and tool-specific symlinks
```

## Architecture

- **Source**: Modular shell scripts in `src/`
- **Distribution**: Single-file `bin/pbproject` (built from src/)
- **Build**: `bin/pbproject-build` concatenates src/* with version info
- **CI**: GitHub Actions builds on push; creates releases on tags
- **Local**: Pre-commit hook auto-rebuilds and stages artifact

The design allows rapid development in `src/` while distributing a single executable.