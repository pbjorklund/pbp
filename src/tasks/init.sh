check_pbp() {
  if [[ ! -d "$PBP_ROOT" ]]; then error "pbp directory not found at $PBP_ROOT"; fi
}

template_path() {
  local name="$1"
  local path="$PBP_ROOT/project-templates/$name"

  if [[ -f "$path" ]]; then
    printf '%s\n' "$path"
    return 0
  fi

  return 1
}

write_default_readme() {
  local display_name="$1"

  cat > README.md <<EOF
# $display_name

## Description
TODO: Add project description

## Usage
TODO: Add usage instructions

## Development
TODO: Add development setup instructions
EOF
}

write_default_gitignore() {
  cat > .gitignore <<'EOF'
# Dependencies
node_modules/
vendor/
__pycache__/
*.pyc

# Build outputs
dist/
build/
target/
*.o
*.so

# Environment
.env
.env.local

# Workflow tools
.af/

# IDE
.vscode/settings.json
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
EOF
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
  local readme_template gitignore_template
  check_pbp
  readme_template="$(template_path README.md || true)"
  gitignore_template="$(template_path .gitignore || true)"
  info "Creating project directory: $project_path"; mkdir -p "$project_path"; cd "$project_path"
  if [[ ! -d .git ]]; then info "Initializing git repository"; git init -b main; success "Git repository initialized"; else info "Git repository already exists"; fi
  info "Basic project structure created"
  if [[ ! -f README.md ]]; then
    if [[ -n "$readme_template" ]]; then
      sed "s/{{PROJECT_NAME}}/$display_name/g" "$readme_template" > README.md
    else
      write_default_readme "$display_name"
    fi
    success "Created README.md"
  fi
  if [[ ! -f .gitignore ]]; then
    if [[ -n "$gitignore_template" ]]; then
      cp "$gitignore_template" .gitignore
    else
      write_default_gitignore
    fi
    success "Created .gitignore"
  fi
  success "Project '$display_name' initialized at $project_path"
}
