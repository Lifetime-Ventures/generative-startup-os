# Idea: Organizations DB with Deep-Tech Stage Vocabulary

## Status

- **Origin**: Multi-agent panel discussion on Notion DB redesign (10 rounds, May 2026)
- **Maturity**: Sketch — needs new DB design, not just schema field
- **Conflict with v0.1.0**: Major if proposed as a 7th DB. Minor if kept as a Phase 2+ extension that founders can opt into.

## Problem in v0.1.0 schema

v0.1.0 has a 6-DB schema. **There is no Organizations / CRM-equivalent DB.** Investor outreach tracking, customer pipeline, partner tracking — all of these currently live as ad-hoc rich-text in Meeting Notes or Investor Updates.

For founders managing 10+ active investor conversations and 5+ customer PoCs simultaneously, this becomes hard to query: "which investors did I last meet?", "which customers are stalled?", "which partners haven't replied in 2 weeks?".

A typical CRM solves this with a `Stage` field on a `Contact / Organization` entity. But typical CRM `Stage` vocabulary is **SaaS Sales Funnel** terms:
- `Lead` → `Qualified` → `Active` → `Closed-Won` / `Closed-Lost`

This vocabulary is **fundamentally wrong for deep-tech B2B** because:
- Deep-tech sales cycles are 3-6 months minimum (not days)
- "Qualified" implies a quick yes/no decision; deep-tech requires technical PoC validation
- "Closed" implies a single transaction event; deep-tech often has long pilot → contract phases
- "Lost" loses signal — deep-tech walks-away often have specific recoverable reasons

## Proposed change

Add an Organizations DB with deep-tech-specific Stage vocabulary:

```
Organizations DB
├── name (title)
├── category (select): Customer / Investor / Partner / Vendor / Academic / Government / Competitor
├── stage (select): the 5-stage deep-tech funnel below
├── pain_score (number 1-10) — for Customer category
├── investor_sentiment (number 1-10) — for Investor category
├── walked_away_reason (rich text) — when stage = "Walked Away"
├── linked_meetings (relation → Meeting Notes)
├── linked_decisions (relation → Decisions Log)
├── notes (rich text)
├── last_contact (date)
├── schema_version, created_by_skill, last_modified_at
```

**Stage select options** (deep-tech vocabulary):

| Stage | English / Japanese | What it means |
|---|---|---|
| 1 | `First Contact / 初接触` | Initial outreach made, no substantive response yet |
| 2 | `Pain Validated / 課題確認済` | Confirmed they have the pain; pain_score ≥ 5 documented |
| 3 | `PoC In Progress / PoC進行中` | Technical pilot underway, agreed scope and timeline |
| 4 | `Contracted / 契約締結` | Formal commercial agreement signed (or term sheet for investors) |
| 5 | `Walked Away / 離脱` | No further engagement, with specific recoverable or terminal reason in `walked_away_reason` |

The vocabulary explicitly **does not** include:
- "Lead" (too sales-y; first contact is not yet a lead)
- "Qualified" (implied by Pain Validated but more honest)
- "Closed-Won/Lost" (binary outcomes don't capture pilot phase)
- "Negotiating" (collapsed into PoC In Progress)

## Trade-offs

**Gains**:
- 7th DB unlocks pipeline querying (which deep-tech founders need around investor outreach #20+)
- Vocabulary fits founder mental model for the first time
- `walked_away_reason` becomes a quarterly-review goldmine ("why have 3 customers walked away citing pricing? maybe pricing strategy is wrong")

**Costs**:
- 7th DB = +1 cognitive load. Founders may not maintain it consistently.
- Adding a DB after launch is a major schema migration (`/migrate` v1→v2 with new DB creation)
- Some founders have existing CRMs (Salesforce, HubSpot, Notion own CRM) — adding this becomes redundant for them
- 90-day schema freeze (per current README) means this can't ship until ~August 2026 minimum

## v2 PR sketch

Two paths:

### Path A: 7th DB (full integration)
- New DB created by `/migrate` v1→v2
- All 5 existing DBs gain optional `linked_organization` relation pointing to this new DB
- `/sync-all` AI extracts organization references from meeting transcripts and links automatically
- `/investor-update` can pull from Organizations DB for "investor sentiment" trends

### Path B: Optional extension (recommended for first ship)
- New DB available as a separate Notion template duplicate URL (e.g., `gsos-organizations-extension`)
- Founders who want CRM functionality opt in by duplicating
- `/sync-all` checks for the DB's existence and uses it if present, ignores if absent
- Schema migration is unnecessary because the DB is opt-in

Path B is lower-risk for v0.1.0 hearing-batch users who haven't asked for this.

## Open questions for hearing batch

- How many founders are tracking 10+ active investor/customer conversations? (informs DB necessity)
- Of those, how many already use a separate CRM (Salesforce, HubSpot, etc.)? (informs whether to integrate or replace)
- Does the deep-tech 5-stage vocabulary feel natural? Is "Pain Validated" or "Walked Away" jarring?

Hearing test: show 3 founders the 5-stage vocabulary and ask "would you prefer this or `Lead/Qualified/Active/Closed-Won/Closed-Lost`?" If 2+ pick the deep-tech version, the vocabulary lands.
