# pbproject

CLI tools for project management and AI assistant configuration.

## What it does

**pbproject**: Manages project lifecycle
- `pbproject init my-app` - Create new project with AI config files
- `pbproject migrate folder_name` - Extract folder to new GitHub repo in ~/Projects/
- `pbproject newghrepo` - Create GitHub repo for current project
- `pbproject status/detach` - Manage project configuration

**llm-setup**: Manages AI instruction files  
- `llm-setup` - Set up AI instruction files (CLAUDE.md, AGENTS.md, etc.)
- `llm-setup --status` - Show which files are present/missing

## Installation

```bash
git clone https://github.com/pbjorklund/pbproject.git
cd pbproject
./setup.sh
```

Requires: bash, git, GitHub CLI (`gh`)

## Usage

Create a new project:
```bash
pbproject init my-tool
```

Promote a folder from your experiments to a standalone repo:
```bash
cd ~/my-experiments
pbproject migrate useful_script
# Creates ~/Projects/useful_script as a GitHub repo, removes original
```

Set up AI files in existing project:
```bash
llm-setup
# Creates LLM_INSTRUCTIONS.md and symlinks CLAUDE.md, AGENTS.md, etc. to it
```

That's it.