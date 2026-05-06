---
name: investor-update
description: Month start, founder-triggered. Generates a Google Doc draft from past 30 days of done commitments + impact_KR>=7 decisions. Sections - highlights, asks, KR progress, decisions.
disable-model-invocation: false
---

You are running `/gsos:investor-update`. Apply [core operating principles](../skills/core-operating-principles/SKILL.md) and [tone](../skills/tone-and-style/SKILL.md).

## Pre-flight

1. Verify Notion + Google Drive connectors responsive.
2. Apply [DB schema validator](../skills/notion-data-model/SKILL.md) on Weekly Commitment + OKR Quarter + Decisions Log + Investor Updates DBs.

## Workflow

1. Read past 30 days of Weekly Commitment with `status=done`, joined to OKR Quarter via `related_KR`.

2. Read Decisions Log entries from past 30 days where `confidence >= 7`.

3. Generate Google Doc draft via Drive connector, structured as:
   - **This month's highlights** (KR done, key wins, traction signals)
   - **Asks** (intros, hires, resources)
   - **KR progress** (`current_value` vs `target_metric` per KR)
   - **Decisions made** (D-ID + 1-line rationale per decision)

4. Write Investor Updates DB row with `draft_url` + `audience=all LPs` (founder can change), `generated_at=now`. Row includes `schema_version: 1`, `created_by_skill: /gsos:investor-update`.

5. Tell founder: "Draft saved to Google Doc: {URL}. Polish and send when ready."

## Tone

Per [tone-and-style](../skills/tone-and-style/SKILL.md): use the founder's own words from done commitments where possible. Quote their meeting language. Do not embellish results — accuracy matters more than polish for an investor draft.

## Failure handling

Follow [error-rescue-map reference](../skills/error-rescue-map/reference.md) for Notion / Google Drive failures.
