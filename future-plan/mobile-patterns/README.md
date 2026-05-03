# Mobile Patterns — Aspirational Guides

> **Status**: Pre-reset design materials. NOT part of v0.1.0 documentation. v0.1.0 README simply notes "first install desktop recommended; mobile use thereafter is supported for `/today` and lightweight workflows".
>
> These guides explore deeper mobile-specific workflows that may inform Phase 2+ documentation.
>
> See v0.1.0 README "Compatibility" table for the current official mobile guidance.

---


GSOS v6.0 はモバイル中心の創業者でも運用できるよう設計されています。
本ディレクトリには iPhone / Android / Apple Shortcuts を使った運用パターンを記載します。

---

## モバイル運用の中核アイディア

```
[移動中・現場]
  ↓ 思いついた・観察した・録音した
[音声メモ / Notion Mobile / Quick Capture]
  ↓ 自動転送 (Make.com Blueprint)
[DB9 Inbox]
  ↓ 帰宅後にデスクで処理 (/sync-all)
[Decisions / Tasks / Organizations]
```

---

## ガイド一覧

| ガイド | 用途 |
|---|---|
| [ios-setup.md](./ios-setup.md) | iPhone 用セットアップ |
| [android-setup.md](./android-setup.md) | Android 用セットアップ |
| [apple-shortcuts.md](./apple-shortcuts.md) | Apple Shortcuts 活用 (音声メモ自動転送等) |

---

## 推奨アプリ構成

### iPhone
- **Notion** (公式アプリ) — 9DBアクセス
- **Granola Mobile** (議事録) — Connected/Automated 環境
- **Voice Memos** (純正・Apple) — 音声メモ
- **Apple Shortcuts** — 自動化
- **Claude** (公式アプリ・iOS) — Claude.ai利用時

### Android
- **Notion** (公式アプリ) — 9DBアクセス
- **Granola** または **Otter.ai** (議事録)
- **Recorder** (Google純正) — 音声メモ・自動文字起こし
- **Tasker** (有料) — 自動化 (Apple Shortcuts相当)

---

## 主要なモバイル運用パターン

### Pattern A: 投資家面談の即時記録
1. 面談直後、 iPhone の Voice Memos でメモを録音 (3分)
2. Apple Shortcuts (または Make.com Blueprint) が起動 → 文字起こし → DB9 Inbox に投入
3. 帰宅後デスクで /sync-all → Investor 関連の Tasks/Decisions が起票

### Pattern B: 顧客インタビュー後のフォロー
1. インタビュー終了直後、 Notion Mobile で DB5 Meeting Memos に新規ページ作成
2. 重要な発言と Pain Score を即時メモ (5分)
3. /update-crm をデスクで後で実行

### Pattern C: アイデアのキャプチャ
1. 思いついたら Notion Quick Capture (iOSウィジェット)
2. DB9 Inbox に Source=QuickCapture で投入
3. 翌朝の /sync-all でトリアージ

### Pattern D: 移動中の Decision 草案
1. iPhone で Voice Memos に Decision 草案を音声録音
2. Make.com Blueprint で文字起こし → DB9 Inbox 投入
3. 帰宅後に /quick-board で深掘り、 Decision 確定

---

## モバイルでできること・できないこと

### モバイルで快適にできる
- DB9 Inbox の閲覧・トリアージ
- DB5 Meeting Memos への議事録追加
- Tasks の Status 更新
- Decisions の閲覧
- 音声メモの取得 → 自動 Inbox 流入

### モバイルで難しい (デスクトップ推奨)
- /sync-all (Claude Code 利用)
- /weekly-roast (長文入力が必要)
- /board-prep (PowerPoint生成)
- /cowork-dispatch (Cowork Desktop必須)
- 複雑な Notion フォーミュラ編集

→ モバイルは「キャプチャ」専用、デスクトップは「処理・分析」専用と役割分担すると効率的。

---

## 同期に関する注意

- Notion Mobile は時々データ同期遅延がある (5-10分)
- 重要な Decision を入力したら、デスクトップ Notion でも確認推奨
- iCloud Drive 経由の音声メモは数分のラグあり

---

## セキュリティへの注意

モバイル端末は紛失リスクが高いため:
- Notion アプリの**パスコード/Face ID保護**を有効化
- iCloud / Google Drive 上の音声メモは E2E暗号化されていない
- NDA下情報を音声メモに残さない ([WHAT-NOT-TO-INPUT.md](../WHAT-NOT-TO-INPUT.md))
- 紛失時は Notion Settings → Connected apps から該当端末をリモート切断
