#!/usr/bin/env bash
# future-plan-add.sh
#
# Single-command workflow to add design discussion outputs to future-plan/.
#
# Usage:
#   ./scripts/future-plan-add.sh "<topic>" <zip-path>
#   ./scripts/future-plan-add.sh --retry "<topic>" <zip-path>   # re-run after fixing scan hits
#
# Example:
#   ./scripts/future-plan-add.sh "DB schema redesign" ~/Downloads/gsos-future-plan.zip
#
# What it does:
#   1. Pulls latest main
#   2. Creates branch claude/future-plan-<topic-kebab>
#   3. Unzips the provided zip (expects to contain a future-plan/ root directory)
#   4. Runs OSS screening scan; aborts on failure (rolls back branch on first run)
#   5. Commits with conventional message
#   6. Pushes and creates a draft PR (using future-plan PR template)
#
# After completion, the user must:
#   - Edit PR description on GitHub (Source / Cherry-pick candidates / Sanitization checklist)
#   - Mark "Ready for review"
#   - Wait for sanitization-only review by Kimura
#
# Requirements: bash, git, gh CLI (https://cli.github.com/), python3, unzip.

set -euo pipefail

# ---------- Argument parsing ----------

RETRY_MODE=0
if [ "${1:-}" = "--retry" ]; then
  RETRY_MODE=1
  shift
fi

if [ "$#" -ne 2 ]; then
  cat <<USAGE
Usage: $0 [--retry] "<topic>" <zip-path>

Examples:
  $0 "DB schema redesign" ~/Downloads/gsos-future-plan.zip
  $0 --retry "DB schema redesign" ~/Downloads/gsos-future-plan.zip

Arguments:
  topic     Short human-readable description (kebab-cased automatically for branch name).
            Must contain at least one ASCII alphanumeric character.
  zip-path  Path to a zip file containing a future-plan/ root directory.

Flags:
  --retry   Re-run after fixing OSS screening hits. Skips the pre-existing-clean
            check and re-uses an existing branch.
USAGE
  exit 1
fi

TOPIC="$1"
ZIP_PATH="$2"

# Validate TOPIC for shell-injection / commit-message-corruption characters.
# We allow Japanese / spaces / punctuation in the human-readable topic, but NOT
# characters that would break command substitution or commit message framing.
case "$TOPIC" in
  *\"*|*\`*|*\$*|*\\*)
    echo "❌ Topic contains a shell-special character (\", \`, \$, \\). Use plain text."
    exit 1
    ;;
esac

# ---------- Resolve zip path safely ----------

if [ ! -e "$ZIP_PATH" ]; then
  echo "❌ Zip file not found: $ZIP_PATH"
  exit 1
fi

# Resolve to absolute path. Fail explicitly if the zip parent directory is unreadable
# (avoids the silent fallback to $PWD that happens when `cd` fails inside `$(...)`).
ZIP_DIR="$(dirname "$ZIP_PATH")"
ZIP_NAME="$(basename "$ZIP_PATH")"
if ! ZIP_ABS_DIR="$(cd "$ZIP_DIR" 2>/dev/null && pwd)"; then
  echo "❌ Cannot access zip parent directory: $ZIP_DIR"
  exit 1
fi
ZIP_PATH="$ZIP_ABS_DIR/$ZIP_NAME"

if [ ! -f "$ZIP_PATH" ]; then
  echo "❌ Zip file not found or unreadable: $ZIP_PATH"
  exit 1
fi

# ---------- Move to repo root ----------

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "$REPO_ROOT" ]; then
  echo "❌ Not in a git repository. Run this script from inside generative-startup-os."
  exit 1
fi
cd "$REPO_ROOT"

# ---------- Tooling preflight ----------

command -v gh >/dev/null 2>&1 || {
  echo "❌ gh CLI not found. Install from https://cli.github.com/ then run 'gh auth login'."
  exit 1
}

command -v unzip >/dev/null 2>&1 || {
  echo "❌ unzip not found."
  exit 1
}

command -v python3 >/dev/null 2>&1 || {
  echo "❌ python3 not found on PATH."
  exit 1
}

# ---------- Pre-existing-clean check (skipped in --retry mode) ----------

if [ "$RETRY_MODE" -eq 0 ]; then
  if ! python3 tools/oss_screening_scan.py --quiet --mode edit >/dev/null 2>&1; then
    echo "❌ Pre-existing OSS screening hits in repo. Resolve them before adding future-plan content."
    echo ""
    python3 tools/oss_screening_scan.py --mode edit
    exit 1
  fi
fi

# ---------- Branch naming ----------

# kebab-case the topic (ASCII only — Japanese / non-ASCII chars are stripped)
TOPIC_KEBAB=$(echo "$TOPIC" \
  | tr '[:upper:]' '[:lower:]' \
  | sed -E 's/[^a-z0-9]+/-/g' \
  | sed -E 's/^-+|-+$//g')

if [ -z "$TOPIC_KEBAB" ]; then
  echo "❌ Topic must contain at least one ASCII alphanumeric character."
  echo "   Branch names can only use [a-z0-9-]. Japanese-only topics are rejected."
  echo "   Add an ASCII slug, e.g.: \"DBスキーマ再設計 / db-schema-redesign\""
  exit 1
fi

BRANCH="claude/future-plan-$TOPIC_KEBAB"

# Branch existence checks
LOCAL_EXISTS=0
REMOTE_EXISTS=0
git show-ref --verify --quiet "refs/heads/$BRANCH" && LOCAL_EXISTS=1
git ls-remote --exit-code --heads origin "$BRANCH" >/dev/null 2>&1 && REMOTE_EXISTS=1

if [ "$RETRY_MODE" -eq 0 ]; then
  if [ "$LOCAL_EXISTS" -eq 1 ]; then
    echo "❌ Branch $BRANCH already exists locally."
    echo "   - Re-run with --retry to re-use it (after fixing scan hits in zip / working tree)"
    echo "   - Or delete it: git branch -D $BRANCH"
    exit 1
  fi
  if [ "$REMOTE_EXISTS" -eq 1 ]; then
    echo "❌ Branch $BRANCH already exists on origin."
    echo "   Use a different topic, or delete the remote branch first."
    exit 1
  fi
fi

# ---------- Update main ----------

if [ "$RETRY_MODE" -eq 0 ]; then
  echo "→ Updating local main..."
  git checkout main
  git pull origin main --ff-only
fi

# ---------- Create or reuse branch ----------

if [ "$RETRY_MODE" -eq 1 ] && [ "$LOCAL_EXISTS" -eq 1 ]; then
  echo "→ Re-using existing branch $BRANCH..."
  git checkout "$BRANCH"
else
  echo "→ Creating branch $BRANCH..."
  git checkout -b "$BRANCH"
fi

# ---------- Unzip ----------

echo "→ Unzipping $ZIP_PATH..."
TEMP_DIR=$(mktemp -d)
# Always clean up TEMP_DIR on exit (success or failure)
trap 'rm -rf "$TEMP_DIR"' EXIT

unzip -q -o "$ZIP_PATH" -d "$TEMP_DIR"

if [ ! -d "$TEMP_DIR/future-plan" ]; then
  echo "❌ Zip does not contain a future-plan/ root directory."
  echo "   Contents: $(ls "$TEMP_DIR")"
  if [ "$RETRY_MODE" -eq 0 ]; then
    git checkout main
    git branch -D "$BRANCH"
  fi
  exit 1
fi

# Detect overwrites and warn (cp would silently clobber)
if [ -d future-plan ]; then
  CONFLICTS=$(cd "$TEMP_DIR" && find future-plan -type f | while read -r f; do
    if [ -f "$REPO_ROOT/$f" ]; then echo "$f"; fi
  done)
  if [ -n "$CONFLICTS" ]; then
    echo "⚠️  The following existing future-plan/ files will be OVERWRITTEN:"
    echo "$CONFLICTS" | sed 's/^/   /'
    echo ""
    echo "   Press Enter to proceed, or Ctrl-C to abort."
    # shellcheck disable=SC2034
    read -r CONFIRM </dev/tty || {
      echo "❌ Aborted."
      exit 1
    }
  fi
fi

# Merge contents into existing future-plan/ (preserving prior content)
mkdir -p future-plan
cp -r "$TEMP_DIR/future-plan/." future-plan/

# ---------- Sanitization scan ----------

echo "→ Running OSS screening scan..."
if ! python3 tools/oss_screening_scan.py --mode edit; then
  echo ""
  echo "❌ OSS screening scan FAILED. Sanitize the affected files in the source zip,"
  echo "   then re-run this script with --retry:"
  echo ""
  echo "       $0 --retry \"$TOPIC\" \"$ZIP_PATH\""
  echo ""
  echo "   The branch $BRANCH is preserved. Local file changes from this run remain."
  echo "   To start over: git checkout main && git branch -D $BRANCH"
  exit 1
fi

echo "✓ OSS screening scan: clean"

# ---------- Commit ----------

echo "→ Committing..."
git add future-plan/

# Build commit message via printf — TOPIC is the only interpolated value, validated
# above to exclude shell-special chars. Pass the full message via stdin to avoid
# the heredoc-inside-command-substitution quoting trap.
git commit -F - <<EOF
future-plan: $TOPIC

Stash design discussion outputs from "$TOPIC" session into future-plan/.

This is idea-stock content (non-authoritative for current product behavior).
See future-plan/README.md for the directory's purpose and cherry-pick process.

Sanitization status:
- python3 tools/oss_screening_scan.py --mode edit: clean

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
EOF

# ---------- Push ----------

echo "→ Pushing branch..."
if [ "$REMOTE_EXISTS" -eq 1 ] && [ "$RETRY_MODE" -eq 1 ]; then
  # Retry mode with existing remote — non-fast-forward push
  git push origin "$BRANCH" --force-with-lease
else
  git push -u origin "$BRANCH"
fi

# ---------- Draft PR ----------

# Check if PR already exists for this branch (retry case)
EXISTING_PR=$(gh pr list --head "$BRANCH" --json url --jq '.[0].url' 2>/dev/null || true)

if [ -n "$EXISTING_PR" ]; then
  echo "✓ PR already exists: $EXISTING_PR"
  PR_URL="$EXISTING_PR (updated)"
else
  echo "→ Creating draft PR..."
  PR_TEMPLATE_PATH=".github/PULL_REQUEST_TEMPLATE/future-plan.md"

  if [ -f "$PR_TEMPLATE_PATH" ]; then
    PR_BODY=$(cat "$PR_TEMPLATE_PATH")
    # Replace topic placeholder if present in template
    PR_BODY="${PR_BODY//<TOPIC>/$TOPIC}"
  else
    PR_BODY="(future-plan PR template not found; please fill in)"
  fi

  PR_URL=$(gh pr create \
    --draft \
    --title "future-plan: $TOPIC" \
    --body "$PR_BODY" \
    --base main \
    --head "$BRANCH" 2>&1) || {
    echo "❌ PR creation failed."
    exit 1
  }
fi

# ---------- Done ----------

cat <<DONE

==========================================================
✓ Draft PR ready.
==========================================================

PR URL: $PR_URL

Next steps (manual):
  1. Open the PR URL above
  2. Edit PR description: fill in Source / Cherry-pick candidates
  3. Verify Sanitization checklist items
  4. Click "Ready for review"
  5. Wait for sanitization-only review by Kimura

Branch: $BRANCH
Local: still on $BRANCH (run 'git checkout main' to return)
DONE
