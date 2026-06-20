---
name: weekly-roast
description: Friday afternoon, founder-triggered. Aggregates this week's done/not-done, identifies drift vs Mission, drafts next week's 5 commitments. Outputs 1-line verdict + 3 observations + 1 forcing question.
disable-model-invocation: false
---

You are running `/gsos:weekly-roast`. Apply [core operating principles](../skills/core-operating-principles/SKILL.md) and [tone](../skills/tone-and-style/SKILL.md).

## Pre-flight

1. Verify Notion connector responsive. `/weekly-roast` uses Notion only — do not gate on Circleback, Calendar, or Drive.
2. Apply [DB schema validator](../skills/notion-data-model/SKILL.md) on Weekly Commitment + Today's Focus + OKR Quarter DBs — including the status value-vocabulary check (see [schema-vocab](../../../docs/schema-vocab.md)). Use `query_database_view` for reads, with SQL `query_data_sources` only as an Enterprise-only optimization that falls back to the view query on a 400 / permission error.

## Workflow

1. Read Today's Focus + Weekly Commitment for current ISO week. Aggregate done vs not-done by normalizing each row's `status` per [schema-vocab](../../../docs/schema-vocab.md) (done = Done-family; not-done = incomplete; exclude the Dropped-family) — do not test the literal `open` / `done`.

2. Read Mission page. Compare commitments against Mission and KRs:
   - **Drift**: commitments without `related_KR` link (count, flag if more than 30 percent of week's commitments)
   - **Stagnate**: KR with `current_value` unchanged for 4 or more weeks
   - **Drag**: not-done items appearing 2 or more weeks in a row

3. Output structured:
   - One-line verdict ("This week was on-track / drifted on KR2 / a wash, here is why")
   - 3 observations (drift / stagnate / drag — be specific, cite row IDs)
   - 1 forcing question (e.g., "If KR2 does not move next week, do you cut it or change strategy?")

4. Ask founder for next week's 5 commitments. Allow draft from this week's not-done + new ones. Write to Weekly Commitment DB with `week=next ISO week`, `source=weekly-roast`. Every row includes `schema_version: 1`, `created_by_skill: /gsos:weekly-roast`.

5. Write reflection to current week's rows: each row's `reflection` field gets a 1-sentence "what happened" note.

## Failure handling

Follow [error-rescue-map reference](../skills/error-rescue-map/reference.md) row 18 for LLM context overflow on high-activity weeks (auto-truncate disclosed).
