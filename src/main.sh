show_help() {
  cat <<EOF
$SCRIPT_NAME - Project initialization and management tool

USAGE:
    $SCRIPT_NAME init <project-name> [project-path]
    $SCRIPT_NAME status [project-path]
    $SCRIPT_NAME migrate <folder-name> [source-project-path]
    $SCRIPT_NAME newghrepo [project-path]
    $SCRIPT_NAME --help
EOF
}

main() {
  case "${1:-}" in
    init) shift; init_project "$@";;
    status) shift; show_status "$@";;
    migrate) shift; migrate_folder "$@";;
    newghrepo) shift; create_github_repo "$@";;
    --help|-h|help) show_help;;
    "") error "No command specified. Use '$SCRIPT_NAME --help' for usage.";;
    *) error "Unknown command: $1. Use '$SCRIPT_NAME --help' for usage.";;
  esac
}
