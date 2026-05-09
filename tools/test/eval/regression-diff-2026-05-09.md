# Prompt Regression Diff: v0 paste-flow -> v1.0.x plugin

**Generated:** 2026-05-09
**Scope:** /plan-eng-review Iron Rule blocker (silent prompt-split regression)
**Method:** Static text diff between `prompts/system-prompt.md` (v0) and `gsos/`-tree (v1.0.x)
**Reason for static diff (vs LLM-driven baseline):** the LLM-driven baseline ideally captures paste-flow output against an anonymized fixture for behavioral comparison. That requires the maintainer's Claude.ai Project + Notion test workspace + Connector OAuth, which can't be done autonomously. A static diff catches the underlying regression mechanism (dropped or paraphrased rescue logic) directly from text. It misses behavioral drift from re-tokenization, but it surfaces every literal content drop, which is the highest-confidence failure mode for a skill split.

---

## Summary

- **Verbatim preservation**: 13 / 21 v0 sections
- **Paraphrased**: 4 / 21 sections (semantic content preserved, wording adjusted)
- **Dropped (HIGH risk)**: 4 sections / 2 entire skills
- **Dropped (MEDIUM risk)**: 4 sub-sections / behaviors

**Verdict**: v1.0.x plugin marketplace ships **without** the v0 `/help` discoverability, `/migrate` schema-upgrade pathway, bilingual pre-flight error messages, and explicit privacy-share confirmation. Plus a forward-broken link from `notion-data-model/SKILL.md` to `prompts/system-prompt.md` that will dangle when v1.2 deletes the latter.

None of the drops are silently wrong outputs (the kind that puts a wrong OKR in a founder's Notion). They are **silently missing surfaces** (the founder types `/help`, gets nothing useful from GSOS) and **silently broken future paths** (the founder has a v2 schema someday, no `/migrate` to run).

---

## v0 -> v1 mapping table

| # | v0 section | v0 lines | v1 location | Status | Notes |
|---|---|---|---|---|---|
| 1 | Header + deprecation banner | 1-9 | `prompts/system-prompt.md` (kept) + `README.md` migration section | KEPT | Deprecation banner added in PR #14, file scheduled for deletion in v1.2 |
| 2 | Identity statement ("You are GSOS...") | 11 | each `gsos/commands/*.md` preamble | PARAPHRASED | "You are running `/gsos:*`. Apply ..." |
| 3 | Operating principles 1-5 | 13-19 | `CLAUDE.md` (single source) + `core-operating-principles/SKILL.md` (link only) | VERBATIM (in CLAUDE.md) | Per Q1 採択, CLAUDE.md is authoritative |
| 4 | Architecture: DB schemas (6 DBs + Mission page) | 21-33 | `notion-data-model/SKILL.md` (links to `notion-templates/README.md` + `prompts/system-prompt.md`) | **PARTIAL — broken in v1.2** | Full column lists are in `notion-templates/README.md` (kept) but the inline schema reference points to system-prompt.md which is deleted in v1.2. See HIGH-5 below. |
| 5 | Architecture: Connector method list (`query_database`, `list_meetings`, etc.) | 35-40 | each command's pre-flight + `notion-data-model/SKILL.md` (brief) | **PARAPHRASED, method names DROPPED** | LLM may invoke wrong method names without the explicit list. See MEDIUM-7. |
| 6 | Pre-flight check (run at start of EVERY skill) | 42-52 | each `gsos/commands/*.md` "Pre-flight" section | VERBATIM-like | But **bilingual error message DROPPED** — see HIGH-3. |
| 7 | DB schema validator (T3) | 54-61 | `notion-data-model/SKILL.md` (paraphrased) | PARAPHRASED | abort message preserved roughly |
| 8 | Schema versioning (`schema_version: 1`) | 63-65 | each command writes `schema_version: 1`; `notion-data-model/SKILL.md` mentions in passing | **PARTIAL — abort case dropped** | "If you encounter `schema_version > 1`, output 'Schema migration required. Run `/migrate` (Phase 2).' and abort." is gone. See MEDIUM-6. |
| 9 | Idempotency lock (T4) | 67-75 | `gsos/commands/okr-set.md` pre-flight step 5 | VERBATIM-like | lock_token logic preserved |
| 10 | Prompt injection defense (T14) | 77-93 | `transcript-handling/SKILL.md` | VERBATIM-like | DATA delimiter wrapping rule + suspicious-content warning preserved |
| 11 | Skill catalog overview ("You have 7 skills...") | 95-99 | `README.md` skill table (5 commands listed) | PARAPHRASED | But "/help suggest if non-skill" UX **DROPPED** — see HIGH-1. |
| 12 | `/okr-set` workflow | 101-133 | `gsos/commands/okr-set.md` | VERBATIM | Mission narrative prompt (lines 116-128) preserved verbatim |
| 13 | `/sync-all` workflow | 135-170 | `gsos/commands/sync-all.md` + `transcript-handling/SKILL.md` (extraction + dedupe prompts) | VERBATIM | both internal prompts preserved verbatim |
| 14 | `/today` workflow | 172-184 | `gsos/commands/today.md` | VERBATIM | weekend skip JP/EN message preserved |
| 15 | `/weekly-roast` workflow | 186-200 | `gsos/commands/weekly-roast.md` | VERBATIM | drift / stagnate / drag detection preserved |
| 16 | `/investor-update` workflow | 202-214 | `gsos/commands/investor-update.md` | VERBATIM | Doc draft structure preserved |
| 17 | `/help` skill | 216-243 | **NOT MIGRATED** | **DROPPED (HIGH-1)** | See below |
| 18 | `/migrate` skill | 245-270 | **NOT MIGRATED** | **DROPPED (HIGH-2)** | See below |
| 19 | Failure handling table (6 service classes) | 272-283 | `gsos/skills/error-rescue-map/reference.md` (full table from `docs/error-rescue-map.md`) | VERBATIM | reference.md is the full migration |
| 20 | Tone | 285-296 | `tone-and-style/SKILL.md` (link to CLAUDE.md) + `CLAUDE.md` Tone section | VERBATIM (in CLAUDE.md) | Never-list preserved |
| 21 | Privacy boundary | 298-304 | `CLAUDE.md` Privacy section + `README.md` data-flow section | **PARTIAL** | Tier 3 + per-founder OAuth principles preserved. **Explicit user-facing confirmation prompt for sending data outside stack DROPPED** — see HIGH-4. |

---

## HIGH-priority drops (4)

### HIGH-1: `/help` skill dropped

**v0 (`prompts/system-prompt.md` lines 216-243)**:

```text
### `/help` — list all skills (T12)
Pure-output skill. ... Output a structured list:
  Daily / weekly cadence:
    /sync-all       — daily morning. Ingest yesterday's meetings into Notion.
    /today          — daily morning. Pick 1-3 actions from this week's commitments.
    /weekly-roast   — Friday afternoon. Reflect on the week, draft next week.
  Setup / monthly:
    /okr-set        — initial setup or quarterly rollover.
    /investor-update— month start.
  Utility:
    /help           — this message.
    /migrate        — upgrade Notion DB schema.

Then offer to invoke one: "Which would you like to run?"
```

**v1.0.x**: no `gsos/commands/help.md`, no equivalent skill in `gsos/skills/`.

**Founder impact**: a founder who types `/help` in Cowork or Code gets the default plugin-host fallback (typically nothing GSOS-specific). The discoverability path for "what skills are available" is broken. The README has the skill table but founders don't typically re-read README mid-workflow.

**Recommended fix**:
- Add `gsos/commands/help.md` that outputs the v0 catalog text. Pre-flight is skipped (no connectors needed). Trivial to restore — ~30 lines.
- Bonus: include the v1 namespacing (`/gsos:*` form) in the help output, which the v0 didn't have.

### HIGH-2: `/migrate` skill dropped

**v0 (`prompts/system-prompt.md` lines 245-270)**:

```text
### `/migrate` — DB schema migration (T9)
Schema upgrade pathway for when the Generative Startup OS framework releases a new schema version. Phase 1 ships at `schema_version: 1`; this skill runs the upgrade when a future version (e.g., schema_version: 2) ships.
...
1. Read `schema_version` property from Mission page metadata.
2. Compare to the latest schema version.
3. Branch:
   - Founder DB at current version: tell founder "Already on schema v{N}. No migration needed." Exit.
   - Founder DB older than skill: apply migrations sequentially.
   - Founder DB newer than skill: tell founder to update Custom Instructions.
4. On any error mid-migration: do NOT proceed to next step. Save error details to Mission page metadata.

Schema version registry (Phase 1):
- v1 (current): the schema documented in `notion-templates/README.md`. ...
There are no migrations to apply yet (v1 is the initial release).
```

**v1.0.x**: no `gsos/commands/migrate.md`, no equivalent.

**Founder impact**: when GSOS Phase 2 ships v2 schema (per the design intent), there is no installed migration pathway. Founders will need to manually re-duplicate the Notion template or hand-edit columns, breaking the "the OS handles its own upgrades" promise. This is also a forward-compatibility regression: v0 documented v1 as the initial state with the registry placeholder for v2; v1.0.x has no such placeholder anywhere.

**Recommended fix**:
- Add `gsos/commands/migrate.md` with the v0 logic.
- Migration step registry should live in the same file (or a sibling `gsos/skills/migrations/` directory) so v2 contributors know where to add v1 -> v2 entries.
- Tracking: `TODOS.md` already has v1.1 sub-agent extraction P3. This should join as a higher-priority restoration item.

### HIGH-3: Bilingual pre-flight error message dropped

**v0 (`prompts/system-prompt.md` lines 49-51)**:

```text
4. If any fail, output (in founder's language):
   - English: "{connector_name} is not connected. OAuth from Settings → Connectors, then type `resume`."
   - Japanese: 「{connector_name} が未接続。 Settings → Connectors から OAuth してから 「再開」 と打ってください。」
```

**v1.0.x**: each `gsos/commands/*.md` says "If any pre-flight fails, follow the [error-rescue-map](../skills/error-rescue-map/SKILL.md) for the matching service class." The reference table in `gsos/skills/error-rescue-map/reference.md` is **English only**.

**Founder impact**: Japanese founders (which is the main hearing-batch demographic per memory `user_language_pref`) will see English error messages and the English keyword `resume` instead of `再開`. Per CLAUDE.md "Match the founder's language (Japanese OK if they use Japanese; switch to match)", this is a tone-rule violation in the error path specifically.

**Recommended fix**:
- Restore the bilingual abort message template directly in each command's Pre-flight section, OR
- Add a "Bilingual error templates" subsection to `tone-and-style/SKILL.md` and reference it from each command.
- Lower-effort interim: a 2-line addition to `error-rescue-map/reference.md` row 1 (Circleback OAuth expired) saying "founder-visible message must be in founder's language; templates: ..."

### HIGH-4: Privacy share-confirmation gate dropped

**v0 (`prompts/system-prompt.md` lines 302-304)**:

```text
If the founder asks you to send their data somewhere outside this stack (e.g., post to Slack, email an LP), confirm explicitly: "This will share `[content summary]` with `[destination]`. Confirm? (yes/no)" before executing.
```

**v1.0.x**: `CLAUDE.md` Privacy boundary section preserves the Tier 3 + per-founder OAuth principles, but the **explicit user-facing confirmation gate** for outbound data transfer is not anywhere in the gsos/ tree.

**Founder impact**: if a founder casually says "send this OKR draft to my LP", v1 GSOS may execute without the explicit confirm? prompt. This isn't an LLM-output silent failure; it's a missing safety gate that v0 had. For a Lifetime-Ventures-branded plugin handling investor-side data, the regression is consequential.

**Recommended fix**:
- Add a "Outbound data confirmation" subsection to `core-operating-principles/SKILL.md` (or restore the line directly in `CLAUDE.md` Operating principles as principle #6).
- The confirmation template (`This will share [content summary] with [destination]. Confirm? (yes/no)`) belongs in `tone-and-style/SKILL.md` alongside the existing Never-list.

### HIGH-5: `notion-data-model/SKILL.md` link to `prompts/system-prompt.md` will dangle in v1.2

**v1.0.x (`gsos/skills/notion-data-model/SKILL.md` line 6)**:

```markdown
The full Notion data model (databases, columns, schema_version conventions, idempotency lock, DB validator) is defined in [notion-templates/README.md](../../../notion-templates/README.md) and the "Architecture you operate against" section of [prompts/system-prompt.md](../../../prompts/system-prompt.md).
```

**v1.2 plan**: `prompts/system-prompt.md` is scheduled for deletion (per the deprecation banner added in PR #14).

**Founder impact**: when v1.2 ships, the SKILL.md link 404s for any LLM trying to follow it. The full inline DB schema (with column lists, connector method names, etc.) is then only in `notion-templates/README.md` which is template/setup-focused, not skill-runtime-focused. The schema-validation and connector-call paths lose their authoritative reference.

**Recommended fix**:
- Before v1.2 deletes `prompts/system-prompt.md`, copy the "Architecture you operate against" section's runtime-relevant content (DB columns + connector methods) into either `notion-data-model/SKILL.md` directly or a sibling `gsos/skills/notion-data-model/reference.md`.
- Update the link in SKILL.md to point to the new local copy.
- This is essentially the same migration pattern used for `error-rescue-map/reference.md` (which copied content from `docs/error-rescue-map.md`).

---

## MEDIUM-priority drops (4)

### MEDIUM-6: Schema-version > v1 abort case dropped

**v0**: "If you encounter a row with `schema_version > 1`, output: 'Schema migration required. Run `/migrate` (Phase 2).' and abort."

**v1.0.x**: not in any command or skill.

**Founder impact**: if a founder's Notion has been bumped (e.g., they used a beta v2 template), v1 commands will silently treat it as v1, possibly mis-mapping columns. Coupled with HIGH-2 (no `/migrate`), the recovery path is also gone.

### MEDIUM-7: Connector method names dropped

**v0** explicitly listed: Notion `query_database / create_page / update_page / search`, Calendar `list_events / create_event / update_event`, Drive `create_file`, Circleback `list_meetings / get_transcript / get_action_items / search`.

**v1.0.x**: command pre-flight says "Verify Notion connector responsive: `query_database` on Mission page" for okr-set, but other commands just say "Verify Notion connector responsive" without method specifics. The full method inventory is gone.

**Founder impact**: minor — modern Anthropic Connectors are well-documented and the LLM can usually pick correct methods. But for a custom workflow ("export this OKR to a Doc"), the LLM may guess wrong without the inventory.

### MEDIUM-8: Skill catalog "If they type a non-skill, suggest /help" dropped

**v0 line 97**: "If they type a non-skill, suggest `/help` and ask what they want."

**v1.0.x**: with `/help` itself dropped (HIGH-1), this UX flow is broken twice over.

**Founder impact**: typo or unfamiliar command -> no graceful guide back to known-good skills.

### MEDIUM-9: "You have 7 skills" narrative count is now wrong

**v0 line 97**: "You have 7 skills."

**v1.0.x** has 5 commands in `gsos/` + 1 in `gsos-power/` = 6 effective. The `prompts/system-prompt.md` retains the "7 skills" claim (it's frozen content), but that's deprecated and going away in v1.2 anyway. Low impact.

---

## What was preserved successfully (no regression risk)

These v0 components landed in v1.0.x without semantic drift:

- All 5 core skill workflows (`/okr-set` -> `/gsos:okr-set`, etc.)
- The Mission narrative prompt (verbatim in `gsos/commands/okr-set.md`)
- The action extraction prompt (verbatim in `transcript-handling/SKILL.md`)
- The pairwise dedupe prompt (verbatim in `transcript-handling/SKILL.md`, including the bilingual question phrasing)
- Operating principles 1-5 (in CLAUDE.md, single source per Q1 採択)
- Idempotency lock (T4) on Mission page metadata
- DATA-delimiter wrapping rule for transcripts
- 24-row failure-mode rescue table (in `error-rescue-map/reference.md`)
- Tone "Never" list (in CLAUDE.md)
- Schema_version + created_by_skill row writes (each command applies)

---

## Recommended remediation roadmap

Ranked by user-facing impact x effort:

1. **v1.0.2** (this PR or next): document this regression-diff. No code change. ~1 hour. (DONE in this PR.)
2. **v1.0.3** (small follow-up PR): restore `/help` (HIGH-1). ~30 lines, ~30 min. Highest discoverability impact for new founders, lowest effort.
3. **v1.0.3** (same PR): restore bilingual error message templates (HIGH-3). ~10 lines. Critical for Japanese-language hearing batch.
4. **v1.0.3** (same PR): restore Privacy share-confirmation gate (HIGH-4). ~5 lines added to `core-operating-principles/SKILL.md` or `CLAUDE.md`.
5. **v1.1**: pre-empt HIGH-5 by copying DB schema reference into `gsos/skills/notion-data-model/reference.md` BEFORE v1.2 deletes `prompts/system-prompt.md`.
6. **v1.1 or v1.2**: restore `/migrate` (HIGH-2). Larger effort because the Phase-2 migration logic itself is unwritten — but at minimum the scaffolding (skill file with the v0 logic) should land. ~50 lines.
7. **v1.1**: restore connector method inventory (MEDIUM-7) in `notion-data-model/SKILL.md` reference.

The HIGH-1 + HIGH-3 + HIGH-4 bundle (~45 lines total) is the most impactful single follow-up PR. Recommend bundling them as `claude/v1.0.3-skill-restorations` after this regression-diff PR lands.

---

## Methodology caveats

- **Static diff cannot detect re-tokenization drift**: even if v0 and v1 prompts are byte-identical, the LLM may produce slightly different outputs because surrounding context (skill bundle structure, frontmatter, link resolution) differs between paste-flow and plugin runtime. To detect that, the maintainer would still need to run the v0 paste-flow and v1 plugin against an identical fixture and diff the outputs. That work is deferred to the next time a founder reports unexpected output, or to v1.2 cutover.
- **No fixture run was executed**: this diff is text-only. It catches dropped logic but not behavioral surprises.
- **`gsos-power` plugin was NOT analyzed**: gsos-power v1.0.1 is Code-only, has no equivalent in v0 paste-flow, and is therefore out of regression-diff scope.
- **`CLAUDE.md` and `AGENTS.md` were treated as authoritative for principles** (per Q1 採択 in the v1.0 design doc). Anything covered there is "preserved" even if not duplicated in `gsos/skills/`.
