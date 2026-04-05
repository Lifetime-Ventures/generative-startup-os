# /sync-all — 日次L1データ同期・タスク自動起票
# Phase: 1以降（全フェーズ）
# 推奨実行タイミング: 業務終了後（毎日）
# Last Updated: v5.0

---

## Purpose

当日（または前回実行以降）の新規・更新データを全ソースからスキャンし、
決定事項・アクションをNotionに自動起票する。

翌日・翌々日のフォーカスタスクとカレンダー作業枠が確保された状態で終業する。
**フォーカスタスクが確定するまでセッションを終了しない。**

---

## When to Use

- 業務終了後（毎日）
- 重要ミーティング後に即時起票したいとき
- /weekly-roast の前の事前同期

---

## Notion DB 参照・転記対象

| DB番号 | 名称 | sync-allでの役割 |
|--------|------|-----------------|
| DB1 | Objectives | KR進捗との整合確認（読み取りのみ） |
| DB2 | Key Results | センシングからKR進捗を更新 |
| DB3 | Decisions | 決定事項を網羅的に起票 |
| DB4 | Tasks | アクションを起票・完了処理・PRR記録 |
| DB5 | Meeting Memos | 議事録サマリーを転記 |
| DB6 | Progress Update | 定例MTG向け進捗レポートを自動作成 |
| DB7 | Organizations | 新規登場組織を登録・既存情報を更新 |
| DB8 | Contacts | 新規登場人物を登録・既存情報を更新 |

DB IDは .claude/context.md の「Notion DB IDs」セクションを参照。

---

## Input（自動スキャン）

スキャン対象は「前回 /sync-all 実行時刻以降」の新規・更新データ。
前回実行時刻は `memory/sync-state.md` に記録する。
初回または記録がない場合は当日00:00以降を対象とする。

### スキャン対象ソース（優先順）

| ソース | ツール | 取得内容 |
|--------|--------|---------| 
| **Google Calendar** | `gcal_list_events` | 当日00:00〜翌々日23:59のイベント（1回で取得） |
| **Notion** | `notion-search` | 当日更新されたページ・DB |
| **Circleback** | `SearchMeetings` / `GetTranscriptsForMeetings` | 録音・文字起こし付きミーティング |
| **Granola** | `query_granola_meetings` / `get_meetings` | CirclebackにないMTGノート |
| **Gmail** | `gmail_search_messages` | 投資家・顧客・取引先からの重要メール（任意） |
| **Slack** | `slack_search_public_and_private` | 重要チャンネルのメッセージ（任意） |

> 議事録ソースの優先順: **Notion → Circleback → Granola**（Granolaは両方にない場合のみ）
> Google Calendarは当日＋翌日＋翌々日を1回で取得（STEP 7で再利用するため再取得不要）
> Gmail/Slackは接続がある場合のみ。接続がなければこの2ソースはスキップ。

---

## Process（9ステップ）

### STEP 1｜並列スキャン（全ソース同時発行）

上表の全ソースを**同一ターンで並列発行**する。逐次実行は禁止。

```
Gmailクエリ例（接続がある場合）:
after:YYYY/MM/DD -category:promotions -from:noreply is:inbox

Slackクエリ例（接続がある場合）:
[自分のSlackユーザーID] after:YYYY-MM-DD
```

---

### STEP 2｜当日タスク完了処理

- カレンダー結果から当日出席MTGをリスト化
- DB4（Tasks）で対応済みタスクを検索 → 候補提示 → 承認後に一括「Done」更新＋PRR貢献度記録

---

### STEP 3｜L1センシング → Notion DB網羅転記

スキャン結果を以下のDBに**網羅的**に転記・起票する。
`memory/sync-state.md` の `synced_meeting_ids` に含まれるIDは重複起票防止のため除外。

**DB5: Meeting Memos**
- 当日のMTG全件について議事録サマリーを作成
- Notion議事録ページが既存の場合はSnapshotセクションを更新
- ない場合は新規ページを作成

**DB3: Decisions**
- MTG・メール・Slackから抽出した決定事項を全件起票
- 既存DB3と照合して未起票のみ（重複チェック必須）
- KR紐付け・Strategic Weight設定

**DB4: Tasks**
- 決定事項から派生するアクションを全件起票
- Est.Hours見積もり・KR紐付け・期限・担当を設定
- 必須フィールド: 優先度（🔴今日/🟠今週/🟡今月）・期限日

**DB2: Key Results**
- MTGや情報から読み取れるKR進捗の変動があれば更新
- Confidence Score を再算出（式は context.md 参照）

**DB7: Organizations / DB8: Contacts**
- 当日のMTG・メール・Slackで新規登場した組織・人物を登録
- 既存レコードのステータス・情報に変動があれば更新

---

### STEP 4｜Gmail トリアージ（接続がある場合のみ）

| 優先度 | 基準 |
|--------|------|
| 🔴 緊急 | 当日中に返信が必要・署名・確認依頼（投資家・顧客からの直接依頼） |
| 🟠 今週 | 今週中に対応・日程調整・契約確認 |
| 🟡 FYI | 対応不要・ニュースレター・自動通知 |

🔴・🟠メールはDB4にタスク起票（STEP 3と重複確認の上）

---

### STEP 5｜Slack トリアージ（接続がある場合のみ）

| 優先度 | 基準 |
|--------|------|
| 🔴 | 自分への直接メンション・直接質問 |
| 🟠 | 顧客・投資家関連チャンネルの未読 |
| 🟡 | 社内情報共有・FYI系 |

🔴・🟠はDB4にタスク起票（STEP 3と重複確認の上）

---

### STEP 6｜Focus Guard チェック

- **Focus Guard**: DB4のDoingタスク数を確認
  → 3件超は🚨アラート＋新規着手ブロック
  → 「Doing [X]件 → 先に完了またはキャンセルしてから新規タスクを着手してください」

---

### STEP 7｜翌日・翌々日 定例レポート生成（DB6: Progress Update）

STEP 1取得済みの翌日・翌々日カレンダーを使う（**再取得禁止**）。

**対象MTGの抽出**
- 定例MTG（recurringEventId があるもの）を翌日・翌々日から全件抽出
- 辞退済み（myResponseStatus: declined）はスキップ

**DB6: Progress Update ページ作成（定例MTG毎に1ページ）**

各定例MTGについて以下を実行：
1. DB6に新規ページを作成（タイトル: `[MTG名] Progress Update — YYYY-MM-DD`）
2. Notionで過去議事録を検索して参照（直近2〜3件）
3. L1スキャン結果（当日MTG・メール・Slack）から関連トピックを抽出
4. 以下のフォーマットで自動記載：

```markdown
## Progress Update — [MTG名]
更新日: YYYY-MM-DD | 次回MTG: YYYY-MM-DD HH:MM

### 📊 前回からのアップデート
- [トピック1]: [前回状況] → [現在状況]
- [トピック2]: ...

### 🔴 議論すべきポイント
1. [課題・論点] — 背景: [1行]
2. ...

### ✅ 前回アクションアイテム結果
| アクション | 担当 | 結果 |
|-----------|------|------|
| [内容] | [名前] | ✅完了 / 🔄継続 / ❌未着手 |

### 📌 次回に持ち込むアジェンダ候補
- [項目]
```

---

### STEP 8｜翌日フォーカスタスク確定＋カレンダーブロック

**⚠️ フォーカスタスクが確定するまでセッションを終了しない。**

**8-a｜フォーカスタスク候補の提示**

翌日・翌々日のカレンダー空き時間を確認し、以下のオプションを提示：

```
【翌日フォーカス候補】
Option A: [タスク名] — Est.[X]h — 理由: [1行]
Option B: [タスク名] — Est.[X]h — 理由: [1行]
Option C: [タスク名] — Est.[X]h — 理由: [1行]

【翌日カレンダー空き枠】
- HH:MM〜HH:MM（[X]h）
- HH:MM〜HH:MM（[X]h）

どれをフォーカス1・2にしますか？（または別タスクを指定）
```

- 持ち越しタスクは必ずOption Aに据える
- Est.Hoursと空き枠の合計が合わない場合は警告を出す

**8-b｜フォーカスタスク確定後の処理**

選択を受けて：
1. **カレンダーに作業枠をブロック**（gcal_create_event）
   - タイトル: `🔴 [フォーカス1タスク名]`
   - 時間: フォーカス1のEst.Hoursに合わせた空き枠に挿入
   - 必要に応じてフォーカス2の枠も作成

2. **確認メッセージを出力**
   ```
   ✅ 翌日フォーカス確定
   🔴 フォーカス1: [タスク名]（[HH:MM〜HH:MM] にブロック済み）
   🟠 フォーカス2: [タスク名]（[HH:MM〜HH:MM] にブロック済み）
   ```

3. **sync-state.md を更新**（last_sync_at = 現在時刻）

---

### STEP 9｜AI Board Meeting（週次Board Meeting設定日の夜のみ）

**実行条件: context.md の `board_meeting_day` に設定した曜日の `board_meeting_time` 以降のみ**

/weekly-roastの後段として、AI Boardエージェントチームによる議論を実施。
エージェント構成・議事録の置き場は context.md の「AI Board設定」を参照。

> メンバーの /sync-all では AI Board Meeting の代わりに
> AI Coachエージェントチームによる議論を実施（/weekly-roast が前段で起動）

---

## Output Format

```
## /sync-all: [YYYY-MM-DD] 日次デルタ
実行時刻: [HH:MM]
スキャン対象: [last_sync_at] 以降

---

### 本日スキャン結果
- MTG: X件（カレンダー）
- スキャンMoM: X件（Notion X / Circleback X / Granola X）
- 重要メール: X件（Gmail）
- Slackメンション: X件

### Notion DB転記サマリー
- DB2 KR更新: X件
- DB3 Decision起票: X件
- DB4 Task起票: X件 / 完了: X件
- DB5 MoM作成/更新: X件
- DB6 Progress Update作成: X件
- DB7 Organization更新: X件
- DB8 Contact更新: X件

---

### 📅 本日MTG一覧
| 時刻 | 内容 |
|------|------|
| HH:MM–HH:MM | [MTG名] |

---

### 起票一覧

**Decisions（DB3）**
- [D-ID]: [タイトル]

**Tasks（DB4）**
- [タスク名] — 期限: [...] — KR: [...]

---

### 📋 DB6 Progress Update 生成一覧
| MTG名 | 日時 | NotionリンクURL |
|-------|------|----------------|
| [定例名] | YYYY-MM-DD HH:MM | [URL] |

---

### ⚠️ アラート（あれば）
[Focus Guard超過 / 期限超過タスク / その他]

---

### Focus Guard
Doing [X]件 → [正常 / 🚨 3件超・新規着手ブロック]

---

### 翌日フォーカス候補 → 選択してください
Option A: ...
Option B: ...
Option C: ...

【翌日カレンダー空き枠】
...
```

（フォーカスタスク確定→カレンダーブロック→sync-state.md更新→完了確認まで継続）

---

## memory/sync-state.md の仕様

```markdown
---
last_sync_at: YYYY-MM-DDTHH:MM:SS+09:00
last_sync_date: YYYY-MM-DD
synced_meeting_ids:
  - [Circleback / Granola meeting UUID]
  - ...
synced_notion_page_ids:
  - [Notion page ID]
  - ...
---
```

`synced_meeting_ids` / `synced_notion_page_ids` を使って重複起票を防ぐ。

---

## 品質チェックリスト

- [ ] 全ソースを並列スキャンしたか（逐次はNG）
- [ ] 議事録参照順はNotion→Circleback→Granolaか
- [ ] DB2〜DB8への転記を網羅的に行ったか
- [ ] カレンダーはSTEP 1の結果（翌々日まで）を再利用したか（再取得はNG）
- [ ] DB6 Progress Updateを翌日・翌々日の定例MTG全件分作成したか
- [ ] タスク追加前にDB4で重複確認したか
- [ ] Focus Guardをチェックしたか
- [ ] フォーカスタスクを確定するまでセッションを継続したか
- [ ] カレンダーに作業枠をブロックしたか
- [ ] sync-state.md の last_sync_at を更新したか

---

## Limitations

- Gmail / Slack は接続がある場合のみ（接続なければスキップ）
- Circlebackは接続がある場合のみ（接続なければNotionとGranolaでカバー）
- DB6 Progress Updateの内容は自動生成ドラフト。MTG前に創業者が確認・加筆すること
- Google Calendarが接続されていない場合、STEP 7・8のカレンダー機能はスキップして手動設定を促す

---

## 関連コマンド

- `/weekly-roast` — 週次PRR評価（AI Coach Session前段 → Part A自己批判 → AI Board Meetingへ）
- `/okr-check` — OKRのL2分析
- `/board-prep` — 取締役会・投資家報告資料の自動生成
