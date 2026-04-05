# memory/sync-state.md — 日次同期状態管理
# /sync-all が自動更新するファイル。手動編集不要。
# Last Updated: v5.0

---

last_sync_at: （初回 /sync-all 実行後にClaudeが自動記入）
last_sync_date: （初回 /sync-all 実行後にClaudeが自動記入）

synced_meeting_ids:
  # Circleback / Granola の meeting UUID
  # 重複起票防止のためにClaudeが自動管理する

synced_notion_page_ids:
  # Notion page ID
  # 重複起票防止のためにClaudeが自動管理する

---

## このファイルの役割

`/sync-all` が実行されるたびに以下を更新する：
1. `last_sync_at` → 現在時刻（ISO 8601形式・JST）
2. `last_sync_date` → 実行日（YYYY-MM-DD形式）
3. `synced_meeting_ids` → 処理済みのCircleback/Granola meeting UUID
4. `synced_notion_page_ids` → 処理済みのNotion page ID

次回 `/sync-all` 実行時は `last_sync_at` 以降のデータのみをスキャンする（差分同期）。

## リセット方法

再スキャンしたい場合は `last_sync_at` の値を削除（または書き換え）してから `/sync-all` を実行する。
