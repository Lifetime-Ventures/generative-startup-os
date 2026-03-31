# Generative Startup OS

**ディープテック・スタートアップ創業者のためのAI組織OS**
*Created by Lifetime Ventures × OIST*

---

研究者として創業したあなたの最大の課題は、「経営の記録と判断」を続けることだ。
このOSはAIがその記録と判断を肩代わりし、技術開発に集中できる時間を作る。
一度の初期設定（通常30〜40分）で、毎朝3分のAIとの対話が組織の記憶を自動的に積み上げる。

> Series Aのデューデリジェンスで「なぜその判断をしたか」「どのように技術優位性を積み上げたか」を
> GitHubのコミット履歴で説明できる会社になる。

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

**後はClaudeが案内します。** 5つの質問に答えるだけで、MCP設定・Notion DB構築・メモリファイル生成が自動完了します。

詳しいセットアップ手順 → [README_SETUP.md](./README_SETUP.md)

---

## 3つのフェーズ

| フェーズ | 人数 | AIが担う役割 |
|---------|------|------------|
| Phase 1：プレチーム | 1名 | 意思決定の記録・タスク管理・知財の蓄積 |
| Phase 2：プレシード | 2名 | 共同創業者への文脈移転・属人化の防止 |
| Phase 3：シード | 3〜5名 | チーム間の情報整流・Series A準備 |

---

## 利用可能なコマンド

| コマンド | 説明 |
|---------|------|
| `/setup-mcp` | MCP設定（Notion・Google・Slack）を自動生成 |
| `/setup-notion` | Notion DBを自動構築（quick/standard/full） |
| `/sync-all` | 議事録・タスクをNotionに同期 |
| `/weekly-roast` | 週次PRR評価＋Gemini監査プロンプト生成 |
| `/moat-capture` | 知財・技術障壁をmoat-strategy.mdに記録 |
| `/irm-briefing` | 投資家面談の準備 |

---

## ファイル構成

```
generative-startup-os/
├── CLAUDE.md                    # OSの中枢神経（起動時に自動読み込み）
├── README.md                    # このファイル
├── README_SETUP.md              # 詳細セットアップ手順
├── .claude/
│   ├── context.md               # 詳細コンテキスト（OKR・DB IDs）
│   └── commands/                # Slashコマンド群
│       ├── setup-mcp.md
│       ├── setup-notion.md
│       ├── sync-all.md
│       ├── weekly-roast.md
│       ├── moat-capture.md
│       └── irm-briefing.md
├── memory/                      # 組織の記憶ファイル群
│   ├── decisions.md
│   ├── preferences.md
│   ├── moat-strategy.md
│   └── runway-vitals.md
├── claude_desktop_config.json.example
└── .gitignore
```

---

*Lifetime Ventures が投資先に提供するAI組織OSパッケージ。*
*詳細・導入支援：担当VCまでお問い合わせください。*
