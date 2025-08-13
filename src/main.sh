show_help() {
  cat <<EOF
$SCRIPT_NAME - Project lifecycle management tool

USAGE:
    $SCRIPT_NAME init <project-name> [project-path]
    $SCRIPT_NAME migrate <folder-name|.> [source-project-path] [--no-history] [--force]
    $SCRIPT_NAME newghrepo [project-path]
    $SCRIPT_NAME llm-setup [--status]
    $SCRIPT_NAME status [project-path]
    $SCRIPT_NAME --help

COMMANDS:
    init       Create new project with basic structure
    migrate    Extract folder to new repo with history preservation
    newghrepo  Create GitHub repository for current project
    llm-setup  Set up AI development instruction files
    status     Show project status and configuration
    
MIGRATE FLAGS:
    --no-history   Move without preserving history
    --force        Bypass safety checks

ENVIRONMENT:
    PBP_PROJECTS_DIR   Where to create new projects (default: ~/Projects)
EOF
}

main() {
  print_version_note
  case "${1:-}" in
    init) shift; init_project "$@";;
    migrate) shift; migrate_folder "$@";;
    newghrepo) shift; create_github_repo "$@";;
    llm-setup) shift; llm_setup "$@";;
    status) shift; show_status "$@";;
    --help|-h|help) show_help;;
    "") error "No command specified. Use '$SCRIPT_NAME --help' for usage.";;
    *) error "Unknown command: $1. Use '$SCRIPT_NAME --help' for usage.";;
  esac
}
