# Idea: 3-Environment Model (Foundation / Connected / Automated)

## Status

- **Origin**: Pre-reset design exploration (Claude Code-first hypothesis, April 2026)
- **Maturity**: Conceptual framework — fundamentally different from v0.1.0's single-environment design
- **Conflict with v0.1.0**: Major. v0.1.0 is single-environment (Claude.ai + Notion + Circleback). This proposes 3 staged environments with different tool surface areas.

## Problem the original idea was solving

Pre-reset hypothesis: founders span a wide range of technical comfort and budget. Forcing all of them into the same setup either:
- Over-serves low-budget non-technical founders (paying $100+/month for tools they don't use), or
- Under-serves high-budget technical founders (no automation when they could afford it)

The proposed solution: 3 staged environments founders can opt into.

| Env | Tool surface | Monthly cost | Target founder |
|---|---|---|---|
| Foundation | Notion only, manual everything | $10 | Solo bootstrapper, no AI familiarity |
| Connected | + Claude.ai + Cowork Desktop | $30-100 | Post-seed solo founder, AI literate |
| Automated | + Claude Code + MCP + iPaaS | $80-120 | Engineer-founder or technical co-founder available |

Founders progress through environments as their company grows.

## Why this didn't survive the reset

The 2026-05-02 foundation reset chose a different strategy: **single environment, optimized for the largest founder segment** (Claude.ai-Pro-paying, AI-literate, non-engineer pre-team founders).

This decision was right for v0.1.0 because:
- 3 environments = 3x the testing surface, 3x the documentation burden
- "Foundation" (no AI) duplicates capabilities Notion already offers — unclear value-add
- "Automated" (Claude Code + MCP) excludes 80%+ of founders who aren't comfortable with terminals
- Single environment = single onboarding path, single failure mode tree, single hearing-test target

For Phase 1's **5-founder hearing batch**, single-environment is the right scope.

## When this idea may resurface

After hearing batch validates the core 5-skill loop (≥3 of 5 founders install + use 3 weeks), Phase 2 might expand to:

- **A "lite" option** for budget-constrained founders (closest to "Foundation" idea, but probably not 0-AI)
- **An "automated" option** for engineer-founders who want MCP + iPaaS (closest to "Automated" idea)

But these would likely be **opt-in extensions to the v0.1.0 base**, not replacements. The 3-environment framing as a primary architecture is unlikely to come back.

## What's worth preserving from this idea

Even if 3-environment-as-architecture is dead, two specific concepts may carry forward:

### 1. Cost transparency

Pre-reset design produced a detailed cost-breakdown comparison across environments. That **comparison framework** — "here's what tools cost, here's what each adds" — is useful for any founder making tooling decisions. A Phase 2 README addition could include a cost ladder for founders weighing Claude.ai Pro vs Pro+API vs Claude Code subscription.

### 2. Optional iPaaS layer

The "Automated" environment's Make.com integration concept (auto-syncing Gmail / Slack / VoiceMemo to Notion via iPaaS) is genuinely valuable for the subset of founders who want it. Could be a Phase 2 "iPaaS extension" available to any founder, not gated by environment.

The make-blueprints/ directory in `automation-stack-options/` (this future-plan directory) preserves the Make.com Blueprint specs that would enable this.

## Open questions for hearing batch

- Do hearing founders complain about Claude.ai Pro cost? (informs "lite" path priority)
- Do hearing founders ask for automation (auto-import Gmail, etc.)? (informs iPaaS extension priority)
- Are there founders who **wouldn't have signed up for v0.1.0** because Claude.ai Pro was too expensive? (only learnable from pivot-test failure, not hearing batch directly)

## Relation to v0.1.0 README's roadmap

v0.1.0 README roadmap mentions Phase 3+ as "pre-team alignment OS expansion (co-founder thesis debate, async investor update sharing)". The 3-environment model is **not aligned** with this — it's more about tooling tier than founder stage.

If anything, the 3-environment model is a **horizontal cost-tier expansion**, while the README roadmap focuses on **vertical stage expansion** (pre-team → small team → bigger team).

These are independent axes. Both may eventually exist; neither is on a Phase 1 ship blocker list.
