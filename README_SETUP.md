# Generative Startup OS — セットアップ手順

## まず確認（30秒）

以下の全てに該当すれば、セットアップが完了できます：

- ✅ GitHubアカウントを持っている（または今から作る）
- ✅ Mac または Windows を使っている
- ✅ Claude.aiのアカウントがある（Proプラン推奨）

**1つでも「？」があれば、担当VCに連絡してキックオフMTGを設定してください。**

---

## Step 1：テンプレートからリポジトリを作成（2分）

1. [github.com/Lifetime-Ventures/generative-startup-os](https://github.com/Lifetime-Ventures/generative-startup-os) を開く
2. 右上の緑の **「Use this template」** → **「Create a new repository」** をクリック
3. Repository name: `generative-startup-os`
4. **「Private」** を選択（必須。decisions.mdやmoat-strategy.mdには機密情報が含まれます）
5. **「Create repository」** をクリック

---

## Step 2：VS Code と Claude Codeをインストール

### Mac の場合（約10分）

ターミナルを開いてください。
（Finder → アプリケーション → ユーティリティ → ターミナル、または Spotlight で「ターミナル」）

```bash
# Node.jsのインストール（未インストールの場合）
brew install node
```

> ⚠️ パスワードを求められたら、Macのログインパスワードを入力してください（画面には表示されません）
> ⚠️ Xcode Command Line Toolsのインストールを求められたら「インストール」を選んでください（5〜10分）

```bash
# Claude Codeのインストール
npm install -g @anthropic-ai/claude-code

# 認証（ブラウザが開いてClaude.aiにログインします）
claude auth login
```

### Windows の場合（VS Code + WSL2 経由・約40分）

<details>
<summary>🪟 Windows セットアップ手順を開く</summary>

Windows では **VS Code をターミナルの代わりに使います。** コマンドを直接入力する場面は最小限に抑えられています。

---

#### Step 2-W1：VS Code をインストールする（5分）

1. [code.visualstudio.com](https://code.visualstudio.com) を開く
2. **「Download for Windows」** をクリックしてインストーラーをダウンロード
3. ダウンロードしたファイル（`.exe`）をダブルクリックして実行
4. インストール完了後、VS Code を起動する

---

#### Step 2-W2：WSL2 をインストールする（15分）

WSL2（Windows の中に Linux 環境を作る機能）が必要です。

1. VS Code を開いた状態で、メニューバーの **「ターミナル」** → **「新しいターミナル」** をクリック
2. 画面下にターミナルパネルが開く
3. 以下を **1行ずつコピーして貼り付け** → Enter を押す：

```
wsl --install
```

4. 完了したら **PC を再起動する**
5. 再起動後、Ubuntu のウィンドウが自動で開く
6. **ユーザー名**（英数字のみ・日本語不可）と**パスワード**を設定する

> ⚠️ ユーザー名に日本語・スペースを使わないこと（パスのエラーが発生します）
> ⚠️ パスワード入力中は画面に何も表示されませんが、正しく入力されています

---

#### Step 2-W3：VS Code に WSL 拡張機能を入れる（3分）

1. VS Code を開く
2. 左サイドバーの **四角いアイコン（拡張機能）** をクリック
3. 検索欄に `WSL` と入力
4. **「WSL」**（Microsoft製）→ **「インストール」** をクリック
5. インストール後、VS Code の左下に **「WSL: Ubuntu」** と表示されれば成功

---

#### Step 2-W4：WSL 内に Node.js と Claude Code を入れる（10分）

1. VS Code 左下の **「WSL: Ubuntu」** をクリック → **「WSL での再接続」** を選ぶ
   （または VS Code を再起動して左下が「WSL: Ubuntu」になっていることを確認）
2. メニューバーの **「ターミナル」** → **「新しいターミナル」** をクリック
3. 以下を **1行ずつ** ターミナルに貼り付けて Enter：

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

4. `claude auth login` を実行するとブラウザが開く → Claude.ai にログインして認証完了

> ✅ `claude --version` を実行して `claude v1.x.x` と表示されればインストール成功

---

#### まだ詰まっている場合 → GitHub Codespaces（ブラウザのみ）

インストールがうまくいかない場合、ブラウザだけで動く代替手段があります：

1. GitHub で自分の `generative-startup-os` リポジトリを開く
2. キーボードの **「.」（ピリオド）キー** を押す
3. ブラウザ内に VS Code が開く
4. 左サイドバーの拡張機能アイコン → `Claude Code` を検索してインストール
5. そのまま Claude Code を使える

</details>

---

## Step 3：リポジトリを VS Code で開いて Claude Code を起動する（5分）

### Mac の場合

1. ターミナルで以下を実行（GitHub のリポジトリページ → 緑の「Code」ボタン → HTTPS の URL をコピー）：

```bash
git clone https://github.com/[あなたのユーザー名]/generative-startup-os.git
```

2. VS Code を開く → **「ファイル」** → **「フォルダーを開く」** → クローンした  フォルダを選択
3. VS Code のメニューバー → **「ターミナル」** → **「新しいターミナル」**
4. ターミナルパネルで以下を実行：

```bash
claude
```

### Windows の場合

VS Code の GUI を使ってリポジトリをクローンします。ターミナルへの直接入力を最小化できます。

1. VS Code を開く（WSL: Ubuntu に接続された状態で）
2. **「表示」** → **「コマンドパレット」**（または ）を開く
3.  と入力して選択
4. GitHub のリポジトリURL（）を貼り付けて Enter
5. 保存先フォルダを選択（WSL のホームディレクトリ  推奨）
6. 「リポジトリを開く」をクリック
7. VS Code のメニューバー → **「ターミナル」** → **「新しいターミナル」**
8. ターミナルパネルで以下を実行：

```bash
claude
```

> ✅ Claude Code が起動して `CLAUDE.md` を読み始めたら成功です

---

## Step 4：Claudeの質問に答える（約10分）

Claude Codeが起動すると、`CLAUDE.md`を読んで初回セットアップを開始します。

**Claudeが5つの質問をします。日本語で答えてください：**

| 質問 | 答え方の例 |
|------|----------|
| Q1：会社名と専門技術領域 | 「Aquamino Technologies、タンパク質構造を用いた創薬プラットフォーム」 |
| Q2：今期（3ヶ月）の最も重要な目標 | 「外部研究機関にプロトタイプの有効性を認めてもらった状態にする」 |
| Q3：その目標を測定する指標（数値） | 「検出感度を100ppmから1ppmに改善」 |
| Q4：やってはいけないこと | 「顧客確認なしに機能を追加する」 |
| Q5：今週最も重要なこと | 「第一期の実験プロトコルを確定する」 |

回答後、Claudeが：
1. `CLAUDE.md`と`.claude/context.md`を自動更新
2. `/setup-mcp`を実行してMCP設定を生成（Notion APIトークンの入力を求められます）
3. **Claude Codeの再起動を求められます** → VS Code のターミナルで  を押してから  と入力して Enter
4. `/setup-notion quick`を実行してNotionにDBを構築

> ⚠️ **再起動が必要な場面：** MCP設定ファイルを生成した後は必ず`claude`を再起動してください

---

## Step 5：Notion APIトークンの設定（3分）

Step 4の途中でClaude Codeが案内しますが、事前に取得しておくとスムーズです：

1. [notion.so/my-integrations](https://www.notion.so/my-integrations) を開く
2. 「**＋ 新しいインテグレーション**」をクリック
3. 名前：`Generative Startup OS` → 保存
4. `secret_` で始まる文字列をコピー（これがAPIトークン）

> **Step 4のStep 4完了後：** 作成されたNotionの各DBページで「…」→「コネクト」→ 作成したインテグレーションを接続してください（手動・約3分）

---

## セットアップ完了後の毎日の使い方

**毎朝（3分）：**
```
claude
→ 「今日のブリーフィングをお願いします」
```

**会議後（5分）：**
```
/sync-all
→ GranolaまたはCirclebackの議事録テキストを貼り付ける
```

**毎週金曜（15分）：**
```
/weekly-roast
→ 週次PRR評価とGemini監査プロンプトが生成される
```

---

## 議事録ツールの選択

| 状況 | 推奨ツール |
|------|-----------|
| Mac/Windows PC・オンライン会議中心 | **Granola**（Mac/Windows/iOS対応） |
| Androidスマートフォンがメイン | **Circleback**（GranolaにAndroid版なし） |
| 対面会議が多い | **Circleback** |

---

## よくあるエラーと対処

| エラー内容 | 対処方法 |
|-----------|---------|
| `command not found: claude` | `echo 'export PATH="$PATH:$(npm root -g)/../.bin"' >> ~/.zshrc && source ~/.zshrc` |
| `MCP server failed to start` | `claude_desktop_config.json`の構文エラーを確認（jsonlint.comで検証） |
| Notion DBが作成されない | Notion APIトークンが有効か確認。インテグレーションをDBに接続したか確認 |
| `claude auth login`でブラウザが開かない | `claude auth login --no-browser` を試す |
| Granolaがアカウントに接続できない | 大学・企業アカウントではなく個人のGoogleアカウントを使う |

**それでも解決しない場合は担当VCに連絡してください。**
