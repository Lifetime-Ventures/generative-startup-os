---
name: investor-update
description: Month start, founder-triggered. Generates a Google Doc draft from past 30 days of done commitments + impact_KR>=7 decisions. Sections - highlights, asks, KR progress, decisions.
disable-model-invocation: false
---

You are running `/gsos:investor-update`. Apply [core operating principles](../skills/core-operating-principles/SKILL.md) and [tone](../skills/tone-and-style/SKILL.md).

## Pre-flight

1. Verify Notion + Google Drive connectors responsive. These are the only connectors `/investor-update` uses — do not gate on Circleback or Calendar.
2. Apply [DB schema validator](../skills/notion-data-model/SKILL.md) on Weekly Commitment + OKR Quarter + Decisions Log + Investor Updates DBs — including the status value-vocabulary check, the **Decisions Log field mapping**, and the **confidence-encoding** table (all in [schema-vocab](../../../docs/schema-vocab.md)). Use `query_database_view` for reads, with SQL `query_data_sources` only as an Enterprise-only optimization that falls back to the view query on a 400 / permission error. After a view query, re-apply date/status filters in skill logic (the view's own filters may not match what this skill needs).
3. **Investor Updates DB existence check.** Step 4 writes to it. If the DB is absent from the workspace (template variance), do NOT abort: auto-create it under the GSOS Home / Mission page with the template-canonical schema (`month` title / `audience` / `draft_url` URL / `highlights` / `asks` / `linked_KRs` relation / `generated_at` date / `sent_at` date / `schema_version` / `created_by_skill` / `last_modified_at`), then **disclose explicitly**: "Your workspace had no Investor Updates DB, so I created one under your GSOS Home page. Future runs will reuse it." Never create it silently.

## Workflow

1. Read past 30 days of Weekly Commitment that are **complete** (status in the Done-family per [schema-vocab](../../../docs/schema-vocab.md) — do not test the literal `done`), joined to OKR Quarter via `related_KR`.

2. Read Decisions Log entries from the past 30 days that are **high-confidence**. Resolve the Decisions Log schema and confidence encoding via [schema-vocab](../../../docs/schema-vocab.md): if the workspace uses the variant schema (`D-ID` / `The Trade-off` / `Assumption` / `classification_confidence`, `/sync-all`-derived), apply the field-mapping table automatically and confirm only genuinely unmapped fields. High-confidence = `confidence` in `7-10` OR select `High` OR `classification_confidence >= 0.9`. Do not compare a raw value to `7` directly.

3. Generate Google Doc draft via Drive connector. Frame it as a **de-risking narrative** per the [founder operating method](../skills/founder-operating-method/SKILL.md) §3.4 (relationship-method fundraising): lead with the **risk closed this period** and the **next risk this raise buys down** — for deep-tech / life-science, progress is uncertainty removed, not activity volume. Structure as:
   - **This month's highlights** (risks closed / KR done, key wins, traction signals). **If there are zero complete commitments this period** (all Not Started / In Progress per [schema-vocab](../../../docs/schema-vocab.md)): do not fabricate wins. Build highlights from **in-progress KR `current_value`** traction, and prepend an explicit note — "No commitments were completed this period; the highlights below are based on in-progress KR progress." Per [tone-and-style](../skills/tone-and-style/SKILL.md), never write in-progress work as done; no exaggeration.
   - **Asks** (intros, hires, resources)
   - **KR progress** (`current_value` vs `target_metric` per KR)
   - **Decisions made** (decision ID + 1-line rationale per decision, using the mapped fields)

4. Write Investor Updates DB row with `draft_url` + `audience=all LPs` (founder can change), `generated_at=now`. Row includes `schema_version: 1`, `created_by_skill: /gsos:investor-update`.

5. Tell founder: "Draft saved to Google Doc: {URL}. Polish and send when ready."

## Tone

Per [tone-and-style](../skills/tone-and-style/SKILL.md): use the founder's own words from done commitments where possible. Quote their meeting language. Do not embellish results — accuracy matters more than polish for an investor draft.

## Failure handling

Follow [error-rescue-map reference](../skills/error-rescue-map/reference.md) for Notion / Google Drive failures.
