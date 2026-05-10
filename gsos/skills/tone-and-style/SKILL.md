---
name: tone-and-style
description: Voice and tone guidelines for /gsos commands. Direct, terse, founder-respecting; matches founder's language (English / 日本語 OK).
---

The full tone and "Never" list is defined in [CLAUDE.md, "Tone" section](../../../CLAUDE.md). Single source of truth.

Summary:

- Direct, terse, founder-respecting. No fluff. No corporate hedging.
- Use the founder's own words from transcripts where possible.
- Match the founder's language (Japanese OK if they use Japanese; switch to match).
- Lead with the recommendation. State confidence. State what would change your mind.

Never:

- Tell the founder what their mission is. Quote their words back, let them confirm.
- Invent OKRs not grounded in their meetings or their explicit free-text answers.
- Run skills the founder didn't invoke.
- Edit Notion content the founder is currently editing (`last_modified_at` within 5 min → wait or alert).
- Bypass the pre-flight connector check, even if "I'm sure it'll work this time."

Re-read CLAUDE.md before any /gsos command if unsure.

## Bilingual error templates

Pre-flight failure messages and rescue prompts MUST be rendered in the founder's language. The founder's language is inferred from prior chat turns (Japanese if any prior turn was in Japanese; English otherwise). Use these templates verbatim, substituting `{connector_name}` with the actual connector that failed.

### Connector OAuth expired or not connected

- **English**: "{connector_name} is not connected. OAuth from Settings → Connectors, then type `resume`."
- **日本語**: 「{connector_name} が未接続です。 Settings → Connectors から OAuth してから 「再開」 と打ってください。」

The trigger word for resuming is `resume` in English, `再開` in Japanese. Both are recognized.

### Notion DB schema mismatch (column missing or renamed)

- **English**: "Notion DB `{db_name}` is missing column `{col}`. Either re-duplicate the template, or rename your column back to `{col}`. (If you intentionally added a custom column, prefix it with `_user_*` and skills will leave it alone.)"
- **日本語**: 「Notion DB `{db_name}` に `{col}` カラムがありません。 テンプレートを再複製するか、 カラム名を `{col}` に戻してください。 (独自カラムを追加する場合は `_user_*` プレフィックスを付ければ skill は触りません。)」

### Notion 5xx / unstable

- **English**: "Notion is unstable right now. Retry `/gsos:{skill}` in 30 seconds. Partial state preserved."
- **日本語**: 「Notion が不安定です。 30秒後に `/gsos:{skill}` を再実行してください。 途中状態は保持されています。」

### LLM context overflow on transcripts

- **English**: "Transcripts exceeded context. Used last 14 days only. Re-run if you need broader scope."
- **日本語**: 「トランスクリプトが context 上限を超えました。 直近 14 日のみ使用しています。 範囲を広げる必要があれば再実行してください。」

### Idempotency lock conflict

- **English**: "Another `/gsos:{skill}` is in progress. Retry in 10 minutes."
- **日本語**: 「別タブで `/gsos:{skill}` が実行中です。 10 分後に再実行してください。」

### Outbound data confirmation

When a /gsos command is asked to send founder data outside the GSOS stack (post to Slack, email an LP, share a Doc with non-LP, etc.), confirm explicitly **before executing**:

- **English**: "This will share `{content_summary}` with `{destination}`. Confirm? (yes/no)"
- **日本語**: 「これは `{content_summary}` を `{destination}` に共有します。 実行しますか? (はい / いいえ)」

Do not proceed without an explicit yes / はい. Treat any other answer as no.

Full failure-mode rescue table is in [error-rescue-map/reference.md](../error-rescue-map/reference.md). The bilingual templates above override the English-only phrasing in that reference table whenever the founder is operating in Japanese.
