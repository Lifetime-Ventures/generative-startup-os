# gsos

AI Chief of Staff for pre-team founders. Convert your meetings into structured OKRs, weekly commitments, and monthly investor updates.

This is the primary plugin in the [Generative Startup OS marketplace](https://github.com/Lifetime-Ventures/generative-startup-os). It works in **Claude Cowork** (Claude Desktop) and **Claude Code**. For Code-only power-user extras (MCP setup automation), also install [`gsos-power`](../gsos-power).

## What this plugin does

5 commands map to a founder's weekly cadence:

| Command | When | What it does |
|---|---|---|
| `/gsos:okr-set` | Initial setup, quarterly | Reads 30 days of meetings, drafts Mission + 3 KRs + 5-7 weekly commitments, founder yes/nos |
| `/gsos:sync-all` | Each morning | Imports new meetings, AI-extracts actions, dedupe-checks against open commitments, founder yes/nos |
| `/gsos:today` | Each morning | Picks 1-3 of this week's commitments based on KR priority, due, recent activity |
| `/gsos:weekly-roast` | Friday afternoon | Aggregates the week, identifies drift from Mission, drafts next week's 5 commitments |
| `/gsos:investor-update` | Month start | Compiles done commitments + decisions into a Google Doc draft for investor outreach |

## Install

### Claude Cowork (recommended for primary users)

1. Open Claude Desktop, switch to the **Cowork** tab.
2. Left sidebar → **Customize** → **Browse plugins** → **Add from GitHub**.
3. Paste: `Lifetime-Ventures/generative-startup-os`
4. Install **gsos**.
5. The plugin's `userConfig` will prompt you to confirm Connectors are installed (Notion / Google Calendar / Circleback). Install them via Claude Desktop **Settings → Connectors** before checking the box.
6. Type `/gsos:okr-set` to begin.

### Claude Code (for power users / contributors)

```bash
claude plugin marketplace add Lifetime-Ventures/generative-startup-os
claude plugin install gsos@generative-startup-os
```

For MCP-backed local execution (Notion local API, hooks for connector pre-flight):

```bash
claude plugin install gsos-power@generative-startup-os
/gsos-power:setup-mcp
```

## Notion workspace requirement

GSOS writes to a Notion workspace duplicated from the [GSOS Notion template](../notion-templates). Duplicate the template into a private workspace before running `/gsos:okr-set`. The first skill execution validates the schema and aborts with a friendly error if it cannot find the expected DBs.

## Connectors required

Three Anthropic Connectors must be enabled before any `/gsos:*` command:

- **Notion** (Anthropic official)
- **Google Calendar** (Anthropic official)
- **Circleback** ([claude.com/connectors/circleback](https://claude.com/connectors/circleback))

GSOS pre-flights every command — it aborts with a 1-click recovery URL if any Connector OAuth has expired.

## Privacy

GSOS lives in your Anthropic / Notion / Google / Circleback accounts. Lifetime Ventures hosts nothing in this stack and does not see your meeting transcripts, OKRs, or any other data. See the [repository README](../README.md) "What happens to your data" section for the full data flow.

## Operating principles

GSOS follows 5 non-negotiable principles defined in [CLAUDE.md](../CLAUDE.md):

1. Never write OKRs from a blank page.
2. Yes/no over interrogation.
3. Founder-triggered, not automated.
4. Notion is the source of truth.
5. Pre-flight every skill.

## Skill structure

This plugin's `skills/` directory contains operating-principle reference material that the 5 commands link to. The actual workflow logic is in `commands/`. Commands are LLM-invoked entry points; skills are knowledge bases that commands import via markdown link.

## License

MIT — see [../LICENSE](../LICENSE).
