# Android Setup Guide — GSOS v6.0

Android端末で GSOS v6.0 を運用するためのセットアップ手順。

---

## 必要なアプリ (Google Play からインストール)

### 必須
- **Notion** (無料)
- **Recorder** (Google純正・Pixelには標準・他端末は別途インストール) — 自動文字起こし機能あり

### 推奨
- **Claude** (公式・Android) — Connected/Automated環境
- **Granola** または **Otter.ai** — 議事録
- **Tasker** (有料・$3.49) — Apple Shortcuts相当の自動化

---

## ステップ1: Notion アプリのセットアップ (5分)

1. Google Play で「Notion」検索 → インストール
2. アカウントでログイン
3. ワークスペース選択 → GSOS のワークスペース
4. 9DB が表示されることを確認
5. アプリロックを有効化:
   - Settings → Security → App Lock

---

## ステップ2: Notion ウィジェットの追加 (3分)

ホーム画面に Notion Quick Capture ウィジェットを追加:

1. ホーム画面長押し → ウィジェット
2. Notion ウィジェット選択
3. 「Quick Capture」または「Database」を選択
4. DB9 Inbox を指定 → 配置

---

## ステップ3: Recorder アプリの設定 (5分)

Pixel デバイス:
1. プリインストールの Recorder アプリを開く
2. 自動文字起こし機能 (リアルタイム) を有効化
3. Google Drive 同期を有効化:
   - Settings → Save backups to Google Drive

他のAndroidデバイス:
- **Otter.ai** (無料300分/月) を代替アプリとして利用
- または **Cogi** (シンプルな録音・タグ付け)

---

## ステップ4: Tasker による自動化 (10-15分・任意)

Tasker は Apple Shortcuts相当の自動化アプリ。

主要なタスク:
- 「Voice memo to GSOS Inbox」 — 録音終了→文字起こし→Notion API 経由で DB9 投入
- 「Quick Decision」 — 即座に DB3 Decisions 新規作成 (Notion API経由)

設定の参考: Tasker → Tasks → New → Add Action → HTTP Request (Notion API)

詳細な Tasker タスクの構築は本ドキュメントの範囲外ですが、 [Notion API公式ドキュメント](https://developers.notion.com) を参照してカスタマイズ可能。

---

## ステップ5: Claude モバイルアプリ (Connected/Automated環境)

1. Google Play で「Claude」(公式・Anthropic) インストール
2. Pro アカウントでログイン
3. GSOS Project に切り替え

iPhoneと同様、モバイル Claude は /quick-board / /irm-briefing が最も使いやすい。

---

## Make.com Blueprint との連携

Android 用 Make.com Blueprint:
1. **Recorder の Google Drive 自動バックアップ → Make.com で監視 → Notion DB9 Inbox**
2. **Otter.ai 議事録 → Make.com で監視 → Notion DB5 Meeting Memos**

設定例は [make-blueprints/voicememo-to-inbox.json](../make-blueprints/voicememo-to-inbox.json) を参考に Google Drive 監視に変更。

---

## モバイル運用の典型的な1日 (Android)

iOS版の流れと基本的に同じ。 違いは:
- Voice Memos の代わりに Recorder アプリ
- Apple Shortcuts の代わりに Tasker
- iCloud の代わりに Google Drive

---

## トラブルシューティング

### Notion アプリが同期しない
- Google Play で最新版に更新
- アプリのキャッシュクリア (Settings → Apps → Notion → Storage → Clear cache)

### Recorder の文字起こしが日本語にならない
- Settings → Language → 日本語を追加
- Pixel以外のデバイスは Recorder の代わりに Otter.ai 推奨 (日本語対応強い)

### Tasker のNotion API 連携が失敗
- Notion インテグレーショントークン (secret_xxx) 確認
- DB9 Inbox にインテグレーション接続済みか
- HTTP Request の Header に `Notion-Version: 2022-06-28` を含めているか

---

## セキュリティチェックリスト

- [ ] Notion アプリのアプリロック有効
- [ ] Google Drive バックアップは意図した通りか
- [ ] 紛失時のリモートワイプ設定 (Find My Device)
- [ ] NDA下情報を音声メモに残さない

---

## iOS との機能差

| 機能 | iOS | Android |
|---|---|---|
| Notion アプリ | ◎ | ◎ |
| 自動化 | Apple Shortcuts (無料・直感的) | Tasker (有料・複雑) |
| 音声→文字 | Voice Memos (iOS 18以降) | Recorder (Pixel) または Otter.ai |
| Claude公式 | ◎ | ◎ |
| iCloud / Drive | iCloud (Apple) | Google Drive |

iOS の方が Apple Shortcuts による自動化が直感的なため、 GSOS との親和性は若干高い。
Android で同等の運用をするには Tasker の習熟が必要。
