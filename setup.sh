#!/bin/bash
set -euo pipefail

# Setup script for pbproject - symlinks tools to local bin

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_BIN_DIR="$HOME/bin"

show_help() {
    cat <<EOF
pbproject setup script

USAGE:
    ./setup.sh [bin-directory]

ARGUMENTS:
    bin-directory    Directory to create symlinks in (default: ~/bin)

DESCRIPTION:
    Creates symlinks for pbproject and llm-link in your local bin directory.
    The bin directory will be created if it doesn't exist.

EXAMPLES:
    ./setup.sh                 # Install to ~/bin
    ./setup.sh ~/.local/bin    # Install to ~/.local/bin

NOTE:
    Make sure your chosen bin directory is in your PATH.
    Add this to your shell config if needed:
        export PATH="\$HOME/bin:\$PATH"
EOF
}

info() {
    echo "ℹ️  $1"
}

success() {
    echo "✅ $1"
}

error() {
    echo "❌ Error: $1" >&2
    exit 1
}

main() {
    local bin_dir="${1:-$DEFAULT_BIN_DIR}"

    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        show_help
        exit 0
    fi

    # Create bin directory if it doesn't exist
    if [[ ! -d "$bin_dir" ]]; then
        info "Creating bin directory: $bin_dir"
        mkdir -p "$bin_dir"
    fi

    # Check if tools exist
    if [[ ! -f "$SCRIPT_DIR/bin/pbproject" ]]; then
        error "pbproject script not found at $SCRIPT_DIR/bin/pbproject"
    fi

    if [[ ! -f "$SCRIPT_DIR/bin/llm-link" ]]; then
        error "llm-link script not found at $SCRIPT_DIR/bin/llm-link"
    fi

    # Create symlinks
    info "Creating symlinks in $bin_dir"

    # Remove existing symlinks or files if they exist
    [[ -L "$bin_dir/pbproject" ]] && rm "$bin_dir/pbproject"
    [[ -L "$bin_dir/llm-link" ]] && rm "$bin_dir/llm-link"

    # Check for existing non-symlink files
    if [[ -f "$bin_dir/pbproject" ]] && [[ ! -L "$bin_dir/pbproject" ]]; then
        error "File $bin_dir/pbproject already exists and is not a symlink. Remove it manually first."
    fi

    if [[ -f "$bin_dir/llm-link" ]] && [[ ! -L "$bin_dir/llm-link" ]]; then
        error "File $bin_dir/llm-link already exists and is not a symlink. Remove it manually first."
    fi

    # Create the symlinks
    ln -s "$SCRIPT_DIR/bin/pbproject" "$bin_dir/pbproject"
    success "Created symlink: $bin_dir/pbproject -> $SCRIPT_DIR/bin/pbproject"

    ln -s "$SCRIPT_DIR/bin/llm-link" "$bin_dir/llm-link"
    success "Created symlink: $bin_dir/llm-link -> $SCRIPT_DIR/bin/llm-link"

    # Make sure scripts are executable
    chmod +x "$SCRIPT_DIR/bin/pbproject" "$SCRIPT_DIR/bin/llm-link"

    # Check if bin directory is in PATH
    if [[ ":$PATH:" != *":$bin_dir:"* ]]; then
        echo
        info "⚠️  $bin_dir is not in your PATH"
        info "Add this to your shell config (~/.bashrc, ~/.zshrc, etc.):"
        echo "    export PATH=\"$bin_dir:\$PATH\""
        echo
        info "Then reload your shell or run: source ~/.bashrc"
    else
        echo
        success "Setup complete! You can now use 'pbproject' and 'llm-link' commands."
    fi

    # Test the commands
    echo
    info "Testing installation:"
    if "$bin_dir/pbproject" --help >/dev/null 2>&1; then
        success "pbproject command works"
    else
        error "pbproject command failed to run"
    fi

    if "$bin_dir/llm-link" --help >/dev/null 2>&1; then
        success "llm-link command works"
    else
        error "llm-link command failed to run"
    fi

    echo
    info "Quick start:"
    echo "    pbproject init my-new-project"
    echo "    pbproject migrate some-folder"
}

main "$@"