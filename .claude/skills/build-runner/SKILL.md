---
name: build-runner
description: freezed/json_serializableのコード生成（build_runner）を実行する。モデル変更後、*.g.dart/*.freezed.dartの再生成が必要な時に使用。
disable-model-invocation: true
---

# Build Runner

freezed / json_serializable のコード自動生成を実行します。

## 実行コマンド

### 全体ビルド（通常使用）
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### ウォッチモード（開発中の継続的生成）
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## 実行前チェック

1. `pubspec.yaml` の依存関係を確認:
   - `freezed_annotation` (dependencies)
   - `json_annotation` (dependencies)
   - `freezed` (dev_dependencies)
   - `json_serializable` (dev_dependencies)
   - `build_runner` (dev_dependencies)

2. 対象ファイルの確認:
   - `@freezed` アノテーションが付いたクラスがあるか
   - `part '<ファイル名>.freezed.dart';` が宣言されているか
   - `part '<ファイル名>.g.dart';` が宣言されているか（JSON対応の場合）

## 実行後チェック

- 生成ファイル（`*.freezed.dart`, `*.g.dart`）がエラーなく生成されたか
- `flutter analyze` でエラーがないか確認

## トラブルシューティング

- **conflicting outputs エラー**: `--delete-conflicting-outputs` フラグで解決
- **part directive エラー**: `part` 宣言がファイル名と一致しているか確認
- **依存関係エラー**: `flutter pub get` を先に実行