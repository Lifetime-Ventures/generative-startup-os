# Apple Shortcuts for GSOS v6.0

iOS Apple Shortcuts を使った GSOS の自動化レシピ集。

---

## 提供される Shortcuts (3種)

| Shortcut名 | 用途 | 起動方法 |
|---|---|---|
| GSOS: Voice Memo to Inbox | 音声メモを文字起こし→DB9 投入 | Voice Memos 共有メニュー |
| GSOS: Quick Decision | DB3 Decisions に即座にエントリ | ホーム画面アイコン |
| GSOS: Investor Brief | Claude.ai で投資家面談ブリーフィング起動 | Siri ショートカット |

---

## 配布方法

これらの Shortcut は iCloud リンクで配布されます (実際のリンクは GitHub リポジトリの README で最新版を確認)。

```
GSOS: Voice Memo to Inbox
https://www.icloud.com/shortcuts/[shortcut-id-1]

GSOS: Quick Decision
https://www.icloud.com/shortcuts/[shortcut-id-2]

GSOS: Investor Brief
https://www.icloud.com/shortcuts/[shortcut-id-3]
```

iPhone でリンクを開く → 「ショートカットを追加」をタップ → 自分の Apple Shortcuts に追加される。

---

## Shortcut 1: Voice Memo to Inbox

### 動作

1. Voice Memos アプリで録音終了後、共有メニューから起動
2. 音声ファイルを iCloud Drive の特定フォルダに保存
3. 別途設定された Make.com Blueprint が iCloud を監視
4. Whisper API で文字起こし → Claude Haiku で要約 → DB9 Inbox に投入

### セットアップ

1. Shortcut を iCloud リンクから追加
2. 「Edit」で開く
3. iCloud Drive の保存先フォルダを指定
4. Make.com Blueprint (voicememo-to-inbox.json) もインポート済みであること

### 使い方

```
[歩きながら気づきを録音]
  ↓
Voice Memos で停止
  ↓
共有 → GSOS: Voice Memo to Inbox
  ↓
完了通知 (約3-5分後)
  「DB9 Inbox に投入されました」
```

---

## Shortcut 2: Quick Decision

### 動作

1. ホーム画面アイコンから起動
2. 「タイトル」「The Trade-off」「Assumption」を順次入力 (音声入力可)
3. Notion API で DB3 Decisions に即座にエントリ作成

### セットアップ

1. Shortcut を iCloud リンクから追加
2. 「Edit」で開く
3. Notion API インテグレーショントークンを入力
4. DB3 Decisions の DB ID を入力
5. ホーム画面に追加 (長押し → ホーム画面に追加)

### 使い方

```
重要な気づきがある
  ↓
ホーム画面の「Quick Decision」アイコンタップ
  ↓
タイトル入力 (音声 or テキスト)
The Trade-off 入力
Assumption 入力
  ↓
DB3 Decisions に D-XXX として作成
```

### 注意

- Quick Decision は「短時間メモ」用なので、後でデスクトップで詳細編集
- The Trade-off / Assumption フィールドは省略不可 (GSOS の核)
- IP Potential はデフォルト「中」で記録、後で見直し

---

## Shortcut 3: Investor Brief

### 動作

1. Siri ショートカットまたはホーム画面から起動
2. 投資家名・面談日時を入力
3. Claude モバイルアプリを開いて `/irm-briefing` プロンプトを準備状態に

### セットアップ

1. Shortcut を iCloud リンクから追加
2. Claude アプリがインストール済みであること
3. Siri音声起動: 「ヘイSiri、Investor Brief を実行」で起動可能

### 使い方

```
明日 13:00 に Investor A との面談
  ↓
今夜 22:00 に Siri に「Investor Brief 実行」
  ↓
Claude.ai が GSOS Project で /irm-briefing コマンド準備状態
  ↓
投資家情報を入力 → ブリーフィング資料を音声で聞きながら寝る
```

---

## カスタムShortcut の作り方

GSOS と連携する独自 Shortcut を作る場合:

### Notion API 連携の基本

```
Action: Get Contents of URL
URL: https://api.notion.com/v1/pages
Method: POST
Headers:
  Authorization: Bearer YOUR_NOTION_TOKEN
  Notion-Version: 2022-06-28
  Content-Type: application/json
Body:
  {
    "parent": {"database_id": "YOUR_DB9_INBOX_ID"},
    "properties": {
      "Subject/Snippet": {"title": [{"text": {"content": "..."}}]},
      "Source": {"select": {"name": "Manual"}}
    }
  }
```

### Claude API 連携の基本

```
Action: Get Contents of URL
URL: https://api.anthropic.com/v1/messages
Method: POST
Headers:
  x-api-key: YOUR_ANTHROPIC_KEY
  anthropic-version: 2023-06-01
  Content-Type: application/json
Body:
  {
    "model": "claude-haiku-4-5",
    "max_tokens": 500,
    "messages": [{"role": "user", "content": "..."}]
  }
```

---

## セキュリティへの注意

- Apple Shortcuts に保存される API キーは **iOS Keychain** に暗号化保存される
- ただし他人にiPhoneを渡したり、 iCloud バックアップを共有しないこと
- API キーが漏洩した場合は Notion / Anthropic コンソールで即時 revoke
- Shortcut の共有時はAPIキーを抜いてから共有 ([→](https://developers.notion.com))

---

## トラブルシューティング

### Shortcut が動作しない
- iCloud で同期されているか確認 (Settings → Apple ID → iCloud → Shortcuts ON)
- Shortcut 内の API キーが有効か確認

### Notion API 401 エラー
- インテグレーショントークン確認
- DB9 にインテグレーション接続済みか確認

### Voice Memos との連携が動かない
- Voice Memos の iCloud 同期 ON か確認
- Make.com Blueprint の iCloud OAuth が切れていないか
