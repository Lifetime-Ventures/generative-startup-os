# Generative Startup OS — 詳細コンテキスト
# v5.0

---

## フェーズ自動判定ロジック
起動時に以下を確認して現フェーズを判定する：
- TEAM_SIZE = 1 → Phase 1
- TEAM_SIZE = 2 → Phase 2
- TEAM_SIZE ≥ 3 → Phase 3
- decisions.md が30件以上 かつ Notion 8DBが稼働 かつ TEAM_SIZE ≥ 2 → Phase 2移行準備完了
- decisions.md が60件以上 かつ team/ フォルダにメンバーが存在 → Phase 3移行準備完了

---

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

Confidence Score（KR自動算出）:
  算出式: (Current/Target) × min(1, PRR4週平均/0.75)
  < 0.4 → 🔴 達成困難 / 0.4〜0.6 → 🟡 要注意 / > 0.7 → 🟢 順調

---

## Notion DB IDs
[/setup-notion実行後にClaudeが自動記入]

objectives_db:
key_results_db:
decisions_db:
tasks_db:
meeting_memos_db:
progress_update_db:
organizations_db:
contacts_db:

---

## MCP設定ステータス
[/setup-mcp実行後にClaudeが記入]

notion:
google_calendar:
granola:
circleback:
slack:
gmail:

---

## AI Board設定（週次Board Meetingのエージェント構成）
[初回セットアップ後、または/setup-notion後に記入]

> ここを自分のスタートアップに合わせてカスタマイズしてください。
> Board Meetingの議事録置き場はNotionのboard_meeting_page_idに記録されます。

board_meeting_page_id: [Notionページ IDを記入]
board_meeting_day: sunday  # Board Meetingを実施する曜日（推奨：日曜夜）
board_meeting_time: 20:00  # 開始時間（推奨：20:00以降）

board_members:
  - role: ファシリテーター
    persona: 中立的な議事進行役
    description: 議事進行・時間管理・論点整理・アクション確定

  - role: 投資家
    persona: [任意で具体的な人物・タイプを記入]
    description: 資金調達・ビジネスモデル・投資家目線での評価
    example: "グロース投資の経験豊富なVCパートナー"

  - role: 技術/科学
    persona: [任意で具体的な人物・タイプを記入]
    description: 技術的実現可能性・研究から事業化の接続・知財
    example: "深い技術理解を持つCTO経験者"

  - role: 顧客/市場
    persona: [任意で具体的な人物・タイプを記入]
    description: 顧客視点・PMF・市場の現実
    example: "あなたの技術の潜在的な顧客側の意思決定者"

  - role: 起業家
    persona: [任意で具体的な人物・タイプを記入]
    description: 創業者目線・現場感・実行の現実
    example: "同じ技術領域で創業した連続起業家"

board_agenda_rotation:
  week1: プロダクト・技術進捗（コアKRの現状）
  week2: 顧客開発・市場開拓（PMF進捗）
  week3: 資金調達・投資家対応（IRM進捗）
  week4: ビジョン・戦略レビュー（中長期）
  month_first_week: 月次戦略回（足元オペレーション禁止・中長期専用）

---

## AI Coach設定（メンバー向け週次コーチングセッション）
[Phase 2以降・/onboard-me実行後に記入]

coach_members: []
# 例:
# - name: [メンバー名]
#   page_id: [Notionページ ID]
#   coach_agents:
#     facilitator: ファシリテーター（役割名のみ・固定）
#     mentor: [任意のペルソナ]
#     proposer: [任意のペルソナ]
#     critic: [任意のペルソナ]
#   last_persona_review: YYYY-MM-DD

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

## PRR計算式

```
PRR = 完了タスクの加重工数合計 ÷ コミットした全タスクの加重工数合計

加重工数 = Est Hours × Strategic Weight × Integrity Rate

Integrity Rate = 1.0 × (0.5 ^ Penalty Count)
  期限変更0回 → 1.0
  期限変更1回 → 0.5
  期限変更2回 → 0.25
  期限変更3回 → 0.125（実質ゼロ）
```

判定ゾーン：
- 90%以上 → 約束が軽すぎる
- 75〜89% → 🟢 健全（目標ゾーン）
- 60〜74% → 🟡 注意
- 60%未満 → 🔴 危険

---

## フェーズ移行チェックリスト

### Phase 1 → Phase 2 移行条件
- [ ] decisions.md に30件以上の記録
- [ ] moat-strategy.md に3件以上のMoat登録
- [ ] Notion 8DBが稼働（少なくともTasks/Decisions/OKR）
- [ ] PRR 4週連続で60%以上
- [ ] 共同創業者またはフルタイムメンバーが確定

### Phase 2 → Phase 3 移行条件
- [ ] decisions.md に60件以上の記録
- [ ] /onboard-me を新メンバー全員が実行済み
- [ ] PMF Score が15%以上（Organizations DBで確認）
- [ ] チームメンバーが3名以上
- [ ] peer-audit を月2回以上実施済み

---

## 初期セットアップ完了チェックリスト

- [ ] CLAUDE.mdのOKRセクションが埋まっているか
- [ ] decisions.mdに最低1件の記録があるか
- [ ] /sync-allが少なくとも1回実行されているか
- [ ] Tasks DBにタスクが入力されているか
- [ ] MCP接続が動作しているか
- [ ] KRに具体的な数値が入っているか（「精度を上げる」ではなく「10ppm→1ppm」）
