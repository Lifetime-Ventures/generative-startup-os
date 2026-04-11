# Generative Startup OS

**ディープテック・スタートアップのためのAI組織OS**
*Created by Lifetime Ventures*

---

日本のアカデミア発の科学技術が世界に届くまでに、数百の判断がある。
Lifetime Ventures はその判断に伴走するために、このOSを投資先に提供する。

あなたには、論文には書いていない判断の積み重ねがある。
**このOSは、その判断をAIとともに記録し続け、共同創業者が来ても、投資家が変わっても消えない会社の知識にする。**

> Series Aのデューデリジェンスで「なぜその判断をしたか」「どのように技術優位性を積み上げたか」を説明できる会社になる。

---

## はじめる

```bash
# 1. このリポジトリを「Use this template」でコピー（Private推奨）

# 2. Claude Codeをインストール
brew install node
npm install -g @anthropic-ai/claude-code
claude auth login

# 3. リポジトリをクローンして起動
git clone https://github.com/[あなたのユーザー名]/generative-startup-os.git
cd generative-startup-os
claude
```

**後はClaudeが案内します。** 6つの質問に答えるだけで、MCP設定・Notion DB構築・メモリファイル生成が自動完了します。

詳しいセットアップ手順 → [README_SETUP.md](./README_SETUP.md)

---

## 3つのフェーズと全機能

### Phase 1 — プレチーム（Founder 1名）
**課題**: 創業者の思考・判断・知財をAIが記憶し続ける

| コマンド | 機能 |
|---------|------|
| `/setup-mcp` | Notion・Google・Slack のMCP設定を自動生成 |
| `/setup-notion` | Notion DBを自動構築（quick/standard/full） |
| `/sync-all` | 議事録・意思決定をNotionに同期 |
| `/weekly-roast` | 週次PRR評価＋Gemini監査プロンプト生成 |
| `/moat-capture` | 技術的優位性・知財をmoat-strategy.mdに記録 |
| `/irm-briefing` | 投資家面談の準備ブリーフィング |

### Phase 2 — プレシード（Founder + Member 2名）
**課題**: ビジョン同期・属人化防止・顧客開発の並走

Phase 1の全機能に加えて：

| コマンド | 機能 |
|---------|------|
| `/onboard-me [role] [name]` | 新メンバーが自律的に会社の文脈を30分で習得 |
| `/peer-audit` | Monday Promise設定・ビジョンズレ検知・Dual PRR |
| `/update-crm` | 顧客開発パイプライン管理・PMF Score計算 |
| `/board-prep` | 取締役会・投資家報告資料の自動生成 |

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

## ファイル構成

```
generative-startup-os/
├── CLAUDE.md                    # OSの中枢神経（起動時に自動読み込み）
├── README.md
├── README_SETUP.md              # 詳細セットアップ手順（日本語・Mac/Windows対応）
│
├── .claude/
│   ├── context.md               # OKR・フェーズ・DB IDs・移行チェックリスト
│   └── commands/
│       ├── # Phase 1
│       ├── setup-mcp.md
│       ├── setup-notion.md
│       ├── sync-all.md
│       ├── weekly-roast.md
│       ├── moat-capture.md
│       ├── irm-briefing.md
│       ├── # Phase 2
│       ├── onboard-me.md
│       ├── peer-audit.md
│       ├── update-crm.md
│       ├── board-prep.md
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
│   └── experiment-log.md        # R&D実験ログ（ディープテック専用）
│
├── team/                        # Phase 2以降：メンバー別デスク
│   └── founder/
│       └── context.md
│   # /onboard-me が team/[name]/context.md を自動生成
│
├── claude_desktop_config.json.example
└── .gitignore
```

---

## PRR（Promise Reliability Ratio）

このOSの中核指標。**「コミットした仕事を誠実にやり切っているか」**を毎週測定する。

- **70〜89%**：健全。このゾーンを維持するのが目標
- **90%以上**：約束が軽すぎる。もっと挑戦的な目標を設定すべき
- **60%未満**：危険。コミット量を半分に減らすか、詰まっている原因を探る

---

*Lifetime Ventures が日本のアカデミア発ディープテック投資先に提供するAI組織OSパッケージ。*
