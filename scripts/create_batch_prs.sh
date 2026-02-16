#!/usr/bin/env bash
set -euo pipefail

COUNT="${1:-10}"
BASE="${2:-main}"

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI is required"
  exit 1
fi

git checkout "$BASE"

for i in $(seq 1 "$COUNT"); do
  branch="repro/local-batch-$(date +%s)-${i}"
  git checkout -b "$branch"
  mkdir -p batch_changes
  echo "local batch pr ${i}" > "batch_changes/local_change_${i}_$(date +%s).txt"
  git add batch_changes
  git commit -m "repro: local batch change ${i}"
  git push -u origin "$branch"

  title="[core] local batch PR ${i}"
  if (( i % 3 == 0 )); then
    title="[ext] local batch PR ${i}"
  fi

  gh pr create \
    --base "$BASE" \
    --head "$branch" \
    --title "$title" \
    --body "Local generated PR ${i} for batch repro"

  git checkout "$BASE"
done
