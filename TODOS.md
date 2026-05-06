# TODOS

Captured deferred work for [Generative Startup OS](https://github.com/Lifetime-Ventures/generative-startup-os). Organized by component, then priority (P0 = ship-blocker, P4 = nice-to-have). Completed items move to the bottom.

---

## Release engineering

### v1.0 ship-time: tag both plugins per Anthropic convention

**Priority:** P0 (release blocker — without tags, `gsos-power` will be disabled with `no-matching-tag` errors for any user installing it)

**What:** When tagging the `v1.0.0` release on this repo, tag each plugin separately using the Anthropic plugin convention `{plugin-name}--v{version}`:

```bash
# Option 1 (recommended): use the official tool
cd gsos && claude plugin tag --push
cd ../gsos-power && claude plugin tag --push

# Option 2: manual git tags (must match plugin.json version exactly)
git tag gsos--v1.0.0
git tag gsos-power--v1.0.0
git push origin gsos--v1.0.0 gsos-power--v1.0.0
```

**Why:** `gsos-power/.claude-plugin/plugin.json` declares `dependencies: [{name: "gsos", version: "~1.0.0"}]`. Per [Anthropic plugin-dependencies docs](https://code.claude.com/docs/en/plugin-dependencies), Claude Code resolves the constraint against git tags matching `gsos--v*` on the marketplace repository. If no such tag exists at install time, `gsos-power` is disabled with `no-matching-tag` and the user sees a broken install.

A single repository-level tag like `v1.0.0` is **not enough** — it doesn't match the `{plugin-name}--v*` pattern.

**Pros:** Dependency resolution works as designed; users get clean install behavior.

**Cons:** None — this is a Day-0 release procedure mistake to avoid.

**Context:** Discovered during Step 0a spec re-read (2026-05-06). Required for Claude Code v2.1.110 or later.

**Depends on:** v1.0 ship readiness (Step 0/0a + prompt-regression baseline).

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
