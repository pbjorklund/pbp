# Configuration Files Rules

MANDATORY requirements for all dotfiles and configuration files in this repository.

## File Structure Requirements

- **MUST** include comment header with file purpose and key features
- **MUST** organize settings into clearly labeled sections using `# Section Name`
- **MUST** place most critical settings at the top of each section
- **MUST** separate sections with blank lines for readability

## Bashrc Configuration Requirements

- **MUST** set `HISTSIZE=10000` and `HISTFILESIZE=20000` minimum
- **MUST** include aliases: `ll='ls -alF'`, `la='ls -A'`, `l='ls -CF'`
- **MUST** set `export EDITOR=vim` or available editor
- **MUST** use `[[ -f /path/to/file ]] && source /path/to/file` for conditional loading
- **MUST** include `shopt -s histappend` for history handling

## Git Configuration Requirements

- **MUST** set `user.name` and `user.email` (use placeholder values if public)
- **MUST** set `core.autocrlf=input` for line endings
- **MUST** set `init.defaultBranch=main`
- **MUST** include aliases: `st=status`, `co=checkout`, `br=branch`, `ci=commit`
- **MUST** set `pull.rebase=false` to specify merge strategy

## Tmux Configuration Requirements

- **MUST** set prefix key binding (default `C-b` or custom like `C-a`)
- **MUST** enable mouse support: `set -g mouse on`
- **MUST** set base index: `set -g base-index 1`
- **MUST** configure status bar with hostname and time
- **MUST** enable vi mode: `setw -g mode-keys vi`

## Cross-Platform Requirements

- **MUST** use OS detection: `case "$(uname -s)" in Darwin|Linux|CYGWIN*)`
- **MUST** check command existence: `command -v cmd >/dev/null 2>&1 && cmd`
- **MUST** provide fallback values for missing tools
- **MUST** document OS-specific sections with comments

## Security Requirements

- **SHALL NOT** include real usernames, emails, or personal data in public configs
- **SHALL NOT** include tokens, passwords, API keys, or secrets
- **MUST** use `chmod 600` for sensitive config files
- **MUST** use environment variables: `${HOME}`, `${USER}` instead of hardcoded paths
- **MUST** use placeholder values: `user.name = "Your Name"`, `user.email = "your.email@example.com"`

## Comment Requirements

- **MUST** explain non-obvious settings with inline comments
- **MUST** include purpose comments for custom functions or aliases
- **MUST** document keybindings and shortcuts
- **MUST** include URL references for complex configurations

## Validation Requirements

- **MUST** validate syntax before committing (shell: `bash -n file`, tmux: `tmux source file`)
- **MUST** test configurations on clean system before deploying
- **MUST** verify all referenced files and commands exist
- **MUST** ensure configurations are compatible with target systems

## Violation Consequences

- Files with syntax errors **WILL BE REJECTED**
- Files containing real personal data **WILL BE REJECTED**
- Files without proper comments **WILL BE REJECTED**
- Files failing validation **WILL BE REJECTED**

## Applies To

- `**/{.*rc,.*conf,.*config}`
- Configuration files like [`bashrc`](bashrc:1), [`gitconfig`](gitconfig:1), [`tmux.conf`](tmux.conf:1)
- Hidden configuration files and directories
