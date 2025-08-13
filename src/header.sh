#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Generated bundle header; do not edit in bin/pbp
# Source modules are in src/

PBP_VERSION="${PBP_VERSION:-unknown}"
PBP_BUILD_TIME="${PBP_BUILD_TIME:-unknown}"
print_version_note() { echo "pbp version: ${PBP_VERSION} (${PBP_BUILD_TIME})"; }
