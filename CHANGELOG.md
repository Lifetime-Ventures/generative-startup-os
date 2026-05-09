# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
