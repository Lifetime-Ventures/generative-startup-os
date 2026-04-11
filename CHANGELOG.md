# Changelog

All notable changes to Generative Startup OS are documented here.

Format: [Semantic Versioning](https://semver.org). Types: `Added` / `Changed` / `Fixed` / `Removed` / `Security`

---

## [5.0.0] — 2026-04-05

### Added
- `/sync-all` — Full 9-step daily L1 scan (6 parallel sources: Calendar, Notion, Circleback, Granola, Gmail, Slack)
- `memory/sync-state.md` — Diff-based sync state tracking (only scans since last run)
- `DB6: Progress Update` — Auto-generated pre-meeting briefings for recurring meetings
- Focus Guard — Blocks new task starts when Doing count exceeds 3
- `/weekly-roast` pipeline: AI Coach Session (pre-step) → Part A self-critique → AI Board Meeting (post-step)
- AI Coach Session — 4-agent, 10+ round weekly coaching with monthly persona review
- AI Board Meeting — 5-agent customizable board; all agent roles and agenda rotation defined in `context.md`
- `/okr-check` — OKR L2 analysis with Confidence Score, root cause analysis (hypothesis / execution / external), next-quarter KR suggestions
- `LICENSE` (MIT), `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `CHANGELOG.md`, `WHAT-NOT-TO-INPUT.md` — OSS scaffolding
- Claude Code vs Claude.ai feature comparison in `/setup-mcp`
- Claude.ai Projects setup path in `README_SETUP.md`

### Changed
- PRR Integrity Rate formula unified to `0.5 ^ Penalty Count` (was 0.7 / 0.5 / 0)
- Notion DB count: 7 → 8 (DB6 Progress Update added)
- Organizations DB: `LP` category → `Investor` (startup-appropriate)
- Contacts DB Roles: added `Candidate`; removed hardcoded institution-specific roles
- MCP config example file renamed: `claude_desktop_config.json.example` → `claude_mcp_config.json.example`
- `board_agenda_rotation week1`: "ポートフォリオ" → "プロダクト・技術進捗"
- "VCキックオフMTG確認リスト" → "初期セットアップ完了チェックリスト"
- All "担当VCに連絡" references → "GitHubのissueに報告"

### Removed
- All hardcoded organization-specific names, Notion page IDs, and Slack user IDs
- Institution-specific `Connection` checkbox from Organizations DB schema
- Institution-specific hardcoded roles from Contacts DB schema

### Security
- Added `WHAT-NOT-TO-INPUT.md` — guidance on what must not be sent to Claude (unpublished patents, patient data, export-controlled technology)
- Added npm package name warnings for third-party MCP servers

---

## [4.0.0] — 2026-03-31

### Added
- Phase 2 commands: `/onboard-me`, `/peer-audit`, `/update-crm`, `/board-prep`
- Phase 3 commands: `/team-prr`, `/narrative-check`, `/series-a-check`, `/culture-audit`, `/monthly-gemini`
- `memory/experiment-log.md` — R&D experiment log for deep tech IP capture
- `team/` folder structure for Phase 2+ member desks

### Changed
- Restructured from phase-separated files (phase1/, phase2/, phase3/) to single flat structure with phase labels

---

## [3.0.0] — 2026-03-30

### Added
- Initial public template release
- Core Phase 1 commands: `/setup-mcp`, `/setup-notion`, `/sync-all`, `/weekly-roast`, `/moat-capture`, `/irm-briefing`
- 7-DB Notion schema
- `memory/` file structure: decisions, preferences, moat-strategy, runway-vitals
