---
name: design-check
description: UIデザインシステム（野球テーマカラー、コンポーネントスタイル）への準拠をチェックする。UI実装、デザインレビュー、新画面作成時に使用。
---

# Design System Checker

base_match プロジェクトのUIがデザインシステムに準拠しているかチェックします。

## 引数

$ARGUMENTS にチェック対象のファイルパスを指定。省略時はpresentation層全体をチェック。

## デザインシステム定義

テーマ定義: `lib/core/theme/app_theme.dart`

### カラーパレット（野球テーマ）

| 定数名 | カラーコード | 用途 |
|--------|-------------|------|
| `AppTheme.fieldGreen` | #1B4332 | メインカラー、AppBar背景 |
| `AppTheme.leatherBrown` | #5C4033 | アクセントカラー |
| `AppTheme.stitchRed` | #C62828 | 強調、選択中のナビアイコン |
| `AppTheme.baseWhite` | #FFF8F0 | 背景色 |
| `AppTheme.trophyGold` | #D4A017 | 実績、ハイライト |

### チェック項目

#### 1. カラー使用
- ハードコードされたカラーコード（`Color(0xFF...)`, `Colors.blue` など）がないか
- `AppTheme` の定数を使用しているか
- ダークモード対応が考慮されているか

#### 2. AppBar スタイル
- 背景: `AppTheme.fieldGreen`（ライトモード）
- テキスト: 白色
- letterSpacing: 1.5

#### 3. BottomNavigationBar
- 選択中アイコン/インジケータ: `AppTheme.stitchRed`

#### 4. Card スタイル
- borderRadius: 12（野球カード風）
- 適切な elevation とpadding

#### 5. 画面遷移アニメーション
- タブ切り替え（home/teams/matchups/profile）: **フェード**
- 詳細画面: **スライドアップ + フェード**
- カードプレビュー: **スケール + フェード**
- 作成/入力画面: **スライドライト**
- 認証画面: **フェード**

#### 6. タイポグラフィ
- フォントサイズの一貫性
- テーマで定義された TextStyle の使用

#### 7. スペーシング
- 一貫したパディング/マージン値
- レスポンシブ対応

## 出力フォーマット

### 準拠 OK
- チェック項目ごとの合格状況

### 違反箇所
- ファイルパス:行番号 - 違反内容 - 修正提案

### 改善提案
- デザイン品質向上のための提案