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
| 17 | `/today` | Weekend / Japan holiday + `today_weekend: false` (default) | Local logic | Skip with: "Weekend off. See you Monday. (Override with `today_weekend: true` in Mission settings.)" | Honest skip with override hint | Edge case test |
| 18 | `/weekly-roast` | LLM context overflow (week with 30+ commitments + 100+ Today rows) | Anthropic | 2-step approach: step 1 summarize this week's done/not-done (truncate Today rows to count + sample 5), step 2 generate roast from summary | Auto-truncate disclosed | Regression test (high-activity week fixture) |
| 19 | `/weekly-roast` | 0 entries in Weekly Commitment for the current week (cold start week 1) | Notion | Branch: tell founder "No commitments recorded this week. For Week 1, I'll skip the roast and draft 5 commitments for next week directly." | Cold start path | Edge case test |
| 20 | `/investor-update` | Google Drive auth fail | Google | Skill abort. Chat: "Google Drive session expired. Reconnect from Settings → Connectors, then type `resume`." + URL | Plain message + fix path | Regression test |
| 21 | `/investor-update` | Google Doc creation 5xx | Google | Retry 2x with 5s, 15s backoff. Final fail: tell founder "Google Doc creation failed. Saving the draft as text in your Notion Investor Updates DB instead." + write to Notion as fallback | Fallback to Notion text | Regression test |
| 22 | `/investor-update` | Past 30 days has 0 done commitments (founder absent month) | Notion | Tell founder: "Past 30 days has 0 done commitments. Skip the investor update? Or write a 1-paragraph 'why progress was slower this month' anchored in the Mission?" | Honest empty state | Edge case test |
| 23 | `/investor-update` | Past 30 days has 30+ done commitments (high-activity month) | Notion | LLM context overflow risk: pre-summarize each commitment to 1-line before passing to draft prompt | Auto-summarize | Regression test |
| 24 | All skills | Connector status pre-flight: 1 of 3 connectors missing | Local state | Identify which (Notion / Calendar / Circleback). Output: "{connector_name} is not connected. Reconnect from Settings → Connectors, then type `resume`." + URL. Skill abort. | Plain message + targeted recovery URL | Regression test (manual disconnect each connector) |
| 25 | All skills | Connector status pre-flight: 2-3 of 3 missing | Local state | Output: "Multiple connectors are not connected ({list}). Re-run onboarding, or reconnect from Settings → Connectors individually." + N URLs | Multi-connector recovery | Regression test |

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

- Pre-flight check section → rows 24, 25
- DB schema validator section → row 8
- Idempotency section → row 9
- Prompt injection defense section → row 14
- Each skill's flow includes its specific rescues from rows 1-23
- "Failure handling" section at the bottom of the system prompt summarizes the patterns

When the system prompt evolves, this map evolves alongside. Drift between them is a maintenance bug.

## Phase 2 follow-up

The map will expand as hearing batch (5 founders × 3 weeks) surfaces real failure modes the catalog missed. Tracking row IDs (#1-#25) lets us reference specific gaps without ambiguity in PR descriptions.

Phase 2 expansion candidates:
- Per-row test fixtures and regression coverage in a future `tests/` directory
- Telemetry hooks (founder consent required) to count which rescue paths actually fire in production
- Localized rescue messages (currently English, with Japanese on weekend skip; bilingual rollout via `/migrate` skill in Phase 2)

---

*Generative Startup OS — Error & Rescue Map v0.1, 2026-05-03*
