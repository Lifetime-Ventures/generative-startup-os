# scripts/ — Operational Scripts

This directory contains operational helper scripts for the GSOS repository.
All scripts are POSIX shell or Python and run from the repository root.

## Available scripts

| Script | Purpose |
|---|---|
| `future-plan-add.sh` | Add design discussion outputs to `future-plan/` via single-command PR creation |

## Adding new scripts

When adding a new script:
1. Place it in `scripts/`
2. Make it executable: `chmod +x scripts/your-script.sh`
3. Add a row to the table above with a brief purpose description
4. If the script writes to OSS-derivable paths, ensure `tools/oss_screening_scan.py`
   covers those paths (see `INCLUDE_GLOBS` in the scan script)

## Conventions

- Scripts run from repo root (use `git rev-parse --show-toplevel` if needed)
- Fail-fast with `set -e` and clear error messages
- Output `✓` on success steps, `❌` on failures
- Print `Next:` instructions when manual follow-up is needed
