---
name: review-pr
description: Pull Requestをbase_matchのアーキテクチャ・デザインシステム基準でレビューする。PRレビュー、コードレビュー依頼時に使用。
---

# PR Reviewer

base_match プロジェクトのPull Requestをレビューします。

## 引数

$ARGUMENTS にPR番号またはブランチ名を指定。
例: `/review-pr 15` or `/review-pr feature/notifications`

## レビュー観点

### 1. アーキテクチャ準拠
- MVVM + Clean Architecture のレイヤ分離が守られているか
- domain層がFlutter/Supabaseに依存していないか
- 依存の方向: presentation → domain ← data

### 2. Riverpod パターン
- Provider定義が適切か
- `ref.watch` / `ref.read` の使い分け
- 不要な再ビルドが発生しないか

### 3. デザインシステム
- `AppTheme` のカラー定数を使用しているか
- 画面遷移アニメーションが規約通りか
- Card の borderRadius: 12 準拠

### 4. DB / Supabase
- RLSポリシーの考慮
- SQLインジェクションの防止
- 適切なエラーハンドリング

### 5. コード品質
- 未使用のimport
- デバッグ用の `print()` 残り
- マジックナンバー・ハードコード文字列
- 適切な命名

### 6. テスト
- 新機能に対するテストが追加されているか
- テストカバレッジが低下していないか

## レビュー手順

1. PRの差分を取得
   ```bash
   gh pr diff $PR_NUMBER
   ```

2. 変更ファイルの一覧確認
   ```bash
   gh pr diff $PR_NUMBER --name-only
   ```

3. 各ファイルを上記観点でレビュー

4. PR情報の確認
   ```bash
   gh pr view $PR_NUMBER
   ```

## 出力フォーマット

### PR概要
- タイトル、説明、変更ファイル数

### 必須修正（Approve前に対応必要）
- ファイル:行番号 - 問題の説明と修正案

### 推奨修正（対応推奨だがブロッカーではない）
- ファイル:行番号 - 改善提案

### Good Points
- 良い点や工夫されている点

### 総合判定
- Approve / Request Changes / Comment