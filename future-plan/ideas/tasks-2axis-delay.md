# Idea: Tasks 2-axis Delay Tracking (Self-caused vs External)

## Status

- **Origin**: Multi-agent panel discussion on Notion DB redesign (10 rounds, May 2026)
- **Maturity**: Detailed design — ready for v2 PR proposal once schema unfreeze (90 days post-launch)
- **Conflict with v0.1.0**: None. Additive change to Weekly Commitment DB.

## Problem in v0.1.0 schema

The v0.1.0 Weekly Commitment DB tracks `status: open / done / dropped` but does not record **why** a commitment slipped to `done` past its `due` date or got `dropped`.

For deep-tech founders, slip causes are not uniform:
- **Self-caused delay**: founder underestimated effort, got distracted, prioritized something else
- **External delay**: experiment equipment failure, reagent lot issue, co-investigator unavailable, regulatory body slow response

A future PRR-style metric (Promise Reliability Ratio, mentioned in pre-reset drafts) would conflate these two causes if the DB doesn't distinguish. This penalizes founders for things they couldn't control, especially in deep tech where external dependencies are a significant fraction of the work.

## Proposed change

Add 2 properties to Weekly Commitment DB:

| Property | Type | Default | Notes |
|---|---|---|---|
| `self_caused_delay` | number | 0 | Increment by 1 each time founder pushes the `due` date by their own choice |
| `external_delay` | number | 0 | Increment by 1 each time `due` slips due to external factor (with optional `delay_reason` rich text) |

Optional companion property:

| `delay_reason` | rich text | empty | Free-text reason when `external_delay` is bumped |

Skill behavior changes:
- `/weekly-roast` — when reflecting on slipped commitments, asks the founder "self-caused or external?" for each not-done item with a past due date, increments the appropriate counter.
- A future Reliability Index formula could be `pow(0.5, prop("self_caused_delay"))` — only self-caused delays compound the penalty.

## Trade-offs

**Gains**:
- Honest signal about founder reliability (separates avoidable from unavoidable)
- Deep-tech-specific reality reflected in the schema
- `external_delay` patterns over time become a leading indicator for systemic risks (e.g., 5+ external delays from same vendor → switch vendor)

**Costs**:
- Adds 2-3 properties to a previously simple DB
- `/weekly-roast` becomes 1 question longer per slipped item
- Founders may game the binary (claiming external when self-caused) — partially mitigated by `delay_reason` requirement for external

## v2 PR sketch

Files that would change:
- `prompts/system-prompt.md` — `/weekly-roast` skill section adds the per-item delay-cause prompt
- `notion-templates/README.md` — Weekly Commitment table gains 2-3 rows
- New schema_version: `2`. Migration step in `/migrate`:
  - Add `self_caused_delay` (default 0)
  - Add `external_delay` (default 0)
  - Add `delay_reason` (default empty)
  - Backfill: leave 0 (no historical inference attempted)
- `docs/error-rescue-map.md` — no new failure modes; behaves as graceful additive

## Open questions for hearing batch

- Do founders find the self/external distinction natural, or annoying?
- What fraction of slips do founders attribute to external causes? (informs whether the binary is meaningful)
- Should there be a 3rd category (e.g., "scope grew, didn't slip"), or is binary enough?

If 3+ of 5 hearing founders say "this would be useful" + at least 1 self-reports external delays in their actual workflow, this idea graduates from `future-plan/ideas/` to a v2 PR.
