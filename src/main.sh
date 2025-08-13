show_help() {
  cat <<EOF
$SCRIPT_NAME - Project initialization and management tool

USAGE:
    $SCRIPT_NAME init <project-name> [project-path]
    $SCRIPT_NAME status [project-path]
    $SCRIPT_NAME migrate <folder-name|.> [source-project-path] [--no-history] [--force]
    $SCRIPT_NAME newghrepo [project-path]
    $SCRIPT_NAME --help

MIGRATE:
    Extract a subfolder into a new repo under ~/Projects with history preserved using git subtree.
    - When run inside a repo subdirectory: use 'migrate .'
    - When providing a folder and optional source path: 'migrate some/folder /path/to/repo'
    Flags:
      --no-history   Move without preserving history (no git subtree)
      --force        Bypass safety checks (e.g., migrating repo root)
EOF
}

main() {
  print_version_note
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
