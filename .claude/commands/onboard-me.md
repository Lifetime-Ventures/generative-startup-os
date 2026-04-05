# /onboard-me — 新メンバー自律オンボーディング
# Phase: 2以降
# Last Updated: v5.0

---

## Purpose

新メンバーが「この組織でどんな判断が重視され、何が禁じられ、どこに向かっているか」を
**創業者の説明なしに** 30分以内で理解するための自律オンボーディングシステム。

加えて、新メンバーの AI Coach Session設定を初期化する。

---

## When to Use

- 新しいメンバーが参加した最初のセッション
- 役割変更時（例：BDから別担当に移った場合）
- パートタイムメンバー・インターン参加時

---

## Step 0: 言語選択

```
Please choose your preferred language:
  [1] 日本語 (Japanese)
  [2] English

Type 1 or 2:
```

→ 以降の全セッションでこの設定が適用される（team/[name]/context.md に記録）

---

## Input

```
/onboard-me [role] [name]

role: Founder / CTO / Research / BD / Operations / Design / General
name: 新メンバーの名前
```

---

## 実行プロトコル

### Step 1: 役割に基づいた関連記憶の抽出

```
実行内容:
  1a. memory/decisions.md を全読み込み
      → role に関連するD-IDを優先的に抽出
      → 抽出基準: Technical / Strategic / Operational に分類
      → 最大15件をランキング（直近5件 + role関連5件 + 最重要5件）

  1b. memory/preferences.md を読み込み
      → 文化コード・禁止パターンを抽出
      → roleに関係するものを優先

  1c. memory/moat-strategy.md を読み込み
      → Active Moatのみ抽出（Obsoleteは除外）
      → 「なぜこれが競合優位性になっているか」を追記して提示

  1d. .claude/context.md を読み込み
      → 今期OKRとそのメンバーの役割に紐づくKRを抽出
```

### Step 2: パーソナライズされたオンボーディング資料の生成

以下の構造でMarkdownレポートを生成する：

```markdown
# [name]へのオンボーディング — [COMPANY_NAME] | [日付]

## あなたの役割（[role]）が担う責任
[CLAUDE.mdのteamセクションから抽出]

## この会社が大切にしていること（文化コード）
[preferences.mdから抽出・要約]

## やってはいけないこと（禁止パターン）
[preferences.mdから抽出]

## 直近の重要な意思決定（あなたの役割に関係するもの）
[decisions.mdから役割関連を抽出]

## 我々の技術的優位性（知っておくべきMoat）
[moat-strategy.mdからActive Moatを要約]

## 今期のOKRとあなたへの期待
[context.mdのOKRからroleに紐づくKRを抽出]

## 最初の1週間でやること（推奨）
1. decisions.md を通読する（所要時間：約30分）
2. /sync-all を使って最初の会議メモを同期する
3. 今週のコミットタスクをClaude Codeに伝える
4. /weekly-roast を初めて実行する（金曜）
```

### Step 3: team/[name]/ フォルダの作成

`team/[name]/` フォルダを作成し、以下のファイルを生成することを提案する：

```
team/[name]/
├── context.md    ← 役割・joined日・OKR担当・PRR記録・AI Coach設定
└── desk.md       ← 個人のタスク・メモ（任意）
```

`team/[name]/context.md` の初期内容：

```markdown
# [name] — コンテキスト

## 基本情報
role: [role]
joined: [YYYY-MM-DD]
language: [JA / EN]
okr_ownership: []

## 今週のフォーカス
[毎週月曜に更新]

## 個人PRR記録
[/weekly-roastが自動更新]

| 週 | PRR | 主な未達原因 |
|----|-----|------------|
| [YYYY-WXX] | XX% | |

## ai-coach-session 設定
最終棚卸: なし（未実施）

| 役割 | ペルソナ |
|------|---------| 
| ファシリテーター | 未設定（役割名のみで運用・変更不可） |
| メンター | 未設定（役割名のみで運用） |
| 提案者 | 未設定（役割名のみで運用） |
| 批判者 | 未設定（役割名のみで運用） |

> ペルソナは1ヶ月の運用後に月次棚卸で設定する。
> 棚卸は /weekly-roast 実行時に自動チェック（前回棚卸から28日以上経過で促す）。

## Notion議事録ページID
coach_session_page_id: [/onboard-me後にClaudeが記入]
```

### Step 4: context.md の AI Coach設定を更新

`.claude/context.md` の「AI Coach設定」セクションに新メンバーを追加することを提案する：

```yaml
coach_members:
  - name: [name]
    page_id: [新規作成したNotionページのID]
    coach_agents:
      facilitator: ファシリテーター（役割名のみ・固定）
      mentor: 未設定
      proposer: 未設定
      critic: 未設定
    last_persona_review: なし
```

### Step 5: 完了報告

オンボーディング完了後に創業者に通知：
「[name]のオンボーディングが完了しました。
 team/[name]/context.md を作成しました。
 最初の /weekly-roast は今週金曜に実施することを推奨します。
 AI Coach Sessionは /weekly-roast 実行時に自動で前段として起動します。」

---

## Limitations

- AI Coach Sessionのペルソナは1ヶ月の運用後に棚卸する（初期は役割名のみ）
- Notionの議事録ページIDはオンボーディング後に手動で context.md に記入が必要な場合がある
- 言語設定（JA/EN）は team/[name]/context.md で後から変更可能
