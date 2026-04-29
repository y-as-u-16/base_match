# 草野球マッチ - 草野球対戦履歴アプリ

草野球における **バッター × ピッチャー** および **チーム × チーム** の対戦履歴を記録し、因縁（相性）を「見せたくなるカード」として共有できるアプリです。未ログインではローカル記録、ログイン後はクラウド同期、課金でチーム共有・因縁生成を提供します。

## 主な機能

- **対戦成績の記録** - 打席イベントを入力し、バッター × ピッチャーの相性データを自動集計
- **ローカル利用開始** - 未ログインでも自分用の試合記録と個人成績確認ができる
- **クラウド同期** - ログイン後に端末内記録をクラウドへ移行・復元
- **チーム管理** - 招待コードでチームを作成・参加、メンバー管理
- **因縁カード** - 課金ユーザーは対戦成績を視覚的なカードにして SNS（LINE・Twitter 等）で共有
- **片側入力対応** - 自分だけの入力でも成立し、相手が後から登録して本人化（Claim）可能

## 技術スタック

| カテゴリ | 技術 |
|---------|------|
| フレームワーク | Flutter (Dart ^3.9.2) |
| バックエンド | Supabase (PostgreSQL + Auth) |
| 状態管理 | Flutter Riverpod |
| ルーティング | go_router |
| データモデル | Freezed + JSON Serializable |
| 環境変数 | flutter_dotenv |

## アーキテクチャ

Clean Architecture + MVVM パターンを採用しています。

```
lib/
├── core/           # 共通ロジック（テーマ、ルーティング、ユーティリティ）
├── features/       # 機能モジュール
│   ├── auth/       #   認証（ログイン・登録）
│   ├── games/      #   試合管理・打席入力
│   ├── teams/      #   チーム管理
│   ├── matchups/   #   対戦成績表示
│   ├── profile/    #   ユーザープロフィール
│   ├── home/       #   ホーム画面
│   └── share/      #   因縁カード共有
└── main.dart       # エントリーポイント
```

各フィーチャーは `data/`（リポジトリ実装）、`domain/`（エンティティ・インターフェース）、`presentation/`（画面・ViewModel）の3層で構成されています。

## セットアップ

### 前提条件

- Flutter SDK (^3.9.2)
- Supabase CLI

### 1. リポジトリのクローン

```bash
git clone <repository-url>
cd base_match
```

### 2. 依存パッケージのインストール

```bash
flutter pub get
```

### 3. ローカル Supabase の起動

```bash
brew install supabase/tap/supabase  # 未インストールの場合
supabase start
```

### 4. 環境変数ファイルの作成

`supabase start` で表示される情報を使って `.env.local` を作成します。

```bash
# .env.local（ローカル開発用）
SUPABASE_URL=http://127.0.0.1:54321
SUPABASE_ANON_KEY=<supabase start で表示された anon key>
```

### 5. コード生成

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 6. アプリの起動

```bash
flutter run
```

詳細は [docs/02_環境構築ガイド.md](docs/02_環境構築ガイド.md) を参照してください。

## ドキュメント

| ドキュメント | 内容 |
|------------|------|
| [基本設計書](docs/00_基本設計書.md) | プロダクト概要・スコープ・画面設計 |
| [テーブル設計書](docs/01_テーブル設計書.md) | DB スキーマ・RLS ポリシー |
| [環境構築ガイド](docs/02_環境構築ガイド.md) | 開発環境のセットアップ手順 |
| [実装計画](docs/03_実装計画.md) | フェーズごとの実装計画 |

## テスト

```bash
flutter test
```

## ライセンス

Private
