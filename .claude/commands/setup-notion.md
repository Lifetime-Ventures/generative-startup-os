# /setup-notion — Notion DBの自動構築

## 使い方
```
/setup-notion quick     → Tasks + Decisions（推奨：最初はこれ）
/setup-notion standard  → Objectives + Key Results + Tasks + Decisions + Meetings
/setup-notion full      → 全7DB（CRM含む）
```

## 実行前の確認
Notion MCPが設定・接続済みであることが必要です。
未設定の場合は先に `/setup-mcp` を実行してください。

## 実行手順

### Step 1: 作成先の確認
「NotionでDBを作成したいページのURLを教えてください」
→ URLからページIDを抽出する（末尾32文字）

### Step 2: DB作成（Pass 1 — リレーションなし）

**[quick モード]**

**Decisions DB を作成：**
```sql
CREATE TABLE "Decisions" (
  "Name" TITLE,
  "Status" SELECT('Active':green, 'Pivoted':yellow, 'Obsolete':gray),
  "IP Potential" SELECT('高':red, '中':yellow, 'なし':gray),
  "Context" RICH_TEXT,
  "Rationale" RICH_TEXT,
  "Date" DATE,
  "Created" CREATED_TIME
)
```

**Tasks DB を作成：**
```sql
CREATE TABLE "Tasks" (
  "Name" TITLE,
  "Status" SELECT('Inbox':gray, 'To Do':blue, 'In Progress':yellow, 'Done':green, 'Delayed':orange, 'Canceled':red),
  "Priority" SELECT('🔴 Urgent':red, '🟠 High':orange, '🟡 Normal':yellow, '⚪ Low':gray),
  "Type" SELECT('R&D':purple, 'Engineering':blue, 'External':green, 'Operational':gray, 'Legal':red),
  "Est Hours" NUMBER,
  "Strategic Weight" NUMBER,
  "Deadline Changes" NUMBER,
  "Due Date" DATE,
  "IP Flag" CHECKBOX,
  "OKR Type" SELECT('OKR-Direct':green, 'Operational':blue, 'Unbound':gray),
  "Weighted Load" FORMULA('prop("Est Hours") * prop("Strategic Weight")')
)
```

**[standard モード — quickに加えて以下を作成]**

**Objectives DB を作成：**
```sql
CREATE TABLE "Objectives" (
  "Name" TITLE,
  "Status" SELECT('Active':green, 'Completed':blue, 'On Hold':gray),
  "Quarter" RICH_TEXT,
  "Owner" PEOPLE,
  "Created" CREATED_TIME
)
```

**Key Results DB を作成：**
```sql
CREATE TABLE "Key Results" (
  "Name" TITLE,
  "Target" NUMBER,
  "Current" NUMBER,
  "Unit" RICH_TEXT,
  "Weight" NUMBER,
  "Status" SELECT('On Track':green, 'At Risk':yellow, 'Off Track':red, 'Achieved':blue),
  "Confidence" SELECT('🟢 高':green, '🟡 中':yellow, '🔴 低':red),
  "Progress %" FORMULA('if(prop("Target") == 0, 0, round(prop("Current") / prop("Target") * 100))')
)
```

**Meetings DB を作成：**
```sql
CREATE TABLE "Meetings" (
  "Name" TITLE,
  "Date" DATE,
  "Type" SELECT('Customer':green, 'Investor':blue, 'Internal':gray, 'Partner':purple),
  "Pain Score" NUMBER,
  "Attendees" PEOPLE,
  "Summary" RICH_TEXT,
  "Next Actions" RICH_TEXT
)
```

**[full モード — standardに加えて以下を作成]**

**Organizations DB を作成：**
```sql
CREATE TABLE "Organizations" (
  "Name" TITLE,
  "Type" SELECT('Customer':green, 'Investor':blue, 'Partner':purple, 'Competitor':red, 'Candidate':yellow),
  "Stage" SELECT('Lead':gray, 'Qualified':yellow, 'Active':green, 'Closed-Won':blue, 'Closed-Lost':red),
  "Pain Score" NUMBER,
  "Notes" RICH_TEXT,
  "Website" URL
)
```

**Contacts DB を作成：**
```sql
CREATE TABLE "Contacts" (
  "Name" TITLE,
  "Role" RICH_TEXT,
  "Email" EMAIL,
  "Type" SELECT('Customer':green, 'Investor':blue, 'Partner':purple, 'Candidate':yellow),
  "Notes" RICH_TEXT
)
```

### Step 3: リレーションの設定（Pass 2）
以下のリレーション設定を試みる（失敗した場合は手動設定の案内をする）：

- Key Results → Objectives（リレーション）
- Tasks → Key Results（リレーション）
- Tasks → Meetings（リレーション、standardとfull）
- Contacts → Organizations（リレーション、fullのみ）

リレーション設定に失敗した場合：
「リレーションの設定に失敗しました。以下の手順で手動設定してください：
 1. Tasks DBを開く → 「＋」でプロパティを追加 → Relation
 2. Key Results DBを選択」

### Step 4: context.mdの自動更新
`.claude/context.md` の「Notion DB IDs」セクションを作成したDBのIDで更新することを提案する。

### Step 5: 完了案内
「DBの作成が完了しました。

⚠️ 重要：各DBのページで以下の手動操作が必要です（約3分）：
1. Tasks DBのページを開く
2. 右上の「…」→「コネクト」
3. 「Generative Startup OS」インテグレーションを選択
4. Decisions DBでも同様に実施

接続が完了したらテストタスクを1件作成して動作確認します。」

### Step 6: 動作確認
インテグレーションの接続完了を確認後、テストタスクを1件作成する。
「今週のフォーカスタスク」をTasks DBに登録して完了報告をする。
