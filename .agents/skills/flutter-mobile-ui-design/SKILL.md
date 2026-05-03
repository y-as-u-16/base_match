---
name: flutter-mobile-ui-design
description: Flutter モバイルアプリの UI/UX 改善を行う。Material 3、ColorScheme/TextTheme、レスポンシブレイアウト、アクセシビリティ、空状態、カード/カレンダー/入力UI、モバイル向けデザイン品質を扱う。Flutter の presentation/widgets/pages 配下で見た目を改善したい、UI方針を作りたい、Figma/モバイルデザイン案を実装したい、既存機能を壊さず画面を洗練したい場合に使う。
---

# Flutter Mobile UI Design

Flutter モバイル画面を、既存の機能・状態管理・データ構造を壊さずに、使いやすく現代的な UI/UX へ改善するための Skill です。Material 3、モバイルのタップ操作、アクセシビリティ、デザイントークン、Widget 分割を優先します。

## 基本方針

- まず対象画面の実装を読む。`pages/`、`widgets/`、`view_models/`、l10n、既存 widget test を確認する。
- UI 改善とロジック変更を混ぜない。原則として `presentation/` 配下で完結させる。
- Provider、Repository、DB、routing、保存処理は、UI改善だけでは触らない。
- 既存の公開 API、constructor、route、test key、tooltip、l10n key を壊さない。
- 画面ファイルを太らせない。page は状態取得と構成に寄せ、見た目は `widgets/` に分割する。
- 生成コード、`*.g.dart`、`*.freezed.dart` は編集しない。

## 進め方

1. **目的を絞る**
   - 対象画面だけに限定する。
   - 新しい機能追加なのか、既存機能の見た目改善なのかを分ける。
   - ユーザーが「方針だけ」と言った場合は実装しない。

2. **現状を分解する**
   - page: Provider 読み取り、画面状態、画面構成。
   - widgets: カード、空状態、入力部品、切替UI、リスト/グリッド。
   - tests: どの文言、key、導線が期待されているか。

3. **UI構成を決める**
   - ファーストビューに最重要情報を置く。
   - セクション見出しで文脈を保つ。
   - カードごとに役割を分ける。
   - 1画面に情報を詰め込みすぎない。

4. **Widget に分割する**
   - 画面専用でも複雑なら private class のまま長くしない。
   - 目安: header、mode selector、summary/card、empty state、list item、calendar grid、input row は分ける。
   - 重複する `Entity -> Card` 変換は helper widget に寄せる。

5. **検証する**
   - `dart format <changed files>`
   - `flutter analyze`
   - 関連 widget test
   - 影響範囲が広い場合は `flutter test`

## デザイン原則

### Material 3 / Theme

- 色は `Theme.of(context).colorScheme` から取る。
- 文字は `Theme.of(context).textTheme` から始める。
- 画面固有の色を直書きしない。必要なら小さな private helper で意味を持たせる。
- ライト/ダーク両方で読めるコントラストにする。
- `surface`、`surfaceContainer*`、`primaryContainer`、`tertiaryContainer`、`outlineVariant` を活用する。

### モバイル操作

- タップ可能領域は最低 44px 以上を目安にする。
- アイコンボタンには tooltip を付ける。
- 小さい画面では横並びを崩せるよう `LayoutBuilder`、`Wrap`、`FittedBox` を使う。
- 長いテキストは `maxLines` と `overflow` を決める。
- ボタンやセルの高さが内容で大きく揺れないよう、固定幅/高さや制約を使う。

### カード / Bento / スポーツデータUI

- カードは情報の役割を明確にする。例: スコア、メタ情報、選択日、空状態。
- 重要な数値は大きく、補助情報は小さく薄く表示する。
- スポーツアプリらしさは、スコアボード風の階層、バッジ、区切り線、強い数値表現で出す。
- 過剰な野球イラスト、派手な装飾、意味のないアニメーションは避ける。
- グラス風や半透明は控えめに使い、可読性を優先する。

### 入力UI

- 数値入力は `Stepper`、`SegmentedButton`、プラス/マイナスボタン、プリセットを検討する。
- 保存 CTA は明確に目立たせる。
- バリデーションは入力箇所の近くに出す。
- 入力画面ではタップ回数を減らす。

### 空状態

- 空状態は「何がないか」だけでなく、次に何をするかを示す。
- CTA は1つに絞る。
- 装飾は控えめにし、アプリの世界観を示す小さなプレビュー程度にする。

## Flutter 実装ルール

- `const` constructor を可能な範囲で使う。
- `BuildContext` から theme/l10n を取得し、必要最小限に渡す。
- 文言は l10n に置く。テストだけのために固定日本語を増やさない。
- `withValues(alpha: ...)` を使い、既存の Flutter バージョンに合わせる。
- `Card` 内のタップは `InkWell` と `borderRadius` を揃える。
- `DecoratedBox` + `Material(color: Colors.transparent)` + `InkWell` の組み合わせは、装飾とリップルを両立したいときに使う。
- スクロール領域内に `GridView` を入れる場合は `shrinkWrap: true` と `NeverScrollableScrollPhysics` を検討する。

## 変更前チェック

- 対象画面だけか。
- 既存機能、route、provider、repository、DB に触っていないか。
- 既存 widget test が何を保証しているか。
- l10n 追加が必要か。追加したら `flutter gen-l10n` を実行する。
- 画面ファイルが太るなら先に widget 分割する。

## 実装後チェック

- 文字が小画面で潰れないか。
- 長いチーム名/名前/ラベルが overflow しないか。
- ダークモードでもコントラスト不足にならないか。
- タップ領域が小さすぎないか。
- 空データ、1件、複数件で破綻しないか。
- `flutter analyze` と関連テストを通したか。

## base_match での追加ルール

- `lib/features/<feature>/presentation/pages/` は薄く保つ。
- 画面専用の見た目は `lib/features/<feature>/presentation/widgets/` に分ける。
- 記録画面では、試合一覧/カレンダー/試合作成導線を磨く。成績ダッシュボード要素を勝手に足さない。
- Home/Stats/Record など、ユーザーが指定した画面以外へ波及させない。
- 既存のローカル記録方針を尊重し、UI文言で「ローカル」「ログインなし」を前面に出しすぎない。
