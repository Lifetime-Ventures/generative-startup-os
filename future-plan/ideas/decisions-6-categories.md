# Idea: Decisions Type — 6 Categories with IP as Independent Category

## Status

- **Origin**: Multi-agent panel discussion on Notion DB redesign (10 rounds, May 2026)
- **Maturity**: Detailed design — ready for v2 PR proposal once schema unfreeze
- **Conflict with v0.1.0**: Minor. Adds 1 SELECT property to existing Decisions Log DB. Existing rows backfill as `Other / Uncategorized`.

## Problem in v0.1.0 schema

The v0.1.0 Decisions Log DB has `decision`, `alternatives_considered`, `rationale`, `confidence`, `impact_KR` — but no **type** field.

Decision types in deep-tech founders' lives are not uniform. They include:
- **Strategic** decisions (pivot, market choice, capital strategy)
- **People** decisions (hire, fire, org structure)
- **Technical** decisions (architecture, framework choice, build vs buy)
- **IP** decisions (file patent, keep trade secret, license out, open-source)
- **Partnership** decisions (strategic alliance, JV, MOU)
- **Governance** decisions (board composition, culture choice)

In particular, **IP decisions are critical for deep-tech but invisible if categorized as "Technical" or "Strategic"**. A founder reviewing 6 months of IP decisions in isolation is a high-value reflection — they may notice patterns ("we keep choosing trade secret over patent — is that consistent with our moat strategy?").

## Proposed change

Add 1 property to Decisions Log DB:

| Property | Type | Required | Notes |
|---|---|---|---|
| `decision_type` | select | yes (default to "Other" if unsure) | One of 6 categories below |

Select options:
- `Strategic` (blue) — pivot, market, capital, business model
- `People` (purple) — hiring, firing, org structure, comp
- `Technical` (orange) — architecture, framework, build/buy, technical debt
- `IP` (red) — patent filing, trade secret, license, open-source, defensive publication
- `Partnership` (green) — strategic alliance, JV, MOU, channel partner
- `Governance` (gray) — board, culture, compliance, ethics

`Other` could be a 7th option for un-categorizable decisions, but ideally rare.

## Trade-offs

**Gains**:
- IP decisions become first-class, queryable, comparable
- 6-month review can surface patterns (e.g., "70% of my decisions are technical, 0% strategic — am I avoiding the hard ones?")
- `/investor-update` can summarize "this month: 2 strategic decisions, 1 IP decision" — investors see decision diversity
- Future skill ideas: `/decisions-by-type` to filter, `/ip-review` for quarterly IP audit

**Costs**:
- Adds 1 SELECT field founders must remember to fill
- Some decisions span types (e.g., "open-source our library" is IP + Strategic) — single SELECT forces a choice
- Slight risk of category bloat if types proliferate post-launch

## v2 PR sketch

Files that would change:
- `notion-templates/README.md` — Decisions Log table gains `decision_type` row + the 6-category select definition
- `prompts/system-prompt.md`:
  - `/okr-set` initial flow gains 1 line about decision typing (just informational, not blocking)
  - Future `/decision` skill (Phase 2) would prompt for type explicitly
  - `/investor-update` can summarize by type
- New schema_version: `2`. Migration step:
  - Add `decision_type` SELECT with the 6 options
  - Backfill existing rows as `Other` (founder can re-categorize manually over time)

## Open questions for hearing batch

- Is 6 the right number? Founders may find 4 (Strategic / People / Technical / Other) easier to use.
- Should `IP` really be independent, or is "deep-tech founders treat IP as part of Strategic"?
- Multi-select vs single-select: would founders prefer to tag a decision with multiple types (e.g., "Strategic" + "IP" for an open-source decision)?

Hearing test: ask founders to categorize 5 of their last 10 decisions retrospectively. If categorization is fast (<30s per decision) and they choose IP for at least 1, the category earns its place.
