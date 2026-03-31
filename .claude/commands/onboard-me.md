# /onboard-me — 新メンバー自律オンボーディング

**発動コマンド**: `/onboard-me [role] [name]`
**使用場面**: 新しいメンバーが参加した最初のセッション
**所要時間**: 約30〜45分（AIが実行、メンバーが読む）
**Phase**: 2以降

## 概要

このスキルは、新メンバーが「この組織でどんな判断が重視され、何が禁じられ、どこに向かっているか」を
**創業者の説明なしに**30分以内に理解するための自律オンボーディングシステム。

---

## 実行プロトコル

### Step 1: 役割に基づいた関連記憶の抽出

```
引数:
  role: "CTO" / "BD" / "Research" / "Operations" / "Design" / "General"
  name: 新メンバーの名前

実行内容:
  1a. memory/decisions.md を全読み込み
      → role に関連するD-XXXを優先的に抽出
      → 抽出基準: Technical / Strategic / Operational に分類
      → 最大15件をランキング（直近5件 + role関連5件 + 最重要5件）

  1b. memory/preferences.md を読み込み
      → 文化コード・禁止パターンを抽出
      → roleに関係するものを優先

  1c. memory/moat-strategy.md を読み込み
      → Active Moatのみ抽出（Obsoleteは除外）
      → 「なぜこれが競合優位性になっているか」を追記して提示
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
[context.mdのOKRから role に紐づくKRを抽出]

## 最初の1週間でやること（推奨）
1. decisions.md を通読する（所要時間：約30分）
2. /sync-all を使って最初の会議メモを同期する
3. 今週のコミットタスクをClaude Codeに伝える
```

### Step 3: メンバー別デスクフォルダの作成

`team/[name]/` フォルダを作成し、以下のファイルを生成することを提案する：

```
team/[name]/
├── context.md      ← このメンバーのOKR・役割・PRR記録
└── desk.md         ← 個人のタスク・メモ（任意）
```

`team/[name]/context.md` の初期内容：

```markdown
# [name] — コンテキスト

## 役割と責任
role: [role]
joined: [YYYY-MM-DD]
okr_ownership: []

## 個人PRR記録
[毎週/weekly-roastが更新]

## 個人フォーカス
[毎週月曜に本人が更新]
```

### Step 4: 完了報告

オンボーディング完了後に創業者に通知：
「[name]のオンボーディングが完了しました。
 team/[name]/context.md を作成しました。
 最初の /peer-audit は来週月曜に実施することを推奨します。」
