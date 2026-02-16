# Codecov missing-base minimal repro repository

This repo template reproduces merge-heavy default-branch history with partial flag uploads, so we can validate base-parent behavior and test fixes.

## What this template includes

- Minimal Python code and tests with two coverage flag groups:
  - `core`
  - `ext`
- `codecov.yml` configured with carryforward defaults.
- GitHub Actions workflows to:
  - generate many PRs quickly,
  - merge those PRs in a batch,
  - produce main-branch history with intermittent partial uploads.

## Workflows

### 1) CI

Workflow: `.github/workflows/ci.yml`

- Manual dispatch.
- Select `test_suite` as `core`, `ext`, or `both`.

### 2) Create stress PR batches (30-60)

Workflow: `.github/workflows/create-stress-batch-prs.yml` (manual `workflow_dispatch`)

Suggested inputs:
- `count: 40`
- `base: main`

This generates merge pressure for base-parent stress testing.

### 3) Merge PRs in batch

Workflow: `.github/workflows/merge-batch-prs.yml` (manual `workflow_dispatch`)

This workflow merges all open PRs in the repository.

This simulates batched landings and generates the merge topology to stress base selection.

## Local CLI alternative (optional)

Use the merge script if you prefer local control with `gh` CLI:

```bash
bash scripts/merge_batch_prs.sh main 1000
```

## Validation checklist

1. Confirm main has many merge commits:

```bash
git log --graph --oneline --decorate --first-parent --max-count=80 main
```

2. In Codecov, inspect consecutive main commits and check:
- whether base commit is present,
- whether comparisons and carryforward behavior are consistent across stress merges.

## Notes

- This template is intentionally minimal to share with Codecov support/engineering.
- `count` can be inscreased to 30+ to make merge topology more stressful.
- Fast stress profile: run `create-stress-batch-prs.yml` with `count=40`, then run `merge-batch-prs.yml`. Then run `ci.yml` to upload coverage to Codecov on the head of the main branch.
