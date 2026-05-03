# Idea: Inbox DB with Channel + Source Type 2-axis Source Tracking

## Status

- **Origin**: Multi-agent panel discussion on Notion DB redesign (10 rounds, May 2026)
- **Maturity**: Sketch — depends on whether v2 introduces an Inbox concept at all
- **Conflict with v0.1.0**: Major. v0.1.0 has no Inbox DB; this would add one.

## Problem in v0.1.0 schema

v0.1.0 has Meeting Notes (auto-synced from Circleback) but **no general-purpose Inbox** for:
- Email threads with investors / customers (currently lost in Gmail)
- Slack messages mentioning the founder (currently lost in Slack)
- Voice memos the founder records on the go (currently lost in iCloud / Dropbox)
- Web articles the founder clipped (currently lost in browser bookmarks)
- Quick-capture thoughts (currently lost in scratch notes)

The result: information that should inform Decisions and Tasks gets stuck in source apps and never gets structured.

This is intentionally out-of-scope for Phase 1 (which focuses on the meeting-to-OKR loop), but Phase 2+ may want it.

## Proposed change

Add an Inbox DB with **2-axis source tracking**:

```
Inbox DB
├── subject_or_snippet (title)
├── channel (select)        — TECHNICAL source (where it came from)
├── source_type (select)    — SEMANTIC source (what kind of info it is)
├── sender (rich text)
├── direct_mention (checkbox)
├── okr_relevance (number 1-10) — AI-scored
├── received_at (date)
├── status (select)         — Unread / Triaged / Archived
├── ai_summary (rich text)  — AI-generated 1-2 sentence summary
├── original_link (url)     — back to source app
├── body (rich text)        — full content if appropriate
├── triaged_to_decision (relation → Decisions Log)
├── triaged_to_task (relation → Weekly Commitment)
├── triaged_to_memo (relation → Meeting Notes)
└── schema_version, created_by_skill, last_modified_at
```

### Why 2-axis source tracking?

A single `source` field conflates two different questions:
- "Where did this come from technically?" (Gmail / Slack / VoiceMemo / Web / Manual)
- "What kind of info is it?" (Investor / Customer / Hiring / Industry / Research / Internal)

Filtering on either alone is useful. Filtering on both intersected ("show me Investor info from Slack this week") is more useful.

**Channel select options** (technical source):
- `Gmail / メール` (red)
- `Slack` (purple)
- `VoiceMemo / 音声メモ` (blue)
- `QuickCapture / Quick Capture` (green)
- `WebClip / Webクリップ` (orange)
- `RSS / RSS` (yellow)
- `Manual / 手動` (gray)
- `Other / その他` (gray)

**Source Type select options** (semantic source):
- `Investor / 投資家` (blue)
- `Customer / 顧客` (green)
- `Hiring / 採用` (purple)
- `Partner / パートナー` (orange)
- `Mentor / メンター` (red)
- `Industry / 業界` (yellow)
- `Research / 研究` (orange)
- `Internal / 内部` (gray)
- `Other / その他` (gray)

## Trade-offs

**Gains**:
- Inbox unification: one place to triage all incoming founder-relevant info
- 2-axis filter unlocks sophisticated queries
- AI summarization at ingest time means founder spends 5min/day triaging instead of 30min/day reading source apps
- Triaged_to_* relations turn ephemeral info into structured Decisions / Tasks

**Costs**:
- Inbox is a major DB (large row volume; could overshadow other DBs)
- Requires automation infrastructure (Make.com / Zapier / iPaaS) to feed it — Phase 1's "founder-triggered, no automation" principle is broken
- 2-axis (Channel + Source Type) is more cognitive load than 1-axis
- Risk of inbox-bloat: founders defer triage and Inbox becomes another graveyard

## v2 PR sketch

Inbox is a Phase 2+ feature, not a v2 schema migration target. Would require:

- New DB created by `/migrate` v2→v3 (after Inbox-using skills exist)
- New skill: `/triage` — AI-assisted Inbox processing, founder yes/nos triaged_to_* assignments
- New skill: `/sync-inbox` — pulls from Channel-specific connectors (Gmail / Slack), classifies Source Type, scores OKR relevance
- Make.com / Zapier blueprints in `automation-stack-options/` (this directory) for the iPaaS path

The 2-axis source tracking is the **specific design recommendation** — even if Inbox itself is uncertain, the 2-axis principle is the contribution.

## Open questions for hearing batch

- Do hearing-batch founders feel Inbox unification pain? (If 2+ of 5 say "I lose investor emails", inbox is validated)
- Would they accept iPaaS automation (Make/Zapier monthly fee) for Inbox to work? (informs Phase 2 cost model)
- Channel vs Source Type: is the 2-axis distinction natural or confusing?

## Related ideas

- `automation-stack-options/` (this future-plan directory): Make.com vs Zapier vs n8n trade-offs for the iPaaS layer
- `mobile-patterns/`: voice memo → Inbox flow
