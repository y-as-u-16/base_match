# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

草野球対戦履歴アプリ「base_match」。バッター×ピッチャー、チーム×チームの対戦履歴を蓄積し、「因縁カード」として共有できるプロダクト。

## 技術スタック

- **フロントエンド**: Flutter (Dart SDK ^3.9.2)
- **バックエンド**: Supabase（認証、データベース、ストレージ）
- **状態管理**: Riverpod または Bloc（推奨）
- **アーキテクチャ**: MVVM + Clean Architecture

## 開発コマンド

```bash
# 依存関係インストール
flutter pub get

# アプリ実行
flutter run

# 静的解析
flutter analyze

# テスト実行
flutter test

# 単一テストファイル実行
flutter test test/widget_test.dart

# ビルド（iOS）
flutter build ios

# ビルド（Android）
flutter build apk
```

## アーキテクチャ

### ディレクトリ構成（予定）

```
lib/
  core/           # 共通基盤（エラー、ネットワーク、ルーティング、テーマ、ユーティリティ）
  features/       # 機能別モジュール
    auth/         # 認証
    teams/        # チーム管理
    games/        # 試合管理
    matchups/     # 対戦成績（因縁）
    profile/      # プロフィール
    share/        # 共有機能
  main.dart
```

### レイヤ構成

各feature内は以下の3層で構成:
- **presentation/**: View（Widget）、ViewModel（StateNotifier/AsyncValue）
- **domain/**: Entity、UseCase、Repository Interface（Flutter/Supabaseに非依存）
- **data/**: Repository実装、DataSource、DTO/Mapper

## 主要ドメイン概念

- **Player**: ユーザー本人または仮プレイヤー（未登録の相手選手）
- **PlateAppearance**: 打席イベント（一次データ、イベントソーシング）
- **Matchup**: バッター×ピッチャーまたはチーム×チームの対戦成績
- **Claim**: 仮プレイヤーを本人に紐づける機能

## データベース設計

主要テーブル: users, teams, team_members, players, games, plate_appearances, claims, audit_logs

集計はSQL View（v_matchup_batter_pitcher, v_matchup_team_team）で実施。RLS適用済み。

## 設計ドキュメント

詳細は `docs/00_基本設計書.md` を参照。

## カスタムSkills（自動呼び出しガイド）

`.claude/skills/` にプロジェクト専用のSkillsが定義されています。ユーザーがスラッシュコマンドで明示的に呼び出さなくても、以下の状況では適切なSkillを自動的に使用してください。

| Skill | 自動呼び出し条件 |
|-------|----------------|
| `flutter-feature` | 新しい画面や機能モジュールの作成を依頼されたとき |
| `flutter-analyze` | コード品質の確認、リファクタリング前の調査、「問題ないか確認して」等の依頼時 |
| `write-test` | テスト作成の依頼、または新機能実装後にテストが未作成の場合 |
| `supabase-schema` | テーブル追加・変更、RLSポリシー、マイグレーション関連の作業時 |
| `design-check` | UI実装後のレビュー、デザイン崩れの指摘、新しい画面のWidget作成後 |
| `build-runner` | freezedモデルやjson_serializableの変更後（※手動起動のみ、自動実行はしない） |
| `review-pr` | PRレビューの依頼、「PRを確認して」等の依頼時 |
