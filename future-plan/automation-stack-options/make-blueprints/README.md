# Make.com Blueprint Specs (Aspirational)

> **Status**: Pre-reset design materials. NOT functional in v0.1.0 because v0.1.0 has no Inbox DB to write to. Preserved for Phase 2+ when Inbox + iPaaS are reconsidered.
>
> See parent README (`automation-stack-options/README.md`) for context, and `future-plan/ideas/inbox-channel-sourcetype.md` for the target Inbox schema.

---


このディレクトリには、 GSOS v6.0 で利用する Make.com Blueprint (シナリオの設計図) が含まれます。
インポートすることで Gmail / 音声メモ / Calendar 等から DB9 Inbox への自動流入が可能になります。

---

## 提供される Blueprint (5種)

| ファイル | 用途 | 推奨実行頻度 |
|---|---|---|
| `gmail-to-inbox.json` | 重要メールを DB9 Inbox に流入 | 15分間隔 |
| `voicememo-to-inbox.json` | iCloud音声メモを DB9 Inbox に流入 | 30分間隔 |
| `calendar-to-tasks.json` | Calendar新規予定を DB4 Tasks に登録 | 1時間間隔 |
| `inbox-ai-filter.json` | DB9 Inbox の関連性スコアリング (Haiku) | DB9更新トリガ |
| `weekly-roast-trigger.json` | 週次振り返りの実行リマインダー | 週1回 (金曜18:00) |

---

## 前提条件

- Make.com アカウント (無料プランで開始可能)
- Notion インテグレーション (`secret_xxx` トークン)
- Anthropic API キー (上限$10/月推奨)
- (Blueprint毎に必要なソース側の認証情報)

---

## インポート手順 (共通)

1. Make.com にログイン → Scenarios → Create a new scenario
2. 右上の「︙」メニュー → **Import Blueprint**
3. このディレクトリの該当 JSON ファイルをアップロード
4. 各モジュールの認証情報を順番に設定:
   - Notion: secret_xxx トークン
   - Anthropic: sk-ant-xxx APIキー
   - Gmail / Google Calendar / iCloud: OAuth認証
5. シナリオ全体を保存
6. 右下のスケジュール設定で実行頻度を選択
7. ON にする

---

## Blueprint 1: gmail-to-inbox.json

**目的**: Gmail の受信メールから「重要」と判定されたものを DB9 Inbox に自動投入

**フロー**:
```
Gmail (Watch emails)
  → Filter (Important/Starred labels)
  → Anthropic Claude (要約・カテゴリ判定)
  → Notion (Create database item in DB9 Inbox)
```

**設定項目**:
- Gmail フィルタ: 「Important」または「Starred」のメール
- 除外ドメイン: `@*.bank.co.jp`、 `@lawyer.firm.com` 等 (機密性高)
- Anthropic モデル: `claude-haiku-4-5` (低コスト)
- Notion DB9 Inbox の DB ID

**月間オペレーション数目安**: メール量に応じて 200-500 ops/月

---

## Blueprint 2: voicememo-to-inbox.json

**目的**: iCloud Drive 上のボイスメモを文字起こししてDB9 Inbox に投入

**フロー**:
```
iCloud (Watch new files in Voice Memos folder)
  → OpenAI Whisper or Anthropic Audio (文字起こし)
  → Anthropic Claude (要約・カテゴリ判定)
  → Notion (Create database item in DB9 Inbox)
```

**設定項目**:
- iCloud Drive のVoice Memosフォルダパス
- 音声→テキスト変換サービス選択 (Whisper APIまたは類似)
- Notion DB9 Inbox の DB ID

**月間オペレーション数目安**: 音声メモ頻度により 50-200 ops/月

**注意**: 音声メモにNDA下情報を残さないこと。 [WHAT-NOT-TO-INPUT.md](../WHAT-NOT-TO-INPUT.md) 参照。

---

## Blueprint 3: calendar-to-tasks.json

**目的**: Google Calendar の新規予定 (顧客MTG・投資家面談等) を DB4 Tasks に自動登録

**フロー**:
```
Google Calendar (Watch new events)
  → Filter (Category match: Investor / Customer / Partner)
  → Notion (Create database item in DB4 Tasks)
  → Set status: "Today" if event is today, else "Inbox"
```

**設定項目**:
- 監視対象カレンダー
- カテゴリマッチパターン (タイトルベース)
- Notion DB4 Tasks の DB ID

**月間オペレーション数目安**: MTG頻度により 100-300 ops/月

---

## Blueprint 4: inbox-ai-filter.json

**目的**: DB9 Inbox に蓄積された未トリアージ項目に対して、 Haiku で OKR関連性スコアを自動付与

**フロー**:
```
Schedule (Every 6 hours)
  → Notion (Search DB9 where Status="Unread")
  → Anthropic Claude Haiku (関連性スコア 1-10)
  → Notion (Update OKR Relevance field)
```

**設定項目**:
- スケジュール頻度 (推奨: 6時間毎)
- Anthropic モデル: `claude-haiku-4-5`
- 関連性判定プロンプト (テンプレート付属)
- Notion DB9 Inbox の DB ID

**月間オペレーション数目安**: 100-300 ops/月

**API使用量**: 月$3-8 (Haiku使用)

---

## Blueprint 5: weekly-roast-trigger.json

**目的**: 毎週金曜の指定時刻に /weekly-roast 実行を促すリマインダー

**フロー**:
```
Schedule (Friday 18:00)
  → Notion (Create reminder page in workspace)
  → (Optional) Email notification
```

**設定項目**:
- 実行曜日・時刻
- 通知先 (Notionページ通知またはメール)

**月間オペレーション数目安**: 4-5 ops/月 (低)

---

## Anthropic API キーの上限設定

Make.com で Anthropic API を使う場合は、 **必ず** 以下を設定:

1. Anthropic Console (https://console.anthropic.com) にログイン
2. Settings → Spending Limits
3. **Monthly Budget Limit: $10** を設定 (推奨)
4. Email Alerts を有効化 (50%, 80%, 100%)

これにより、 Make.com Blueprint が暴走しても月$10で停止します。

---

## 月間オペレーション数の目安

無料プラン (1000 ops/月) で利用する場合の Blueprint 組み合わせ:
- gmail-to-inbox: 300 ops
- inbox-ai-filter: 200 ops
- weekly-roast-trigger: 5 ops
- **合計: 約505 ops/月** → 無料プランで十分

Core プラン ($9/月・10,000 ops/月) なら全Blueprint を余裕で運用可能。

---

## トラブルシューティング

### Notion API 401 エラー
- インテグレーションのトークン (secret_xxx) を確認
- Notion DB9 Inbox にインテグレーションがコネクトされているか確認

### Anthropic API 429 エラー
- Spending Limit に到達 → Anthropic Console で確認
- Rate limit → Make.com の retry 設定を有効化

### Gmail / Calendar OAuth 切れ
- Make.com → Connections で再認証

### Blueprint が動かない
- Make.com → History でエラーログ確認
- 各モジュールを個別に「Run once」でテスト

---

## セキュリティへの配慮

[WHAT-NOT-TO-INPUT.md](../WHAT-NOT-TO-INPUT.md) を必ず確認してください。

特に Make.com / iPaaS 経由のデータフローは:
- 第三者サーバーを経由する
- ログが一定期間 (標準30日) 保持される
- 機密性の極めて高い情報 (バイオ・量子・国防) は流さない方針

これらに該当する場合は手動運用 (Foundation環境) または Claude Code 直接 MCP連携 (Automated環境) を選択してください。

---

## 関連ドキュメント

- [docs/automation-options.md](../docs/automation-options.md) — Make.com vs Zapier vs n8n
- [docs/cost-breakdown.md](../docs/cost-breakdown.md) — 月額コスト試算
- [WHAT-NOT-TO-INPUT.md](../WHAT-NOT-TO-INPUT.md) — 入力禁止事項
