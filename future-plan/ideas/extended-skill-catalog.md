# Idea: Extended Skill Catalog Beyond v0.1.0's 5 Skills

## Status

- **Origin**: Pre-reset design exploration (Claude Code-first hypothesis, April 2026)
- **Maturity**: Aspirational catalog — most are sketches, a few are detailed
- **Conflict with v0.1.0**: Major if proposed as Phase 1 expansion. None if treated as Phase 2+ candidate pool.

## Problem in v0.1.0 ship

v0.1.0 ships 5 skills: `/okr-set`, `/sync-all`, `/today`, `/weekly-roast`, `/investor-update`, plus utilities `/help` and `/migrate`.

This is the **right Phase 1 scope** — minimum viable skill set proven to address Monday-morning drift. But pre-reset design explored 18 skills covering scenarios beyond pre-team founders. Some of these are worth keeping in mind for Phase 2+ once the 5-skill MVP is validated.

## Aspirational skill catalog (Phase 2+ candidates)

The following 13 skills were specified during pre-reset Claude Code-first design. Each is a **candidate for Phase 2+ consideration**, not a commitment.

Importantly, several of these may not survive the Claude.ai-first reset. The Claude Code-first context assumed founders comfortable with terminal MCP, multiple model invocations, and persistent local state — none of which v0.1.0 assumes.

### Candidates that fit Claude.ai-first hypothesis (likely Phase 2)

1. **`/quick-board`** — 3-agent micro-meeting (10 min). Founder says "I'm stuck on X", Claude orchestrates 3 personas (e.g., Skeptical Investor / Engineering Lead / Customer Voice) to give 3 perspectives in series. Output is structured "What I heard / What I'd do next". This is the **strongest Phase 2 candidate** — fits Claude.ai-first, doesn't require new DBs, addresses real founder loneliness.

2. **`/decision`** — explicitly walks the founder through writing a Decisions Log entry. Currently founders write to Decisions Log manually; this skill structures the writing. Already on Phase 2 roadmap per main README.

3. **`/onboard-me`** — 2nd-person onboarding flow. New co-founder candidate runs this skill in shared Project to get up to speed on Mission + active OKRs + recent Decisions. Already on Phase 2 roadmap per main README.

### Candidates that need rework for Claude.ai-first

4. **`/irm-briefing`** — pre-investor-meeting briefing. Read past N investor conversations + recent Decisions + KR progress, output a 1-page brief. Useful, but should re-read current investor-update skill to avoid redundancy.

5. **`/moat-capture`** — guided write of competitive moat narrative. Founders often can't articulate moat clearly; structured questions help. Pre-reset design assumed a `Moat Strategy` page that doesn't exist in v0.1.0.

6. **`/peer-audit`** — co-founder reviews each other's weekly commitments. Pre-reset assumed multi-founder workspace; v0.1.0 is solo-founder focused.

7. **`/board-prep`** — pre-board-meeting deck draft. Likely too heavy for solo founders; defer until Phase 3+.

### Candidates likely to be deprioritized

8. **`/cowork-dispatch`** — Claude Code-specific automation dispatch. Doesn't apply to Claude.ai-first.

9. **`/sync-mcp`** / **`/setup-mcp`** — MCP setup helpers. v0.1.0 uses Anthropic-official connectors only (no DIY MCP).

10. **`/team-prr`**, **`/narrative-check`**, **`/series-a-check`**, **`/culture-audit`**, **`/monthly-gemini`**, **`/update-crm`** — team-stage and Series-A-stage skills. All deferred to Phase 3+ per current README roadmap.

## Trade-offs of skill expansion

**Gains from selective Phase 2 additions** (e.g., `/quick-board` + `/decision` + `/onboard-me`):
- `/quick-board` addresses #1 founder pain not solved by current 5: "I'm stuck and have no one to think with"
- `/decision` makes Decisions Log entries more consistent (currently manual write quality varies)
- `/onboard-me` enables co-founder onboarding without 1:1 verbal handoff

**Costs of expansion**:
- Each skill adds system prompt tokens (current `prompts/system-prompt.md` is already substantial)
- Skills must each pass pre-flight checks → more connector failure paths
- Skill discovery becomes harder (`/help` already lists 7; 10+ would feel cluttered)

## v2 PR sketch (most-likely Phase 2 path)

Phase 2 addition order (recommendation):
1. `/quick-board` — addresses unique unmet need; no schema impact
2. `/decision` — already roadmap'd; aligns with existing Decisions Log
3. `/onboard-me` — already roadmap'd; aligns with future multi-founder direction

Each is its own PR. Each updates `prompts/system-prompt.md` skill catalog section + `docs/chat-transcripts.md` + `docs/error-rescue-map.md` per the pattern v0.1.0 established.

## Open questions for hearing batch

- Do hearing-batch founders ask "I wish there was a skill for X"? Track those requests verbatim — they're the input to Phase 2 skill prioritization.
- Specifically: do founders self-report "I'm stuck and don't know who to talk to" moments? (informs `/quick-board` priority)
- Does anyone bring a co-founder candidate during the 3-week hearing window? (informs `/onboard-me` priority)
