# Generative Startup OS — セットアップ手順
# v5.0

---

## まず確認（30秒）

以下のどちらの使い方をしますか？

| 使い方 | 向いているケース | 必要なもの |
|--------|----------------|-----------|
| **A. Claude Code（推奨）** | PC作業が中心・Notionと連携したい・/sync-allをフル活用したい | PC・GitHubアカウント・Claude Proプラン |
| **B. Claude.aiブラウザ版** | まずAI対話から試したい・スマートフォン中心・PCの設定が苦手 | Claude.aiアカウントのみ |

---

## 方法A：Claude Code セットアップ（推奨）

### 所要時間

```
Step 1  リポジトリ作成      ─── 2分
Step 2  Claude Code導入    ─── Mac 約10分 / Windows 約40分
Step 3  起動                ─── 3分
Step 4  初回設定（6質問）   ─── 10分
Step 5  MCP設定             ─── 5〜15分
Step 6  Notion DB構築       ─── 3分
────────────────────────────────────────
合計   Mac: 約35分 / Windows: 約75分
```

---

### Step 1：リポジトリ作成（2分）

1. このリポジトリ（テンプレートのGitHub URL）を開く
2. 右上の緑の **「Use this template」** → **「Create a new repository」** をクリック
3. Repository name: `generative-startup-os`
4. **「Private」を選択**（必須。decisions.md・moat-strategy.mdには機密情報が含まれます）
5. **「Create repository」** をクリック

---

### Step 2：Claude Codeのインストール

#### ✅ Mac（約10分）

ターミナルを開いてください。（Finder → アプリケーション → ユーティリティ → ターミナル）

```bash
# Node.jsのインストール（未インストールの場合）
brew install node
```

> ⚠️ Xcodeのインストールを求められたら「インストール」を押してください（5〜10分）

```bash
npm install -g @anthropic-ai/claude-code
claude auth login
```

`claude auth login` を実行するとブラウザが開きます。Claude.aiにログインして認証完了。

#### 🪟 Windows（VS Code + WSL2 経由・約40分）

<details>
<summary>Windows セットアップ手順を開く</summary>

**W-1. VS Code をインストール（5分）**
[code.visualstudio.com](https://code.visualstudio.com) からダウンロードしてインストール

**W-2. WSL2 をインストール（15分）**
VS Code 「ターミナル」→「新しいターミナル」→ 以下を貼り付けて Enter：
```
wsl --install
```
> このページをブックマークしてください。**再起動後はここから続けます → W-3**

PC を再起動 → Ubuntu が自動起動 → ユーザー名（英数字のみ）とパスワードを設定

> パスワード入力中は画面に何も表示されませんが、正しく入力されています

**W-3. VS Code に WSL 拡張機能を入れる（3分）**
VS Code の拡張機能アイコン → 「WSL」を検索 → Microsoft製「WSL」をインストール
→ 左下に「WSL: Ubuntu」と表示されれば成功

**W-4. Node.js と Claude Code をインストール（10分）**
VS Code 左下「WSL: Ubuntu」をクリック →「WSL での再接続」
「ターミナル」→「新しいターミナル」→ 以下を **1行ずつ** 貼り付けて Enter：

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```
```
source ~/.bashrc
```
```
nvm install 20 && nvm use 20
```
```
npm install -g @anthropic-ai/claude-code
```
```
claude auth login
```

**詰まった場合 → GitHub Codespaces（ブラウザのみ）：**
GitHubでリポジトリを開いて「.」キーを押す → ブラウザ版VS Codeが開く → Claude Code拡張をインストール

</details>

---

### Step 3：起動（3分）

**Mac の場合：**
```bash
git clone https://github.com/[ユーザー名]/generative-startup-os.git
cd generative-startup-os
claude
```

**Windows の場合：**
VS Code コマンドパレット（`Ctrl+Shift+P`）→ `Git: Clone` → リポジトリURLを貼り付け
「ターミナル」→「新しいターミナル」→ `claude` と入力して Enter

✅ Claude Code が起動して `CLAUDE.md` を読み始めたら成功

---

### Step 4：初回設定（約10分）

Claude Codeが起動すると初回セットアップを開始します。
自動で始まらない場合は「初回セットアップを始めてください」と入力してください。

**Claudeが6つの質問をします：**

| 質問 | 答え方の例 |
|------|----------|
| Q1：コア技術と差別化 | 「従来比10倍の感度でタンパク質を検出できる。既存法では必要な前処理が不要」 |
| Q1.5：技術障壁（スキップ可） | 「10年分の実験データと合成プロセスの暗黙知。特許出願準備中」 |
| Q2：今期3ヶ月の目標完了像 | 「大学病院と共同研究契約を1件締結している」 |
| Q3：測定指標（スキップ可） | 「検出感度を100ppmから1ppmに改善する」 |
| Q4：過去の学習・禁止パターン | 「検証なしに次の実験ステージへ進んでしまった」 |
| Q5：今週のフォーカス | 「第一期の実験プロトコルを確定する」 |

回答後、Claudeが：
1. `CLAUDE.md` と `.claude/context.md` を更新（承認を求めます → **y** を押す）
2. `/setup-mcp` を案内

---

### Step 5：MCP設定（5〜15分）

Claude Codeが `/setup-mcp` コマンドを案内します。対話形式で各ツールを設定します。

**必須（最初に設定）：**
- **Notion** → [notion.so/my-integrations](https://www.notion.so/my-integrations) で `secret_` から始まるトークンを取得

**推奨（/sync-allの自動化に必要）：**
- **Google Calendar** → カレンダーのスキャン・フォーカスタスクのカレンダーブロック
- **Granola** → 会議ノートの自動取得

**任意（接続するとさらに自動化）：**
- Circleback / Slack / Gmail

> ⚠️ `claude auth login` 後に **Claude Codeを再起動**してから `/setup-notion quick` を実行してください（Ctrl+C → `claude`）

---

### Step 6：Notion DB構築（3分）

```
/setup-notion quick     → Tasks + Decisions（最初はこれ）
/setup-notion standard  → OKR + Tasks + Decisions + Meeting Memos（5DB）
/setup-notion full      → 全8DB（Progress Update・CRM含む）
```

**DB構築後の手動操作（1回のみ・約3分）：**
作成された各 Notion DBのページで「**…**」→「**コネクト**」→「**Generative Startup OS**」を選択。
この操作だけはNotion APIで自動化できないため手動で行います。

---

## 方法B：Claude.ai ブラウザ版での使い方

Claude Codeなしでも AI Board Meeting・週次レビュー・OKR分析などをブラウザから使えます。

### セットアップ（5分）

1. [claude.ai](https://claude.ai) にログイン → 左サイドバーの「**Projects**」→「**新しいプロジェクト**」
2. プロジェクト名：`Generative Startup OS — [会社名]`
3. 「**Project Instructions**」に以下を貼り付ける：

```
あなたは私のスタートアップの Chief of Staff AI です。
アップロードされたファイルを会社の記憶として参照してください。
「素晴らしいです」で終わらない。必ず「今週何をするか」に落としてください。
```

4. 「**Files**」に以下のファイルをアップロード：
   - `CLAUDE.md`
   - `.claude/context.md`
   - `memory/decisions.md`
   - `memory/preferences.md`
   - `memory/moat-strategy.md`
   - `memory/runway-vitals.md`

5. 初回の会話で「初回セットアップを始めてください」と入力する

### Claude.aiでの毎日の使い方

| タイミング | 操作 |
|-----------|------|
| 会議後 | GranolaまたはCirclebackの議事録テキストをコピーして「以下の議事録を整理してタスクと決定事項を抽出してください」と貼り付ける |
| 毎週末 | 「/weekly-roast を実行してください。今週のPRRは〇〇%、タスクは以下です：[タスクリスト]」と入力 |
| 月次 | 「/okr-check を実行してください。今期のKRは以下です：[KRリスト]」と入力 |

### Claude.aiの制限事項

| 機能 | 状態 |
|------|------|
| Notionへの自動タスク起票 | ❌（手動でNotionに入力） |
| Google Calendarの自動スキャン | ❌ |
| カレンダーへのフォーカスタスクブロック | ❌ |
| memory/ファイルの自動更新 | ❌（Claudeの回答を見て手動でファイルを更新） |
| AI Board Meeting / AI Coach Session | ✅ テキストで実行可能 |
| /weekly-roast（PRR計算） | ✅ データを貼り付けて実行可能 |
| /okr-check | ✅ KRデータを貼り付けて実行可能 |
| /irm-briefing | ✅ 実行可能（memory/ファイルをProjectにアップロード済みの場合） |

---

## 議事録ツールの選択

| 状況 | 推奨 |
|------|------|
| Mac/Windows PC・オンライン会議中心 | **Granola**（Mac/Windows/iOS対応） |
| Androidスマートフォンがメイン | **Circleback** |
| 対面会議が多い | **Circleback**（モバイル録音に強い） |

---

## セットアップ完了後の毎日の使い方（Claude Code）

| タイミング | コマンド | 所要時間 |
|-----------|---------|---------|
| 毎日の終業時 | `claude` → `/sync-all` | 5〜10分（自動スキャン中） |
| 毎週末（金曜または日曜） | `/weekly-roast` | 30〜45分 |
| 月次 | `/okr-check` → `/monthly-gemini` | 20分 |
| 新メンバー参加時 | `/onboard-me [role] [name]` | 30分 |

---

## よくあるエラーと対処

| エラー内容 | 対処方法 |
|-----------|---------|
| `command not found: claude` | `echo 'export PATH="$PATH:$(npm root -g)/../.bin"' >> ~/.zshrc && source ~/.zshrc` |
| `MCP server failed to start` | `claude_mcp_config.json` の構文エラーを確認（jsonlint.comで検証） |
| Notion DBが作成されない | Notion APIトークンが有効か確認。各DBでインテグレーションを接続したか確認 |
| `claude auth login` でブラウザが開かない | `claude auth login --no-browser` を試す |
| GranolaがGoogleアカウントに接続できない | 大学・企業アカウントではなく個人のGoogleアカウントを使う |
| WSLで `Ctrl+C` が効かない | VS Codeのターミナルパネルをゴミ箱アイコンで閉じて新しく開く |

**それでも解決しない場合は [GitHub Issues](../../issues) に報告してください。**
