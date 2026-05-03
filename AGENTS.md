# AGENTS.md — Constitutional Rules for AI Contributors

This file defines the rules of engagement for AI assistants (Claude Code, Codex, Gemini, etc.) contributing to `Lifetime-Ventures/generative-startup-os`. Human contributors should also read it for context, but the strictest interpretation applies to AI-driven changes (branches prefixed `claude/`, `codex/`, `gemini/`).

These rules are **non-negotiable**. They exist because this is a public OSS repository sharing infrastructure (deny-list secrets, sanitization workflow) with `Lifetime-Ventures/edge-stream` — a private Lifetime Ventures (LtV) repository containing LP/portfolio/internal data. A single accidental commit of internal data to this public repo is irreversible.

---

## Trust boundary (the 8-second test)

If you would be uncomfortable seeing a string commit appear on the front page of Hacker News, do NOT commit it.

**Specifically NEVER commit:**
- Real LP names, fund names, or commitment amounts
- Real portfolio company names (anonymize as `[Portfolio A]`, `[Portfolio B]` if reference is unavoidable)
- Real founder names (anonymize as `[Founder]` or `Sarah at Acme Corp.` style placeholder)
- Real LtV team member full names beyond what is publicly known on lifetime-ventures.com
- Real meeting transcripts, real OKR copy, real investor update drafts, real Notion content from a live LtV workspace
- Specific metric values from LtV portfolio (revenues, runway, KPIs, exit valuations)
- IC committee member identities or vote records

**Always OK to commit:**
- Generic founder personas as illustrative examples
- Skill prompts, Notion DB schemas, Zapier templates that work with anyone's data
- Architecture diagrams, design rationale, public design philosophy
- Test fixtures using clearly fake data (`Acme Corp`, `Test Founder`, `$1M ARR`)
- References to public Lifetime Ventures positioning (the firm exists, has an OIST partnership, runs OLtV2 fund — these are public)

When uncertain, anonymize and ask via PR description. The OSS screening CI catches most violations but is a safety net, not the primary defense. **The primary defense is your judgment before you write the commit.**

---

## Data tier matrix

This repo only handles Tier 3 data (publicly disclosable). Tier 0/1/2 are forbidden.

| Tier | Description | This repo |
|---|---|---|
| Tier 0 | LP info, Cap Table, IC minutes, fund commitments | **NEVER** |
| Tier 1 | DD findings, portfolio KPIs, fund operations | **NEVER** |
| Tier 2 | LtV-internal team strategy, hiring, partner discussions | **NEVER** |
| Tier 3 | Generic OSS framework code, public design philosophy, anonymized founder personas, public skill catalog | **Allowed** |

---

## OSS Export Screening (CI gate)

Every PR runs `oss-export-screening.yml` which:

1. Loads deny-list patterns from GitHub organization secrets (`LV_PORTFOLIO_COMPANIES`, `LV_ACTIVE_FOUNDERS`) — shared with the edge-stream private repo. The lists never appear in this repo's git history.
2. Loads regex patterns from `tools/scan_keywords/sensitive_metrics.txt` (committed in this repo, public-safe abstractions only).
3. Runs `tools/oss_screening_scan.py --mode edit` over OSS-derivable paths.
4. Fails the PR if any deny-list pattern matches.

**You cannot merge a PR that fails this scan.** Branch protection enforces this on `main`.

If your PR fails the scan and you believe it's a false positive:
1. Read the reported file:line and the matched pattern
2. If the regex is overly broad → propose a refinement to `sensitive_metrics.txt` in a separate PR
3. If a substring match is genuinely allowed (e.g., quoting a public news headline) → escalate to Kimura, do NOT bypass the scan

---

## Branch and PR rules

**No direct commits to `main`.** All changes go through PRs. Branch protection enforces this.

**AI-driven branches** must be prefixed:
- `claude/<topic>` — Claude Code-driven
- `codex/<topic>` — Codex-driven
- `gemini/<topic>` — Gemini-driven

This makes Kimura's review queue scannable.

**PR templates** live in `.github/PULL_REQUEST_TEMPLATE/`:
- `default.md` — for normal feature / fix / docs PRs (full functional review)
- `future-plan.md` — for PRs that ONLY add content under `future-plan/` (sanitization-only review)

When opening a PR via web UI for a `future-plan/`-only branch, switch templates by appending `?template=future-plan.md` to the compare URL. The `scripts/future-plan-add.sh` helper handles this automatically when `gh` CLI is installed.

**`future-plan/` is a sanctioned subtree** for non-authoritative idea-stock content (v2 schema candidates, Phase 2+ exploration). The same Tier 0/1/2/3 rules apply equally — no "draft folder" exception. See `future-plan/README.md` for the cherry-pick process and sunset criteria.

**PR descriptions must include:**
- Summary of what changed and why
- The OSS screening scan result (if it ran during local dev: `python3 tools/oss_screening_scan.py` clean)
- Confirmation that no Tier 0/1/2 data was added: "I confirmed this PR only contains Tier 3 (publicly disclosable) data."

**Merge approval:** Kimura merges. AI assistants do NOT self-merge, even for trivial fixes. The merge button is the human checkpoint.

---

## Sanitization discipline

When porting content from edge-stream (private) to this repo (public):

1. Run a manual `grep` for known internal terms BEFORE committing:
   ```bash
   grep -E '(山田|芝尾|篠原|赤浦|Q市場|NEDO|Kinish|JKISS|qubitcore|DXER|OIST(?! Innovation)|Rehab|OLtV[12])' <file>
   ```
   (OIST is allowed when it refers to the public university partnership; OIST Innovation is the public-facing entity name.)
2. Replace any portfolio name with `[Portfolio A]`, `[Portfolio B]` etc.
3. Replace any specific metric (e.g., `26.3億円`) with abstract form (`a few billion yen`, `low ten-figures yen`)
4. Replace any team member full name with role only (`Principal`, `Office Manager`)
5. After sanitization, run the OSS screening scan locally:
   ```bash
   python3 tools/oss_screening_scan.py --mode edit
   ```
6. If clean, commit. If hits, sanitize more.

---

## AI provenance

Include the standard trailer for AI co-authored commits:

```
Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>
```

For commits authored solely by Kimura with no AI involvement, omit the trailer.

---

## Emergency contact

If you (an AI contributor) detect that you may have committed Tier 0/1/2 data:

1. STOP immediately, do NOT push more commits
2. Open a Slack DM to Kimura with the commit SHA and the suspected leak
3. Do NOT attempt git history rewrite without Kimura's confirmation (this is a one-way operation that breaks all forks)

---

*Constitutional Rules for AI Contributors — v1.0, 2026-05-02*
*Synced with edge-stream Constitution and WHAT-NOT-TO-INPUT.md*
