create_github_repo() {
  local project_path="${1:-$PWD}"; cd "$project_path"
  if [[ ! -d .git ]]; then error "Not in a git repository. Run this command in a project directory."; fi
  if ! command -v gh &>/dev/null; then error "GitHub CLI (gh) is not installed. Install it with: dnf install gh"; fi
  if ! gh auth status &>/dev/null; then error "Not authenticated with GitHub. Run: gh auth login"; fi
  local project_name; project_name=$(basename "$project_path")
  local current_remote=""; if git remote get-url origin &>/dev/null; then current_remote=$(git remote get-url origin); info "Current remote origin: $current_remote"
    if [[ "$current_remote" == *"github.com"* ]]; then
      local username expected_remote expected_https; username=$(gh api user --jq .login); expected_remote="git@github.com:$username/$project_name.git"; expected_https="https://github.com/$username/$project_name.git"
      if [[ "$current_remote" == "$expected_remote" ]] || [[ "$current_remote" == "$expected_https" ]]; then
        info "GitHub repository already configured correctly"
        if git log origin/"$(git branch --show-current)" 2>/dev/null; then info "Repository is up to date"; else info "Attempting to push unpushed commits"; if git push origin "$(git branch --show-current)"; then success "Successfully pushed to existing repository"; else error "Failed to push to existing repository. Check SSH keys or run manually: git push origin $(git branch --show-current)"; fi; fi
        return
      else info "Different GitHub repository already configured: $current_remote"; return; fi
    fi
  fi
  local username; username=$(gh api user --jq .login)
  if gh repo view "$username/$project_name" &>/dev/null; then
    info "Repository $username/$project_name already exists on GitHub"
    if [[ -z "$current_remote" ]]; then info "Adding remote origin"; git remote add origin "git@github.com:$username/$project_name.git"; success "Added remote origin"; fi
    info "Attempting to push to existing repository"; if git push -u origin "$(git branch --show-current)"; then success "Successfully pushed to existing repository"; success "Repository URL: https://github.com/$username/$project_name"; else error "Failed to push to repository. Check SSH keys or run manually: git push -u origin $(git branch --show-current)"; fi; return
  fi
  info "Creating private GitHub repository: $project_name"
  if gh repo create "$project_name" --private --source=. --remote=origin; then
    success "GitHub repository created successfully"; info "Pushing code to repository"
    if git push -u origin "$(git branch --show-current)"; then success "Code pushed successfully"; success "Repository URL: https://github.com/$username/$project_name"; else info "Repository created but push failed"; info "You can push manually later with: git push -u origin $(git branch --show-current)"; info "Check your SSH keys: ssh -T git@github.com"; success "Repository URL: https://github.com/$username/$project_name"; fi
  else error "Failed to create GitHub repository"; fi
}
