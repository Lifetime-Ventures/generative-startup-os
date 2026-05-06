# Generative Startup OS

> AI Chief of Staff for pre-team founders. Convert the meetings you're already having into structured OKRs, weekly commitments, and monthly investor updates — using only Claude.ai, Notion, and your AI meeting notes tool.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Status: Phase 1 Beta](https://img.shields.io/badge/Status-Phase%201%20Beta-orange.svg)](#status)

---

## What this is

A founder runs `/okr-set` in Claude.ai Chat. The OS reads their last 30 days of meetings (via Circleback), drafts 3 KRs and 5-7 weekly commitments grounded in what the founder actually said in pitches, and writes them to a Notion workspace duplicated 5 minutes ago.

From that point: `/sync-all` each morning structures new meetings into commitments. `/today` picks 1-3 actions from the week. `/weekly-roast` Friday afternoon catches drift and drafts next week. `/investor-update` month start generates a Google Doc draft from the same source.

Founder OKRs aren't missing — they're already in their meetings, just not structured. This OS structures them.

## Who it's for

Pre-team (solo, or 1-2 co-founder candidates) founders who:

- Already use an AI meeting notes tool (Circleback recommended; Granola supported via Zapier fallback path)
- Already use Notion or are willing to start
- Already have Claude.ai Pro or are willing to subscribe
- Recognize the Monday-morning "what am I doing this week?" drift as their actual pain

**Not for**: post-team companies (use a real PM tool), engineers building a startup who prefer code-first workflow, founders not using AI meeting notes (Phase 2 fallback path will address this).

## Why we're building it

Lifetime Ventures has watched the same pattern across 8 years of pre-team founder relationships: founders write OKRs, then don't open them for two weeks. They lose the thread. Existing solutions (Notion AI templates, 15Five, Reflexion, Notion 1-pagers) all fail in the same way: they ask the founder to write OKRs from a blank page.

Founders aren't missing OKRs. They're missing structure on the OKRs they're already articulating in investor pitches, customer PoC calls, and co-founder thesis conversations. AI meeting notes tools (Circleback, Granola) are recording all of it. We're building the bridge.

---

## Quickstart

Realistic time: **10-15 minutes** for Path 1 (Cowork), **15-20 minutes** for Path 2 (Code), **25-40 minutes** for Path 3 (Granola via Zapier).

### Prerequisites

- [ ] Claude.ai paid plan (Pro / Max / Team / Enterprise — Cowork plugin marketplace requires a paid plan)
- [ ] A Notion workspace **only you can access** (private workspace recommended; shared workspaces expose your investor updates and decisions to coworkers)
- [ ] Circleback account with at least 1 week of recorded meetings (or Granola if using Path 3)
- [ ] Google Workspace account (Gmail + Calendar)

### Path 1 — Cowork (recommended for primary users)

1. **Notion template duplicate** (30 sec) — *(Notion template URL will be added in the `claude/v0-notion-template` follow-up PR.)* Click the link, choose your private workspace, then "Duplicate".
2. **Open Claude Desktop → Cowork tab** → left sidebar **Customize → Browse plugins → Add from GitHub** (1 min)
3. Paste `Lifetime-Ventures/generative-startup-os` and click **Install** on `gsos`.
4. The plugin's `userConfig` will prompt you to confirm Connectors are installed. Open Claude Desktop **Settings → Connectors** and add:
   - Notion (Anthropic official)
   - Google Calendar (Anthropic official)
   - Circleback ([claude.com/connectors/circleback](https://claude.com/connectors/circleback))
   Then check the box and submit.
5. **Run `/gsos:okr-set`** in the Cowork tab (3-5 min) — drafts Mission, KRs, weekly commitments from your meetings; you yes/no each.
6. **Done** (T+10-15 min) — Mission draft, OKR Quarter 3 KRs, Weekly Commitment 5-7 items, Today's Focus row 1 in Notion.

### Path 2 — Claude Code (power users / contributors)

```bash
# 1. Add the marketplace
claude plugin marketplace add Lifetime-Ventures/generative-startup-os
# 2. Install the base plugin
claude plugin install gsos@generative-startup-os
# 3. (Optional) Install the Code-only extras (local Notion MCP, hooks)
claude plugin install gsos-power@generative-startup-os
/gsos-power:setup-mcp
# 4. Run the same skills
/gsos:okr-set
```

Connectors (Notion / Google Calendar / Circleback) are configured the same way as Path 1 — via Claude Desktop **Settings → Connectors**. Code reads them through the same Anthropic-cloud-mediated path.

### Path 3 — Granola via Zapier (only if you already pay for Zapier)

Same as Path 1, but step 4 swaps Circleback Connector for a Zapier setup:
- Zapier "Note Added to Granola Folder" trigger (folder: "GS-OS sync")
- Zapier "Create Notion Database Item" action (target: Meeting Notes DB)
- Add Notion + Google Calendar Connectors (skip Circleback)

Cost note: Granola Basic (free) + Zapier paid ($20/mo) ≈ Circleback direct ($20/mo). If you don't already pay for Zapier, Path 1 is cleaner.

### Migrating from the old paste-flow (pre-v1.0)

If you set up GSOS before v1.0 by pasting `prompts/system-prompt.md` into a Claude.ai Project's Custom Instructions, that flow is now deprecated. To migrate:

1. Install `gsos` via Path 1 (Cowork) or Path 2 (Code) above.
2. Verify `/gsos:okr-set` runs and writes to your existing Notion workspace (Notion DB schema is unchanged from v0).
3. Delete the Custom Instructions content from your old Claude.ai Project. The plugin is now canonical.

`prompts/system-prompt.md` is kept in this repo for one release and will be removed in v1.2.

---

## Skills (Phase 1)

Commands are namespaced by plugin (Anthropic Cowork/Code convention): `/<plugin>:<command>`. The 5 base commands ship in the `gsos` plugin; the optional `gsos-power` plugin (Code only) adds `/gsos-power:setup-mcp` and reserves `/gsos-power:peer-audit` and `/gsos-power:board-prep` for v1.1.

| Command | When | What it does |
|---|---|---|
| `/gsos:okr-set` | Initial setup, quarterly | Reads 30 days of meetings, drafts Mission + 3 KRs + 5-7 weekly commitments, founder yes/nos |
| `/gsos:sync-all` | Each morning | Imports new meetings, AI-extracts actions, dedupe-checks against open commitments, founder yes/nos |
| `/gsos:today` | Each morning | Picks 1-3 of this week's commitments based on KR priority, due, recent activity |
| `/gsos:weekly-roast` | Friday afternoon | Aggregates the week, identifies drift from Mission, drafts next week's 5 commitments |
| `/gsos:investor-update` | Month start | Compiles done commitments + decisions into a Google Doc draft for investor outreach |
| `/gsos-power:setup-mcp` | Once at install (Code only) | Installs the Notion local MCP server and configures Claude Code to use it |

`/gsos:sync-all` is **founder-triggered**, not automated. Calendar reminders prompt you to type the command; the AI does not run on a schedule on your behalf. We chose this over hosting servers and credentials. If you need true automation, that is on the Phase 2 backlog.

---

## What happens to your data

When you use Generative Startup OS, your meeting transcripts and OKR data flow through:

- **Anthropic Claude.ai** — your Project conversations and skill executions. Standard retention applies (we operate without Zero Data Retention to keep MCP connectors functional). [Anthropic Privacy Policy](https://www.anthropic.com/legal/privacy)
- **Circleback** — your meeting recordings, transcripts, and summaries. Stays in your Circleback account; Anthropic accesses via your individual OAuth token. [Circleback Privacy](https://circleback.ai/privacy)
- **Notion** — all OKR / Weekly / Today / Meeting / Updates / Decisions database content. Stored in your Notion workspace. [Notion Privacy](https://www.notion.so/privacy-policy)
- **Google Calendar / Drive / Workspace** — Calendar reminders and Google Doc drafts (for investor updates). [Google Privacy](https://policies.google.com/privacy)
- **Zapier** (Path 2 only) — your Granola API token and meeting note metadata flow through Zapier. [Zapier Privacy](https://zapier.com/privacy)

**Lifetime Ventures hosts nothing in this stack. We do not see your meeting transcripts, OKRs, or any other data.** The only telemetry signal we collect (opt-in) is a weekly poll of your Notion `last_modified_at` timestamps to count active usage during the Phase 1 hearing batch.

You can opt out at any time. You can also self-host all of this — the OS is open source.

---

## Notion data model

Your Notion workspace will contain:

- **Mission & Strategy** (page) — thesis, target user, wedge, 5-year vision
- **OKR Quarter** (DB) — current quarter Objective + 3-5 KRs, status, confidence, linked to commitments
- **Weekly Commitment** (DB) — 3-7 KR-linked commitments per week, source-tagged
- **Today's Focus** (DB) — 1-3 daily actions, KR-linked
- **Meeting Notes** (DB) — meetings synced from Circleback (or Granola+Zapier), AI-summarized
- **Investor Updates** (DB) — monthly draft archive
- **Decisions Log** (DB) — D-ID numbered decisions, alternatives, rationale, confidence

Schema details and column-level documentation in [`notion-templates/`](./notion-templates/).

If you customize the schema, prefix new columns with `_user_*` to avoid breaking skill behavior. The skills run a pre-flight schema validator and will abort with a clear message if a required column is missing or renamed.

---

## Compatibility

| Platform | Path 1 (Circleback) | Path 2 (Granola Zapier) |
|---|---|---|
| Mac (desktop) | ✓ | ✓ |
| Windows (desktop) | ✓ | ✗ (Granola is Mac/iOS only) |
| Linux (desktop) | ✓ (Claude.ai web) | ✗ |
| iPhone | partial (first install desktop recommended) | ✓ |
| iPad | partial (same as iPhone) | partial |
| Android | partial (Claude.ai mobile only; Granola unavailable) | ✗ |

First install recommended on desktop. Mobile use thereafter is supported for `/today` and lightweight workflows.

---

## Status

**Phase 1 Beta** (2026-05-02 foundation reset). 5-skill MVP shipping over the next 1-2 weeks. 5-founder hearing batch following. Pivot test: ≥3 of 5 founders install + use 3 weeks → Phase 2.

This repository was reset on 2026-05-02 from an earlier Claude Code-first design. The current direction is **Claude.ai-first**, optimized for non-technical founders. Earlier `/setup-mcp`, `/peer-audit`, `/board-prep`, etc. commands are not part of Phase 1 scope.

## Roadmap

- **Phase 1** (~2 weeks) — 5-skill MVP shipping
- **Phase 2** (post-hearing) — `/decision` skill, schema migration via `/migrate`, multi-language (English + Japanese), 2nd-person onboarding (`/onboard-me`), optional Web Dashboard layer
- **Phase 3+** (vision, not committed) — pre-team alignment OS expansion (co-founder thesis debate, async investor update sharing), generative artifact engine (founder voice memo → publishable thesis essay, pitch deck v0 draft)

## Contributing

This is OSS. We accept skill contributions, Notion template improvements, README PRs, and bug reports. The 6-DB schema is frozen for the first 90 days post-launch; schema-breaking PRs will be deferred to v2.

AI contributors (Claude Code, Codex, Gemini) — read [`AGENTS.md`](./AGENTS.md) before opening PRs. There are sanitization rules and a CI screening gate; both must be satisfied for merge.

### `future-plan/` — idea stock for v2 and Phase 2+

The [`future-plan/`](./future-plan/) directory holds non-authoritative design materials curated for the post-90-day schema unfreeze and Phase 2+ feature exploration. Contents are **not** part of v0.1.0 behavior and should be ignored by anyone running the OS today. Ideas land here from chat-thread design discussions via [`scripts/future-plan-add.sh`](./scripts/future-plan-add.sh) and graduate into live code via separate, focused PRs at unfreeze. See [`future-plan/README.md`](./future-plan/README.md) for the cherry-pick process and sunset criteria.

## License

MIT. See [LICENSE](./LICENSE).

## Origin

Built and maintained by [Lifetime Ventures](https://lifetime-ventures.com). The framework distills 8 years of pre-team founder pattern recognition from LtV's portfolio support work into a self-serve OSS form. LP, portfolio, and internal LtV data are NOT part of this repository — see [`AGENTS.md`](./AGENTS.md) for the data tier policy.

---

*Generative Startup OS — v0.1.0, 2026-05-02 foundation reset*
