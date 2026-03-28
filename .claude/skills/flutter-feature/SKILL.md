---
name: flutter-feature
description: Clean Architecture + MVVM パターンに準拠した新しいfeatureモジュールを作成する。新機能追加、画面作成、feature scaffolding時に使用。
---

# Flutter Feature Generator

base_match プロジェクトに新しいfeatureモジュールを作成します。

## 引数

$ARGUMENTS にはfeature名を指定してください（例: `/flutter-feature notifications`）

## アーキテクチャルール

このプロジェクトは **MVVM + Clean Architecture** を採用しています。
新しいfeatureは以下のディレクトリ構成で作成してください:

```
lib/features/<feature_name>/
  data/
    repositories/         # Repository実装（Supabase通信）
    models/               # DTO / JSONモデル（freezed + json_serializable）
  domain/
    entities/             # ドメインエンティティ（純粋Dart、Flutter非依存）
    repositories/         # Repository インターフェース（抽象クラス）
  presentation/
    pages/                # 画面Widget
    view_models/          # StateNotifier / Riverpod Provider
    widgets/              # feature固有のWidget
```

## 実装ガイドライン

### 状態管理
- **flutter_riverpod** を使用（`^2.6.1`）
- ViewModelは `StateNotifier` または `AsyncNotifier` で定義
- Provider定義は view_models/ 内に配置

### エンティティ
- `freezed` アノテーションを使用
- domain/entities/ は Flutter に依存しない純粋な Dart クラス

### Repository
- domain/repositories/ にインターフェース（抽象クラス）を定義
- data/repositories/ に Supabase を使った実装クラスを配置
- Riverpod Provider でDI

### モデル（DTO）
- `freezed` + `json_serializable` を使用
- `fromJson` / `toJson` を自動生成
- エンティティへの変換メソッド `toEntity()` を実装

### ページ（View）
- `ConsumerWidget` または `ConsumerStatefulWidget` を使用
- テーマカラーは `AppTheme` の定数を使用:
  - `AppTheme.fieldGreen` (#1B4332) - メインカラー
  - `AppTheme.leatherBrown` (#5C4033) - アクセント
  - `AppTheme.stitchRed` (#C62828) - 強調
  - `AppTheme.baseWhite` (#FFF8F0) - 背景
- ルーティングは `go_router` を使用

## 作成手順

1. 既存のfeature（例: `lib/features/teams/`）を参考に構造を確認
2. 上記ディレクトリ構成でファイルを作成
3. エンティティ → Repository Interface → Repository実装 → ViewModel → Page の順で実装
4. `lib/core/routing/` にルート追加が必要か確認
5. `flutter pub run build_runner build` の実行が必要な場合は案内