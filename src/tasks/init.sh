check_pbp() {
  if [[ ! -d "$PBP_ROOT" ]]; then error "pbp directory not found at $PBP_ROOT"; fi
  if [[ ! -d "$PBP_ROOT/project-templates" ]]; then error "project-templates directory not found at $PBP_ROOT/project-templates"; fi
}

init_project() {
  local project_name="${1:-}"
  if [[ -z "$project_name" ]]; then 
    error "Project name is required. Use 'pbp init <name>' or 'pbp init .' for current directory"
  fi
  local project_path display_name
  if [[ "$project_name" == "." ]]; then
    project_path="$PWD"; display_name="$(basename "$PWD")"
  else
    project_path="${2:-$PWD/$project_name}"; display_name="$project_name"
  fi
  check_pbp
  info "Creating project directory: $project_path"; mkdir -p "$project_path"; cd "$project_path"
  if [[ ! -d .git ]]; then info "Initializing git repository"; git init; success "Git repository initialized"; else info "Git repository already exists"; fi
  info "Basic project structure created"
  if [[ ! -f README.md ]]; then sed "s/{{PROJECT_NAME}}/$display_name/g" "$PBP_ROOT/project-templates/README.md" > README.md; success "Created README.md"; fi
  if [[ ! -f .gitignore ]]; then cp "$PBP_ROOT/project-templates/.gitignore" .gitignore; success "Created .gitignore"; fi
  success "Project '$display_name' initialized at $project_path"
}
