# pbp

🚀 **Project lifecycle management** - Extract folders from monorepos into focused projects with preserved git history.

## Features

- **Smart Migration** - Extract any folder into a new repo with complete git history
- **Minimal Dependencies** - Works with standard git installation (no subtree required)  
- **Auto GitHub Integration** - Creates repos, sets remotes, pushes code automatically
- **AI Development Ready** - Sets up instruction files for Claude, GitHub Copilot, etc.
- **Version Tracking** - Shows version/build info on every command

## Quick Start

```bash
# Install
curl -L https://github.com/pbjorklund/pbp/releases/latest/download/setup.sh | bash

# Extract a folder from your current repo
cd my-monorepo/useful-component
pbp migrate .
# → Creates ~/Projects/useful-component with git history + GitHub repo

# Or extract a specific folder  
pbp migrate components/auth
# → Creates ~/Projects/auth with history
```

## Commands

| Command | Description |
|---------|-------------|
| `pbp init <name>` | Create new project with basic structure |
| `pbp migrate <folder\|.>` | Extract folder to new repo with history |
| `pbp newghrepo` | Create GitHub repo for current project |  
| `pbp status` | Show project and git status |

## Migration Examples

```bash
# Extract current directory (you're in a subdirectory of a repo)
cd ~/experiments/batch-processor  
pbp migrate .
# → ~/Projects/batch-processor with full git history

# Extract specific component
pbp migrate src/auth-service
# → ~/Projects/auth-service  

# Move without preserving history (faster)
pbp migrate . --no-history
```

**What happens:**
1. Extracts folder with relevant git history using built-in git commands
2. Removes folder from source repo and commits the deletion
3. Creates new repo under `~/Projects/`
4. Sets up GitHub repo and pushes code
5. You end up in the new project directory

## Installation

### Quick Install (Recommended)
```bash
# Download and run setup
curl -L https://github.com/pbjorklund/pbp/releases/latest/download/pbp -o pbp
chmod +x pbp && mkdir -p ~/.local/bin && mv pbp ~/.local/bin/
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
```

### With Setup Script  
```bash
# Clone repo and use setup script (includes llm-setup)
git clone https://github.com/pbjorklund/pbp.git && cd pbp && ./setup.sh
```

### From Source
```bash
git clone https://github.com/pbjorklund/pbp.git && cd pbp && ./setup.sh
```

## Requirements

- **bash, git** - Standard on all systems
- **GitHub CLI** - For GitHub operations: `gh auth login`
  - Install: `dnf install gh` (Fedora) or `brew install gh` (macOS)

## Contributing

```bash
# Setup for development
git clone https://github.com/pbjorklund/pbp.git && cd pbp
./setup.sh && git config core.hooksPath .githooks

# Make changes to src/
# Pre-commit hook auto-builds bin/pbp

# Release
./publish.sh patch  # or minor, major
```

**Architecture:** Modular shell scripts in `src/` built into single `bin/pbp` executable.