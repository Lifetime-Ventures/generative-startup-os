# iOS Setup Guide — GSOS v6.0

iPhone / iPad で GSOS v6.0 を運用するためのセットアップ手順。

---

## 必要なアプリ (App Store からインストール)

### 必須
- **Notion** (無料)
- **Voice Memos** (純正・初期インストール済み)

### 推奨
- **Claude** (公式・iOS) — Connected/Automated環境 で活用
- **Granola** — 議事録 (Connected/Automated環境)
- **Apple Shortcuts** (純正・初期インストール済み) — 自動化

---

## ステップ1: Notion アプリのセットアップ (5分)

1. App Store で「Notion」を検索 → インストール
2. アカウントでログイン (デスクトップで使っているのと同じアカウント)
3. ワークスペース選択 → GSOS のワークスペース
4. 9DB が表示されることを確認
5. パスコード保護を有効化:
   - Settings → Security → Lock with passcode

---

## ステップ2: Notion ウィジェットの追加 (3分)

ホーム画面に Notion Quick Capture ウィジェットを追加:

1. ホーム画面で長押し → 左上「+」アイコン
2. ウィジェット検索で「Notion」
3. 「Quick Capture」または「Today's Tasks」サイズを選択
4. 設定で「DB9 Inbox」を選択 → ホーム画面に配置

これでホーム画面から1タップで DB9 に新規エントリ追加可能。

---

## ステップ3: Voice Memos の設定 (5分)

1. Settings → Voice Memos
2. 自動文字起こしを有効化 (iOS 18以降の標準機能)
3. iCloud 同期を有効化:
   - Settings → [Your Name] → iCloud → Voice Memos → ON

これにより、 Voice Memos で録音 → iCloud Drive → (Make.com Blueprint で取得) → DB9 Inbox の流れが完成。

---

## ステップ4: Apple Shortcuts の設定 (10-15分)

詳細は [apple-shortcuts.md](./apple-shortcuts.md) を参照。

主要な Shortcut:
- 「Voice memo to GSOS Inbox」 — 録音→文字起こし→Notion DB9 投入
- 「Quick Decision」 — 即座に DB3 Decisions に新規ページ作成
- 「Investor Brief Trigger」 — Claude.ai に投資家面談ブリーフィングを依頼

---

## ステップ5: Claude モバイルアプリ (Connected/Automated環境)

1. App Store で「Claude」(公式・Anthropic) インストール
2. Pro アカウントでログイン
3. GSOS Project に切り替え
4. メモリーセクションで `.claude/context.md` を確認

モバイル Claude では:
- /quick-board が最も使いやすい (3エージェント10分)
- /irm-briefing は移動中の準備に活躍
- /sync-all はテキスト出力中心ならモバイルでも可 (ただし Cowork統合は不可)

---

## ステップ6: Granola Mobile (任意・推奨)

1. App Store で「Granola」インストール
2. デスクトップで使っているアカウントでログイン
3. iPhone でも会議に参加すると自動的に議事録化される
4. 議事録は Notion DB5 に手動コピペ (現状)

---

## モバイル運用の典型的な1日

```
08:00 起床
  Notion Mobile で DB4 Tasks の Today を確認

10:00 移動中の通勤電車
  Notion Mobile で DB9 Inbox の Unread をトリアージ
  Apple Shortcuts でアイデアを Voice Memo として記録

11:00 投資家面談 (オフィス)
  Granola Mobile で議事録自動取得
  終了直後、 Voice Memos で「面談の感触」を3分メモ

13:00 移動中
  /quick-board (Claude.ai) で午前面談のフォロー判断

18:00 帰宅
  デスクトップで Claude Code → /sync-all
  DB9 Inbox にiPhone から流入した8件をトリアージ
  翌日のフォーカスタスク決定
```

---

## トラブルシューティング

### Notion アプリが同期しない
- Settings → General → Check for updates
- アプリを完全終了して再起動
- Wi-Fi/4G 接続確認

### Voice Memos が iCloud に同期しない
- Settings → [Your Name] → iCloud → iCloud容量確認 (満杯ではないか)
- Settings → Voice Memos → 「After Auto-Delete」を「Never」に変更

### Make.com Blueprint が音声メモを取得しない
- Make.com の iCloud OAuth が切れていないか確認
- Voice Memos のフォルダ名が標準名のままか確認 (リネーム不可)

---

## セキュリティチェックリスト

- [ ] Notion アプリのパスコード/Face ID 保護有効
- [ ] Voice Memos の iCloud同期は意図した通りか
- [ ] iCloud バックアップは暗号化されているか
- [ ] 紛失時のリモートワイプ設定 (Find My iPhone)
- [ ] NDA下情報を音声メモに残さない
