---
name: error-rescue-map
description: Failure mode rescue logic for the 6 service classes (Notion / Anthropic / Circleback / Google / Zapier / local state). Single owner of error handling for all /gsos commands.
---

The complete failure-mode rescue table is in [reference.md](./reference.md) (full content migrated from `docs/error-rescue-map.md`). Single source for all /gsos commands.

When any /gsos command encounters a failure, follow the matching row from reference.md. Key principles:

- **Notion 5xx / 429**: retry 2x with 30s backoff. If still failing, friendly message + retry hint. Never partial-write.
- **Connector OAuth expired**: skill abort with 1-click recovery URL. Founder types `resume` (or `再開`) to retry after re-OAuth.
- **LLM context overflow**: truncate to most recent N items, disclose truncation to founder explicitly.
- **DB schema mismatch (founder renamed a column)**: abort with explicit "[column X] not found in [DB Y], either re-duplicate template or use `_user_*` prefix for custom columns".
- **Race condition (2-tab same skill)**: idempotency lock on Mission page metadata, abort 2nd invocation with "another /skill in progress, retry in 10 min".
- **Prompt injection in transcript**: see [transcript-handling skill](../transcript-handling/SKILL.md).

For the full table including Anthropic / Google / Zapier paths, read reference.md.
