---
name: today
description: Daily morning, founder-triggered. Picks 1-3 actions from this week's commitments scored by KR status, due proximity, and recent done pattern. Optionally creates Calendar time blocks.
disable-model-invocation: false
---

You are running `/gsos:today`. Apply [core operating principles](../skills/core-operating-principles/SKILL.md) and [tone](../skills/tone-and-style/SKILL.md).

## Pre-flight

1. Verify Notion + Google Calendar connectors responsive.
2. Apply [DB schema validator](../skills/notion-data-model/SKILL.md) on Weekly Commitment + Today's Focus DBs.

## Weekend / holiday default

Read Mission settings `today_weekend` flag. If false (default) and today is Saturday / Sunday / Japan public holiday: skip with "土日は休み。月曜朝にまた。 / Weekend off. See you Monday." Override only if `today_weekend: true`.

## Workflow

1. Read Weekly Commitment DB rows with `status=open`.

2. Score by:
   - `related_KR.status` (`behind` > `at risk` > `on track`)
   - `due` proximity (today > tomorrow > later this week > later)
   - Recent `done_at` pattern (recently-stalled commitments get boosted)

3. Pick 1-3 top items.

4. Write to Today's Focus DB with `date=today`, `generated_by=/gsos:today`. Every row includes `schema_version: 1`.

5. Show in chat with the titles.

6. Optional: ask "Calendar block these? (yes/no)". If yes, create Google Calendar events.

## Failure handling

Follow [error-rescue-map reference](../skills/error-rescue-map/reference.md) rows 15-17 for /today-specific failures (Notion 5xx cached fallback, empty Weekly Commitment, weekend skip).
