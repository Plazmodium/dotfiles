---
name: git-tidy
description: Tidy git branches — fast-forward dev to main, prune merged branches, verify release tags. Keeps repos clean and easy to reason about.
---

# git-tidy

Sync long-lived branches, prune merged branches, and audit release tags.

## Usage

```text
--dry-run       # Report what would happen; change nothing
--skip-tags     # Skip release tag audit
--force-prune   # Delete merged branches without confirmation list
```

Default: interactive mode — report plan, then execute with confirmation prompts.

---

## Pre-Flight

Before anything, gather repo state. **All read-only — no mutations yet.**

```bash
# Confirm we're in a git repo
git rev-parse --show-toplevel

# Check for uncommitted changes (abort if dirty)
git status --porcelain

# Check for .jj/ (prefer jj if colocated)
ls -d .jj 2>/dev/null

# Fetch latest from all remotes
git fetch --all --prune --tags
```

<critical>
**ABORT if worktree is dirty.** Uncommitted changes risk data loss during branch switches.
Tell the user to commit or stash first.
</critical>

---

## Phase 1: Identify Branches

### Detect default branch (main)

```bash
# Try remote HEAD first, fall back to common names
git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||'

# Fallback: check which of main/master exists
git rev-parse --verify origin/main 2>/dev/null && echo main
git rev-parse --verify origin/master 2>/dev/null && echo master
```

### Detect dev branch

Look for the long-lived development branch. Check in order:

```bash
for branch in dev develop development; do
  git rev-parse --verify "origin/$branch" 2>/dev/null && echo "$branch" && break
done
```

If no dev branch found, skip branch sync and report it.

### Map branch topology

```bash
# Commits on main not on dev
git log --oneline "origin/$DEV_BRANCH..origin/$DEFAULT_BRANCH" | head -20

# Commits on dev not on main
git log --oneline "origin/$DEFAULT_BRANCH..origin/$DEV_BRANCH" | head -20

# Merge base
git merge-base "origin/$DEFAULT_BRANCH" "origin/$DEV_BRANCH"
```

---

## Phase 2: Fast-Forward Dev to Main

**Goal:** After a merge to main (PR merge, hotfix, etc.), dev should include those commits.

### Decision logic

| State | Action |
|-------|--------|
| Dev is ancestor of main (dev behind, no divergence) | Fast-forward dev → main tip |
| Main is ancestor of dev (main behind) | Nothing to do — dev already ahead |
| Branches diverged | **Do NOT auto-merge.** Report divergence, suggest manual resolution |
| Identical | Nothing to do |

### Execute fast-forward

```bash
# Only if dev is strictly behind main (fast-forward safe)
git checkout "$DEV_BRANCH"
git merge --ff-only "origin/$DEFAULT_BRANCH"
git push origin "$DEV_BRANCH"
```

<critical>
**NEVER force-push or create merge commits automatically.**
Only `--ff-only` is safe here. If it fails, report and stop.
</critical>

### Report

```text
Branch Sync:
  main:    abc1234 (2025-04-08)
  dev:     def5678 → abc1234 (fast-forwarded, 3 commits absorbed)
  Status:  ✓ In sync
```

If diverged:

```text
Branch Sync:
  main:    abc1234
  dev:     def5678
  Base:    999aaaa
  Status:  ✗ DIVERGED — 2 commits on main, 5 on dev
  Action:  Manual merge required. Run: git checkout dev && git merge main
```

---

## Phase 3: Prune Merged Branches

### Find merged branches

```bash
# Branches fully merged into default branch (excluding protected)
git branch -r --merged "origin/$DEFAULT_BRANCH" \
  | grep -v -E "origin/(${DEFAULT_BRANCH}|${DEV_BRANCH}|HEAD|release/|hotfix/)" \
  | sed 's|origin/||' \
  | sort

# Also check local branches merged into default
git branch --merged "$DEFAULT_BRANCH" \
  | grep -v -E "^\*|${DEFAULT_BRANCH}|${DEV_BRANCH}" \
  | sed 's/^[ ]*//' \
  | sort
```

### Also find branches merged into dev

```bash
git branch -r --merged "origin/$DEV_BRANCH" \
  | grep -v -E "origin/(${DEFAULT_BRANCH}|${DEV_BRANCH}|HEAD|release/|hotfix/)" \
  | sed 's|origin/||' \
  | sort
```

### Protected branch patterns

Never prune:
- `main`, `master`
- `dev`, `develop`, `development`
- `release/*`, `hotfix/*` (unless fully merged AND tagged)
- Any branch with open PRs

```bash
# Check for open PRs on candidates (if gh available)
gh pr list --state open --json headRefName --jq '.[].headRefName' 2>/dev/null
```

### Execute pruning

Unless `--dry-run`, present the list and confirm before deleting:

```text
Merged branches to prune:
  Local:
    feature/add-login        (merged 2025-03-15, 12 commits)
    fix/typo-readme          (merged 2025-04-01, 1 commit)
  Remote:
    origin/feature/add-login (merged 2025-03-15)
    origin/fix/typo-readme   (merged 2025-04-01)

Proceed? [y/N]
```

```bash
# Local
git branch -d "$BRANCH"

# Remote
git push origin --delete "$BRANCH"
```

<critical>
**Use `-d` (lowercase) not `-D`.** Lowercase refuses to delete unmerged branches — safety net.
**Always confirm before remote deletes** unless `--force-prune`.
</critical>

---

## Phase 4: Release Tag Audit

Skip if `--skip-tags`.

### Gather tags

```bash
# All tags sorted by version
git tag --sort=-version:refname | head -30

# Tags on main with dates
git log --oneline --decorate "origin/$DEFAULT_BRANCH" | grep 'tag:' | head -20

# Check if HEAD of main is tagged
git describe --tags --exact-match "origin/$DEFAULT_BRANCH" 2>/dev/null
```

### Checks

| Check | What | Severity |
|-------|------|----------|
| Untagged merge commits on main | PRs merged without a release tag | Warning |
| Tag not on main | Tags pointing to commits not reachable from main | Error |
| Tag format inconsistency | Mix of `v1.0.0` and `1.0.0` styles | Warning |
| Missing semver progression | Gaps or duplicates in version sequence | Info |
| Unreachable tags | Tags on deleted/orphan branches | Error |

```bash
# Find merge commits on main without tags
git log --oneline --merges "origin/$DEFAULT_BRANCH" | while read hash msg; do
  if ! git describe --tags --exact-match "$hash" 2>/dev/null; then
    echo "UNTAGGED: $hash $msg"
  fi
done

# Tags not reachable from main
for tag in $(git tag); do
  if ! git merge-base --is-ancestor "$tag" "origin/$DEFAULT_BRANCH" 2>/dev/null; then
    echo "ORPHAN: $tag"
  fi
done

# Tag format consistency
git tag | grep -E '^v?[0-9]' | head -5  # detect pattern
```

### Report

```text
Release Tags:
  Latest:      v2.3.1 (on main, 2025-04-05)
  Format:      v{major}.{minor}.{patch} (consistent ✓)
  Total:       14 tags

  Warnings:
    ⚠ 2 merge commits on main without release tags
      - abc1234 Merge PR #42: Add billing module
      - def5678 Merge PR #45: Fix auth flow
    
  Errors:
    ✗ Tag v1.2.0-beta points to orphan commit (not on main)

  Suggestions:
    → Tag abc1234 as v2.4.0 if it represents a release
    → Delete or retag v1.2.0-beta
```

---

## Phase 5: Summary Report

```text
═══════════════════════════════════════
  git-tidy complete
═══════════════════════════════════════

Branch Sync:
  main ↔ dev:  ✓ In sync (fast-forwarded 3 commits)

Pruned Branches:
  Local:   4 deleted
  Remote:  4 deleted
  Skipped: 1 (open PR on feature/new-api)

Release Tags:
  Status:  2 warnings, 0 errors
  Latest:  v2.3.1

Stale Remote Refs:
  Pruned:  7 (via fetch --prune)

No destructive actions taken without confirmation.
═══════════════════════════════════════
```

---

## Additional Suggestions

These are opportunistic checks — report but don't act unless asked:

- **Stale unmerged branches**: Branches with no commits in 90+ days, not merged anywhere
- **Diverged feature branches**: Branches that are very far behind main (>100 commits)
- **Duplicate branches**: Branches pointing to the same commit as another branch
- **Missing upstream tracking**: Local branches without a remote tracking branch

```bash
# Stale branches (no activity in 90 days)
git for-each-ref --sort=committerdate --format='%(committerdate:short) %(refname:short)' refs/remotes/origin/ \
  | awk -v cutoff="$(date -v-90d +%Y-%m-%d 2>/dev/null || date -d '90 days ago' +%Y-%m-%d)" '$1 < cutoff'

# Local branches without upstream
git branch -vv | grep -v '\[origin/'
```

---

## Anti-Patterns

- **Force-pushing**: NEVER force-push shared branches
- **Auto-merging diverged branches**: Only fast-forward is safe without human review
- **Deleting unmerged branches**: Use `-d` not `-D`; let git refuse if unsafe
- **Skipping fetch**: Always fetch before comparing — local refs may be stale
- **Pruning release branches**: Keep `release/*` until confirmed tagged and merged
- **Ignoring open PRs**: Always check for open PRs before pruning remote branches
- **Mutating on dirty worktree**: Abort if `git status --porcelain` has output
