# pbp

🚀 **Extract folders from monorepos into focused projects with preserved git history.**

## Install

```bash
curl -L https://github.com/pbjorklund/pbp/releases/latest/download/pbp -o ~/.local/bin/pbp && chmod +x ~/.local/bin/pbp
```

## Usage

```bash
# Extract current directory to new repo
cd my-monorepo/useful-component  
pbp migrate .
# → ~/Projects/useful-component with git history + GitHub repo

# Extract specific folder
pbp migrate components/auth
# → ~/Projects/auth with history

# Skip history preservation (faster)
pbp migrate . --no-history
```

| Command | Description |
|---------|-------------|
| `pbp init <name>` | Create new project with basic structure |
| `pbp migrate <folder\|.>` | Extract folder to new repo with history |
| `pbp newghrepo` | Create GitHub repo for current project |  
| `pbp status` | Show project and git status |

## Requirements

- **git** - Standard on all systems  
- **GitHub CLI** - `gh auth login` (install: `dnf install gh` or `brew install gh`)

## Contributing

```bash
git clone https://github.com/pbjorklund/pbp.git && cd pbp && ./dev-setup.sh
# Make changes to src/, then: ./publish.sh patch
```