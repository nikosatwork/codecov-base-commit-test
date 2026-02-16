#!/usr/bin/env bash
set -euo pipefail

BASE="${1:-main}"
LIMIT="${2:-1000}"

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI is required"
  exit 1
fi

prs=$(gh pr list --state open --base "$BASE" --limit "$LIMIT" --json number --jq '.[].number')

if [[ -z "$prs" ]]; then
  echo "No PRs to merge"
  exit 0
fi

for pr in $prs; do
  echo "Merging PR #$pr"
  gh pr merge "$pr" --merge --delete-branch || echo "Failed to merge #$pr"
done
