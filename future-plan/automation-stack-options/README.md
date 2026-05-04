# Automation Stack Options — Make.com vs Zapier vs n8n

> **Status**: Pre-reset design materials. NOT part of v0.1.0. Reserved for Phase 2+ Inbox / iPaaS exploration.
>
> v0.1.0 explicitly chose **founder-triggered, no-automation** architecture. This directory preserves automation analysis for the day Phase 2 considers iPaaS extensions (e.g., Gmail-to-Inbox auto-sync).
>
> See `future-plan/ideas/inbox-channel-sourcetype.md` for the Inbox concept this would automate, and `future-plan/ideas/3-environment-model.md` for the broader "Automated environment" context.

---


Pre-reset design exploration considered  DB9 Inbox への自動流入を **Make.com** で実現することを標準としています。
本ドキュメントでは選択理由と他の選択肢の比較を提示します。

---

## なぜ Make.com を選んだか

### 1. コスト効率

| サービス | AI関連ステップ利用可能なプラン | 月額 |
|---------|--------------------------|------|
| **Make.com** | Core | **$9/月** |
| Zapier | Premium | $50/月 |
| n8n (Self-hosted) | Community | $0 + VPS代 ($13-30/月) |

**Make.com Core プランで Anthropic API・OpenAI・Webhook 等が利用可能** (Zapier は Premium必要)。

### 2. 無料プランの実用性

Make.com 無料プラン:
- 月1000オペレーション
- 最大2シナリオ (Blueprint)
- 15分間隔の実行

→ 多くのP1創業者は **無料プランで開始できる**

### 3. ノーコードと柔軟性のバランス

- ZapierほどUIが固い (=安心) ことはないが、 直感的
- n8nほど技術力を要求しない
- ローカルでテスト → 本番デプロイができる

### 4. データ主権

Make.com:
- ISO 27001 / SOC 2 Type II 認証
- データ保存場所: EU/US リージョン
- 標準ログ保存期間: 30日

ただし「外部サービス経由」であることに変わりないため、機密性の高い領域では n8n Self-hosted も検討。

---

## 三者比較

| 項目 | Make.com | Zapier | n8n |
|---|---|---|---|
| 月額 | $9 (Core) | $50 (Premium必須) | $0 + VPS$13-30 |
| 無料プラン実用性 | 1000ops/月で十分 | 100tasks/月で不足 | 完全Free |
| AI関連ステップ | Core で利用可 | Premiumのみ | OSSで自由 |
| 学習コスト | 中 | 低 | 高 |
| ノーコード性 | ◎ | ◎ | △ |
| データ主権 | 第三者経由 | 第三者経由 | 完全自社管理 |
| LtVサポート | Blueprint公式提供 | 非対応 | 非対応 |
| 推奨対象 | **GSOS v6.0標準** | 既存Zapier利用者 | 高機密性領域 (将来) |

---

## Make.com Blueprint 5種

Pre-reset design exploration considered 以下の Blueprint を提供 (`make-blueprints/` ディレクトリ):

1. **gmail-to-inbox.json** — Gmail重要メール → DB9 Inbox
2. **voicememo-to-inbox.json** — iCloud音声メモ → DB9 Inbox
3. **calendar-to-tasks.json** — Google Calendar予定 → DB4 Tasks
4. **inbox-ai-filter.json** — DB9 Inbox の Haiku 関連性スコアリング
5. **weekly-roast-trigger.json** — 週次 /weekly-roast 実行リマインダー

詳細: [make-blueprints/README.md](../make-blueprints/README.md)

---

## Zapier ユーザー向けの注意

すでに Zapier を契約している場合、 GSOS v6.0 の Make.com Blueprint を Zapier に移植することは可能ですが:
- AI関連ステップは Premium プラン ($50+/月) が必要
- Blueprint の YAML/JSON 形式は互換性なし (手動で再構築)

LtV としては推奨しないが、自己責任での移行は可能。

---

## n8n Self-hosted (将来オプション)

### いつ検討すべきか

以下の条件にすべて該当する場合、 n8n を検討:
- バイオ・量子・国防系などの **極めて機密性の高い領域**
- 月$30程度の VPS 費用を許容
- Docker/Linux運用ができる技術力 (または技術アドバイザー伴走)
- データを第三者サーバー経由で送信したくない

### 推奨VPS

最も推奨される構成は **Google Compute Engine (GCE)** :
- Workspace連携の親和性 (既に Google アカウント使用)
- 東京リージョン (asia-northeast1) で日本のレイテンシ最適
- $13-18/月 (e2-small インスタンス)
- 自動バックアップ容易

代替案:
- AWS Lightsail ($10-20/月)
- DigitalOcean ($12/月〜)
- Linode/Akamai ($12/月〜)

### v6.0 での扱い

n8n は v6.0 では **公式サポート対象外** ですが、 docs/automation-options.md (本ドキュメント) で言及。
将来的に GSOS の利用が広がった場合 (v7.0以降)、 LtV が n8n Blueprint を提供する可能性があります。

現時点では n8n を選ぶ場合は **完全に自己責任** での運用となります。

---

## 関連ドキュメント

- [make-blueprints/README.md](../make-blueprints/README.md) — Blueprint導入手順
- [WHAT-NOT-TO-INPUT.md](../WHAT-NOT-TO-INPUT.md) — iPaaS経由のデータフロー注意
- [docs/cost-breakdown.md](./cost-breakdown.md) — 月額コスト詳細
