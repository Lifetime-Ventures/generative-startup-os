# /moat-capture — 知財・技術障壁の記録
# Phase: 1以降
# Last Updated: v5.0

---

## Purpose

技術的発見・競合優位性を memory/moat-strategy.md に記録する。
ディープテック創業者のコアスキル。

---

## When to Use

- 実験・会議・調査から技術的突破口を発見したとき
- 競合との差別化要素を言語化したいとき
- /sync-all 実行時に IP Flagが立ったタスクがある場合

---

## 実行手順

### Step 1: 発見の聞き取り
「今日の実験・会議・調査から、競合には真似できないことを発見しましたか？
 以下のどれかに当てはまれば教えてください：
 - 技術的な突破口（競合が5年以上かかる）
 - データの蓄積（我々にしかないデータセット）
 - 研究者の知見（論文化できていない暗黙知）
 - 製造プロセスの独自性
 - 顧客との独占的な関係」

### Step 2: Moatの分類と記録
入力をもとに以下のフォーマットで moat-strategy.md への追記案を提示する：

```markdown
## [MT-XXX] [タイトル] | YYYY-MM-DD
**Category:** Patent / Trade Secret / Data / Know-how / Network
**Status:** Active
**Description:** [発見の内容]
**Why competitors can't copy:** [技術的背理法：競合がこれをできない理由]
**Evidence:** [実験データや文献があれば]
**IP Action:** Patent出願検討 / 秘匿維持 / 防衛的公開 / 対応不要
```

### Step 3: IP Flagの設定

関連するTasksやDecisions（DB3・DB4）にIP Flagを立てることを提案する。

### Step 4: experiment-log.mdへの連携

実験に基づく発見の場合、memory/experiment-log.md への記録も提案する。
「技術的背理法（Proof by Contradiction）」の形式で記録することで、
特許出願の根拠・DDでの説明材料として機能させる。

---

## Limitations

- IP評価（Patent出願 vs 秘匿維持）の最終判断は弁護士確認が必要
- 「競合がこれをできない理由」は最も重要なフィールド。スキップ不可
