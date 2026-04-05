# /setup-mcp — MCP設定の自動生成
# Phase: 1（初回セットアップ）
# Last Updated: v5.0

---

## Purpose

Notion・Google Calendar・Granola・Circleback・Slack・Gmail の
MCP設定ファイルを自動生成する。

---

## ユースケース別の使い方

### A. Claude Code（ターミナル）での使い方（推奨）

Claude Codeはローカルで動作し、すべてのMCP機能をフル活用できる。
MCP設定は `~/.claude/claude_mcp_config.json` に保存される。

**このコマンドを実行すると以下が自動で行われる：**
1. 既存設定の確認・バックアップ
2. 各APIトークンの収集（対話形式）
3. 設定ファイルの生成
4. `.gitignore` へのAPIキー除外設定の追加

### B. Claude.aiブラウザ版での使い方

Claude.aiのブラウザ版ではMCPサーバーを直接設定できない。
以下の機能が利用可能：

| 機能 | Claude Code | Claude.ai |
|------|-------------|-----------|
| Notionへのタスク起票 | ✅ MCP経由・自動 | ⚠️ 手動でNotionに入力 |
| Google Calendarの読み書き | ✅ MCP経由・自動 | ❌ 不可 |
| Granola/Circleback読み込み | ✅ MCP経由・自動 | ✅ 議事録テキストを手動ペースト |
| Gmail/Slackスキャン | ✅ MCP経由・自動 | ❌ 不可 |
| memory/ファイルの読み書き | ✅ ローカルファイル | ⚠️ Claude.ai Projectsのファイルで代替 |

**Claude.aiを使う場合の推奨フロー：**
- Claude.ai Projectsに以下のファイルをアップロードしてコンテキストとして設定する：
  - `CLAUDE.md`
  - `.claude/context.md`
  - `memory/decisions.md`
  - `memory/preferences.md`
  - `memory/runway-vitals.md`
  - `memory/moat-strategy.md`
- 議事録はGranola/Circlebackからテキストをコピーして貼り付ける
- Notionへの転記は Claude.aiの回答を見て手動で行う

---

## 実行手順（Claude Code）

### Step 1: 既存設定の確認
`~/.claude/claude_mcp_config.json` が存在するか確認する。
存在する場合：「既存の設定を上書きしますか？（バックアップを作成してから更新します）」と確認する。

### Step 2: .gitignoreの確認
プロジェクトの`.gitignore`に `claude_mcp_config.json` が含まれているか確認する。
含まれていない場合は追加することを提案する（APIキーの漏洩防止）。

### Step 3: APIトークンの収集

**Notion（必須）：**
「Notion APIトークンを入力してください。
 取得方法：notion.so/my-integrations → 新しいインテグレーション作成
 → 名前: Generative Startup OS → secret_ から始まる文字列をコピー」

**Google Calendar（推奨）：**
「Google Calendarと連携しますか？（y/n）
 ✅ 連携すると /sync-all でカレンダーの自動スキャン・フォーカスタスクのブロックができます
 ⚠️ OAuth設定が必要です。セットアップ手順: README_SETUP.mdのMCPセクションを参照」

**Granola（推奨）：**
「Granolaと連携しますか？（y/n）
 ✅ 連携すると /sync-all で会議ノートを自動取得できます
 取得方法：Granolaアプリ → Settings → API → Generate API Key
 ⚠️ MCPパッケージ名（`@granola-ai/mcp-server`）は例示です。[Granolaの公式ドキュメント](https://granola.ai)で最新のパッケージ名を確認してから実行してください」

**Circleback（任意）：**
「Circlebackと連携しますか？（y/n）
 ✅ Granolaにないオンライン会議の録音・文字起こしを取得できます
 取得方法：app.circleback.ai → Settings → API Key
 ⚠️ MCPパッケージ名（`@circleback/mcp-server`）は例示です。[Circlebackの公式ドキュメント](https://circleback.ai)で最新のパッケージ名を確認してから実行してください」

**Slack（任意）：**
「Slackと連携しますか？（y/n）
 ✅ 連携すると /sync-all でSlackのメンションを自動スキャンできます
 xoxb- から始まる Bot Token を入力」

**Gmail（任意）：**
「Gmailと連携しますか？（y/n）
 ✅ 連携すると /sync-all で重要メールを自動トリアージできます
 ⚠️ OAuth設定が必要です。README_SETUP.mdのMCPセクションを参照」

### Step 4: 設定ファイルの生成

`~/.claude/claude_mcp_config.json` に以下の内容で生成することを提案する：

```json
{
  "mcpServers": {
    "notion": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-notion"],
      "env": {
        "NOTION_API_TOKEN": "[入力されたトークン]"
      }
    },
    "google-calendar": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-google-calendar"],
      "env": {
        "GOOGLE_CLIENT_ID": "[OAuth Client ID]",
        "GOOGLE_CLIENT_SECRET": "[OAuth Client Secret]",
        "GOOGLE_REFRESH_TOKEN": "[Refresh Token]"
      }
    },
    "granola": {
      "command": "npx",
      "args": ["-y", "@granola-ai/mcp-server"],
      "env": {
        "GRANOLA_API_KEY": "[入力されたキー]"
      }
    },
    "circleback": {
      "command": "npx",
      "args": ["-y", "@circleback/mcp-server"],
      "env": {
        "CIRCLEBACK_API_KEY": "[入力されたキー]"
      }
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "[入力されたトークン]"
      }
    },
    "gmail": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-gmail"],
      "env": {
        "GMAIL_CLIENT_ID": "[OAuth Client ID]",
        "GMAIL_CLIENT_SECRET": "[OAuth Client Secret]",
        "GMAIL_REFRESH_TOKEN": "[Refresh Token]"
      }
    }
  }
}
```

接続するサービスに対応するセクションのみ追加する（スキップしたサービスは除外）。

### Step 5: context.mdの更新

`.claude/context.md` の「MCP設定ステータス」セクションを更新することを提案する：
- 接続済み: 接続完了
- スキップ: 未接続（後で設定可能）

### Step 6: 完了案内

「設定ファイルを生成しました。
 Claude Codeを再起動してください（Ctrl+C → claude）。
 再起動後、/setup-notion quick を実行してNotionのDBを構築します。

 **Claude.aiブラウザ版での利用について：**
 MCPは Claude Code専用です。Claude.aiでは /sync-all などの自動連携機能は動作しません。
 Claude.aiで使う場合は README_SETUP.md の『Claude.aiでの使い方』セクションを参照してください。」

---

## Claude Code vs Claude.ai の機能比較（詳細）

### Claude Codeでのみ使えるコマンド・機能

| コマンド/機能 | 理由 |
|-------------|------|
| /sync-all の自動スキャン（STEP 1〜6） | Google Calendar・Notion・Granola等のMCPが必要 |
| カレンダーへのフォーカスタスクブロック | gcal_create_eventが必要 |
| /setup-notion のDB自動構築 | Notion MCPが必要 |
| memory/ファイルの自動更新 | ローカルファイルシステムアクセスが必要 |

### Claude.aiで代替できる機能

| コマンド/機能 | Claude.aiでの代替方法 |
|-------------|---------------------|
| /sync-all のタスク抽出 | 議事録テキストを貼り付けて手動で分類依頼 |
| /weekly-roast | OKR・タスク・PRRデータを貼り付けて実行 |
| /okr-check | KRデータをコピーして貼り付け |
| /irm-briefing | memory/ファイルをプロジェクトにアップロードして実行 |
| /moat-capture | テキストを入力して実行（memory/への書き込みは手動） |
| AI Board Meeting / AI Coach Session | テキストで実行可能（ファイル更新は手動） |

### Claude.ai Projectsでの推奨セットアップ

1. claude.aiでProjectを作成
2. 以下のファイルをProjectの「Files」にアップロード：
   - CLAUDE.md
   - .claude/context.md
   - memory/decisions.md（最新版）
   - memory/preferences.md
   - memory/moat-strategy.md
   - memory/runway-vitals.md
3. Project Instructionsに以下を設定：
   ```
   あなたは[会社名]のChief of Staff AIです。
   CLAUDE.mdとcontext.mdを読んで、すべての会話の文脈としてください。
   アップロードされたmemory/ファイルも参照してください。
   ```
4. モバイル・ブラウザからCLAUDE.mdの文脈で対話できる

---

## Limitations

- APIキーは必ず .gitignore で除外されたファイルに保存する
- claude_mcp_config.json はGitHubにコミットしない
- OAuth認証（Google Calendar・Gmail）は初期設定が複雑なため、詰まった場合は [GitHub Issues](../../issues) に報告してください
