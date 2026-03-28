---
name: supabase-schema
description: Supabaseのテーブル設計、RLS、マイグレーション、SQL Viewの作成・レビューを行う。DB設計変更、新テーブル追加、RLSポリシー確認時に使用。
---

# Supabase Schema Manager

base_match プロジェクトのデータベース設計を管理します。

## 引数

$ARGUMENTS に操作内容を指定してください。
例: `/supabase-schema 新しいnotificationsテーブルを追加`

## プロジェクトのDB設計

詳細は以下のドキュメントを必ず参照してください:
- `docs/01_テーブル設計書.md` - テーブル定義
- `docs/00_基本設計書.md` - 全体設計

### 主要テーブル
- `users` - ユーザー情報
- `teams` - チーム情報
- `team_members` - チーム所属
- `players` - プレイヤー情報（仮プレイヤー含む）
- `games` - 試合情報
- `plate_appearances` - 打席イベント（イベントソーシング）
- `claims` - 仮プレイヤーの本人紐付け
- `audit_logs` - 監査ログ

### 集計View
- `v_matchup_batter_pitcher` - バッター×ピッチャー対戦成績
- `v_matchup_team_team` - チーム×チーム対戦成績

## 設計原則

### RLS（Row Level Security）
- **全テーブルにRLS必須**
- ユーザーは自分が所属するチームのデータのみアクセス可能
- 公開データ（チーム名など）は認証済みユーザー全員がread可能
- audit_logs は管理者のみアクセス可能

### 命名規則
- テーブル名: スネークケース、複数形（`plate_appearances`）
- カラム名: スネークケース（`created_at`）
- View名: `v_` プレフィックス（`v_matchup_batter_pitcher`）
- インデックス名: `idx_<テーブル>_<カラム>`
- RLSポリシー名: `<テーブル>_<操作>_policy`

### マイグレーション
- Supabase CLIの `supabase migration new` を使用
- 各マイグレーションファイルには以下を含める:
  1. テーブル/カラムの変更
  2. RLSポリシーの追加・更新
  3. 必要なインデックス
  4. ロールバック用のコメント

### データ型ガイドライン
- ID: `uuid` (デフォルト `gen_random_uuid()`)
- 日時: `timestamptz` (デフォルト `now()`)
- テキスト: `text`（長さ制限はアプリ側で）
- 列挙: `text` + CHECK制約（Supabase Enumsは避ける）
- 金額: 使用なし

## 出力

変更を行う場合:
1. SQLマイグレーションコードを生成
2. 対応するDart側のモデル変更を提案
3. RLSポリシーの確認
4. docs/01_テーブル設計書.md の更新を提案