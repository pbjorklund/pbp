update_pbp() {
  check_dep_gh
  
  local install_dir="${PBP_INSTALL_DIR:-$HOME/.local/bin}"
  local repo="pbjorklund/pbp"
  
  # Get current and latest versions
  local current_version latest_version
  current_version="$PBP_VERSION"
  latest_version=$(gh release view --repo "$repo" --json tagName -q .tagName 2>/dev/null || echo "unknown")
  
  if [[ "$latest_version" == "unknown" ]]; then
    error "Could not fetch latest version from GitHub"
  fi
  
  info "Current: $current_version"
  info "Latest:  $latest_version"
  
  if [[ "$current_version" == "$latest_version" ]]; then
    success "Already on latest version"
    return 0
  fi
  
  info "Downloading $latest_version..."
  local tmp_file="/tmp/pbp-$$"
  
  if gh release download "$latest_version" --repo "$repo" --pattern 'pbp' --output "$tmp_file"; then
    mkdir -p "$install_dir"
    mv "$tmp_file" "$install_dir/pbp"
    chmod +x "$install_dir/pbp"
    success "Updated to $latest_version"
    "$install_dir/pbp" version 2>&1 | head -1
  else
    rm -f "$tmp_file"
    error "Failed to download release"
  fi
}
