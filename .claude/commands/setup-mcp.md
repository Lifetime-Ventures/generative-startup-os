# /setup-mcp — MCP設定の自動生成

Notion・Google Calendar・Slack のMCP設定ファイルを自動生成します。

## 実行手順

### Step 1: 既存設定の確認
`~/.claude/claude_desktop_config.json` が存在するか確認する。
存在する場合：「既存の設定を上書きしますか？」と確認する。

### Step 2: .gitignoreの確認
プロジェクトの`.gitignore`に `claude_desktop_config.json` が含まれているか確認する。
含まれていない場合は追加することを提案する（APIキーの漏洩防止）。

### Step 3: APIトークンの収集

**Notion（必須）：**
「Notion APIトークンを入力してください。
 取得方法：notion.so/my-integrations → 新しいインテグレーション作成
 → secret_ から始まる文字列をコピー」

**Google Calendar（任意）：**
「Google Calendarと連携しますか？（y/n）
 ※ 後回し可能。yの場合は別途OAuth設定が必要です」

**Slack（任意）：**
「Slack Botトークンを入力しますか？（y/n）
 ※ 後回し可能。xoxb- から始まる文字列」

### Step 4: 設定ファイルの生成
`~/.claude/claude_desktop_config.json` に以下の内容で生成することを提案する：

```json
{
  "mcpServers": {
    "notion": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-server-notion"],
      "env": {
        "NOTION_API_TOKEN": "[入力されたトークン]"
      }
    }
  }
}
```

Google CalendarとSlackが入力された場合は該当セクションを追加する。

### Step 5: context.mdの更新
`.claude/context.md` の「MCP設定ステータス」セクションを更新することを提案する。

### Step 6: 完了案内
「設定ファイルを生成しました。
 Claude Codeを再起動してください（Ctrl+C → claude）。
 再起動後、/setup-notion quick を実行してNotionのDBを構築します。」
