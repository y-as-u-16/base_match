# AGENTS.md

このリポジトリで作業する人間・AI エージェント向けの作業ガイドです。実装前に全体を読み、変更の粒度を小さく保ってください。

## プロジェクト概要

- アプリ: 草野球の対戦履歴を記録・共有する Flutter アプリ
- 主要技術: Flutter, Riverpod, go_router, Supabase, Freezed, json_serializable
- アーキテクチャ: Clean Architecture + MVVM

## ディレクトリ方針

- `lib/core/`: ルーティング、テーマ、共通 UI、定数、ユーティリティ
- `lib/features/<feature>/`: 機能単位の実装
- `lib/features/<feature>/data/`: Repository 実装、DTO、外部連携
- `lib/features/<feature>/domain/`: Entity、Repository interface
- `lib/features/<feature>/presentation/`: 画面、ViewModel、UI ロジック
- `test/unit/`: 単体テスト
- `test/widget/`: Widget テスト
- `docs/`: 要件・設計・セットアップ資料
- `supabase/`: ローカル Supabase 関連ファイル、マイグレーション

## セットアップ

1. `flutter pub get`
2. `supabase start`
3. `.env.local` を作成する
4. 必要に応じて `dart run build_runner build --delete-conflicting-outputs`
5. `flutter run`

`.env.local` の例:

```dotenv
SUPABASE_URL=http://127.0.0.1:54321
SUPABASE_ANON_KEY=<supabase start で表示された anon key>
```

補足:

- 開発時は `.env.local`、リリース時は `.env` を読む実装になっています
- Android エミュレータでは `127.0.0.1` が `10.0.2.2` に変換されます
- 機密情報はコミットしないでください

## よく使うコマンド

```bash
flutter pub get
dart format .
flutter analyze
flutter test
dart run build_runner build --delete-conflicting-outputs
supabase start
```

## 実装ルール

- 既存の feature 分割と `data/domain/presentation` の責務を崩さない
- UI から Supabase を直接呼ばず、Repository 経由に寄せる
- ルーティング変更は `lib/core/routing/` を起点に確認する
- 状態管理は既存の Riverpod パターンに合わせる
- 生成コードは手編集しない
- 影響範囲がある変更では `flutter analyze` と関連テストを優先して実行する

## コード生成

以下のような生成物は直接編集しません。

- `*.freezed.dart`
- `*.g.dart`

モデルやアノテーションを更新したら、次を実行してください。

```bash
dart run build_runner build --delete-conflicting-outputs
```

## テスト方針

- ロジック追加時は `test/unit/` を優先
- UI の分岐や画面導線は `test/widget/` を追加
- バグ修正時は、再発防止になるテスト追加を優先

## ドキュメント参照先

- `README.md`: 概要と基本コマンド
- `docs/00_基本設計書.md`: 画面・プロダクト設計
- `docs/01_テーブル設計書.md`: DB/RLS 設計
- `docs/02_環境構築ガイド.md`: 環境変数と Supabase セットアップ
- `docs/03_実装計画.md`: 実装フェーズ

## 変更時の注意

- 既存の未コミット変更を巻き戻さない
- `.env`, `.env.local` などの機密ファイルは新規作成しても Git に含めない
- `README.md` や `docs/` を変える場合は、実装内容と不整合がないように同時更新する
- 大きな変更は小さい単位に分け、意図がわかる差分にする
