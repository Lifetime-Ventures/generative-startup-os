# Generative Startup OS

**ディープテック・スタートアップのためのAI組織OS**
*Created by Lifetime Ventures × OIST*

---

OISTや日本のアカデミア発の科学技術が世界に届くまでに、数百の判断がある。
Lifetime Ventures はその判断に伴走するために、このOSを投資先に提供する。

あなたには、論文には書いていない判断の積み重ねがある。
**このOSは、その判断をAIとともに記録し続け、共同創業者が来ても、投資家が変わっても消えない会社の知識にする。**

> Series Aのデューデリジェンスで「なぜその判断をしたか」「どのように技術優位性を積み上げたか」を説明できる会社になる。

---

## はじめる（Claude Code）

```bash
# 1. このリポジトリを「Use this template」でコピー（Private必須）

# 2. Claude Codeをインストール
brew install node                          # Mac
npm install -g @anthropic-ai/claude-code
claude auth login

# 3. リポジトリをクローンして起動
git clone https://github.com/[ユーザー名]/generative-startup-os.git
cd generative-startup-os
claude
```

**後はClaudeが案内します。** 6つの質問に答えるだけで、MCP設定・Notion DB構築・メモリファイル生成が自動完了します。

詳しいセットアップ手順（Mac/Windows/Claude.ai版）→ [README_SETUP.md](./README_SETUP.md)

---

## Claude.aiブラウザ版でも使えます

Claude CodeなしでもClaude.aiのブラウザ版から使えます。
Notion自動連携・カレンダーブロックなどの自動機能は動作しませんが、
AI Board Meeting・週次レビュー・OKR分析などの思考支援機能はフル活用できます。

→ 詳細は [README_SETUP.md](./README_SETUP.md) の「Claude.aiでの使い方」を参照

---

## 3つのフェーズと全機能

### Phase 1 — プレチーム（Founder 1名）
**課題**: 創業者の思考・判断・知財をAIが記憶し続ける

| コマンド | 機能 |
|---------|------|
| `/setup-mcp` | Notion・Calendar・Granola等のMCP設定を自動生成（Claude Code vs Claude.ai比較付き） |
| `/setup-notion` | Notion 8DBを自動構築（quick/standard/full） |
| `/sync-all` | 6ソース並列スキャン → Notion DB網羅転記 → 翌日フォーカス確定 → カレンダーブロック |
| `/weekly-roast` | AI Coach Session（前段）→ 自己批判パケット → AI Board Meeting（週次Board Meeting日の夜） |
| `/okr-check` | OKRのL2分析・Confidence Score算出・次期KR修正案 |
| `/moat-capture` | 技術的優位性・知財をmoat-strategy.mdに記録 |
| `/irm-briefing` | 投資家面談の準備ブリーフィング |

### Phase 2 — プレシード（Founder + Member 2名）
**課題**: ビジョン同期・属人化防止・顧客開発の並走

Phase 1の全機能に加えて：

| コマンド | 機能 |
|---------|------|
| `/onboard-me [role] [name]` | 新メンバーが30分で会社の文脈を自律習得 + AI Coach Session設定の初期化 |
| `/peer-audit` | Monday Promise設定・Semantic Drift Detection・Dual PRR・Focus Guard |
| `/update-crm` | 顧客開発パイプライン管理・PMF Score・Investor Sentiment計算 |
| `/board-prep` | 取締役会・投資家報告資料の自動生成（懸念事項はAIが自動生成） |

### Phase 3 — シード（チーム 3〜5名）
**課題**: N:N情報整流・Series A準備・組織の再現性確立

Phase 1・2の全機能に加えて：

| コマンド | 機能 |
|---------|------|
| `/team-prr` | チーム全体のPRRダッシュボード・ボトルネック検知 |
| `/narrative-check` | ピッチ・採用・提案の一貫性チェック・Bus Factor計算 |
| `/series-a-check` | Series A Readiness Score（25項目・目標85点） |
| `/culture-audit` | 文化コンプライアンス・採用パイプライン |
| `/monthly-gemini` | 月次Gemini戦略監査プロンプト生成 |

---

## v5 の主な新機能

### 1. /sync-all が9ステップの日次L1スキャンに進化
- **6ソース並列スキャン**（Calendar・Notion・Circleback・Granola・Gmail・Slack）
- **差分管理**（memory/sync-state.mdで前回実行以降のみスキャン）
- **DB6: Progress Update 自動生成**（翌日・翌々日の定例MTGごとに進捗レポートを前日生成）
- **Focus Guard**（Doing 3件超で新規着手をブロック）
- **翌日フォーカス確定 → カレンダーブロックまでセッション完結**

### 2. /weekly-roast が3段パイプラインに進化
- **前段：AI Coach Session**（4エージェント・10ラウンド以上・月次ペルソナ棚卸）
- **Part A：自己批判パケット**（Founder/Member共通）
- **後段：AI Board Meeting**（5エージェント・context.mdで創業者がカスタマイズ可能）
- Board Meetingの**エージェント構成・議題ローテーション・議事録置き場は全て自分で定義**

### 3. Notion 8DBに進化（DB6: Progress Update新設）
- **DB6: Progress Update**：定例MTG向けの進捗レポートを前日に自動生成
- **PRR計算式を0.5の累乗方式に統一**（期限変更1回→0.5、2回→0.25、3回→0.125）
- **Confidence Score**（KRの達成自信度を自動算出）
- **Organizations DBのLP → Investor読み替え**（スタートアップ向けに再設計）

### 4. /okr-check 新設
- Confidence Score算出（PRR連動）
- 原因分析（仮説 / 実行 / 外部要因）
- 次期KR修正案

---

## ファイル構成

```
generative-startup-os/
├── CLAUDE.md                    # OSの中枢神経（起動時に自動読み込み）
├── README.md
├── README_SETUP.md              # 詳細セットアップ手順（Mac/Windows/Claude.ai）
│
├── .claude/
│   ├── context.md               # OKR・AI Board設定・DB IDs・フェーズ移行チェックリスト
│   └── commands/
│       ├── # Phase 1
│       ├── setup-mcp.md         # MCP設定（Claude Code vs Claude.ai詳細比較）
│       ├── setup-notion.md      # Notion 8DB自動構築
│       ├── sync-all.md          # 9ステップ日次L1スキャン
│       ├── weekly-roast.md      # AI Coach Session→自己批判→AI Board Meeting
│       ├── okr-check.md         # OKR L2分析（新設）
│       ├── moat-capture.md      # 知財・技術障壁の記録
│       ├── irm-briefing.md      # 投資家面談ブリーフィング
│       ├── # Phase 2
│       ├── onboard-me.md        # 新メンバーオンボーディング + AI Coach設定初期化
│       ├── peer-audit.md        # ビジョン同期・Dual PRR・Semantic Drift Detection
│       ├── update-crm.md        # 顧客開発・PMF Score・Investor Sentiment
│       ├── board-prep.md        # 取締役会・投資家報告資料
│       └── # Phase 3
│           ├── team-prr.md
│           ├── narrative-check.md
│           ├── series-a-check.md
│           ├── culture-audit.md
│           └── monthly-gemini.md
│
├── memory/                      # 組織の記憶（全フェーズ共通）
│   ├── decisions.md             # 意思決定ログ
│   ├── preferences.md           # 文化コード・禁止パターン
│   ├── moat-strategy.md         # 技術的優位性・知財マップ
│   ├── runway-vitals.md         # 財務バイタル
│   ├── experiment-log.md        # R&D実験ログ（ディープテック専用）
│   └── sync-state.md            # 日次同期状態管理（/sync-allが自動更新）
│
├── team/                        # Phase 2以降：メンバー別デスク
│   └── founder/
│       └── context.md
│   # /onboard-me が team/[name]/context.md を自動生成
│   # context.md には AI Coach Session設定（ペルソナ）も含む
│
├── claude_mcp_config.json.example
└── .gitignore
```

---

## PRR（Promise Reliability Ratio）

```
PRR = 完了タスクの加重工数合計 ÷ コミットした全タスクの加重工数合計

加重工数 = Est Hours × Strategic Weight × Integrity Rate

Integrity Rate = 1.0 × (0.5 ^ Penalty Count)
  期限変更0回 → 1.0
  期限変更1回 → 0.5（以前は0.7）
  期限変更2回 → 0.25（以前は0.5）
  期限変更3回 → 0.125（実質ゼロ）
```

- **75〜89%**：🟢 健全。このゾーンを維持するのが目標
- **90%以上**：約束が軽すぎる。もっと挑戦的な目標を設定すべき
- **60〜74%**：🟡 注意。コミット量を見直す
- **60%未満**：🔴 危険。コミット量を半分に減らすか、詰まっている原因を探る

---

*Lifetime Ventures が OIST・日本のアカデミア発ディープテック投資先に提供するAI組織OSパッケージ。*

