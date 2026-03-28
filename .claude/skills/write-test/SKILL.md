---
name: write-test
description: Flutter/Dartのテストコードを作成する。ユニットテスト、Widgetテスト、統合テストの作成時に使用。
---

# Flutter Test Writer

base_match プロジェクトのテストコードを作成します。

## 引数

$ARGUMENTS にテスト対象のファイルパスまたはfeature名を指定してください。
例: `/write-test lib/features/teams/domain/entities/team.dart`

## テスト作成ルール

### ディレクトリ構成
テストファイルは `test/` 以下に、`lib/` と同じ構造で配置:
```
test/
  features/
    teams/
      data/repositories/    # Repository実装のテスト
      domain/entities/       # エンティティのテスト
      presentation/
        view_models/         # ViewModelのテスト
        pages/               # Widgetテスト
```

### テストの種類と優先度

1. **Unit Test（最優先）**: domain/entities, domain/usecases
   - 純粋なDartロジックのテスト
   - 外部依存なし
   - `flutter test test/features/.../domain/`

2. **ViewModel Test**: presentation/view_models
   - Repository をモック化
   - StateNotifier の状態遷移をテスト
   - `mocktail` パッケージを使用

3. **Widget Test**: presentation/pages, presentation/widgets
   - `WidgetTester` を使用
   - Provider のオーバーライドでモック注入
   - UI要素の存在・操作をテスト

4. **Repository Test**: data/repositories
   - Supabaseクライアントをモック化
   - データ変換ロジックの正確性を確認

### テストの書き方

```dart
// テストファイルの基本構造
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('クラス名', () {
    // setUp / tearDown

    group('メソッド名', () {
      test('正常系: 期待される動作の説明', () {
        // Arrange（準備）
        // Act（実行）
        // Assert（検証）
      });

      test('異常系: エラーケースの説明', () {
        // ...
      });
    });
  });
}
```

### 命名規則
- テストファイル名: `<対象ファイル名>_test.dart`
- group: クラス名 → メソッド名
- test: 「正常系/異常系: 動作の説明」

## 手順

1. テスト対象のコードを読んで理解する
2. テストケースを洗い出す（正常系・異常系・境界値）
3. 必要なモッククラスを作成
4. テストコードを実装
5. `flutter test <テストファイルパス>` で実行して確認