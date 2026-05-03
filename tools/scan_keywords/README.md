# Scan Keywords

This directory contains the deny-list configuration consumed by `tools/oss_screening_scan.py` (the OSS Export Screening CI gate).

## Files

| File | Source | Purpose |
|---|---|---|
| `portfolio_companies.txt` | Empty placeholder. **Real values injected via GitHub org secret `LV_PORTFOLIO_COMPANIES` at CI runtime.** | Block real portfolio company names from leaking into public commits |
| `active_founders.txt` | Empty placeholder. **Real values injected via GitHub org secret `LV_ACTIVE_FOUNDERS` at CI runtime.** | Block real LtV-pipeline founder names from leaking |
| `lifetime_team.txt` | Optional, public-OK names only (committed) or env override `LV_LIFETIME_TEAM`. Skipped in CI edit mode, used in publish mode only. | Reserved for future subtree extract / mirror gate |
| `sensitive_metrics.txt` | Committed in this repo, regex patterns only, public-safe abstractions. | Block specific LtV operating metrics (KR values, fund commitments, exit multiples, etc.) using abstract regex |

## Why split storage?

Per `CLAUDE.md`: real portfolio/founder names cannot be committed to this public repo. The `oss_screening_scan.py` script reads from environment variables (injected by the GitHub Actions workflow from organization secrets) when present, and falls back to the local `.txt` files when env vars are unset. The local files for `portfolio_companies.txt` and `active_founders.txt` are placeholder-empty by Constitutional design.

## Source of truth

The canonical deny-list lives in `Lifetime-Ventures/edge-stream` (private repo) at `startup-fa/reference/lifetime_pfc/scan_keywords/`. Both repos consume the same GitHub organization secrets, so:

1. Kimura updates `edge-stream/startup-fa/reference/lifetime_pfc/scan_keywords/{portfolio_companies,active_founders}.txt` (private)
2. Kimura runs the secret update procedure (see `edge-stream/SECRETS-UPDATE.md`) to push the new content to org secrets `LV_PORTFOLIO_COMPANIES` and `LV_ACTIVE_FOUNDERS`
3. Both `edge-stream` and `generative-startup-os` workflows immediately use the updated list on next CI run

## Pattern format

- `portfolio_companies.txt` and `active_founders.txt`: one literal substring per line. `#` lines are comments. Case-sensitive match against file content.
- `sensitive_metrics.txt`: one Python regex per line. `#` lines are comments. Invalid regexes are warned and skipped.

## Local testing

To run the scan locally before pushing:

```bash
# Edit mode (CI default): no real deny-list, regex layer only
python3 tools/oss_screening_scan.py --mode edit

# Publish mode (future use): also blocks lifetime_team
python3 tools/oss_screening_scan.py --mode publish
```

If you need to test against the real deny-list locally (rare, requires Kimura approval):

```bash
LV_PORTFOLIO_COMPANIES="$(cat /path/to/private/portfolio_companies.txt)" \
LV_ACTIVE_FOUNDERS="$(cat /path/to/private/active_founders.txt)" \
python3 tools/oss_screening_scan.py --mode edit
```

Never check the populated lists into this repo's git history.

## Update cadence

- Quarterly review (Kimura runs it during quarter-end ops cycle)
- Incident-driven: any time a portfolio company exits, a founder declines, or LtV team composition changes

See `edge-stream/startup-fa/reference/lifetime_pfc/scan_keywords/curation_rubric.md` for the full curation rubric.
