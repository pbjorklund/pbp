show_status() {
  local project_path="${1:-$PWD}"; cd "$project_path"
  if [[ ! -d .git ]]; then error "Not in a git repository. Run this command in a project directory."; fi
  info "Project status for: $project_path"; echo
  echo "📁 Project: $(basename "$project_path")"; echo "📂 Path: $project_path"; echo
  echo "🔀 Git Information:"; local current_branch; current_branch=$(git branch --show-current 2>/dev/null || echo "unknown"); echo "   Branch: $current_branch"
  if ! git diff-index --quiet HEAD -- 2>/dev/null; then echo "   Status: ⚠️  Uncommitted changes"; else echo "   Status: ✅ Clean working directory"; fi
  if git remote get-url origin &>/dev/null; then
    local remote_url; remote_url=$(git remote get-url origin); echo "   Remote: $remote_url"
    if [[ "$remote_url" == *"github.com"* ]]; then
      echo; echo "🐙 GitHub Repository:"; local repo_info=""
      if [[ "$remote_url" == *"git@github.com:"* ]]; then repo_info=$(echo "$remote_url" | sed 's/git@github.com://' | sed 's/\.git$//');
      elif [[ "$remote_url" == *"https://github.com/"* ]]; then repo_info=$(echo "$remote_url" | sed 's|https://github.com/||' | sed 's/\.git$//'); fi
      if [[ -n "$repo_info" ]] && command -v gh &>/dev/null; then
        echo "   Repository: https://github.com/$repo_info"
        if gh repo view "$repo_info" &>/dev/null; then
          local visibility; visibility=$(gh repo view "$repo_info" --json visibility --jq .visibility 2>/dev/null || echo "unknown"); echo "   Visibility: $visibility"
          if git fetch origin &>/dev/null; then
            local ahead behind; ahead=$(git rev-list --count HEAD..origin/$current_branch 2>/dev/null || echo "0"); behind=$(git rev-list --count origin/$current_branch..HEAD 2>/dev/null || echo "0")
            if [[ "$ahead" -gt 0 ]] && [[ "$behind" -gt 0 ]]; then echo "   Sync: ⚠️  $behind ahead, $ahead behind";
            elif [[ "$behind" -gt 0 ]]; then echo "   Sync: ⬆️  $behind commits ahead";
            elif [[ "$ahead" -gt 0 ]]; then echo "   Sync: ⬇️  $ahead commits behind"; else echo "   Sync: ✅ Up to date"; fi
          fi
        else echo "   Status: ❌ Repository not accessible or doesn't exist"; fi
      else echo "   Repository: $repo_info (GitHub CLI not available for detailed info)"; fi
    fi
  else echo "   Remote: ❌ No remote configured"; echo; echo "💡 To create GitHub repository: pbp newghrepo"; fi
  echo
  echo "📋 Project Structure:"; [[ -f README.md ]] && echo "   ✅ README.md" || echo "   ❌ README.md missing"; [[ -f .gitignore ]] && echo "   ✅ .gitignore" || echo "   ❌ .gitignore missing"
  if [[ -f package.json ]]; then echo "   📦 package.json (Node.js project)"; elif [[ -f Cargo.toml ]]; then echo "   🦀 Cargo.toml (Rust project)"; elif [[ -f pyproject.toml ]] || [[ -f requirements.txt ]]; then echo "   🐍 Python project"; elif [[ -f go.mod ]]; then echo "   🐹 go.mod (Go project)"; fi
  echo
  echo "🤖 AI Development Support:";
  if command -v llm-setup &>/dev/null; then llm-setup --status;
  elif [[ -x "$PBP_ROOT/bin/llm-setup" ]]; then "$PBP_ROOT/bin/llm-setup" --status;
  else echo "   ❌ llm-setup not found - LLM instruction files not configured"; echo "   💡 Run 'llm-setup' to add AI development support"; fi
}
