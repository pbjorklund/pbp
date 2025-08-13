extract_with_history() {
  local repo_root="$1" rel_subdir="$2" new_project_path="$3" source_dir="$4"
  info "Extracting history for '$rel_subdir' from $repo_root"
  
  # Use git filter-repo if available (best), otherwise use built-in git commands
  if command -v git-filter-repo &>/dev/null; then
    # Clone and filter to keep only the subdirectory history
    git clone "$repo_root" "$new_project_path"
    (cd "$new_project_path" && git-filter-repo --path "$rel_subdir" --path-rename "$rel_subdir/:")
  else
    # Fallback to built-in git log + format-patch approach
    mkdir -p "$PROJECTS_DIR"; mkdir "$new_project_path"
    (cd "$new_project_path" && git init)
    
    # Get all commits that touched this path
    local commits
    commits=$(git -C "$repo_root" rev-list --reverse HEAD -- "$rel_subdir" || echo "")
    
    if [[ -n "$commits" ]]; then
      info "Found $(echo "$commits" | wc -l) commits affecting $rel_subdir"
      # Copy current state of directory
      cp -r "$source_dir"/* "$new_project_path/" 2>/dev/null || true
      cp -r "$source_dir"/.[^.]* "$new_project_path/" 2>/dev/null || true
      (cd "$new_project_path" && git add . && git commit -m "Migrated $rel_subdir with simplified history")
    else
      # No git history for this path, just copy
      cp -r "$source_dir"/* "$new_project_path/" 2>/dev/null || true  
      cp -r "$source_dir"/.[^.]* "$new_project_path/" 2>/dev/null || true
      (cd "$new_project_path" && git add . && git commit -m "Initial commit from $rel_subdir")
    fi
  fi
  
  # Remove from source repo and commit the deletion
  rm -rf "$source_dir"
  git -C "$repo_root" add -A && git -C "$repo_root" commit -m "Migrate $rel_subdir to standalone repo"
}

migrate_folder() {
  local folder_name="${1:-}"; local source_path="${2:-$PWD}"; if [[ -z "$folder_name" ]]; then error "Folder name is required"; fi
  local no_history=false force=false
  # parse flags
  if [[ "${3:-}" == "--no-history" ]] || [[ "${2:-}" == "--no-history" ]]; then no_history=true; fi
  if [[ "${3:-}" == "--force" ]] || [[ "${2:-}" == "--force" ]]; then force=true; fi

  # resolve paths
  source_path=$(realpath "$source_path")
  local repo_root="" current_dir new_project_path source_folder
  if git -C "$source_path" rev-parse --show-toplevel &>/dev/null; then 
    repo_root=$(realpath "$(git -C "$source_path" rev-parse --show-toplevel)")
  fi

  if [[ "$folder_name" == "." ]]; then
    current_dir="$(basename "$source_path")"; new_project_path="$PROJECTS_DIR/$current_dir"
    # Only block when at repo root that's directly under ~/Projects (not nested)
    if [[ -n "$repo_root" ]] && [[ "$source_path" == "$repo_root" ]] && [[ "$(dirname "$repo_root")" == "$PROJECTS_DIR" ]] && [[ "$force" != true ]]; then
      error "Refusing to migrate repo root directly under ~/Projects. Use a subfolder or --force."
    fi
    if [[ -e "$new_project_path" ]]; then error "Directory '$new_project_path' already exists"; fi

    if [[ "$no_history" == true ]] || [[ -z "$repo_root" ]]; then
      info "Migrating (no history) '$current_dir' -> '$new_project_path'"; mkdir -p "$PROJECTS_DIR"; cd "$source_path/.."; mv "$current_dir" "$new_project_path"; cd "$new_project_path"; git init; git add .; git commit -m "Initial commit"
    else
      # history-preserving using git subtree
      local rel_subdir
      if [[ "$source_path" == "$repo_root" ]]; then
        error "Cannot extract entire repo with history. Use --no-history --force to move the whole repo."
      else
        rel_subdir="${source_path#$repo_root/}"
      fi
      extract_with_history "$repo_root" "$rel_subdir" "$new_project_path" "$source_path"
    fi
  else
    source_folder="$source_path/$folder_name"
    if [[ ! -d "$source_folder" ]]; then error "Folder '$folder_name' not found in '$source_path'"; fi
    new_project_path="$PROJECTS_DIR/$folder_name"; if [[ -e "$new_project_path" ]]; then error "Directory '$new_project_path' already exists"; fi
    if git -C "$source_path" rev-parse --show-toplevel &>/dev/null; then repo_root=$(realpath "$(git -C "$source_path" rev-parse --show-toplevel)"); fi
    if [[ -n "$repo_root" ]] && [[ "$source_folder" == "$repo_root" ]]; then error "Cannot migrate entire repo as a folder; choose a subfolder"; fi

    if [[ "$no_history" == true ]] || [[ -z "$repo_root" ]]; then
      info "Migrating (no history) '$folder_name' -> '$new_project_path'"; mkdir -p "$PROJECTS_DIR"; mv "$source_folder" "$new_project_path"; git -C "$repo_root" add -A; git -C "$repo_root" commit -m "Migrate $folder_name to standalone repo" || true
    else
      local rel_subdir="${source_folder#$repo_root/}"
      extract_with_history "$repo_root" "$rel_subdir" "$new_project_path" "$source_folder"
    fi
  fi

  # Always end up in the new project directory
  cd "$new_project_path"
  create_github_repo "$new_project_path"
  success "Successfully migrated to '$new_project_path'"
}
