check_dep_gh() {
  if ! command -v gh &>/dev/null; then
    error "GitHub CLI (gh) is required for this operation.
Install: dnf install gh
Then authenticate: gh auth login"
  fi
  if ! gh auth status &>/dev/null; then
    error "GitHub CLI is not authenticated.
Run: gh auth login"
  fi
}

check_dep_git() {
  if ! command -v git &>/dev/null; then
    error "Git is required but not found in PATH."
  fi
}