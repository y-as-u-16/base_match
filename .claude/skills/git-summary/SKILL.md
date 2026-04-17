---
name: git-summary
description: Gitの変更履歴を要約する。PR作成前の確認に便利
argument-hint: [ブランチ名またはコミット数]
disable-model-invocation: true
allowed-tools: Bash Read
---

# Git変更サマリー

現在のブランチの変更内容を要約してください。

## 情報収集

以下のコマンドで情報を収集:

```!
git log --oneline -20
```

```!
git diff --stat HEAD~5
```

## 出力形式

```
## 変更サマリー
（何を実装/修正したか、1-3文で）

## 変更ファイル一覧
（カテゴリ別に分類）

## 主な変更点
（箇条書きで重要な変更）

## レビュー時の注意点
（レビュアーに見てほしいポイント）
```