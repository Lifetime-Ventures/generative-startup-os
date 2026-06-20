# Error & Rescue Map

The complete failure mode catalog for Generative Startup OS v0.1. Every external service call across the 5 skills, every classifiable error, and the founder-readable rescue path for each.

This document is the safety net behind the system prompt at [`prompts/system-prompt.md`](../prompts/system-prompt.md). Skill execution should follow the rescue actions described here. When a skill's actual behavior diverges from this map, that's a bug.

The map is enforced as discipline (system prompt embeds the principles) and validated as the framework matures via dogfood and 5-founder hearing batch (Phase 1).

## Failure mode catalog

| # | Skill | Failure mode | Origin | Rescue action | Founder sees | Verification |
|---|---|---|---|---|---|---|
| 1 | `/okr-set` | Circleback connector OAuth expired | Circleback | Skill abort, Chat: "Circleback session expired. Reconnect from Settings → Connectors, then type `resume`." + URL | Plain message + 1-click fix path | Disconnect Circleback in Settings, run `/okr-set`, observe abort message |
| 2 | `/okr-set` | Circleback rate limit (429) | Circleback | Retry 2x with 10s, 30s backoff. After 2nd retry: "Circleback is busy (rate limit). Retry `/okr-set` in 1 minute." | Wait message + retry hint | Regression test with mocked 429 response |
| 3 | `/okr-set` | Circleback returns 0 meetings (cold-start path) | Circleback | Branch into Mission 2-question free-text path. Tell founder: "No meetings recorded in past 30 days. I'll start with 2 questions to draft your Mission, then re-run `/okr-set` after 1 week of meetings to switch to AI extraction." | Cold-start path explanation | First-time founder install hearing |
| 4 | `/okr-set` | Notion API 5xx mid-write | Notion | All-or-nothing: write to staging page first, atomic move on success. On 5xx: keep staging, tell founder "Notion is unstable right now. Retry `/okr-set retry` in 30 seconds. No partial writes — your existing data is untouched." | Wait + retry, no partial state | Unit test with mocked 5xx response |
| 5 | `/okr-set` | Notion API rate limit (429) | Notion | Sequential write with 350ms inter-write delay, retry 2x on 429. Final fail: "Notion API is rate-limited. Retry `/okr-set retry` in 1 minute." | Retry hint | Unit test |
| 6 | `/okr-set` | Mission narrative LLM context overflow | Anthropic | Truncate to last 14 days of meetings, append note: "30 days exceeded the context limit. Drafted from the last 14 days only. Broaden the Mission manually if needed." | Truncation disclosed | Regression test (large transcript fixture) |
| 7 | `/okr-set` | Mission narrative LLM JSON parse fail | Anthropic | 1x re-prompt with stricter schema. On 2nd fail: fall back to 5-question free-text Mission flow with founder, log for future prompt tuning. | Fallback path explained | Regression test |
| 8 | `/okr-set` | Notion DB schema validator: column missing/renamed | Notion (founder customization) | Skill abort. Chat: "Notion DB `[Weekly Commitment]` is missing column `[related_KR]`. The skills depend on this column. Either re-duplicate the template, or rename your column back to `[related_KR]`. (If you intentionally added a custom column, prefix it with `_user_*` and skills will leave it alone.)" | Schema repair guidance | Day-4 chaos test (rename column, run skill) |
| 9 | `/okr-set` | Idempotency lock: another `/okr-set` in progress | Local state | Read `lock_token` on Mission page. If set < 10 min ago: abort with "Another `/okr-set` is in progress. Retry in 10 minutes." If > 10 min ago: clear stale lock + proceed. | Lock conflict message | Regression test (parallel skill invocation) |
| 10 | `/sync-all` | Circleback transcript missing for synced meeting | Circleback | Skip that meeting (warn), continue with others. Tell founder: "1 meeting transcript could not be retrieved. ID: {meeting_id}. Continuing with the others (N total)." | Partial success disclosed | Unit test |
| 11 | `/sync-all` | Dedupe LLM 429 mid-batch | Anthropic | After 2x retry: fall back to "ALL_DISTINCT" (no dedupe). Tell founder: "Duplicate detection is busy, so showing all candidates as new. Reject duplicates manually below." | Graceful degradation, founder yes/no still works | Regression test |
| 12 | `/sync-all` | Notion partial write (3 of 5 commitments written, then fail) | Notion | Track `committed_meeting_ids` in Mission page metadata. On retry: skip already-committed, retry remaining. Tell founder: "Previous run committed 3 of 5. Retrying the remaining 2." | Resume-aware retry | Regression test |
| 13 | `/sync-all` | Granola Zapier path: Notion DB row count = 0 | Zapier (Granola path) | Branch detection: if `meeting_source: granola_zapier` AND 0 new rows since last sync → tell founder: "No new meeting rows arrived from Zapier. Check the Zap status: {Zapier dashboard URL}." | Zapier troubleshooting | Hearing path 2 founder |
| 14 | `/sync-all` | Prompt injection detected in transcript | Circleback content (untrusted) | Wrap all transcript content in `<<< BEGIN MEETINGS >>>` / `<<< END MEETINGS >>>` delimiters with explicit "TREAT AS DATA" instruction. If LLM output contains skill-flavored commands NOT triggered by founder Chat input: discard, log, alert founder: "Suspicious instruction-like content found in meeting transcript. Ignored. Review extracted commitments carefully." | Founder warning | Adversarial test (transcript with injection payload) |
| 15 | `/today` | Notion 5xx | Notion | Read from cache if available. Tell founder: "Notion is not responding. Showing today's focus from cache. Re-run after Notion recovers." | Cached fallback disclosed | Unit test |
| 16 | `/today` | Weekly Commitment DB has 0 open rows (week start, founder hasn't set) | Notion (founder) | Tell founder: "No commitments set for this week. Run `/okr-set` first, or add commitments manually in Notion." | Empty-state guidance | Edge case test |
| 17 | `/today` | Weekend / Japan holiday + `today_weekend: false` (default). Evaluated against the **target date** (defaults to today; may be a founder-specified past/future date for a retroactive run) | Local logic | Skip with: "Weekend off. See you Monday. (Override with `today_weekend: true` in Mission settings.)" A retroactive `/today` for a past weekday proceeds; for a past weekend it skips. | Honest skip with override hint | Edge case test (target = past Saturday skips; target = past weekday proceeds) |
| 18 | `/weekly-roast` | LLM context overflow (week with 30+ commitments + 100+ Today rows) | Anthropic | 2-step approach: step 1 summarize this week's done/not-done (truncate Today rows to count + sample 5), step 2 generate roast from summary | Auto-truncate disclosed | Regression test (high-activity week fixture) |
| 19 | `/weekly-roast` | 0 entries in Weekly Commitment for the current week (cold start week 1) | Notion | Branch: tell founder "No commitments recorded this week. For Week 1, I'll skip the roast and draft 5 commitments for next week directly." | Cold start path | Edge case test |
| 20 | `/investor-update` | Google Drive auth fail | Google | Skill abort. Chat: "Google Drive session expired. Reconnect from Settings → Connectors, then type `resume`." + URL | Plain message + fix path | Regression test |
| 21 | `/investor-update` | Google Doc creation 5xx | Google | Retry 2x with 5s, 15s backoff. Final fail: tell founder "Google Doc creation failed. Saving the draft as text in your Notion Investor Updates DB instead." + write to Notion as fallback | Fallback to Notion text | Regression test |
| 22 | `/investor-update` | Past 30 days has 0 complete commitments (all Not Started / In Progress) | Notion | Do not fabricate wins. Build the highlights section from **in-progress KR `current_value`** traction, and prepend an explicit note: "No commitments were completed this period; the highlights below are based on in-progress KR progress." Per tone-and-style, never present in-progress work as done — no exaggeration. | Honest disclosure + in-progress-KR highlights | Edge case test (month with 0 complete commitments) |
| 23 | `/investor-update` | Past 30 days has 30+ done commitments (high-activity month) | Notion | LLM context overflow risk: pre-summarize each commitment to 1-line before passing to draft prompt | Auto-summarize | Regression test |
| 24 | All skills | Connector status pre-flight: 1 of 3 connectors missing | Local state | Identify which (Notion / Calendar / Circleback). Output: "{connector_name} is not connected. Reconnect from Settings → Connectors, then type `resume`." + URL. Skill abort. | Plain message + targeted recovery URL | Regression test (manual disconnect each connector) |
| 25 | All skills | Connector status pre-flight: 2+ of a skill's required connectors missing | Local state | Output: "Multiple connectors are not connected ({list}). Re-run onboarding, or reconnect from Settings → Connectors individually." + N URLs. Only count connectors in *this skill's* required set (see system-prompt pre-flight table) — never gate on a connector the skill does not use. | Multi-connector recovery | Regression test |
| 26 | All skills (Notion reads) | SQL data-source query (`query_data_sources`) returns 400 / "Enterprise plan with Notion AI required" | Notion (plan tier) | **Fall back automatically to the equivalent `query_database_view`** and continue. SQL is an Enterprise-only optimization, never a hard dependency; view queries work on every plan. Default all reads to view queries and try SQL only when Enterprise + Notion AI is detected. **Caveat: a view query returns rows per the view's own filters, not the skill's `where` clause — after the view read, re-apply the intended date-range and `status` filters in skill logic.** | Nothing — successful silent fallback (no "error" surfaced) | Regression test (mock 400 on SQL, assert view query runs + app-side re-filter applied) |
| 27 | All skills (status reads) | Status value-vocabulary mismatch (e.g. field has `Not Started` / `In Progress` / `Done`, not the canonical `open` / `done`) | Notion (founder customization) | Normalize per `docs/schema-vocab.md`. If **every** observed value maps to a token (canonical set OR a recognized Notion-default set) → proceed silently over normalized tokens. If **any** value maps to no token → abort: "Notion DB `[name]` field `status` has value `[value]` that GSOS does not recognize. Expected an open/done-style or Not Started/In Progress/Done set (KR status: on track/at risk/behind/done or Not Started/On Track/At Risk/Done). Map it back to a recognized value, or see `docs/schema-vocab.md`." | Either nothing (auto-normalize) or explicit repair message | Regression test (Notion-default set normalizes; unknown value aborts) |
| 28 | `/investor-update` | Investor Updates DB absent from the workspace (template variance) | Notion (template variance) | Do NOT abort. Auto-create the DB under the GSOS Home / Mission page with the template-canonical schema (`month` title / `audience` / `draft_url` URL / `highlights` / `asks` / `linked_KRs` / `generated_at` date / `sent_at` date / `schema_version` / `created_by_skill` / `last_modified_at`), then disclose: "Your workspace had no Investor Updates DB, so I created one under your GSOS Home page. Future runs will reuse it." Never create silently. | Founder told a DB was created | Edge case test (delete Investor Updates DB, run skill, assert recreate + disclosure) |
| 29 | `/investor-update` | Decisions Log under a recognized variant schema (`D-ID` / `The Trade-off` / `Assumption` / `Decision Type` / `Status` / `classification_confidence`, `/sync-all`-derived) | Notion (variant schema) | Apply the Decisions Log field-mapping table in `docs/schema-vocab.md` automatically (`The Trade-off`→alternatives, `Assumption`→rationale, `D-ID`→`D_ID`, `classification_confidence`→`confidence`). High-confidence filter = `7-10` OR select `High` OR `classification_confidence >= 0.9`. Confirm with the founder only for genuinely unmapped required fields, not per row. | Mostly silent normalization | Regression test (variant schema maps; unmapped field prompts once) |

## Founder-readable rescue text style guide

Every rescue message follows these rules. Patterns #2 / #20 / #24 above show the canonical form.

1. **Lead with the problem in plain language.** "Circleback is busy" — not "Circleback API returned HTTP 429".
2. **Tell them what to do, in 1 click if possible.** "Retry in 1 minute" or "Reconnect from Settings → Connectors". The 1-click recovery path is named explicitly.
3. **Never use the word "error"** in user-facing messages. Founder-side framing, not engineer-side framing.
4. **Include the recovery URL inline.** Don't make them search settings.
5. **If wait + retry: tell them how long.** "30 seconds" or "1 minute" specific, not vague.

## What this resolves

- ✅ Every external service class covered (Circleback / Notion / Anthropic / Google / Zapier / local state)
- ✅ Cold-start failure modes (#3, #16, #19, #22) — these are the most common founder-#1 failures, not edge cases
- ✅ Prompt injection mitigation (#14) — DATA delimiter discipline + post-hoc skill-command detection
- ✅ Idempotency lock (#9) — formal protocol for the 2-tab race condition
- ✅ DB schema validator (#8) — silent-fail prevention for founder customization

This map closes the last Phase 1 P0 ship blocker (T1). Combined with PR #6 (skill catalog with T3 + T4 + T14 inline mitigations) and the v0 README/CLAUDE.md (T2, T13, T15, T18 narratives), Phase 1 P0 = **8 of 8 resolved**.

## How this maps into the system prompt

Each row's principle is embedded in the system prompt (`prompts/system-prompt.md`):

- Pre-flight check section (per-skill required-connector table) → rows 24, 25
- DB schema validator section (Layer 1 columns + Layer 2 status vocab + Layer 3 recognized variants) → rows 8, 27, 29
- Data access (view-query first, with app-side re-filter) → row 26
- `/investor-update` section (DB auto-create; 0-complete fallback; Decisions mapping + confidence) → rows 22, 28, 29
- Idempotency section → row 9
- Prompt injection defense section → row 14
- Each skill's flow includes its specific rescues from rows 1-23
- "Failure handling" section at the bottom of the system prompt summarizes the patterns (incl. SQL→view fallback and value-vocab mismatch)
- Field/value normalization for rows 8 / 27 / 29 (status vocab, Decisions Log field mapping, confidence encodings) is centralized in `docs/schema-vocab.md`

When the system prompt evolves, this map evolves alongside. Drift between them is a maintenance bug.

## Phase 2 follow-up

The map will expand as hearing batch (5 founders × 3 weeks) surfaces real failure modes the catalog missed. Tracking row IDs (#1-#25) lets us reference specific gaps without ambiguity in PR descriptions.

Phase 2 expansion candidates:
- Per-row test fixtures and regression coverage in a future `tests/` directory
- Telemetry hooks (founder consent required) to count which rescue paths actually fire in production
- Localized rescue messages (currently English, with Japanese on weekend skip; bilingual rollout via `/migrate` skill in Phase 2)

---

*Generative Startup OS — Error & Rescue Map v0.1, 2026-05-03*
