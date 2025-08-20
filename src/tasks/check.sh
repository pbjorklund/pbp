show_check_help() {
  cat <<EOF
pbp check - Check git status across all repositories

USAGE:
    pbp check [directory]

ARGUMENTS:
    directory    Directory to scan for git repos (default: PBP_PROJECTS_DIR or ~/Projects)

DESCRIPTION:
    Scans the specified directory for git repositories and reports their status:
    - Uncommitted changes
    - Untracked/staged files  
    - Unpushed/unpulled commits
    - Sync status with remote

EXAMPLES:
    pbp check                  # Check ~/Projects (or PBP_PROJECTS_DIR)
    pbp check ~/Development    # Check specific directory
    
ENVIRONMENT:
    PBP_PROJECTS_DIR          # Default directory to check
EOF
}

check_repos() {
  local check_dir="${1:-$PROJECTS_DIR}"
  
  if [[ "${1:-}" == "--help" ]]; then
    show_check_help
    return 0
  fi
  
  if [[ ! -d "$check_dir" ]]; then
    error "Directory does not exist: $check_dir"
  fi
  
  # Set up interrupt handler
  trap 'echo -e "\n\nInterrupted by user"; exit 130' INT
  
  # Colors
  local RED='\033[0;31m'
  local GREEN='\033[0;32m'  
  local YELLOW='\033[1;33m'
  local BLUE='\033[0;34m'
  local NC='\033[0m'
  
  echo -e "${BLUE}🔍 Checking git status in $check_dir...${NC}"
  echo
  
  local found_issues=false
  local checked_repos=0
  
  builtin cd "$check_dir" || error "Cannot access directory: $check_dir"
  
  for dir in */; do
    if [[ -d "$dir/.git" ]]; then
      checked_repos=$((checked_repos + 1))
      
      # Get repo name (remove trailing slash)
      local repo_name="${dir%/}"
      
      # Fetch latest remote changes silently (with timeout)
      timeout 10 git -C "$dir" fetch --quiet 2>/dev/null || true
      
      # Check for uncommitted changes
      if ! git -C "$dir" diff-index --quiet HEAD -- 2>/dev/null; then
        echo -e "${RED}❌ $repo_name${NC} - Uncommitted changes"
        found_issues=true
      elif [[ -n "$(git -C "$dir" status --porcelain)" ]]; then
        echo -e "${YELLOW}⚠️  $repo_name${NC} - Untracked/staged files"
        found_issues=true
      else
        # Check for unpushed/unpulled commits
        local local_head remote_head
        local_head=$(git -C "$dir" rev-parse HEAD 2>/dev/null || echo "")
        remote_head=$(git -C "$dir" rev-parse @{u} 2>/dev/null || echo "")
        
        if [[ -n "$local_head" && -n "$remote_head" ]]; then
          if [[ "$local_head" != "$remote_head" ]]; then
            # Check if we're ahead or behind
            local ahead behind
            ahead=$(git -C "$dir" rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
            behind=$(git -C "$dir" rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
            
            if [[ "$behind" -gt 0 && "$ahead" -gt 0 ]]; then
              echo -e "${RED}🔄 $repo_name${NC} - $ahead commits to push, $behind commits to pull (diverged)"
              found_issues=true
            elif [[ "$ahead" -gt 0 ]]; then
              echo -e "${YELLOW}📤 $repo_name${NC} - $ahead commits ahead (unpushed)"
              found_issues=true
            elif [[ "$behind" -gt 0 ]]; then
              echo -e "${YELLOW}📥 $repo_name${NC} - $behind commits behind remote (need to pull)"
              found_issues=true
            fi
          else
            echo -e "${GREEN}✅ $repo_name${NC} - Clean and synced"
          fi
        elif [[ -n "$local_head" ]]; then
          echo -e "${YELLOW}🔗 $repo_name${NC} - No remote tracking branch"
          found_issues=true
        else
          echo -e "${RED}❓ $repo_name${NC} - Unable to determine status"
          found_issues=true
        fi
      fi
    fi
  done
  
  echo
  if [[ "$checked_repos" -eq 0 ]]; then
    echo -e "${YELLOW}No git repositories found in $check_dir${NC}"
  elif [[ "$found_issues" == false ]]; then
    echo -e "${GREEN}🎉 All $checked_repos repositories are clean and synced!${NC}"
  else
    echo -e "${YELLOW}⚠️  Some repositories need attention (checked $checked_repos repos)${NC}"
  fi
}