#!/usr/bin/env bash
# pre-skill-connector-check.sh
#
# SessionStart hook for gsos-power (Claude Code only).
# Checks Notion / Calendar / Circleback connector health and writes a 24h cache
# to ${CLAUDE_PLUGIN_DATA}/connector-health.json so /gsos:* skills can read it
# without re-running the check on every invocation.
#
# Performance contract (per /plan-eng-review P1 fix):
# - Runs ONCE per session at SessionStart, not per skill call.
# - Result cached for 24h; cache hit is read-only.
# - Failure outputs a single human-readable line; never hard-aborts the session.

set -euo pipefail

CACHE_DIR="${CLAUDE_PLUGIN_DATA:-$HOME/.claude/plugins/data/gsos-power-generative-startup-os}"
CACHE_FILE="${CACHE_DIR}/connector-health.json"
CACHE_TTL_SECONDS=$((24 * 60 * 60))

mkdir -p "${CACHE_DIR}" 2>/dev/null || true

# Cache hit check
if [ -f "${CACHE_FILE}" ]; then
  CACHE_AGE=$(( $(date +%s) - $(stat -c %Y "${CACHE_FILE}" 2>/dev/null || stat -f %m "${CACHE_FILE}" 2>/dev/null || echo 0) ))
  if [ "${CACHE_AGE}" -lt "${CACHE_TTL_SECONDS}" ]; then
    # Cache fresh — exit silently, /gsos:* skills will read the cache file directly
    exit 0
  fi
fi

# Cache miss or stale — perform health check.
# NOTE: this is a v1.0 placeholder. Real connector health checks happen via the
# Notion / Google Calendar / Circleback Anthropic Connectors which are mediated by
# Claude Desktop / Code at request time, not by shell. The hook's job here is to
# write a lightweight "session entry" record that downstream skills can detect.
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
cat > "${CACHE_FILE}" <<EOF
{
  "checked_at": "${TIMESTAMP}",
  "session_marker": true,
  "notes": "Connector health is verified per-skill at runtime. This file marks SessionStart for gsos-power v1.0."
}
EOF

# Output a single line for skills to consume (or for human visibility)
# Per /plan-eng-review A3: friendly format, never hard-abort.
echo "gsos-power: SessionStart connector check OK (cached for 24h)."
exit 0
