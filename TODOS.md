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

## gsos plugin

### v1.1: hide reference SKILL.md from the user-facing slash menu

**Priority:** P3

**What:** When `gsos` is installed in Cowork, all 10 components (5 SKILL.md + 5 commands.md) appear as `/`-invocable entries in the Cowork directory and slash menu, including reference-only skills like `/core-operating-principles`, `/error-rescue-map`, `/notion-data-model`, `/tone-and-style`, `/transcript-handling`. Founders see 10 commands but only 5 are user-meaningful — the other 5 are LLM reference materials linked from `CLAUDE.md`.

**Why:** Discovered during Step 0 manual verification on 2026-05-06 (screenshot in PR #13 closing comments). The 5 reference skills should be Claude-invocable in context but not surfaced as slash commands the founder picks from a menu.

**Pros:** Cleaner founder UX — `/gsos:okr-set` and the 4 sister commands are obviously the intended entry points; no decision paralysis from reference skills.

**Cons:** Need to confirm the right plugin manifest mechanism. Options include adding `disable-model-invocation: true` (commands convention) to SKILL.md frontmatter, moving the reference content into the `agents/` tree with its own visibility rules, or restructuring as bare markdown files referenced from the 5 commands without being indexed.

**Context:** Discovered post-ship; not a v1.0 blocker. The 5 commands work end-to-end; reference skills are functionally inert (no harm if invoked, just extra menu noise).

**Depends on:** Spec confirmation around SKILL.md frontmatter visibility flags.

---

### Post-v1.0.1: push gsos-power--v1.0.1 tag after merge

**Priority:** P0 (release-engineering, every gsos-power version bump)

**What:** After this v1.0.1 follow-up PR merges, push the matching git tag so the dependency resolution still works:

```bash
cd gsos-power && claude plugin tag --push
# or manually:
git tag gsos-power--v1.0.1 && git push origin gsos-power--v1.0.1
```

**Why:** Same reason as the v1.0.0 tag push at ship — without `gsos-power--v1.0.1`, anyone installing `gsos-power` after this PR merges would resolve to v1.0.0 (the prior tag). They would not see the corrected description nor the version-aligned manifest.

**Pros:** Dependency resolution stays accurate.

**Cons:** None — this is the release procedure for every version bump.

**Context:** Established in v1.0 ship (TODOS "v1.0 ship-time" item, now Completed). This is the standing procedure for every subsequent version bump on either plugin.

---

## Repository operations

### v1.1: Inbound license-compat check in OSS screening

**Priority:** P3

**What:** Add a lightweight check (regex layer in `tools/oss_screening_scan.py` or a sibling script) that flags incoming PRs containing GPL / AGPL / CC-BY-NC / SSPL license markers in newly-added files. Apache-2.0 outbound license is incompatible with GPL family for incorporation.

**Why:** Discovered during 2026-05-10 license migration eng review (`claude/license-migration-apache2`). Current OSS screening focuses on data tier (Tier 0-3) sanitization, not license posture. After Apache-2.0 migration, accidentally incorporating GPL-licensed code from a contributor PR would put the entire repo's license clarity at risk. Apache-2.0's patent grant (§3) only flows clean if all incorporated code is Apache-2.0-compatible.

**Pros:** Long-term protection of Apache-2.0 license clean room; catches contributor mistakes early; lightweight (regex on diff, not full file scan); reuses the existing `INCLUDE_GLOBS` + `EXCLUDE_SUBSTRINGS` infrastructure pattern in `oss_screening_scan.py`.

**Cons:** False positives possible (e.g., quoting GPL FAQ in docs); requires deny-list maintenance; not strictly necessary while contributor pool is small and PRs are human-reviewed.

**Context:** The OSS screening pattern is established (see existing `tools/oss_screening_scan.py:74` INCLUDE_GLOBS and `tools/scan_keywords/sensitive_metrics.txt`). License marker detection would be a sibling regex layer that scans incoming PR diffs for strings like `GNU General Public License`, `Affero General Public License`, `CC BY-NC`, `Server Side Public License`. Recommended scope: `--mode pr-license-check` flag added to `oss_screening_scan.py`, fired by a new CI step in `oss-export-screening.yml` only on `pull_request` events.

**Depends on:** v1.0 hearing batch settled (≥3 of 5 founders in 4 weeks); not a v1.0.x blocker. Reasonable to bundle with the v1.1 sub-agent extraction work (TODOS.md "v1.1: Sub-agent extraction for `gsos`") as that PR will already be touching contributor-facing infrastructure.

---

## Completed

### v1.0 ship-time: tag both plugins per Anthropic convention

**Completed:** v1.0.0 (2026-05-06)

Pushed `gsos--v1.0.0` (a6d007d) and `gsos-power--v1.0.0` (d545a49) to origin via `claude plugin tag --push`. Step 0 manual verification on 2026-05-06 confirmed both plugins install cleanly in Cowork via the Add-from-GitHub flow under the Personal (個人用) tab; the `/gsos:okr-set` pre-flight runs as designed.
