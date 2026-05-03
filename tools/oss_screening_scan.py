#!/usr/bin/env python3
"""
OSS Screening Scan — repo-wide deny-list check for the public Generative Startup OS repo.

Adapted from Lifetime-Ventures/edge-stream's same-named script. Both repos share
the same GitHub organization secrets (LV_PORTFOLIO_COMPANIES, LV_ACTIVE_FOUNDERS)
so the deny-list has a single source of truth (edge-stream scan_keywords/) and
never appears in either repo's git history.

This is a SAFETY NET, not the primary defense. The primary defense is the
sanitization discipline in CLAUDE.md before commits land.

Deny-list source:
  GitHub organization secrets (env-var injection at CI runtime):
    LV_PORTFOLIO_COMPANIES   (multi-line, newline-separated, # = comment)
    LV_ACTIVE_FOUNDERS       (multi-line, newline-separated, # = comment)
    LV_LIFETIME_TEAM         (publish-mode only, skipped in CI edit mode)
  Committed in this repo (public-safe regex patterns only):
    tools/scan_keywords/sensitive_metrics.txt   — regex pattern scan

Scan paths (OSS-derivable surface for this repo):
  Include:
    docs/**/*.md
    prompts/**/*.md / *.txt
    notion-templates/**/*.md
    zapier-templates/**/*.md / *.json
    tools/*.py / *.sh
    scripts/*.sh / *.md           (operational helpers)
    future-plan/**/*.md / *.txt / *.yaml / *.json / *.sh   (idea-stock content)
    README.md, CLAUDE.md, CONTRIBUTING.md, INSTALL.md
  Exclude (non-OSS, scan source itself, build artifacts):
    .git/, node_modules/, .gstack/, scan_keywords/*.txt itself

Constitutional constraint (CLAUDE.md): real portfolio/founder names must NEVER
be committed to this public repo. portfolio_companies and active_founders
deny-lists are injected via secrets at runtime; they do NOT appear in this
repo's source tree. The sensitive_metrics.txt regex layer is committed but
contains only abstract patterns safe for public exposure.

Exit codes:
  0  hit なし、または scan target ゼロ件
  1  hit あり (CI fail)
  2  scan_keywords/ ディレクトリが存在しない (config error)

Usage:
  python3 tools/oss_screening_scan.py [--repo-root PATH] [--quiet] [--mode edit|publish]

Modes:
  edit (default): portfolio + founders + sensitive_metrics. CI per-PR gate.
  publish: edit + lifetime_team. Reserved for future subtree extract / mirror gate.

Env var override (mandatory for portfolio/founders, since they cannot be committed):
  Constitution-compliant injection of org-shared deny-lists:
    LV_PORTFOLIO_COMPANIES (multi-line, newline-separated, # = comment)
    LV_ACTIVE_FOUNDERS     (multi-line, newline-separated, # = comment)
  Empty/unset -> falls back to placeholder .txt files (empty) -> 0 substring entries.
  populate cadence: quarterly + incident-driven (synced with edge-stream).

CI integration:
  .github/workflows/oss-export-screening.yml (edit mode, env-var injection)
"""

from __future__ import annotations

import argparse
import os
import re
import sys
from pathlib import Path

DEFAULT_KEYWORDS_DIR = "tools/scan_keywords"

# OSS-derivable paths for the public Generative Startup OS repo
INCLUDE_GLOBS = [
    "docs/**/*.md",
    "prompts/**/*.md",
    "prompts/**/*.txt",
    "notion-templates/**/*.md",
    "zapier-templates/**/*.md",
    "zapier-templates/**/*.json",
    "tools/*.py",
    "tools/*.sh",
    # scripts/ operational helpers (added with future-plan/ infrastructure)
    "scripts/*.sh",
    "scripts/*.md",
    # future-plan/ idea-stock content (sanitization rules apply equally)
    "future-plan/**/*.md",
    "future-plan/**/*.txt",
    "future-plan/**/*.yaml",
    "future-plan/**/*.yml",
    "future-plan/**/*.json",
    # *.json.example must be scanned explicitly: Path.glob suffix matching means
    # `**/*.json` does NOT match `foo.json.example` (suffix is `.example`).
    "future-plan/**/*.json.example",
    "future-plan/**/*.sh",
    "README.md",
    "CLAUDE.md",
    "CONTRIBUTING.md",
    "INSTALL.md",
    # NOTE: AGENTS.md is intentionally NOT scanned. It contains illustrative
    # "what NOT to commit" examples (e.g., specific metric values shown as
    # bad-example placeholders) that would trip the sensitive_metrics regexes.
    # The file is human-curated under the trust boundary; scanning it would
    # only produce noise.
]

# Excluded path substrings (non-OSS / scan source / build artifacts)
EXCLUDE_SUBSTRINGS = [
    "/.git/",
    "/node_modules/",
    "/.gstack/",
    "/scan_keywords/",
]


def parse_substring_lines(lines: list[str]) -> list[str]:
    """Shared parser: 1 line = 1 entry, # = comment, blank skipped, case-sensitive."""
    out: list[str] = []
    for line in lines:
        s = line.strip()
        if not s or s.startswith("#"):
            continue
        out.append(s)
    return out


def load_substrings(path: Path) -> list[str]:
    """File-based loader: reads from .txt and parses."""
    if not path.exists():
        return []
    return parse_substring_lines(path.read_text(encoding="utf-8").splitlines())


def load_substrings_with_env_override(path: Path, env_var_name: str) -> list[str]:
    """Env var injection (CI secret) takes priority over .txt placeholder.
    Placeholder .txt is empty in this repo by Constitutional design — env-unset
    fallback yields 0 entries, which is correct (regex layer remains active)."""
    env_content = os.environ.get(env_var_name, "").strip()
    if env_content:
        return parse_substring_lines(env_content.splitlines())
    return load_substrings(path)


def load_regexes(path: Path) -> list[tuple[str, re.Pattern[str]]]:
    """1 line = 1 Python regex, # = comment, invalid regex は warn してスキップ."""
    if not path.exists():
        return []
    out: list[tuple[str, re.Pattern[str]]] = []
    for n, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        s = line.strip()
        if not s or s.startswith("#"):
            continue
        try:
            out.append((s, re.compile(s)))
        except re.error as e:
            print(
                f"  WARN: {path}:{n} invalid regex skipped: {s!r} ({e})",
                file=sys.stderr,
            )
    return out


def collect_targets(repo_root: Path) -> list[Path]:
    """INCLUDE_GLOBS で集めた後 EXCLUDE_SUBSTRINGS で除外、ソート済みリストを返す。"""
    seen: set[Path] = set()
    for pattern in INCLUDE_GLOBS:
        for p in repo_root.glob(pattern):
            if not p.is_file():
                continue
            posix = p.as_posix()
            if any(ex in posix for ex in EXCLUDE_SUBSTRINGS):
                continue
            seen.add(p)
    return sorted(seen)


def scan(targets: list[Path], substrings: list[str], regexes: list[tuple[str, re.Pattern[str]]]) -> list[str]:
    errors: list[str] = []
    for path in targets:
        try:
            text = path.read_text(encoding="utf-8")
        except (UnicodeDecodeError, OSError) as e:
            errors.append(f"{path}: read error ({e})")
            continue
        for needle in substrings:
            if needle in text:
                errors.append(
                    f"{path}: literal {needle!r} — deny-listed in scan_keywords/"
                )
        for src, pat in regexes:
            m = pat.search(text)
            if m:
                errors.append(f"{path}: regex /{src}/ matched {m.group(0)!r}")
    return errors


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[1])
    ap.add_argument("--repo-root", default=".", help="repo root path (default: cwd)")
    ap.add_argument("--quiet", action="store_true", help="suppress info logs on success")
    ap.add_argument(
        "--mode",
        choices=["edit", "publish"],
        default="edit",
        help=(
            "edit (default): portfolio + founders + sensitive_metrics. "
            "publish: + lifetime_team (reserved for future subtree extract gate)."
        ),
    )
    args = ap.parse_args()

    repo_root = Path(args.repo_root).resolve()
    keywords_dir = repo_root / DEFAULT_KEYWORDS_DIR

    if not keywords_dir.exists():
        print(
            f"ERROR: scan_keywords/ directory missing: {keywords_dir}\n"
            f"  This repo requires the OSS screening scan to pass before any\n"
            f"  PR can land. Either populate scan_keywords/ or temporarily disable\n"
            f"  the workflow with explicit Kimura approval.",
            file=sys.stderr,
        )
        return 2

    # Env var override: portfolio + active_founders are NEVER committed to this repo.
    # Org secrets (LV_PORTFOLIO_COMPANIES, LV_ACTIVE_FOUNDERS) inject at runtime.
    portfolio = load_substrings_with_env_override(
        keywords_dir / "portfolio_companies.txt", "LV_PORTFOLIO_COMPANIES"
    )
    founders = load_substrings_with_env_override(
        keywords_dir / "active_founders.txt", "LV_ACTIVE_FOUNDERS"
    )
    substrings = portfolio + founders

    # Publish mode adds lifetime_team (reserved for future subtree extract gate).
    if args.mode == "publish":
        team = load_substrings_with_env_override(
            keywords_dir / "lifetime_team.txt", "LV_LIFETIME_TEAM"
        )
        substrings = substrings + team

    regexes = load_regexes(keywords_dir / "sensitive_metrics.txt")

    targets = collect_targets(repo_root)

    if not args.quiet:
        print(
            f"OSS screening scan [mode={args.mode}]: {len(targets)} files, "
            f"{len(substrings)} literal entries + {len(regexes)} regex patterns"
        )

    errors = scan(targets, substrings, regexes)

    if errors:
        print("\nOSS SCREENING — DENY-LIST HIT:", file=sys.stderr)
        for e in errors:
            print(f"  - {e}", file=sys.stderr)
        print(
            "\nResolution path:\n"
            "  - false positive → refine tools/scan_keywords/sensitive_metrics.txt regex (separate PR)\n"
            "  - true positive  → anonymize the content, then re-run scan\n"
            "  - new pattern    → add to sensitive_metrics.txt + co-sign with Kimura before merging\n"
            "Read CLAUDE.md for the full sanitization protocol before bypassing.",
            file=sys.stderr,
        )
        return 1

    if not args.quiet:
        print("OSS screening scan: clean (no deny-list hits).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
