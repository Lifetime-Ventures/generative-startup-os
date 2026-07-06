---
name: today
description: Daily morning, founder-triggered. Picks 1-3 actions from this week's commitments scored by KR status, due proximity, and recent done pattern. Optionally creates Calendar time blocks.
disable-model-invocation: false
---

You are running `/gsos:today`. Apply [core operating principles](../skills/core-operating-principles/SKILL.md) and [tone](../skills/tone-and-style/SKILL.md).

## Pre-flight

1. Verify **Notion + Google Calendar** connectors responsive. `/today` reads no transcripts, so **Circleback is NOT required** and must not be part of this pre-flight.
2. Apply [DB schema validator](../skills/notion-data-model/SKILL.md) on Weekly Commitment + Today's Focus DBs — including the status value-vocabulary check (see [schema-vocab](../../../docs/schema-vocab.md)).
3. Use `query_database_view` for all reads. Only use the SQL `query_data_sources` as an Enterprise-only optimization, and on a 400 / permission error fall back to the view query (see [error-rescue-map reference](../skills/error-rescue-map/reference.md)).

## Target date

`/today` operates on a **target date**, defaulting to the execution date (today). The founder may run it for a specific past or future weekday by naming a date in their chat message (e.g. "run /gsos:today for 2026-06-18", or `date=<指定日>`). When a date is given, that is the target date — a retroactive / catch-up run. No formal argument is declared; parse the date from the founder's natural message, and if none is given, target = today.

## Weekend / holiday default

Evaluate the skip against the **target date**, not the execution date. Read Mission settings `today_weekend` flag. If false (default) and the target date is Saturday / Sunday / Japan public holiday: skip with "土日は休み。月曜朝にまた。 / Weekend off. See you Monday." Override only if `today_weekend: true`. (A retroactive run for a past weekday proceeds; for a past weekend it skips.)

## Workflow

1. Read Weekly Commitment DB rows that are **incomplete** — `status` not in the Done-family or Dropped-family per [schema-vocab](../../../docs/schema-vocab.md). Do NOT filter on the literal `open` (e.g. `Not Started` and `In Progress` both count as incomplete).

2. Score by:
   - `related_KR.status` normalized per [schema-vocab](../../../docs/schema-vocab.md): `behind` > `at_risk` > `on_track` > `not_started` (`done` KRs add no urgency). Resolve the raw value (e.g. `At Risk` → `at_risk`) before weighting.
   - `due` proximity relative to the **target date** (target day > next day > later this week > later)
   - Recent `done_at` pattern (recently-stalled commitments get boosted)

3. Pick 1-3 top items. Per the [founder operating method](../skills/founder-operating-method/SKILL.md) **Top Goal** principle (§2.1), the #1 slot is the quarter's Top-Goal block — the single most important thing, done first — not merely the easiest or nearest-due task; use the score to order the rest. Phrase each pick as a single executable next action (§2.2).

4. Write to Today's Focus DB with `date=<target date>`, `generated_by=/gsos:today`. Every row includes `schema_version: 1`. Write the `status` using a value that already exists in the founder's option set (per schema-vocab write rule).

5. Show in chat with the titles.

6. Optional: ask "Calendar block these? (yes/no)". If yes, create Google Calendar events on the target date.

## Failure handling

Follow [error-rescue-map reference](../skills/error-rescue-map/reference.md) rows 15-17 for /today-specific failures (Notion 5xx cached fallback, empty Weekly Commitment, weekend skip).
