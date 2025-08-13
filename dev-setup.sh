#!/bin/bash
set -euo pipefail

# Development setup script for pbp - symlinks tools from local repo to PATH

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_BIN_DIR="$HOME/.local/bin"

show_help() {
    cat <<EOF
pbp development setup script

USAGE:
    ./dev-setup.sh [bin-directory]

ARGUMENTS:
    bin-directory    Directory to create symlinks in (default: ~/.local/bin)

DESCRIPTION:
    Creates symlink for pbp from this repo to your local bin directory.
    For development use only - symlinks to repo files for easy testing of changes.

EXAMPLES:
    ./dev-setup.sh                 # Install to ~/.local/bin
    ./dev-setup.sh ~/bin           # Install to ~/bin

NOTE:
    Make sure your chosen bin directory is in your PATH.
    Most modern systems include ~/.local/bin in PATH by default.
    If needed, add this to your shell config:
        export PATH="$HOME/.local/bin:$PATH"
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
    # Check for help flags first, before setting bin_dir
    if [[ "${1:-}" == "--help" ]] || [[ "${1:-}" == "-h" ]]; then
        show_help
        exit 0
    fi

    local bin_dir="${1:-$DEFAULT_BIN_DIR}"

    # Create bin directory if it doesn't exist
    if [[ ! -d "$bin_dir" ]]; then
        info "Creating bin directory: $bin_dir"
        mkdir -p "$bin_dir"
    fi

    # Check if pbp exists locally, or download from releases  
    if [[ ! -f "$SCRIPT_DIR/bin/pbp" ]]; then
        info "pbp not found locally, downloading from GitHub releases..."
        mkdir -p "$SCRIPT_DIR/bin"
        if command -v curl &>/dev/null; then
            curl -L https://github.com/pbjorklund/pbp/releases/latest/download/pbp -o "$SCRIPT_DIR/bin/pbp"
        elif command -v wget &>/dev/null; then
            wget https://github.com/pbjorklund/pbp/releases/latest/download/pbp -O "$SCRIPT_DIR/bin/pbp"
        else
            error "Neither curl nor wget found. Please install one or clone the repo manually."
        fi
        chmod +x "$SCRIPT_DIR/bin/pbp"
        success "Downloaded pbp from GitHub releases"
    fi
        chmod +x "$SCRIPT_DIR/bin/pbp" "$SCRIPT_DIR/bin/llm-setup"
        success "Downloaded pbp from GitHub releases"
    fi

    if [[ ! -f "$SCRIPT_DIR/bin/llm-setup" ]]; then
        # Create a minimal llm-setup if it doesn't exist
        cat > "$SCRIPT_DIR/bin/llm-setup" << 'EOF'
#!/bin/bash
echo "llm-setup: AI development file management"
echo "This feature requires the full repository. Install from source:"
echo "git clone https://github.com/pbjorklund/pbp.git && cd pbp && ./setup.sh"
exit 1
EOF
        chmod +x "$SCRIPT_DIR/bin/llm-setup"
    fi

    # Create symlinks
    info "Creating symlinks in $bin_dir"

    # Remove existing symlinks (including old ones)
    [[ -L "$bin_dir/pbp" ]] && rm "$bin_dir/pbp"
    [[ -L "$bin_dir/pbproject" ]] && rm "$bin_dir/pbproject" && info "Removed old pbproject symlink"
    [[ -L "$bin_dir/llm-setup" ]] && rm "$bin_dir/llm-setup" && info "Removed old llm-setup symlink (now pbp llm-setup)"
    [[ -L "$bin_dir/llm-link" ]] && rm "$bin_dir/llm-link" && info "Removed old llm-link symlink"

    # Check for existing non-symlink files
    if [[ -f "$bin_dir/pbp" ]] && [[ ! -L "$bin_dir/pbp" ]]; then
        error "File $bin_dir/pbp already exists and is not a symlink. Remove it manually first."
    fi

    if [[ -f "$bin_dir/pbproject" ]] && [[ ! -L "$bin_dir/pbproject" ]]; then
        info "Warning: Found old pbproject file (not symlink) at $bin_dir/pbproject"
        info "Please remove it manually: rm $bin_dir/pbproject"
    fi

    if [[ -f "$bin_dir/llm-setup" ]] && [[ ! -L "$bin_dir/llm-setup" ]]; then
        info "Warning: Found old llm-setup file (not symlink) at $bin_dir/llm-setup"
        info "llm-setup is now 'pbp llm-setup'. Remove with: rm $bin_dir/llm-setup"
    fi

    # Create the symlink
    ln -s "$SCRIPT_DIR/bin/pbp" "$bin_dir/pbp"
    success "Created symlink: $bin_dir/pbp -> $SCRIPT_DIR/bin/pbp"

    # Make sure script is executable
    chmod +x "$SCRIPT_DIR/bin/pbp"

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
        success "Setup complete! You can now use 'pbp' commands."
    fi

    # Test the command
    echo
    info "Testing installation:"
    if "$bin_dir/pbp" --help >/dev/null 2>&1; then
        success "pbp command works"
    else
        error "pbp command failed to run"
    fi

    echo
    info "Quick start:"
    echo "    pbp init my-new-project"
    echo "    pbp migrate some-folder"
    echo "    pbp llm-setup"
}

main "$@"