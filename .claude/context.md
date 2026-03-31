# Generative Startup OS — 詳細コンテキスト

## フェーズ自動判定ロジック
起動時に以下を確認して現フェーズを判定する：
- TEAM_SIZE = 1 → Phase 1
- TEAM_SIZE = 2 → Phase 2
- TEAM_SIZE ≥ 3 → Phase 3
- decisions.md が30件以上 かつ Notion 7DBが稼働 かつ TEAM_SIZE ≥ 2 → Phase 2移行準備完了
- decisions.md が60件以上 かつ team/ フォルダにメンバーが存在 → Phase 3移行準備完了

## 初回セットアップ手順

CLAUDE.mdの[COMPANY_NAME]が未置換の場合に以下を実行する。
日本語で一つずつ質問してください：

**Q1（コア技術と差別化）：**
「あなたの技術・製品の核心を1文で教えてください。
 競合や既存の手法と比べて、何が根本的に違いますか？
 例：従来比10倍の感度で〇〇を検出できる」

**Q1.5（技術障壁）：**
「あなたの技術や知見の中で、外部の人が1年以内に再現するのが難しいと思うものは何ですか？
 特許・秘匿ノウハウ・データ・製造プロセスのどれに近いですか？
 （答えにくければスキップ可）」

**Q2（今期の目標）：**
「今から3ヶ月後、何ができていれば『この3ヶ月は成功だった』と言えますか？
 例：大学病院と共同研究契約を1件締結している」

**Q3（測定指標・任意）：**
「その成功を証明するとしたら、何の数字で示せますか？
 数字が思い浮かばなければスキップして次に進んでください」

**Q4（過去の学習）：**
「これまでの研究・開発・ビジネスの経験から、繰り返したくない判断パターンはありますか？
 例：検証なしに次の実験ステージへ進んでしまった」

**Q5（今週）：**
「今週、最も時間をかけるべきことを1つだけ教えてください」

回答が揃ったら：
1. CLAUDE.mdと本ファイルのプレースホルダーを更新することを提案
2. 承認後に両ファイルを更新
3. /setup-mcp を実行することを提案

---

## 今期のOKR
[初回セットアップ後にClaudeが記入]

Objective 1：
  KR1：　現在値： / 目標： / 重要度： / Strategic Weight：
  KR2：　現在値： / 目標： / 重要度： / Strategic Weight：

---

## Notion DB IDs
[/setup-notion実行後にClaudeが自動記入]

tasks_db:
decisions_db:
objectives_db:
key_results_db:
meetings_db:
organizations_db:
contacts_db:

---

## MCP設定ステータス
[/setup-mcp実行後にClaudeが記入]

notion:
google_calendar:
slack:

---

## Strategic Weight マッピング

| KRの重要度 | Tasksに設定する値 |
|-----------|----------------|
| 最重要KR | 3.0 |
| 重要KR | 2.0 |
| 標準KR | 1.5 |
| 標準以下 | 1.0 |
| 運営業務（Non-OKR） | 0.5 |
| 未分類 | 0.3（分類促進ペナルティ） |

---

## フェーズ移行チェックリスト

### Phase 1 → Phase 2 移行条件
- [ ] decisions.md に30件以上の記録
- [ ] moat-strategy.md に3件以上のMoat登録
- [ ] Notion 7DBが稼働（少なくともTasks/Decisions/OKR）
- [ ] PRR 4週連続で60%以上
- [ ] 共同創業者またはフルタイムメンバーが確定

### Phase 2 → Phase 3 移行条件
- [ ] decisions.md に60件以上の記録
- [ ] /onboard-me を新メンバー全員が実行済み
- [ ] PMF Score が15%以上（Organizations DBで確認）
- [ ] チームメンバーが3名以上
- [ ] peer-audit を月2回以上実施済み

---

## 1週間後のVCキックオフMTG確認リスト

- [ ] CLAUDE.mdのOKRセクションが埋まっているか
- [ ] decisions.mdに最低1件の記録があるか
- [ ] /sync-allが少なくとも1回実行されているか
- [ ] Tasks DBにタスクが入力されているか
- [ ] MCP接続が動作しているか
- [ ] KRに具体的な数値が入っているか（「精度を上げる」ではなく「10ppm→1ppm」）
