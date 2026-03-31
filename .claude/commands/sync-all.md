# /sync-all — 日次情報同期

議事録・メモ・決定事項をNotionのDBに同期します。

## 実行手順

### Step 1: 入力収集
「今日の議事録やメモを貼り付けてください。
 GranolaまたはCirclebackからコピーしたテキストでOKです」

### Step 2: 情報の抽出と分類
貼り付けられたテキストから以下を抽出する：

**タスク（Tasks DB）：**
- 「〜する」「〜を確認する」「〜に連絡する」などの行動を抽出
- OKR Type を判定（context.mdのOKRを参照して紐付け）
- Strategic Weight を設定（最重要KR関連→3.0、その他→1.0〜2.0）
- Due Dateを推定（「今週」→今週金曜、「来月」→来月末など）

**意思決定（Decisions DB）：**
- 「〜にした」「〜と決めた」などの決定を抽出
- decisions.md形式でも記録することを提案

**知財関連（moat-strategy.md）：**
- 技術的な発見、競合との差別化要素があれば flagして提案

### Step 3: Notionへの同期提案
抽出した内容を一覧表示して確認を求める：

```
【今日のタスク（Tasks DB登録候補）】
1. [タスク名] - OKR: [KR番号] - Weight: [X] - Due: [日付]
2. ...

【意思決定（Decisions DB登録候補）】
1. [決定内容の要約]

Notionに登録しますか？ (y/n)
```

### Step 4: memory/decisions.mdの更新
意思決定があった場合、decisions.mdへの追記案を提示する：

```markdown
## [D-XXX] [タイトル] | YYYY-MM-DD
**Status:** Active
**Related KR:** [KR番号またはなし]
**Context:** [背景]
**Decision:** [決定内容]
**Rationale:** [理由]
**IP Potential:** 高/中/なし
```

### Step 5: runway-vitals.mdの確認
財務に関する情報が含まれていた場合、memory/runway-vitals.mdの更新を提案する。
