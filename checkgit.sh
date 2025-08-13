#!/bin/bash

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Checking git status across all directories...${NC}\n"

found_issues=false

for dir in */; do
    if [ -d "$dir/.git" ]; then
        cd "$dir"
        
        # Get repo name
        repo_name=$(basename "$(pwd)")
        
        # Fetch latest remote changes silently
        git fetch --quiet 2>/dev/null || true
        
        # Check for uncommitted changes
        if ! git diff-index --quiet HEAD -- 2>/dev/null; then
            echo -e "${RED}❌ $repo_name${NC} - Uncommitted changes"
            found_issues=true
        elif [ -n "$(git status --porcelain)" ]; then
            echo -e "${YELLOW}⚠️  $repo_name${NC} - Untracked/staged files"
            found_issues=true
        else
            # Check for unpushed/unpulled commits
            local_head=$(git rev-parse HEAD 2>/dev/null || echo "")
            remote_head=$(git rev-parse @{u} 2>/dev/null || echo "")
            
            if [ -n "$local_head" ] && [ -n "$remote_head" ]; then
                if [ "$local_head" != "$remote_head" ]; then
                    # Check if we're ahead or behind
                    ahead=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
                    behind=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
                    
                    if [ "$behind" -gt 0 ] && [ "$ahead" -gt 0 ]; then
                        echo -e "${RED}🔄 $repo_name${NC} - $behind commits to push, $ahead commits to pull (diverged)"
                        found_issues=true
                    elif [ "$behind" -gt 0 ]; then
                        echo -e "${YELLOW}📤 $repo_name${NC} - $behind commits ahead (unpushed)"
                        found_issues=true
                    elif [ "$ahead" -gt 0 ]; then
                        echo -e "${YELLOW}📥 $repo_name${NC} - $ahead commits behind remote (need to pull)"
                        found_issues=true
                    fi
                else
                    echo -e "${GREEN}✅ $repo_name${NC} - Clean and synced"
                fi
            elif [ -n "$local_head" ]; then
                echo -e "${YELLOW}🔗 $repo_name${NC} - No remote tracking branch"
                found_issues=true
            else
                echo -e "${RED}❓ $repo_name${NC} - Unable to determine status"
                found_issues=true
            fi
        fi
        
        cd ..
    fi
done

echo ""
if [ "$found_issues" = false ]; then
    echo -e "${GREEN}🎉 All repositories are clean and synced!${NC}"
else
    echo -e "${YELLOW}⚠️  Some repositories need attention${NC}"
fi