---
name: help
description: List all GSOS skills with when-to-use guidance. Pure-output command (no connector calls, no Notion writes). Run when the founder forgets a skill name or wants to see what is available.
disable-model-invocation: false
---

You are running `/gsos:help`. This is a pure-output command. Skip pre-flight (no connectors needed). Apply [tone-and-style](../skills/tone-and-style/SKILL.md) for the founder's language.

## Output

Print exactly the following catalog. Match the founder's language (Japanese-OK if they have been speaking Japanese; switch to match).

```text
Generative Startup OS — skill catalog

Daily / weekly cadence:
  /gsos:sync-all       — daily morning. Ingest yesterday's meetings into Notion.
  /gsos:today          — daily morning. Pick 1-3 actions from this week's commitments.
  /gsos:weekly-roast   — Friday afternoon. Reflect on the week, draft next week.

Setup / monthly:
  /gsos:okr-set        — initial setup or quarterly rollover. Drafts Mission + KRs from your meetings.
  /gsos:investor-update— month start. Generates a Google Doc draft for LPs from done commitments.

Discovery:
  /gsos:help           — this message.

Power user (Claude Code, optional):
  /gsos-power:setup-mcp — install the Notion local MCP server for offline-friendly reads.
```

Then ask: "Which would you like to run?"

If the founder names one of the catalog entries, suggest invoking that skill next. If the founder describes a goal that matches one of the skills, recommend the matching skill with one sentence on why. If the founder describes a goal that does not map to any skill, say so honestly and offer to capture the request as a TODO in their Notion Mission page metadata.

## Non-skill input handling

If the founder types a slash command that is not in the catalog (typo, unfamiliar skill name, or `/migrate` or another retired skill), respond with:

```text
"{input}" is not a GSOS skill in this version. The available skills are listed below. Want me to run one of them?
```

Then re-print the catalog above.

## Notes

- This command does NOT write to Notion or call any connector. It is a chat-only response.
- The schema-migration command `/migrate` is **planned for v1.1** (deferred from v0). If a founder needs schema migration today, suggest re-duplicating the Notion template and re-running `/gsos:okr-set`.
- Power-user extras under `/gsos-power:*` are only available to founders who have installed the `gsos-power` plugin via Claude Code. Mention them only if context indicates the founder is in Claude Code (otherwise stick to the `/gsos:*` core five).
