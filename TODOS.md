# TODOS

Captured deferred work for [Generative Startup OS](https://github.com/Lifetime-Ventures/generative-startup-os). Organized by component, then priority (P0 = ship-blocker, P4 = nice-to-have). Completed items move to the bottom.

---

## gsos-power plugin

### v1.1: Add `/gsos-power:peer-audit` and `/gsos-power:board-prep`

**Priority:** P2

**What:** Add two more power-user commands to `gsos-power`:
- `/gsos-power:peer-audit` — cross-founder review workflow (peer reads each other's KRs and weekly-roast output, structured back-and-forth)
- `/gsos-power:board-prep` — board-meeting deck draft from KR progress + Decisions Log + Investor Updates

**Why:** Both were explicitly out of scope for the v0.1.0 reset (single founder, single onboarding path) but `gsos-power` provides a Code-only opt-in surface where they fit cleanly without re-introducing the v0 reset risk for primary users.

**Pros:** Founder Code power-user experience deepens; Lifetime Ventures portfolio founders who want peer-review or quarterly board cadence get supported workflows.

**Cons:** Hearing batch may not have validated v1.0 base by the time v1.1 ships — coordinate with the Roll-back trigger in the design doc.

**Context:** Design doc Migration M2 (`~/.gstack/projects/lifetime-ventures/kimura-no-git-design-20260506-151018-gsos-cowork-plugin-marketplace.md`) targets +2-4 weeks after v1.0 ship.

**Depends on:** v1.0 hearing batch validation (≥3 of 5 founders adopt within 4 weeks).

---

### v1.1: Sub-agent extraction for `gsos`

**Priority:** P3

**What:** Extract sub-agent logic from inline command prompts into `gsos/agents/`:
- `action-extractor` — used by `/gsos:sync-all` for AI extraction of action items per meeting
- `drift-detector` — used by `/gsos:weekly-roast` for drift / stagnate / drag detection

**Why:** Anthropic plugin spec recommends sub-agent extraction as the canonical way to tune `model` / `effort` / `maxTurns` per workflow. Inline prompts cannot be tuned independently.

**Pros:** Faster iteration on extraction quality; per-skill model selection (e.g., Haiku for dedupe, Sonnet for narrative).

**Cons:** If hearing batch shows inline prompts work fine at v1.0 quality, the migration is unnecessary churn. Wait for signal.

**Context:** `/plan-eng-review` flagged this as YAGNI for Sprint 1. Design doc next-steps step #6 was deferred. See [eng review test plan](`../../../.gstack/projects/lifetime-ventures/kimura-no-git-eng-review-test-plan-20260506-153000-gsos-cowork-plugin-marketplace.md`).

**Depends on:** v1.0 hearing batch — extract only if 2+ founders report quality issues with the affected commands, or if Kimura wants to A/B different models on /sync-all dedupe.

---

### v1.1: Windows / Linux platform verification for `/gsos-power:setup-mcp`

**Priority:** P2

**What:** Verify `gsos-power/hooks/scripts/pre-skill-connector-check.sh` runs on Windows (Git Bash / WSL) and Linux. Verify the Notion MCP server binary is available and installable on all 3 platforms.

**Why:** v1.0 ships with `.sh` scripts that work natively on macOS and Linux but require Git Bash / WSL on Windows. Kimura's primary dev machine is Windows; founders are likely a mix.

**Pros:** Inclusive Code experience across all 3 platforms.

**Cons:** Hearing batch participants are likely majority Mac (typical founder demographic).

**Context:** Design doc Risk table "MCP server が user マシンで起動失敗" is rated Med/Med. This TODO is the actionable mitigation.

**Depends on:** Kimura's local Windows test of `/gsos-power:setup-mcp` end-to-end.

---

## Completed

(empty — v1.0 ship pending Step 0/0a verification)
