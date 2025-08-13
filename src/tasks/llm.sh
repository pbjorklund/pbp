show_llm_help() {
  cat <<EOF
pbp llm-setup - Set up AI development instruction files

USAGE:
    pbp llm-setup [--status]

OPTIONS:
    --status    Show current status of LLM instruction files

DESCRIPTION:
    Sets up LLM instruction files for AI development. Creates template files
    for Claude, GitHub Copilot, OpenCode, and other AI assistants.
    
    Files created:
    - LLM_INSTRUCTIONS.md (Main instruction template)
    - CLAUDE.md, AGENTS.md, GEMINI.md
    - .github/copilot-instructions.md  
    - .roo/rules/00-general.md

EXAMPLES:
    pbp llm-setup           # Set up LLM files in current project
    pbp llm-setup --status  # Check current status
EOF
}

# Embedded template files - baked into the binary
create_embedded_templates() {
  local temp_dir="$1"
  mkdir -p "$temp_dir"
  
  # LLM_INSTRUCTIONS.md template
  cat > "$temp_dir/LLM_INSTRUCTIONS.md" << 'EOF'
# {{PROJECT_NAME}} - LLM Development Instructions

## Project Overview
- **Purpose**: [TODO: Brief description of what this project does]
- **Type**: [TODO: Type of project - CLI tool, web app, library, etc.]
- **Target Users**: [TODO: Who uses this project]
- **Tech Stack**: [TODO: Main technologies used]

## Code Organization
- **Key Directories**: [TODO: Important directories to know about]
- **Entry Points**: [TODO: Main files where execution starts]
- **Configuration**: [TODO: Config files and how they work]
- **Dependencies**: [TODO: Key external dependencies]

## Development Guidelines
- **Code Style**: [TODO: Coding standards and conventions]
- **Documentation Standards**: [TODO: How to document code]
- **Review Process**: [TODO: How changes are reviewed]

## Project-Specific Context

### Critical Design Principles
[TODO: Core principles that guide this project]

### Technology Integrations  
[TODO: How different parts of the system work together]

### Common Gotchas
[TODO: Things that commonly trip people up]
EOF

  # README.md template
  cat > "$temp_dir/README.md" << 'EOF'
# {{PROJECT_NAME}}

[Brief description of what this project does]

## Installation

```bash
# Installation instructions
```

## Usage

```bash
# Basic usage examples
```

## Contributing

Contributions welcome! Please read the contributing guidelines first.

## License

[License information]
EOF

  # .gitignore template
  cat > "$temp_dir/.gitignore" << 'EOF'
# Dependencies
node_modules/
__pycache__/
*.pyc
.venv/
venv/

# Build outputs
build/
dist/
*.egg-info/
target/

# IDE files
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Environment files
.env
.env.local
EOF
}

llm_setup() {
  local show_status=false
  
  # Parse arguments
  case "${1:-}" in
    --status) show_status=true ;;
    --help) show_llm_help; return 0 ;;
    "") ;; # default action
    *) error "Unknown option: $1. Use 'pbp llm-setup --help' for usage." ;;
  esac
  
  if [[ "$show_status" == true ]]; then
    show_llm_status
    return 0
  fi
  
  # Set up LLM instruction files
  setup_llm_files
}

show_llm_status() {
  local files=(
    "LLM_INSTRUCTIONS.md"
    "CLAUDE.md" 
    "AGENTS.md"
    "GEMINI.md"
    ".github/copilot-instructions.md"
    ".roo/rules/00-general.md"
  )
  
  for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
      echo "   ✅ $file"
    else
      echo "   ❌ $file missing"
    fi
  done
}

setup_llm_files() {
  local project_name
  project_name=$(basename "$PWD")
  
  # Use custom template if specified, otherwise use embedded templates
  local template_source=""
  if [[ -n "${PBP_LLM_TEMPLATE:-}" ]] && [[ -f "$PBP_LLM_TEMPLATE" ]]; then
    template_source="$PBP_LLM_TEMPLATE"
    info "Using custom LLM template: $PBP_LLM_TEMPLATE"
  else
    # Create temporary template directory with embedded templates
    local temp_templates="/tmp/pbp-templates-$$"
    create_embedded_templates "$temp_templates"
    template_source="$temp_templates/LLM_INSTRUCTIONS.md"
  fi
  
  # Create backup if files exist
  local backup_dir=""
  local files_to_backup=(
    "LLM_INSTRUCTIONS.md" "CLAUDE.md" "AGENTS.md" "GEMINI.md"
    ".github/copilot-instructions.md" ".roo/rules/00-general.md"
  )
  
  for file in "${files_to_backup[@]}"; do
    if [[ -f "$file" ]]; then
      if [[ -z "$backup_dir" ]]; then
        backup_dir="/tmp/llm-backup-$(date +%Y-%m-%d-%H%M%S)"
        mkdir -p "$backup_dir"
        info "Backing up existing files to $backup_dir"
      fi
      mkdir -p "$backup_dir/$(dirname "$file")" 2>/dev/null || true
      cp "$file" "$backup_dir/$file"
    fi
  done
  
  # Create LLM_INSTRUCTIONS.md
  if [[ ! -f "LLM_INSTRUCTIONS.md" ]]; then
    sed "s/{{PROJECT_NAME}}/$project_name/g" "$template_source" > "LLM_INSTRUCTIONS.md"
    success "Created LLM_INSTRUCTIONS.md"
  fi
  
  # Create tool-specific instruction files as independent copies
  for tool_file in "CLAUDE.md" "AGENTS.md" "GEMINI.md"; do
    if [[ ! -f "$tool_file" ]]; then
      cp "LLM_INSTRUCTIONS.md" "$tool_file"
      success "Created $tool_file"
    fi
  done
  
  # Create GitHub Copilot instructions
  if [[ ! -f ".github/copilot-instructions.md" ]]; then
    mkdir -p ".github"
    cp "LLM_INSTRUCTIONS.md" ".github/copilot-instructions.md"
    success "Created .github/copilot-instructions.md"
  fi
  
  # Create Roo rules
  if [[ ! -f ".roo/rules/00-general.md" ]]; then
    mkdir -p ".roo/rules"
    cp "LLM_INSTRUCTIONS.md" ".roo/rules/00-general.md"
    success "Created .roo/rules/00-general.md"
  fi
  
  # Clean up temporary templates if we created them
  if [[ -z "${PBP_LLM_TEMPLATE:-}" ]]; then
    rm -rf "$temp_templates"
  fi
  
  success "LLM instruction files set up successfully!"
  echo
  info "Next steps:"
  echo "1. Edit LLM_INSTRUCTIONS.md to describe your project"
  echo "2. Run your AI assistant and tell it: 'Follow the LLM_INSTRUCTIONS.md setup process'"
  echo "3. The AI will analyze your project and customize the instructions"
}