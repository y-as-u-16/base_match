---
name: flutter-analyze
description: Flutter/Dartコードの静的解析とアーキテクチャ準拠チェックを実行する。コード品質確認、リファクタリング前の調査、PRレビュー準備に使用。
---

# Flutter Code Analyzer

base_match プロジェクトのコード品質を分析します。

## 分析対象

$ARGUMENTS が指定されていればそのパス、なければプロジェクト全体を分析。

## 実行する分析

### 1. Flutter 静的解析
```bash
flutter analyze
```
エラー・警告・情報を分類して報告。

### 2. アーキテクチャ準拠チェック

以下の違反がないか確認:

- **domain層の独立性**: `lib/features/*/domain/` 内に `import 'package:flutter` や `import 'package:supabase` が含まれていないか
- **レイヤ依存方向**: presentation → domain ← data の依存方向が守られているか
- **直接的なSupabaseアクセス**: presentation層から直接Supabaseを呼んでいないか

### 3. コード品質チェック

- 未使用の import がないか
- `print()` デバッグが残っていないか
- ハードコードされた文字列（国際化対応の観点）
- `setState` の使用（Riverpodを使うべき箇所で使っていないか）

### 4. Riverpod パターンチェック

- Provider が適切にスコープされているか
- `ref.watch` と `ref.read` の使い分けが正しいか
- dispose が必要な Provider で適切に処理されているか

## 出力フォーマット

結果を以下の形式で報告:

### 重大な問題（修正必須）
- ファイルパス:行番号 - 問題の説明

### 警告（修正推奨）
- ファイルパス:行番号 - 問題の説明

### 改善提案
- 具体的な改善案