# Notion DB Schemas — 9DB Aspirational Design

> **Status**: Aspirational design from pre-reset exploration. NOT the v0.1.0 schema. NOT a committed v2 schema. Materials archive for future v2+ schema design discussions.
>
> **For the current v0.1.0 schema**, see `notion-templates/README.md` at the repo root (6-DB design with Mission page).
>
> **For the cherry-pick narrative**, see `future-plan/ideas/` directory (each idea is independently mergeable).

This document captures the 9-DB schema explored in the pre-reset Claude Code-first hypothesis. It includes design choices that may inform a future v2 schema PR — but the document as a whole describes a different product than v0.1.0.

Important divergences from v0.1.0:
- 9 DBs instead of 6
- New Inbox DB (Layer 1 / receipt)
- New Progress Update DB
- New Organizations DB with deep-tech Stage vocabulary
- New Contacts DB
- Decision Type 6-category property (IP independent)
- Tasks (= Weekly Commitment) with Self-caused Delay + External Delay split
- Hybrid internationalization (English fields, EN/JA bilingual select options)

These divergences are explored individually as cherry-pick candidates in `future-plan/ideas/*.md`. The full 9-DB schema below is presented as the integrated design that produced these candidates.

---

- 5レイヤー情報ライフサイクルの **リレーション設計**

---

## 5レイヤー情報ライフサイクル

```
[Layer 1: 受信]   Inbox
       ↓ Triaged_To
[Layer 2: 加工]   Meeting Memos / Progress Update
       ↓ Generated
[Layer 3: 判断]   Decisions / (Moat in memory)
       ↓ Spawned
[Layer 4: 実行]   Tasks → Key Results → Objectives
       ↓ Connected
[Layer 5: 関係]   Organizations / Contacts
```

---

## Foundation バリアント別の DB

| バリアント | 含まれるDB | 適用条件 |
|---|---|---|
| **Starter** | Inbox, Meeting Memos, Decisions (3DB) | 初日〜1週間 |
| **Standard** | + Tasks, Objectives, Key Results (6DB) | 1週間〜1ヶ月 |
| **Full** | + Progress Update, Organizations, Contacts (9DB) | 1ヶ月以降 |

---

## 国際化対応の原則

| 要素 | ルール | 例 |
|---|---|---|
| DB名 | 英語固定 | `Decisions` |
| フィールド名 | 英語固定 | `Trade-off`, `Assumption` |
| Field Description | 英日併記 | `The cost of this option / この選択の代償` |
| Select 選択肢 | 英日併記 | `Active / 進行中` |
| 本文・メモ | 創業者の母語自由 | (日本語/英語/その他) |

---

## Layer 1: Inbox (DB9)

| Field | Type | Description |
|---|---|---|
| Subject/Snippet | TITLE | Subject or first sentence / 件名または冒頭抜粋 |
| Channel | SELECT | Technical source (see below) |
| Source Type | SELECT | Semantic source (see below) |
| Sender | RICH_TEXT | Sender name and address / 送信者 |
| Direct Mention | CHECKBOX | Was I directly addressed? / 自分への直接メンションか |
| OKR Relevance | NUMBER | AI-scored relevance 1-10 / AI判定スコア |
| Received At | DATE | Receipt timestamp / 受信日時 |
| Status | SELECT | Workflow state (see below) |
| AI Summary | RICH_TEXT | AI-generated summary / AI要約 |
| Original Link | URL | Source link / 元データへのリンク |
| Body | RICH_TEXT | Full body (mind sensitive data) / 本文 |
| Triaged To Decision | RELATION → Decisions | Promoted to decision |
| Triaged To Task | RELATION → Tasks | Promoted to task |
| Triaged To Memo | RELATION → Meeting Memos | Promoted to memo |
| Triaged To Organization | RELATION → Organizations | Linked organization |

**Channel** (技術的経路): `Gmail / メール`, `Slack`, `VoiceMemo / 音声メモ`, `QuickCapture / Quick Capture`, `WebClip / Webクリップ`, `RSS / RSS`, `Manual / 手動`, `Other / その他`

**Source Type** (情報の意味): `Investor / 投資家`, `Customer / 顧客`, `Hiring / 採用`, `Partner / パートナー`, `Mentor / メンター`, `Industry / 業界`, `Research / 研究`, `Internal / 内部`, `Other / その他`

**Status**: `Unread / 未読`, `Triaged / 仕分け済`, `Archived / 保管`

---

## Layer 2: Meeting Memos (DB5)

| Field | Type | Description |
|---|---|---|
| Meeting Name | TITLE | 会議名 |
| Date | DATE | 開催日 |
| Category | SELECT | Meeting category (see below) |
| Source | SELECT | Recording source (see below) |
| Raw Transcript URL | URL | Recording / transcript link |
| AI Summary | RICH_TEXT | AI-generated summary / AI要約 |
| Attendees | PEOPLE | Internal participants / 内部出席者 |
| External Contacts | RELATION → Contacts | External attendees |
| Related Organization | RELATION → Organizations | Org context |
| Generated Decisions | RELATION → Decisions | Decisions made |
| Generated Tasks | RELATION → Tasks | Tasks created |

**Category**: `Investor / 投資家`, `Customer / 顧客`, `Academic / 学術`, `Hiring / 採用`, `Partner / パートナー`, `Mentor / メンター`, `Internal / 内部`, `External / 外部`

**Source**: `Granola`, `Circleback`, `Manual / 手動`, `VoiceMemo / 音声メモ`, `Other / その他`

---

## Layer 2: Progress Update (DB6) — Standard以上

| Field | Type | Description |
|---|---|---|
| Title | TITLE | e.g. "2026-W18 Board Update" |
| MTG Date | DATE | Target meeting date |
| Status | SELECT | `Draft / 下書き`, `Ready / 完成`, `Shared / 共有済` |
| Owner | PEOPLE | Author |
| Related Meeting | RELATION → Meeting Memos | |
| Related KRs | RELATION → Key Results | |

---

## Layer 3: Decisions (DB3) — 中核DB

| Field | Type | Description |
|---|---|---|
| D-ID | TITLE | Unique ID e.g. D-042 / 一意のID |
| Status | SELECT | Lifecycle state (see below) |
| Decision Type | SELECT | **6 categories (v6.1 redesigned)** (see below) |
| Trade-off | RICH_TEXT | The cost of this choice / この選択の代償 (REQUIRED) |
| Assumption | RICH_TEXT | The premise this depends on / 依拠する前提 (REQUIRED) |
| IP Potential | SELECT | Patent/secret potential (see below) |
| Date | DATE | Decision date / 意思決定日 |
| Created | CREATED_TIME | Auto |
| Spawned Tasks | RELATION → Tasks | Tasks from this decision |
| Source Memo | RELATION → Meeting Memos | Origin meeting if any |
| Source Inbox | RELATION → Inbox | Origin inbox item if any |

**Status**: `Active / 進行中` (green), `Pivoted / 方針転換` (yellow), `Obsolete / 失効` (gray)

**Decision Type (v6.1の6カテゴリ・IP独立)**:
- `Strategic / 戦略` (blue) — Pivot, Market, Capital
- `People / 人事` (purple) — Hiring, Org structure
- `Technical / 技術` (orange) — Product, Architecture
- `IP / 知財` (red) — Patent, Trade secret, License (**v6.1新設・独立**)
- `Partnership / 提携` (green) — Strategic alliances
- `Governance / 統治` (gray) — Culture, Compliance

**IP Potential**: `High / 高` (red), `Medium / 中` (yellow), `None / なし` (gray)

---

## Layer 4: Tasks (DB4) — Standard以上 — PRR計算ソース

| Field | Type | Description |
|---|---|---|
| Task Name | TITLE | タスク名 |
| Status | SELECT | Workflow state (see below) |
| OKR Type | SELECT | OKR linkage (see below) |
| Priority | SELECT | Priority (see below) |
| Est. Hours | NUMBER | Estimated hours / 工数見積もり |
| Strategic Weight | NUMBER | KR importance 1.0-3.0 |
| **Self-caused Delay** | NUMBER | **(v6.1)** Internal delay count / 自分由来の遅延回数 |
| **External Delay** | NUMBER | **(v6.1)** External factor delay count / 外部要因の遅延回数 |
| Reliability Index | FORMULA | `pow(0.5, prop("Self-caused Delay"))` |
| Weighted Load | FORMULA | `prop("Est. Hours") * prop("Strategic Weight") * prop("Reliability Index")` |
| Assignee | PEOPLE | 担当者 |
| Due Date | DATE | 期限 |
| IP Flag | CHECKBOX | 知財関連 |
| Related KR | RELATION → Key Results | |
| Related Decision | RELATION → Decisions | |
| Source Memo | RELATION → Meeting Memos | |

**Status**: `Inbox / 未着手`, `Today / 今日`, `Doing / 実行中`, `Done / 完了`, `Delayed / 遅延`, `Cancelled / キャンセル`

**OKR Type**: `OKR-Direct / OKR直結`, `Operational / 運営`, `Unbound / 未分類`

**Priority**: `🔴 Urgent / 今日`, `🟠 This Week / 今週`, `🟡 This Month / 今月`

**v6.1の重要変更**: Penalty Count 単一フィールドを **Self-caused Delay** + **External Delay** に分離。

理由: ディープテック創業者は外部要因 (実験装置故障、試薬ロット不良、共同研究者の遅延) による遅延が頻発する。 v6.0 ではこれが Penalty Count に加算され、PRR の意味が崩壊していた。

新しい計算:
```
Reliability Index = 0.5 ^ Self-caused Delay
  (External Delay は計算に含まない)

Weighted Load = Est. Hours × Strategic Weight × Reliability Index

PRR (週次) = Done タスクの Weighted Load 合計 / 全コミットタスクの Weighted Load 合計
```

External Delay は別途記録され、 /weekly-roast で「外部要因が多い時期」を分析できる。

---

## Layer 4: Objectives (DB1) — Standard以上

| Field | Type | Description |
|---|---|---|
| Objective Name | TITLE | Goal name |
| Narrative | RICH_TEXT | Why this matters / なぜこの目標か |
| Status | SELECT | `Active / 進行中`, `Achieved / 達成`, `Paused / 保留` |
| Quarter | RICH_TEXT | e.g. 2026-Q2 |
| Owner | PEOPLE | Responsible |
| Created | CREATED_TIME | Auto |

---

## Layer 4: Key Results (DB2) — Standard以上

| Field | Type | Description |
|---|---|---|
| KR Name | TITLE | KR description |
| Target Value | NUMBER | 目標値 |
| Current Value | NUMBER | 現在値 |
| Unit | RICH_TEXT | 単位 (社/件/円/% etc.) |
| Strategic Weight | NUMBER | 1.0-3.0 |
| Status | SELECT | `On Track / 順調`, `At Risk / 要注意`, `Off Track / 危険`, `Achieved / 達成` |
| Confidence | SELECT | `🟢 High / 高`, `🟡 Medium / 中`, `🔴 Low / 低` |
| Progress % | FORMULA | `if(prop("Target Value") == 0, 0, round(prop("Current Value") / prop("Target Value") * 100))` |
| Owner | PEOPLE | |
| Objective | RELATION → Objectives | Parent |

---

## Layer 5: Organizations (DB7) — Full以上

> **注**: ここでの「Stage」は **CRMの顧客・投資家ステージ** を指し、 GSOS の「環境」(Foundation/Connected/Automated) とは別の概念です。

| Field | Type | Description |
|---|---|---|
| Organization Name | TITLE | Org name (anonymize as needed) |
| Category | SELECT | Org type (see below) |
| **Stage (CRM)** | SELECT | **(v6.1 redesigned for deep tech)** (see below) |
| Market Friction Score | NUMBER | Customer pain 1-10 (Customer only) |
| Investor Sentiment | NUMBER | Investor interest 1-10 (Investor only) |
| Notes | RICH_TEXT | Memo |
| Website | URL | Public site |

**Category**: `Customer / 顧客`, `Investor / 投資家`, `Partner VC / 共同投資家`, `Partner / 事業パートナー`, `Academic / 学術機関`, `Government / 行政`, `Vendor / ベンダー`, `Competitor / 競合`

**Stage (v6.1のディープテック向け再設計)**:
- `First Contact / 初接触` (gray) — Initial outreach
- `Pain Validated / 課題確認済` (yellow) — Pain Score ≥ 5 confirmed
- `PoC In Progress / PoC進行中` (green) — Pilot underway
- `Contracted / 契約締結` (blue) — Commercial contract signed
- `Walked Away / 離脱` (red) — No further engagement (with reason)

**v6.1の変更理由**: 旧 `Lead/Qualified/Active/Closed-Won/Closed-Lost` は SaaS Sales Funnel 用語で、ディープテックの 3-6ヶ月 PoC期間と齟齬があった。新用語はディープテックB2B の長期顧客開発プロセスを表現する。

---

## Layer 5: Contacts (DB8) — Full以上

| Field | Type | Description |
|---|---|---|
| Name | TITLE | Person name (anonymize as needed) |
| Role | SELECT | Role (see below) |
| Key Insight | RICH_TEXT | Important insight from this person |
| Email | EMAIL | (consider sensitivity) |
| LinkedIn | URL | Public profile |
| Related Organization | RELATION → Organizations | Affiliated org |
| Last Contact | DATE | Last interaction date |

**Role**: `Founder / 創業者`, `CTO / CTO`, `Researcher / 研究者`, `Investor / 投資家`, `Lead Investor / リード投資家`, `Academic / 学術`, `Government Official / 行政`, `Mentor / メンター`, `Candidate / 採用候補`, `Vendor / ベンダー`, `Other / その他`

---

## DB schema version 管理

`.claude/state.yaml` に `db_schema_version` フィールド:

```yaml
db_schema_version: "6.1"   # or "6.0" for legacy mode
```

- **6.0 (legacy)**: v6.0 時代のスキーマで運用継続。新機能リリースは v6.1+ のみで、 6.0 環境では受けられない。
- **6.1**: v6.1 新スキーマ。 6カテゴリ Decision Type、 Self-caused/External Delay 分離、 ディープテック Stage。

移行は `scripts/migrate-v6.0-to-v6.1.sh` (リポジトリ側) と `/setup-notion migrate` コマンド (Notion DB側) を順次実行。

---

## DB Extensions Library (v6.2 予定)

v6.2 で `notion-templates/extensions/` に追加予定:

- `patents-db` — 特許管理
- `publications-db` — 論文・学会発表
- `experiments-db` — 実験ログのDB版
- `cap-table-db` — 資本政策表
- `hires-pipeline-db` — 採用パイプライン
- `competitors-db` — 競合トラッキング
- `investors-deep-db` — 投資家詳細管理

各 extension は単独でインポート可能。 LtV が領域モジュール (bio/saas/hardware) としてバンドル提供。

---

## 関連ドキュメント

- [README.md](./README.md) — テンプレート利用ガイド
- [variants/README.md](./variants/README.md) — Foundation 3バリアント詳細
- [extensions/README.md](./extensions/README.md) — 拡張DB ライブラリ (v6.2)
- [.claude/commands/setup-notion.md](../.claude/commands/setup-notion.md) — Claude経由の自動構築
