# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [gsos 1.2.0] — /investor-update field-session fixes

From a real workspace running `/gsos:investor-update` (PR #24). Backward
compatible: no Notion `schema_version` change, no skill renames. Existing
installs keep working; this release makes `/investor-update` tolerate real-world
workspace variance and degrade honestly.

### Added
- **Auto-create a missing Investor Updates DB.** If the DB is absent from the
  duplicated workspace, `/investor-update` creates it under the GSOS Home /
  Mission page with the template-canonical schema and discloses this to the
  founder (never silent), instead of failing.
- `docs/schema-vocab.md` now also owns the **Decisions Log field-mapping table**
  (`The Trade-off`→alternatives, `Assumption`→rationale, `D-ID`→`D_ID`,
  `classification_confidence`→`confidence`) and a **confidence-encoding table**
  (`7-10` / `High` / `>= 0.9` all mean high-confidence).

### Changed
- DB schema validator (T3) gains **Layer 3**: recognized variant schemas
  (Decisions Log, confidence) auto-map; only genuinely unmapped fields prompt.
- `/investor-update` confidence filter resolves per encoding instead of comparing
  a raw value to `7`.
- **Zero-complete-commitment month**: highlights fall back to in-progress KR
  `current_value` traction with an explicit "no completions this period" note;
  in-progress work is never written as done (tone-and-style no-exaggeration).
- View-query reads now carry a **re-filter caveat**: re-apply date/status filters
  app-side, since a view returns rows per the view's own filters.
- `docs/error-rescue-map.md` (+ skill `reference.md`): rows 28 (DB auto-create)
  and 29 (Decisions variant) added; row 22 (0-complete) revised; row 26
  (SQL→view) extended with the re-filter caveat.

### Compatibility
- No `schema_version` change — founders do not run `/migrate`. Workspaces with a
  variant Decisions Log or non-canonical confidence encodings now normalize
  instead of mis-reading; a missing Investor Updates DB is created on first run.

## [gsos 1.1.0] — Schema-vocab normalization + field-session fixes

From a real founder workspace running `/gsos:today` retroactively (PR #21).
Backward compatible: no Notion DB `schema_version` change, no skill renames, no
removed skills. Existing installs keep working; this release makes GSOS tolerate
real-world Notion field setups it previously mis-read.

### Added
- `docs/schema-vocab.md` — single source of truth for `status` value
  vocabulary. Maps both the template-canonical sets and the common Notion-default
  sets (`Not Started` / `In Progress` / `Done`; KR: `On Track` / `At Risk`) to
  internal tokens. Canonical rule: *incomplete = not Done-family and not
  Dropped-family*.
- `/gsos:today` optional **target date** — run it for a specific past/future
  weekday (parsed from the founder's message; no formal argument, zero-arg
  invariant preserved). Weekend/holiday skip and the written `date` use the
  target date.

### Changed
- DB schema validator (T3) now checks the `status` **value vocabulary** in
  addition to column names: recognized sets auto-normalize; only an unmappable
  value aborts. Skills no longer test the literal `open`/`done`.
- KR scoring (`/gsos:today`) resolves `related_KR.status` via normalized tokens
  (`behind` > `at_risk` > `on_track` > `not_started`).
- Notion reads are **view-query-first** (`query_database_view`). SQL
  (`query_data_sources`) is used only as an Enterprise + Notion-AI optimization
  and falls back to a view query automatically on a 400 / permission error.
- Pre-flight verifies **only the connectors each skill uses** (per-skill table).
  Circleback is required only by `/okr-set` and `/sync-all`; `/today` =
  Notion + Calendar; `/okr-set` dropped its unused Calendar check.
- `docs/error-rescue-map.md` (+ skill `reference.md`): rows 26 (SQL→view
  fallback) and 27 (value-vocab mismatch) added; rows 17 / 24 / 25 clarified.

### Compatibility
- No `schema_version` change — founders do **not** need to run `/migrate` or
  rename their Notion select options. A workspace with Notion-default status
  values now validates and normalizes instead of mis-reading.

## [Unreleased] — License migration to Apache-2.0

### Changed
- **License: MIT → Apache License 2.0**. The repository is now distributed under the Apache License, Version 2.0. The Apache-2.0 license is a permissive license like MIT, but adds explicit grants and protections that are appropriate for a deep-tech-adjacent OSS framework:
  - **Patent grant clause (§3)**: contributors automatically grant a royalty-free patent license covering their contributions, with termination on patent litigation. This protects downstream users from contributor-side patent suits over contributed code.
  - **Trademark clause (§6)**: the license does not grant rights to use Lifetime Ventures trademarks; this prevents downstream forks from misrepresenting their software as official LV products.
  - **NOTICE file requirement (§4d)**: redistributions must preserve the project's `NOTICE` file. A new `NOTICE` file has been added at the repository root.
  - **Modified-file marking (§4b)**: derivative works must carry prominent notices indicating modifications.
- `LICENSE` file replaced with the official Apache-2.0 text plus the standard appendix copyright header pointing to "Lifetime Ventures LLC / ライフタイムベンチャーズ合同会社, 2025-2026".
- License badge in `README.md` updated to "License: Apache 2.0".
- License section in `README.md` rewritten and now references both `LICENSE` and `NOTICE`. A short license-history note has been added.
- License notes in `gsos/README.md` and `gsos-power/README.md` updated.
- Closing line of `CLAUDE.md` updated from "MIT licensed" to "Apache-2.0 licensed".
- `license` field in `gsos/.claude-plugin/plugin.json` and `gsos-power/.claude-plugin/plugin.json` updated from `"MIT"` to `"Apache-2.0"` (SPDX identifier).
- Contributing section in `README.md` now includes an explicit Developer Certificate of Origin-style line clarifying that contributions are licensed under Apache-2.0.

### Added
- `NOTICE` file at repository root, listing copyright holder and standard attribution per Apache-2.0 §4(d).
- `CHANGELOG.md` (this file) at repository root, seeded with the license migration entry.

### Compatibility
- **No code or behavior changes.** This release does not alter Notion DB schema, plugin manifests (apart from the `license` metadata field), command behavior, error-rescue logic, or any other functional surface. The only deltas are in license text, license-related documentation, and license metadata.
- **No breaking changes for existing installations.** Users who already installed `gsos` or `gsos-power` from the marketplace continue to operate normally. Re-installation is not required.
- Apache-2.0 is one-way compatible with MIT for incoming code (MIT-licensed code can be contributed and re-licensed under Apache-2.0). Contributions made under MIT prior to this release remain valid; the cumulative codebase is now distributed under Apache-2.0.

### Why now
- Clearer alignment with the deep-tech ecosystem norm (Anthropic MCP SDK, Kubernetes, TensorFlow, Apache Foundation projects all use Apache-2.0).
- Ahead of expanded MCP-server work where contributed code may carry implementation-level patentable techniques (peer selection, scoring, ranking algorithms). Apache-2.0's patent grant protects downstream users.
- Required precondition for the planned `lv-mcp-servers` monorepo work, where existing `comps-mcp` (Apache-2.0) will be co-located with new MCP packages. Single-license posture across the LtV OSS portfolio reduces contributor confusion and legal-review friction.

### Migration impact for users
- **GSOS users (founders running the plugin)**: no action required. The license change is transparent at the user level.
- **GSOS contributors (existing or new)**: by submitting a PR after the merge of this change, you agree your contribution is licensed under Apache-2.0. This is documented in the updated Contributing section of `README.md`.
- **Forks**: existing forks continue under MIT for their pre-fork content; new commits pulled from this repo carry Apache-2.0. Fork maintainers should evaluate whether to stay on MIT or migrate.
