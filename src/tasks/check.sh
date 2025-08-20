show_check_help() {
  cat <<EOF
pbp check - Check git status across all repositories

USAGE:
    pbp check [directory] [--debug]

ARGUMENTS:
    directory    Directory to scan for git repos (default: PBP_PROJECTS_DIR or ~/Projects)

OPTIONS:
    --debug      Show debug information for tracking branch issues

DESCRIPTION:
    Scans the specified directory for git repositories and reports their status:
    - Uncommitted changes
    - Untracked/staged files  
    - Unpushed/unpulled commits
    - Sync status with remote

EXAMPLES:
    pbp check                  # Check ~/Projects (or PBP_PROJECTS_DIR)
    pbp check ~/Development    # Check specific directory
    pbp check --debug          # Show debug info for repos with issues
    
ENVIRONMENT:
    PBP_PROJECTS_DIR          # Default directory to check
EOF
}

# Check a single repository and return status
check_single_repo() {
  local check_dir="$1"
  local dir="$2"
  local debug_mode="$3"
  local repo_name="${dir%/}"
  
  # Colors
  local RED='\033[0;31m'
  local GREEN='\033[0;32m'  
  local YELLOW='\033[1;33m'
  local NC='\033[0m'
  
  # Fetch latest remote changes silently (with timeout)
  timeout 10 git -C "$check_dir/$dir" fetch --quiet 2>/dev/null || true
  
  # Check for uncommitted changes
  if ! git -C "$check_dir/$dir" diff-index --quiet HEAD -- 2>/dev/null; then
    echo -e "${RED}❌ $repo_name${NC} - Uncommitted changes"
    return 1
  elif [[ -n "$(git -C "$check_dir/$dir" status --porcelain)" ]]; then
    echo -e "${YELLOW}⚠️  $repo_name${NC} - Untracked/staged files"
    return 1
  else
    # Check for unpushed/unpulled commits
    local local_head remote_head
    local_head=$(git -C "$check_dir/$dir" rev-parse HEAD 2>/dev/null || echo "")
    remote_head=$(git -C "$check_dir/$dir" rev-parse @{u} 2>/dev/null || echo "")
    
    if [[ -n "$local_head" && -n "$remote_head" ]]; then
      if [[ "$local_head" != "$remote_head" ]]; then
        # Check if we're ahead or behind
        local ahead behind
        ahead=$(git -C "$check_dir/$dir" rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
        behind=$(git -C "$check_dir/$dir" rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
        
        if [[ "$debug_mode" == "true" && ("$behind" -gt 0 || "$ahead" -gt 0) ]]; then
          local upstream_branch current_branch
          upstream_branch=$(git -C "$check_dir/$dir" rev-parse --abbrev-ref @{u} 2>/dev/null || echo "unknown")
          current_branch=$(git -C "$check_dir/$dir" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
          local actual_head
          actual_head=$(git -C "$check_dir/$dir" log -1 --format="%H" 2>/dev/null | cut -c1-7)
          echo "DEBUG $repo_name: local=$local_head remote=$remote_head upstream=$upstream_branch branch=$current_branch actual_head=$actual_head ahead=$ahead behind=$behind" >&2
          echo "DEBUG $repo_name: path=$check_dir/$dir" >&2
        fi
        
        if [[ "$behind" -gt 0 && "$ahead" -gt 0 ]]; then
          echo -e "${RED}🔄 $repo_name${NC} - $ahead commits to push, $behind commits to pull (diverged)"
          return 1
        elif [[ "$ahead" -gt 0 ]]; then
          echo -e "${YELLOW}📤 $repo_name${NC} - $ahead commits ahead (unpushed)"
          return 1
        elif [[ "$behind" -gt 0 ]]; then
          echo -e "${YELLOW}📥 $repo_name${NC} - $behind commits behind remote (need to pull)"
          return 1
        fi
      else
        echo -e "${GREEN}✅ $repo_name${NC} - Clean and synced"
        return 0
      fi
    elif [[ -n "$local_head" ]]; then
      if [[ "$debug_mode" == "true" ]]; then
        local current_branch remotes
        current_branch=$(git -C "$check_dir/$dir" branch --show-current 2>/dev/null || echo "unknown")
        remotes=$(git -C "$check_dir/$dir" remote -v 2>/dev/null | head -3 || echo "none")
        echo "DEBUG $repo_name: no upstream tracking - branch=$current_branch remotes: $remotes" >&2
      fi
      echo -e "${YELLOW}🔗 $repo_name${NC} - No remote tracking branch"
      return 1
    else
      echo -e "${RED}❓ $repo_name${NC} - Unable to determine status"
      return 1
    fi
  fi
}

check_repos() {
  local check_dir="$PROJECTS_DIR"
  local debug_mode=false
  
  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help)
        show_check_help
        return 0
        ;;
      --debug)
        debug_mode=true
        shift
        ;;
      *)
        check_dir="$1"
        shift
        ;;
    esac
  done
  
  if [[ ! -d "$check_dir" ]]; then
    error "Directory does not exist: $check_dir"
  fi
  
  # Set up interrupt handler
  trap 'echo -e "\n\nInterrupted by user"; kill $(jobs -p) 2>/dev/null || true; exit 130' INT
  
  # Colors
  local BLUE='\033[0;34m'
  local GREEN='\033[0;32m'
  local YELLOW='\033[1;33m'
  local NC='\033[0m'
  
  echo -e "${BLUE}🔍 Checking git status in $check_dir...${NC}"
  echo
  
  builtin cd "$check_dir" || error "Cannot access directory: $check_dir"
  
  # Create temp files for collecting results
  local temp_dir
  temp_dir=$(mktemp -d)
  local output_file="$temp_dir/output"
  local status_file="$temp_dir/status"
  
  # Track background jobs
  local pids=()
  local checked_repos=0
  
  # Start parallel checks
  for dir in */; do
    if [[ -d "$dir/.git" ]]; then
      checked_repos=$((checked_repos + 1))
      {
        if check_single_repo "$check_dir" "$dir" "$debug_mode"; then
          echo "0" >> "$status_file"
        else
          echo "1" >> "$status_file"
        fi
      } >> "$output_file" &
      pids+=($!)
    fi
  done
  
  # Wait for all background jobs to complete
  for pid in "${pids[@]}"; do
    wait "$pid" 2>/dev/null || true
  done
  
  # Display results (sorted by repo name)
  if [[ -f "$output_file" ]]; then
    sort "$output_file"
  fi
  
  # Count issues
  local found_issues=false
  if [[ -f "$status_file" ]] && grep -q "1" "$status_file" 2>/dev/null; then
    found_issues=true
  fi
  
  # Cleanup
  rm -rf "$temp_dir"
  
  echo
  if [[ "$checked_repos" -eq 0 ]]; then
    echo -e "${YELLOW}No git repositories found in $check_dir${NC}"
  elif [[ "$found_issues" == false ]]; then
    echo -e "${GREEN}🎉 All $checked_repos repositories are clean and synced!${NC}"
  else
    echo -e "${YELLOW}⚠️  Some repositories need attention (checked $checked_repos repos)${NC}"
  fi
}