#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Generated bundle header; do not edit in bin/pbproject
# Source modules are in src/

PBPROJECT_VERSION="${PBPROJECT_VERSION:-unknown}"
PBPROJECT_BUILD_TIME="${PBPROJECT_BUILD_TIME:-unknown}"
print_version_note() { echo "pbproject version: ${PBPROJECT_VERSION} (${PBPROJECT_BUILD_TIME})"; }
