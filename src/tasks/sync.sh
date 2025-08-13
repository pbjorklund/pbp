show_sync_help() {
  cat <<EOF
pbp sync - Clone user's GitHub repositories and manage local repositories

USAGE:
    pbp sync [options] [directory]

ARGUMENTS:
    directory    Directory to clone repos into (default: PBP_PROJECTS_DIR or ~/Projects)

OPTIONS:
    --public     Clone only public repositories
    --private    Clone only private repositories  
    --active     Clone only recently active repositories (pushed within 6 months)
    --all        Include all repos you have access to (orgs, collaborations, etc.)
    --dry-run    Show what would be cloned without actually cloning
    --help       Show this help

DESCRIPTION:
    By default, clones only repositories you own. Use --all to include organization
    repos and collaborations. After cloning, checks for local git repositories 
    without GitHub remotes and offers to create GitHub repositories for them.
    Uses GitHub CLI - requires 'gh auth login'.

EXAMPLES:
    pbp sync                    # Clone missing owned repos to ~/Projects
    pbp sync --all              # Include org repos and collaborations
    pbp sync --public           # Clone only public owned repos
    pbp sync --dry-run          # Show what would be cloned
    pbp sync ~/Development      # Clone to specific directory

ENVIRONMENT:
    PBP_PROJECTS_DIR           # Default directory for cloning
EOF
}

sync_repos() {
  local sync_dir="${PROJECTS_DIR}"
  local public_only=false
  local private_only=false
  local active_only=false
  local dry_run=false
  local all_repos=false
  
  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      --public) public_only=true; shift ;;
      --private) private_only=true; shift ;;
      --active) active_only=true; shift ;;
      --all) all_repos=true; shift ;;
      --dry-run) dry_run=true; shift ;;
      --help) show_sync_help; return 0 ;;
      -*) error "Unknown option: $1. Use 'pbp sync --help' for usage." ;;
      *) sync_dir="$1"; shift ;;
    esac
  done
  
  # Validate conflicting options
  if [[ "$public_only" == true && "$private_only" == true ]]; then
    error "Cannot specify both --public and --private"
  fi
  
  # Check dependencies
  check_dep_gh
  
  # Ensure sync directory exists
  mkdir -p "$sync_dir"
  sync_dir=$(realpath "$sync_dir")
  
  info "Syncing GitHub repositories to: $sync_dir"
  
  # Build gh api query parameters
  local query_params=""
  if [[ "$public_only" == true ]]; then
    query_params="visibility=public"
  elif [[ "$private_only" == true ]]; then
    query_params="visibility=private"
  fi
  
  # Get list of repositories
  if [[ "$all_repos" == true ]]; then
    info "Fetching all accessible repositories from GitHub..."
    local repos_json
    repos_json=$(gh api user/repos --paginate -q '.[] | {name, clone_url, private, pushed_at, owner: .owner.login}' ${query_params:+--field "$query_params"})
  else
    info "Fetching owned repositories from GitHub..."
    local username
    username=$(gh api user --jq .login)
    local repos_json
    repos_json=$(gh api user/repos --paginate -q '.[] | select(.owner.login == "'$username'") | {name, clone_url, private, pushed_at, owner: .owner.login}' ${query_params:+--field "$query_params"})
  fi
  
  if [[ -z "$repos_json" ]]; then
    info "No repositories found"
    return 0
  fi
  
  local repos_to_clone=()
  local skipped_repos=()
  local existing_repos=()
  
  # Process each repository
  while IFS= read -r repo_line; do
    if [[ -z "$repo_line" ]]; then continue; fi
    
    local repo_name ssh_url is_private pushed_at owner
    repo_name=$(echo "$repo_line" | jq -r '.name')
    owner=$(echo "$repo_line" | jq -r '.owner')
    ssh_url="git@github.com:${owner}/${repo_name}.git"
    is_private=$(echo "$repo_line" | jq -r '.private')
    pushed_at=$(echo "$repo_line" | jq -r '.pushed_at')
    
    # Check if active filter applies
    if [[ "$active_only" == true ]]; then
      local six_months_ago
      six_months_ago=$(date -d '6 months ago' '+%Y-%m-%d' 2>/dev/null || date -v-6m '+%Y-%m-%d' 2>/dev/null)
      local pushed_date
      pushed_date=$(echo "$pushed_at" | cut -d'T' -f1)
      
      if [[ "$pushed_date" < "$six_months_ago" ]]; then
        skipped_repos+=("$repo_name (inactive: last push $pushed_date)")
        continue
      fi
    fi
    
    # Check if repository already exists locally
    if [[ -d "$sync_dir/$repo_name" ]]; then
      existing_repos+=("$repo_name")
      continue
    fi
    
    repos_to_clone+=("$repo_name|$ssh_url|$is_private")
    
  done <<< "$repos_json"
  
  # Summary
  echo
  info "Repository summary:"
  echo "  Total found: $(echo "$repos_json" | wc -l)"
  echo "  Already cloned: ${#existing_repos[@]}"
  echo "  To clone: ${#repos_to_clone[@]}"
  echo "  Skipped: ${#skipped_repos[@]}"
  
  # Show existing repos
  if [[ ${#existing_repos[@]} -gt 0 ]]; then
    echo
    info "Already cloned:"
    for repo in "${existing_repos[@]}"; do
      echo "  ✓ $repo"
    done
  fi
  
  # Show skipped repos
  if [[ ${#skipped_repos[@]} -gt 0 ]]; then
    echo
    info "Skipped repos:"
    for repo in "${skipped_repos[@]}"; do
      echo "  ⏸ $repo"
    done
  fi
  
  # Show repos to clone
  if [[ ${#repos_to_clone[@]} -gt 0 ]]; then
    echo
    if [[ "$dry_run" == true ]]; then
      info "Would clone (dry run):"
      for repo_info in "${repos_to_clone[@]}"; do
        IFS='|' read -r repo_name ssh_url is_private <<< "$repo_info"
        local privacy_indicator=""
        [[ "$is_private" == "true" ]] && privacy_indicator=" 🔒"
        echo "  → $repo_name$privacy_indicator"
      done
    else
      info "Cloning repositories..."
      local cloned=0
      local failed=0
      
      for repo_info in "${repos_to_clone[@]}"; do
        IFS='|' read -r repo_name ssh_url is_private <<< "$repo_info"
        
        echo -n "  Cloning $repo_name... "
        if git clone "$ssh_url" "$sync_dir/$repo_name" --quiet 2>/dev/null; then
          echo "✓"
          cloned=$((cloned + 1))
        else
          echo "✗ Failed"
          failed=$((failed + 1))
        fi
      done
      
      echo
      success "Cloned $cloned repositories successfully"
      if [[ $failed -gt 0 ]]; then
        info "$failed repositories failed to clone"
      fi
    fi
  else
    echo
    success "All repositories are already cloned!"
  fi
  
  # Check for local repositories without GitHub remotes
  echo
  info "Checking for local repositories without GitHub remotes..."
  
  local orphan_repos=()
  
  # Find all git repositories in sync directory
  while IFS= read -r -d '' git_dir; do
    local repo_dir
    repo_dir=$(dirname "$git_dir")
    local repo_name
    repo_name=$(basename "$repo_dir")
    
    # Skip if this directory is the current pbproject repo
    if [[ "$repo_dir" == "$sync_dir/pbproject" ]]; then
      continue
    fi
    
    # Check if it has a GitHub remote
    if ! (cd "$repo_dir" && git remote get-url origin 2>/dev/null | grep -q "github.com"); then
      orphan_repos+=("$repo_name")
    fi
  done < <(find "$sync_dir" -maxdepth 2 -name .git -type d -print0)
  
  if [[ ${#orphan_repos[@]} -gt 0 ]]; then
    echo
    info "Found ${#orphan_repos[@]} local repositories without GitHub remotes:"
    for repo in "${orphan_repos[@]}"; do
      echo "  → $repo"
    done
    
    echo
    read -p "Would you like to create GitHub repositories for these projects? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      for repo_name in "${orphan_repos[@]}"; do
        echo
        info "Processing: $repo_name"
        echo "  Location: $sync_dir/$repo_name"
        
        read -p "  Create GitHub repository for '$repo_name'? (y/N/q): " -n 1 -r
        echo
        
        case $REPLY in
          [Yy])
            echo "  Creating GitHub repository..."
            if (cd "$sync_dir/$repo_name" && create_github_repo "$sync_dir/$repo_name"); then
              success "  ✓ Created GitHub repository for $repo_name"
            else
              error "  ✗ Failed to create GitHub repository for $repo_name"
            fi
            ;;
          [Qq])
            info "  Skipping remaining repositories"
            break
            ;;
          *)
            info "  Skipped $repo_name"
            ;;
        esac
      done
    else
      info "Skipped creating GitHub repositories"
    fi
  else
    echo
    success "All local repositories have GitHub remotes!"
  fi
}