migrate_folder() {
  local folder_name="${1:-}"; local source_path="${2:-$PWD}"; if [[ -z "$folder_name" ]]; then error "Folder name is required"; fi
  local new_project_path current_dir
  if [[ "$folder_name" == "." ]]; then
    current_dir="$(basename "$PWD")"; new_project_path="$PROJECTS_DIR/$current_dir"
    if [[ "$PWD" == "$PROJECTS_DIR"/* ]] && [[ -d .git ]]; then error "Already in ~/Projects/ and is a git repository"; fi
    if [[ -e "$new_project_path" ]]; then error "Directory '$new_project_path' already exists"; fi
    info "Migrating current directory '$current_dir' to '$new_project_path'"; mkdir -p "$PROJECTS_DIR"; cd ..; mv "$current_dir" "$new_project_path"; cd "$new_project_path"
  else
    source_path=$(realpath "$source_path"); local source_folder="$source_path/$folder_name"
    if [[ ! -d "$source_folder" ]]; then error "Folder '$folder_name' not found in '$source_path'"; fi
    new_project_path="$PROJECTS_DIR/$folder_name"; if [[ -e "$new_project_path" ]]; then error "Directory '$new_project_path' already exists"; fi
    info "Migrating folder '$folder_name' to '$new_project_path'"; mkdir -p "$PROJECTS_DIR"; mv "$source_folder" "$new_project_path"; cd "$new_project_path"
  fi
  if [[ ! -d .git ]]; then git init; fi; git add .; git commit -m "Initial commit"; create_github_repo "$new_project_path"; success "Successfully migrated to '$new_project_path'"
}
