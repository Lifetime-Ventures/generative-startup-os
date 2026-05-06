---
name: sync-all
description: Daily morning, founder-triggered. Reads new meetings from the last 24 hours, AI-extracts action items, pairwise dedupe against existing open Weekly Commitments, founder yes/nos new candidates.
disable-model-invocation: false
---

You are running `/gsos:sync-all`. Apply [core operating principles](../skills/core-operating-principles/SKILL.md), [transcript-handling](../skills/transcript-handling/SKILL.md), and [tone](../skills/tone-and-style/SKILL.md).

This skill is **founder-triggered**, not automated cron. Calendar reminder is just a ping that prompts the founder to type the command.

## Pre-flight

1. Verify Notion + Circleback connectors responsive (or Notion only if `meeting_source: granola_zapier`).
2. Apply [DB schema validator](../skills/notion-data-model/SKILL.md) on Meeting Notes + Weekly Commitment DBs.

## Workflow

1. **Path detection**: read Mission page metadata `meeting_source` field.
   - `circleback`: use Circleback connector directly.
   - `granola_zapier`: read Notion Meeting Notes DB rows where `last_modified_at >= 24h ago` (Zapier writes raw rows; the skill AI-processes them).

2. **Circleback path**: `circleback.list_meetings(since=24h ago)`. For each, `get_transcript`. Write to Notion Meeting Notes DB with summary + AI-classified type + related_KR. Wrap transcript in DATA delimiters before extracting.

3. **AI-extract action items** from each meeting's transcript. Use the [transcript-handling skill's](../skills/transcript-handling/SKILL.md) action extraction prompt.

4. **Pairwise dedupe** between extracted candidates and existing open Weekly Commitments. Use the [transcript-handling skill's](../skills/transcript-handling/SKILL.md) dedupe prompt.

5. DUPLICATE → skip + add `source_meeting` relation to existing row. AMBIGUOUS → ask founder yes/no in chat. DISTINCT → add to candidate list.

6. Show founder candidate list. Yes/no per item. Add accepted to Weekly Commitment DB with `source=from_meeting` and `source_meeting` relation set. Every row includes `schema_version: 1` and `created_by_skill: /gsos:sync-all`.

## Failure handling

Follow [error-rescue-map reference](../skills/error-rescue-map/reference.md) rows 10-14 for /sync-all-specific failures (transcript missing, dedupe LLM 429, partial Notion write, Granola Zapier 0 rows, prompt injection).
