migrate_folder() {
  local folder_name="${1:-}"
  local source_path="${2:-$PWD}"
  if [[ -z "$folder_name" ]]; then error "Folder name is required"; fi

  source_path=$(realpath "$source_path")
  local repo_root="" current_dir new_project_path source_folder

  if git -C "$source_path" rev-parse --show-toplevel &>/dev/null; then 
    repo_root=$(realpath "$(git -C "$source_path" rev-parse --show-toplevel)")
  fi

  # Determine what we're migrating
  if [[ "$folder_name" == "." ]]; then
    current_dir="$(basename "$source_path")"
    new_project_path="$PROJECTS_DIR/$current_dir"
    source_folder="$source_path"
  else
    current_dir="$folder_name"
    new_project_path="$PROJECTS_DIR/$folder_name"
    source_folder="$source_path/$folder_name"
  fi

  # Validations
  if [[ ! -d "$source_folder" ]]; then error "Folder '$source_folder' not found"; fi
  if [[ -e "$new_project_path" ]]; then error "Directory '$new_project_path' already exists"; fi
  if [[ -n "$repo_root" ]] && [[ "$source_folder" == "$repo_root" ]]; then
    error "Cannot migrate entire repo root. Run from a subfolder or specify a subfolder name."
  fi

  # Simple approach: move folder, commit deletion in source, init new repo
  info "Migrating '$current_dir' -> '$new_project_path'"
  mkdir -p "$PROJECTS_DIR"
  mv "$source_folder" "$new_project_path"

  # Commit the removal in source repo if applicable
  if [[ -n "$repo_root" ]]; then
    git -C "$repo_root" add -A
    git -C "$repo_root" commit -m "Migrate $current_dir to standalone repo" || true
  fi

  # Initialize new repo
  cd "$new_project_path"
  git init -b main
  git add .
  git commit -m "Initial commit (migrated from $(basename "$repo_root"))"

  # Trust mise config if present
  if [[ -f "mise.toml" ]] || [[ -f ".mise.toml" ]]; then
    if command -v mise &>/dev/null; then
      info "Trusting mise config"
      mise trust
    fi
  fi

  # Create GitHub repo and set up remote
  create_github_repo "$new_project_path"
  success "Successfully migrated to '$new_project_path'"
}
