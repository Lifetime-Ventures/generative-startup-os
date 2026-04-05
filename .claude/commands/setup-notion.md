# /setup-notion — Notion 8DB自動構築
# Phase: 1（初回セットアップ）
# Last Updated: v5.0

---

## 使い方
```
/setup-notion quick     → Tasks + Decisions（推奨：最初はこれ）
/setup-notion standard  → Objectives + Key Results + Tasks + Decisions + Meeting Memos（5DB）
/setup-notion full      → 全8DB（CRM・Progress Update含む）
```

## 実行前の確認
Notion MCPが設定・接続済みであることが必要です。
未設定の場合は先に `/setup-mcp` を実行してください。

---

## 実行手順

### Step 1: 作成先の確認
「NotionでDBを作成したいページのURLを教えてください」
→ URLからページIDを抽出する（末尾32文字）

---

### Step 2: DB作成（Pass 1 — リレーションなし）

#### [quick モード]

**DB3: Decisions を作成：**
```sql
CREATE TABLE "Decisions" (
  "D-ID" TITLE,
  "Status" SELECT('Active':green, 'Pivoted':yellow, 'Obsolete':gray),
  "Decision Type" SELECT('Technical':blue, 'Business':purple, 'Product':orange, 'Operations':gray, 'Pivot':red),
  "The Trade-off" RICH_TEXT,
  "Assumption" RICH_TEXT,
  "IP Potential" SELECT('高':red, '中':yellow, 'なし':gray),
  "Date" DATE,
  "Created" CREATED_TIME
)
```

**DB4: Tasks を作成：**
```sql
CREATE TABLE "Tasks" (
  "Task Name" TITLE,
  "Status" SELECT('Inbox':gray, 'Today':red, 'Doing':blue, 'Done':green, 'Delayed':orange, 'Cancelled':red),
  "OKR Type" SELECT('OKR-Direct':green, 'Operational':blue, 'Unbound':gray),
  "Priority" SELECT('🔴 今日':red, '🟠 今週':orange, '🟡 今月':yellow),
  "Est. Hours" NUMBER,
  "Strategic Weight" NUMBER,
  "Penalty Count" NUMBER,
  "Integrity Rate" FORMULA('pow(0.5, prop("Penalty Count"))'),
  "Weighted Load" FORMULA('prop("Est. Hours") * prop("Strategic Weight") * prop("Integrity Rate")'),
  "Assignee" PEOPLE,
  "Due Date" DATE,
  "IP Flag" CHECKBOX
)
```

#### [standard モード — quickに加えて以下を作成]

**DB1: Objectives を作成：**
```sql
CREATE TABLE "Objectives" (
  "Objective Name" TITLE,
  "Narrative" RICH_TEXT,
  "Status" SELECT('Active':green, 'Achieved':blue, 'Paused':gray),
  "Quarter" RICH_TEXT,
  "Owner" PEOPLE,
  "Created" CREATED_TIME
)
```

**DB2: Key Results を作成：**
```sql
CREATE TABLE "Key Results" (
  "KR Name" TITLE,
  "Target Value" NUMBER,
  "Current Value" NUMBER,
  "Unit" RICH_TEXT,
  "Strategic Weight" NUMBER,
  "Status" SELECT('On Track':green, 'At Risk':yellow, 'Off Track':red, 'Achieved':blue),
  "Confidence" SELECT('🟢 高':green, '🟡 中':yellow, '🔴 低':red),
  "Progress %" FORMULA('if(prop("Target Value") == 0, 0, round(prop("Current Value") / prop("Target Value") * 100))'),
  "Owner" PEOPLE
)
```

**DB5: Meeting Memos を作成：**
```sql
CREATE TABLE "Meeting Memos" (
  "Meeting Name" TITLE,
  "Date" DATE,
  "Category" SELECT('Internal':gray, 'Customer':green, 'Investor':blue, 'Partner':purple, 'Academic':orange, 'External':gray),
  "Raw Transcript URL" URL,
  "AI Summary" RICH_TEXT,
  "Attendees" PEOPLE
)
```

#### [full モード — standardに加えて以下を作成]

**DB6: Progress Update を作成：**
```sql
CREATE TABLE "Progress Update" (
  "Title" TITLE,
  "MTG Date" DATE,
  "Status" SELECT('Draft':gray, 'Ready':green, 'Shared':blue),
  "Owner" PEOPLE
)
```

**DB7: Organizations を作成：**
```sql
CREATE TABLE "Organizations" (
  "Organization Name" TITLE,
  "Category" SELECT('Customer':green, 'Investor':blue, 'Partner VC':purple, 'Partner':orange, 'Academic':yellow, 'Government':gray, 'Vendor':gray, 'Competitor':red),
  "Stage" SELECT('Lead':gray, 'Qualified':yellow, 'Active':green, 'Closed-Won':blue, 'Closed-Lost':red),
  "Market Friction Score" NUMBER,
  "Investor Sentiment" NUMBER,
  "Notes" RICH_TEXT,
  "Website" URL
)
```

**DB8: Contacts を作成：**
```sql
CREATE TABLE "Contacts" (
  "Name" TITLE,
  "Role" SELECT('Founder':purple, 'CTO':blue, 'Researcher':orange, 'Investor':green, 'Lead Investor':green, 'Academic':orange, 'Government Official':gray, 'Candidate':yellow, 'Vendor':gray, 'Other':gray),
  "Key Insight" RICH_TEXT,
  "Email" EMAIL,
  "LinkedIn" URL
)
```

---

### Step 3: リレーションの設定（Pass 2）

以下のリレーション設定を試みる（失敗した場合は手動設定の案内をする）：

- Key Results → Objectives（リレーション）
- Tasks → Key Results（リレーション）
- Tasks → Decisions（リレーション）
- Tasks → Meeting Memos（リレーション、standard/full）
- Progress Update → Meeting Memos（リレーション、fullのみ）
- Progress Update → Key Results（リレーション、fullのみ）
- Contacts → Organizations（リレーション、fullのみ）
- Meeting Memos → Organizations（リレーション、fullのみ）

リレーション設定に失敗した場合：
「リレーションの設定に失敗しました。以下の手順で手動設定してください：
 1. Tasks DBを開く → 「＋」でプロパティを追加 → Relation
 2. Key Results DBを選択」

---

### Step 4: context.mdの自動更新

`.claude/context.md` の「Notion DB IDs」セクションを作成したDBのIDで更新することを提案する。

また、CLAUDE.mdの「AI Reviewセッション設定」の `board_meeting_page_id` に
「AI Board Meeting議事録」ページを新規作成してそのIDを記入することを提案する。

---

### Step 5: 完了案内

「DBの作成が完了しました。

⚠️ 重要：各DBのページで以下の手動操作が必要です（約3分）：
1. Tasks DBのページを開く
2. 右上の「…」→「コネクト」
3. 「Generative Startup OS」インテグレーションを選択
4. 他のDBでも同様に実施

接続が完了したらテストタスクを1件作成して動作確認します。」

---

### Step 6: 動作確認

インテグレーションの接続完了を確認後、テストタスクを1件作成する。
「今週のフォーカスタスク」をTasks DBに登録して完了報告をする。

---


|---------|--------------|---------|
| DB1: Objectives | DB1 | 共通（そのまま継承） |
| DB2: Key Results | DB2 | Confidence Score追加 |
| DB3: Decisions | DB3 | Decision Type追加 |
| DB4: Tasks | DB4 | Integrity Rate計算式を0.5^n方式に統一 |
| DB5: Meeting Memos | DB5 | CategoryにAcademic追加 |
| DB7: Organizations | DB7 | LP→Investor読み替え・OIST Connection削除 |
| DB8: Contacts | DB8 | Role拡充 |
