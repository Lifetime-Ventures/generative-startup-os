# /series-a-check — Series A Readiness Score

**発動コマンド**: `/series-a-check`
**推奨実行頻度**: 月1回（毎月第1月曜）
**Phase**: 3（Phase 2後半でも活用可）

## 概要

Series AのDDを「受けてから準備する」のではなく、「常に受けられる状態を維持する」。
25項目を自動チェックしてスコアを算出する。**目標スコア: 85点以上**。

---

## チェック項目（25項目・100点満点）

### A. 技術・知財（25点）

| ID | チェック項目 | 配点 | 確認方法 |
|----|------------|------|---------|
| A1 | Active Moatが7件以上ある | 5点 | moat-strategy.md のインデックス件数 |
| A2 | 特許出願済みまたは出願準備中が2件以上 | 5点 | moat-strategy.md の IP Action欄 |
| A3 | 重大な技術負債（High Priority）が0件 | 5点 | Tasks DBのTypeが「Technical Debt」かつPriority「🔴」の件数 |
| A4 | 実験ログが直近3ヶ月分存在する | 5点 | memory/experiment-log.md の記録件数 |
| A5 | 技術的背理法（競合が失敗する理由）が3件以上文書化 | 5点 | moat-strategy.md の「Why competitors can't copy」セクション |

### B. 市場・顧客（25点）

| ID | チェック項目 | 配点 | 確認方法 |
|----|------------|------|---------|
| B1 | PMF Score が30%以上 | 7点 | Organizations DB の Pain Score集計 |
| B2 | Pain Score ≥ 7 の顧客が5社以上 | 6点 | Organizations DB フィルター |
| B3 | 有料顧客またはLOI（意向書）が3件以上 | 6点 | Organizations DB（Closed-Won） |
| B4 | 直近30日以内に顧客MTGがある | 3点 | Meetings DB の日付確認 |
| B5 | 失注理由が全Closed-Lost案件に記録されている | 3点 | Organizations DB の Notes欄 |

### C. 実行・ガバナンス（25点）

| ID | チェック項目 | 配点 | 確認方法 |
|----|------------|------|---------|
| C1 | decisions.md に60件以上の記録がある | 7点 | decisions.md のインデックス件数 |
| C2 | 過去8週間のPRR平均が65%以上 | 6点 | .claude/context.md のPRR記録 |
| C3 | 週次チェックインを8週連続で実施している | 4点 | /weekly-roast の実行履歴 |
| C4 | OKR未紐付けタスクが全体の20%未満 | 4点 | Tasks DB の OKR-Unbound件数÷総件数 |
| C5 | 月次の /board-prep を3ヶ月連続で実施している | 4点 | decisions.md の「報告実施」記録 |

### D. チーム・採用（25点）

| ID | チェック項目 | 配点 | 確認方法 |
|----|------------|------|---------|
| D1 | /onboard-me を全メンバーが実行済み | 7点 | team/ フォルダの存在確認 |
| D2 | 主要ポジションの採用計画が存在する | 6点 | Contacts DB（Candidate）のパイプライン |
| D3 | preferences.md の文化コードが5件以上 | 4点 | preferences.md の記載件数 |
| D4 | 創業者不在でもメンバーが1週間業務継続できる状態 | 4点 | narrative-check の Bus Factor スコア |
| D5 | 財務責任者または CFO 候補が存在する | 4点 | Contacts DB または team/ フォルダ |

---

## スコア判定と推奨アクション

```
85-100点: DD Ready ✅
  「Series Aのタームシートを受け取れる状態です」

70-84点: あと少し ⚠️
  「以下のX項目を改善すれば85点に到達します：[不足項目リスト]」

50-69点: 準備不足 🔴
  「Series Aより先に以下を優先してください：[優先改善項目]」

50点未満: Phase 2に戻る
  「組織の基盤固めが先です。/onboard-me と /peer-audit に集中してください」
```

---

## 月次レポート形式

```
📊 Series A Readiness Score | [年月]

総合スコア: XX/100点 [目標: 85点]

A. 技術・知財:  XX/25点
B. 市場・顧客:  XX/25点
C. 実行・ガバナンス: XX/25点
D. チーム・採用: XX/25点

重点改善項目（スコアアップに最も効果的なもの）:
1. [項目名]（+X点）：[具体的なアクション]
2. [項目名]（+X点）：[具体的なアクション]
3. [項目名]（+X点）：[具体的なアクション]

次回チェック予定: [来月第1月曜日]
```
