show_help() {
  cat <<EOF
$SCRIPT_NAME - Project lifecycle management tool

USAGE:
    $SCRIPT_NAME init <project-name> [project-path]
    $SCRIPT_NAME migrate <folder-name|.> [source-project-path] [--no-history] [--force]
    $SCRIPT_NAME sync [--public|--private|--active|--dry-run] [directory]
    $SCRIPT_NAME check [directory]
    $SCRIPT_NAME newghrepo [project-path]
    $SCRIPT_NAME llm-setup [--status]
    $SCRIPT_NAME status [project-path]
    $SCRIPT_NAME --help

COMMANDS:
    init       Create new project with basic structure
    migrate    Extract folder to new repo with history preservation
    sync       Clone all user GitHub repos that aren't already cloned
    check      Check git status across all repositories
    newghrepo  Create GitHub repository for current project
    llm-setup  Set up AI development instruction files
    status     Show project status and configuration
    
FLAGS:
    migrate --no-history   Move without preserving history
    migrate --force        Bypass safety checks
    sync --public          Clone only public repos
    sync --private         Clone only private repos  
    sync --active          Clone only recently active repos
    sync --dry-run         Show what would be cloned

ENVIRONMENT:
    PBP_PROJECTS_DIR   Where to create new projects (default: ~/Projects)
    PBP_LLM_TEMPLATE   Custom LLM instruction template file
EOF
}

main() {
  print_version_note
  case "${1:-}" in
    init) shift; init_project "$@";;
    migrate) shift; migrate_folder "$@";;
    sync) shift; sync_repos "$@";;
    check) shift; check_repos "$@";;
    newghrepo) shift; create_github_repo "$@";;
    llm-setup) shift; llm_setup "$@";;
    status) shift; show_status "$@";;
    --help|-h|help) show_help;;
    "") show_help;;
    *) error "Unknown command: $1. Use '$SCRIPT_NAME --help' for usage.";;
  esac
}
