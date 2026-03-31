# /board-prep — 取締役会・投資家報告資料の自動生成

**発動コマンド**: `/board-prep [月次/四半期/臨時]`
**Phase**: 2以降（Phase 1でも /irm-briefing の代替として利用可）

## 設計思想

取締役会資料の最大の価値は「透明性」。
AIが自己批判的な「懸念事項」セクションを自動生成することで、
創業者の「都合のいい省略」を防ぐ。

---

## データ収集フェーズ

`/board-prep` 実行時にClaude Codeが収集するデータ：

```
1. OKR進捗：Key Results DB の全KR（Current / Target / Progress%）
2. PRR推移：前回報告以降の週次PRRの平均・最低値
3. 財務：runway-vitals.md の最新値（ランウェイ・バーンレート・MRR）
4. 技術・Moat：moat-strategy.md の更新分（前回報告以降）
5. 顧客：Organizations DB の Pipeline + PMF Score
6. 採用：Contacts DB（Candidate）のステージ分布
7. 意思決定：decisions.md の前回報告以降のD-XXX一覧
8. リスク自動収集：
   - PRRが60%未満だった週の回数
   - Overdue タスクの件数
   - Closed-Lost の失注理由パターン
```

---

## 報告書フォーマット

以下のMarkdown形式で生成する：

```markdown
# [COMPANY_NAME] — [月次/四半期] 報告 | [年月]

## エグゼクティブサマリー（3行以内）
[今期最も重要な進捗・課題・判断を3行で]

## OKR進捗
| KR | 現在値 | 目標 | 進捗 | 見込み |
|----|--------|------|------|--------|
| KR1 | | | | On Track / At Risk / Off Track |

## PRR（実行の誠実性）
- 今期平均PRR：[XX]%
- 最低PRR週：[XX]%（[理由]）
- 傾向：[改善/悪化/維持]

## 財務状況
- ランウェイ：[X]ヶ月（[金額]）
- バーンレート：[X]円/月
- MRR：[X]円（前月比[+/-X]%）

## 顧客・市場
- インタビュー累計：[X]社
- PMF Score：[X]%
- Active顧客：[X]社
- Pipeline上位3社：[会社名・Stage・次のアクション]

## 技術・知財
- 新規Moat登録：[X]件
- 特許出願状況：[状況]

## 重要な意思決定（今期）
[decisions.mdから抜粋・要約]

## ⚠️ 懸念事項（AIが自動生成）
[以下をAIが自己批判的に記載:
 - OKRで遅れているKR
 - PRRが低かった週とその原因
 - 失注した案件と失注理由
 - 技術的リスク]

## 来期のフォーカス
1. [優先度1]
2. [優先度2]
3. [優先度3]

## 資金調達状況（該当する場合）
[runway-vitals.mdから抽出]
```

---

## 報告後のアクション

報告書生成後に以下を提案する：
1. decisions.mdへの「報告実施」記録（D-XXX）の追加
2. 懸念事項に対応するTasksの作成
3. 次回報告日のリマインダー設定
