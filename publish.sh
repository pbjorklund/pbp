#!/usr/bin/env bash
set -euo pipefail

# Usage: ./publish.sh {major|minor|patch}
# - Bumps semver tag based on latest tag
# - Creates git tag with last commit message as annotation
# - Pushes tag; GitHub Actions will build and create release

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

inc=${1:-}
if [[ -z "$inc" ]]; then
  echo "Usage: $0 {major|minor|patch}" >&2
  exit 1
fi
if [[ "$inc" != "major" && "$inc" != "minor" && "$inc" != "patch" ]]; then
  echo "Invalid increment: $inc (use major|minor|patch)" >&2
  exit 1
fi

# Ensure clean tree (no unstaged or uncommitted changes)
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "Working tree not clean. Commit/stage changes first." >&2
  exit 1
fi

# Get latest tag (semver vX.Y.Z). If none, start at v0.0.0
last_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
# Strip leading v
base=${last_tag#v}
IFS='.' read -r MA MI PA <<<"$base"
MA=${MA:-0}; MI=${MI:-0}; PA=${PA:-0}
case "$inc" in
  major) MA=$((MA+1)); MI=0; PA=0;;
  minor) MI=$((MI+1)); PA=0;;
  patch) PA=$((PA+1));;
esac
new_tag="v${MA}.${MI}.${PA}"

# Tag with latest commit message as annotation
msg=$(git log -1 --pretty=%B)

echo "Tagging $new_tag"
git tag -a "$new_tag" -m "$msg"

echo "Pushing tag"
git push --tags

echo "Done. GitHub Actions will build and publish release for $new_tag."
