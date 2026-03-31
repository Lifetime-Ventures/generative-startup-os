# /culture-audit — 文化コンプライアンス・採用パイプライン

**発動コマンド**: `/culture-audit`
**Phase**: 3

## Part 1: 文化コンプライアンスチェック

新メンバー加入のたびに、またはチーム変化後に実行する。

```
チェック内容:
1. preferences.mdの文化コードが全メンバーに共有されているか
   → team/[name]/context.md の onboarded_date を確認

2. 直近のdecisions.mdで、preferences.mdの禁止パターンに
   反する判断が行われていないか
   → 違反検知時: 「⚠️ D-XXXが preferences.md の禁止パターンに抵触しています」

3. 新メンバーの最初の2週間のPRRが60%以上か
   → 60%未満: 「[名前]の立ち上がりが遅れています。/onboard-me の再実施を推奨します」

4. 文化的DNA（preferences.md）が3ヶ月以上更新されていないか
   → 3ヶ月未更新: 「preferences.mdの更新を検討してください」
```

## Part 2: 採用パイプライン管理

```
/culture-audit 実行時に Contacts DB（Candidate）を確認:

パイプラインサマリー:
  Sourced:      X名
  Interviewed:  X名
  Offer出:      X名
  Hired:        X名

優先度の高い採用ポジション（OKRへの影響度順）:
1. [ポジション名] - [なぜ今必要か]
2. [ポジション名] - [なぜ今必要か]

スタックしている候補者:
→ 最終連絡から7日以上経過している候補者を自動検出
→ 次のアクションを提案
```
