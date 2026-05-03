# Versioning & Update Propagation

How the framework evolves and how founders running an installed copy get the changes.

## TL;DR for founders

When the upstream framework releases a new version:

1. **Watch this repo** (GitHub → "Watch" → "Releases only") to get notified
2. On notification, open `prompts/system-prompt.md` at the latest commit
3. Copy the content between the horizontal rules and replace your Claude.ai Project's Custom Instructions
4. If the release notes mention a schema change, type `/migrate` in your Project chat (one-shot upgrade)
5. Your data in Notion is untouched throughout — only the OS behavior updates

This file walks through that flow in detail and the framework-side machinery behind it.

---

## Versioning model

The framework uses semver-flavored versioning, but adapted for an OSS skill catalog rather than a code library:

- **MAJOR** — schema-breaking. Existing founders' Notion DBs need migration via `/migrate`. Released only with explicit founder warning + migration path.
- **MINOR** — new skills, new schema columns (additive only — backward compatible). Existing founders can upgrade at their leisure.
- **PATCH** — system prompt wording fixes, error message tweaks, doc clarifications. No founder action required (re-paste system prompt is optional, captures wording improvements).

Phase 1 ships `v0.1.0` (`schema_version: 1` for the Notion DB, prompt revision MINOR=1 PATCH=0).

`v0.x` is the explicit pre-launch range. Founder workspaces installed during v0.x may need manual migration if v1.0 introduces breaking schema changes that `/migrate` can't handle automatically. We commit to a stable `v1.0` schema for at least 90 days after the official launch.

## Where the version lives

Two source-of-truth markers:

- **Framework version**: written in `CHANGELOG.md` (when re-introduced in a follow-up PR — it was deleted in the foundation reset and gets a fresh start once Phase 1 ships) and in `prompts/system-prompt.md` header.
- **Schema version**: written as `schema_version` on the founder's Notion Mission page metadata (set during `/okr-set` initial setup, bumped by `/migrate`).

These can drift legitimately:
- Framework v0.1.0 → v0.1.1 (PATCH wording fix) → schema_version stays at `1`. Founder re-pastes system prompt; no `/migrate` needed.
- Framework v0.1.0 → v0.2.0 (MINOR new skill, no schema change) → schema_version stays at `1`. Founder re-pastes.
- Framework v0.2.0 → v0.3.0 (MINOR with new column added to Weekly Commitment DB) → schema bumps to `v2`. Founder re-pastes + runs `/migrate`.

## How updates reach founders

There are 3 distribution channels, ordered by founder friction (least → most):

### Channel 1 — Anthropic marketplace plugin (status: pending Anthropic policy resolution)

**Status as of 2026-05-03**: Anthropic Custom Connector marketplace exists (Circleback is published there, used by this framework's Path 1). Whether this OSS framework can publish a self-installable Project template to the same marketplace is a question for Phase 0 B1 (`SETUP-GUIDE.md` in the v0-reset-handoff staging area).

**If marketplace publishing is supported**:
- Framework versions are tagged + pushed to Anthropic
- Founders see "Update available" inline in Claude.ai
- One-click apply, system prompt updates automatically
- For schema-breaking updates, the marketplace install hook prompts the founder to run `/migrate` after the prompt update

**If marketplace publishing is not supported**:
- Fall back to Channel 2 (manual re-paste).

This decision is tracked in the repo issue tracker (when opened) and deferred from Phase 1 — the framework works without it.

### Channel 2 — Manual re-paste from GitHub (always works)

The fallback that never breaks:

1. Founder watches the repo's Releases ("Watch" → "Custom" → "Releases")
2. Release notification arrives via GitHub email or notification feed
3. Founder opens `prompts/system-prompt.md` at the release tag (or `main`)
4. Copy content between the two horizontal rules (the marker text says: "End of Custom Instructions content. Do not paste anything below this line.")
5. Open Claude.ai → Generative Startup OS Project → Settings → Custom Instructions → paste, replacing existing content → Save
6. If release notes mention schema change: type `/migrate` in chat → wait for "Migration complete" → done

Time per update: 2-3 minutes.

This channel is documented in `prompts/README.md`. Every release note explicitly says "to update: re-paste system-prompt.md and (if schema changed) run /migrate".

### Channel 3 — Self-check skill (Phase 2 expansion)

For founders who don't watch the repo and don't want to remember to check, a `/check-for-updates` skill is on the Phase 2 roadmap. The skill would:

1. Fetch a `versions.json` manifest from `https://raw.githubusercontent.com/Lifetime-Ventures/generative-startup-os/main/versions.json` (a stable URL with the current framework version + schema version + brief release notes)
2. Compare against the system prompt's embedded version constant
3. If newer version exists, show the founder a 3-line summary + the diff link + the upgrade procedure
4. Founder runs the upgrade manually (Channel 2)

The skill is read-only — it doesn't auto-upgrade. Founders stay in control.

## What `/migrate` does and doesn't do

**Does**: schema upgrades on the founder's existing Notion DBs. Adds columns. Bumps `schema_version`. Idempotent (safe to re-run).

**Doesn't**:
- Replace the system prompt (that's Channel 1 / Channel 2)
- Touch founder content (Mission narrative, OKRs, weekly commitments, meeting notes — all stay exactly as the founder wrote them)
- Run automatically (founder triggers via `/migrate` keyword)
- Migrate across MAJOR version boundaries automatically (those will require manual founder review per release notes)

See `prompts/system-prompt.md` `/migrate` section for the full skill spec.

## What never changes regardless of version

- **Your data ownership**: meeting transcripts, Notion content, Google Doc drafts — all live in your accounts. No update can touch what you wrote.
- **Connector OAuth**: Notion / Calendar / Circleback / Drive auths persist across system prompt updates. Re-OAuth only if Anthropic or the connector vendor invalidates the token.
- **Skill names**: `/okr-set`, `/sync-all`, `/today`, `/weekly-roast`, `/investor-update`, `/help`, `/migrate` are stable. New skills may be added; existing skill names will not be renamed without a 90-day deprecation window with both names accepted.

## Release cadence

No fixed cadence. Releases ship when:
- A bug fix is ready (PATCH within days)
- A new skill or feature is ready (MINOR — typically every 2-4 weeks during active development)
- A schema change passes hearing batch + `/migrate` testing (MAJOR — every few months)

The framework targets "founder churn-friendly" updates: a founder who hasn't updated in 3 months should still be able to use their installed version, plus catch up to latest with a single re-paste + at most one `/migrate` invocation.

## Phase 0 B1 status (Anthropic marketplace publish)

Per the v0 design (private LtV staging notes), Phase 0 B1 was an open question on whether Anthropic's marketplace supports OSS Project template publishing. As of v0.1.0 ship (this repo's current state), the answer is "fall back to Channel 2 (manual re-paste) — works fine, decoupled from Anthropic policy".

If Anthropic publishes guidance enabling marketplace plugin install for this framework, a follow-up PR will:
- Add a `claude.ai/marketplace/...` link to the README's Quickstart Path 1 step 2 as the primary path
- Keep manual re-paste as documented fallback for self-hosters

## Phase 2 expansion

- `/check-for-updates` skill (Channel 3 self-check)
- `versions.json` manifest at repo root (small JSON with `framework_version`, `schema_version`, `release_notes_url`)
- GitHub Release automation: every merge to main with a version-bumping commit creates a GitHub Release with auto-generated notes
- Email digest for founders who opt in (deferred until founder count > 50; manual signal during hearing batch is sufficient for ≤ 5)

## Phase 1 P1 closure note

This document closes T8 (Anthropic marketplace plugin update propagation policy) by explicitly documenting the dual-channel approach (marketplace if supported, manual re-paste always). Combined with PR #6 (system prompt with T3/T4/T14), PR #7 (Error & Rescue Map T1), PR #8 (Notion templates T20 + T12 partial), PR #9 (Chat transcripts T19), PR #10 (`/help` + `/migrate` T9 + T12 closure), and the v0 README/CLAUDE.md (T2 / T13 / T15 / T17 / T18), Phase 1 P0 + P1 = **15 of 15 ship blockers RESOLVED**.

The framework is hearing-ready.

---

*Generative Startup OS — Update Propagation v0.1, 2026-05-03*
