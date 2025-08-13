# pbp

**Extract folders and automatically commit, create new GitHub repos, push, and do all the time consuming annoying stuff. From nascent small hobby projects to spinning off dedicated tools.**

## Install

```bash
curl -L https://github.com/pbjorklund/pbp/releases/latest/download/pbp -o ~/.local/bin/pbp && chmod +x ~/.local/bin/pbp
```

## User Journey

**Weekend:** New side project idea strikes
```bash
pbp init discord-bot
# Use global AI configs while hacking together MVP
```

**Few weeks later:** Bot is working, want better AI help with the mess you created
```bash
pbp llm-setup  # Now Claude understands your specific bot architecture
```

**Month later:** That config parser you wrote is perfect for other projects
```bash
cd discord-bot/src/config
pbp migrate . 
# → New "config" repo with history, auto-pushed to GitHub
```

**New laptop setup:**
```bash
pbp sync --all    # Get all 47 side projects you've accumulated
```

**Sunday evening routine:**
```bash
pbp check        # Quick health check across all projects
# "discord-bot: 2 commits ahead" - push that bug fix
# "my-blog: 3 commits behind" - someone fixed your typos
# "crypto-tracker: uncommitted changes" - finish that feature
```

**2 years later:** 
```bash
# 15 extracted utilities, 8 active projects, 3 with actual users
# Everything organized in ~/Projects, no more "where did I put that script?"
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

# Sync your owned GitHub repos locally
pbp sync
# → Clones any missing owned repos from your GitHub

# Check status of all your projects  
pbp check
# → Shows git status across ~/Projects
```

| Command | Description |
|---------|-------------|
| `pbp init <project-name> [project-path]` | Create new project with basic structure |
| `pbp migrate <folder\|.> [source-project-path]` | Extract folder to new repo with history |
| `pbp migrate --no-history` | Move without preserving history |
| `pbp migrate --force` | Bypass safety checks |
| `pbp sync [directory]` | Clone owned GitHub repos that aren't cloned locally |
| `pbp sync --public` | Clone only public repos |
| `pbp sync --private` | Clone only private repos |
| `pbp sync --active` | Clone only recently active repos |
| `pbp sync --all` | Include org repos and collaborations |
| `pbp sync --dry-run` | Show what would be cloned |
| `pbp check [directory]` | Check git status across all repositories |
| `pbp llm-setup [--status]` | Set up AI development instruction files |
| `pbp newghrepo [project-path]` | Create GitHub repo for current project |  
| `pbp status [project-path]` | Show project and git status |

**Environment:**
- `PBP_PROJECTS_DIR` - Where to create new projects (default: `~/Projects`)
- `PBP_LLM_TEMPLATE` - Custom LLM instruction template file

## Requirements

- **git** - Standard on all systems  
- **GitHub CLI** - `gh auth login` (install: `dnf install gh` or `brew install gh`)

## Contributing

```bash
# Fork the repo on GitHub, then:
git clone https://github.com/YOUR_USERNAME/pbp.git && cd pbp && ./dev-setup.sh
# Make changes to src/, commit, and open a pull request
```