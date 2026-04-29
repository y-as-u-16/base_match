---
name: issue-inspect
description: GitHub Issue 番号、#番号、または Issue URL を受け取り、Issue の内容を確認して要件・背景・不明点・次の確認事項を整理する
argument-hint: "Issue番号、#番号、またはIssue URL"
disable-model-invocation: true
allowed-tools: Read Grep Glob Bash
---

# Issue Inspect

GitHub Issue の内容を確認し、実装前に必要な情報を短く整理してください。

## 引数の解釈

- `123`: Issue 番号として扱う
- `#123`: `#` を除いて Issue 番号として扱う
- `https://github.com/<owner>/<repo>/issues/123`: URL からリポジトリと Issue 番号を読み取る
- 番号や URL がない場合は、ユーザーに Issue 番号を確認する

## 前提

- GitHub Issue の確認には `gh` を優先して使う
- 現在の Git リポジトリが GitHub に紐づいている場合は、そのリポジトリの Issue として扱う
- Issue URL が渡された場合は、URL の `<owner>/<repo>` を優先する
- `gh` が使えない、未認証、または Issue にアクセスできない場合は、エラー内容を伝え、Issue URL または本文の共有を依頼する
- Issue 内容の確認だけを行い、ユーザーが明示しない限りブランチ作成・実装・ファイル編集はしない
- Issue 内容から実装用ブランチ名を 1 つ提案する。ただし、ユーザーが明示しない限りブランチは作成しない

## ブランチ名の提案ルール

- 形式は `<prefix>/#Issue番号_english-english` を基本にする
- 例: `feature/#28_local-record-mode`
- prefix は既存リポジトリの規約があれば最優先する。規約がない場合は、一般的な Gitflow / Bitbucket 系の分類に合わせて、機能追加は `feature`、通常の不具合修正は `bugfix`、本番緊急修正は `hotfix`、リリース準備は `release` を使う
- ドキュメントのみ、設定・依存関係・開発補助などの作業で、リポジトリに専用 prefix の規約がない場合は、Conventional Commits で広く使われる分類に合わせて `docs` または `chore` を使ってよい
- prefix と Issue 番号の間は `/` でつなぐ
- Issue 番号と英単語部分は `_` でつなぐ
- 英単語同士は `-` でつなぐ
- 英単語部分は Issue の目的が分かる短い kebab-case にする
- ブランチ名は提案だけに留め、ユーザーが依頼するまで `git switch -c` などは実行しない

## 手順

1. 入力から Issue 番号または Issue URL を特定する。
2. `git remote get-url origin` で現在の GitHub リポジトリを確認する。URL が渡されている場合は URL 側を優先する。
3. `gh issue view` で Issue のタイトル、状態、本文、ラベル、担当者、コメント、URL を取得する。
4. 本文とコメントを読み、実装に必要な情報だけを抽出する。
5. Issue が close 済み、別 Issue に重複、仕様未確定、または作業対象外に見える場合は明示する。
6. 追加で確認すべきソースやドキュメントがある場合だけ、必要最小限でリポジトリ内を検索する。
7. Issue の内容から、ブランチ名の提案ルールに沿ったブランチ名を 1 つ作る。
8. 最後に、実装へ進む場合の最小の次アクションを提示する。

## 推奨コマンド

現在のリポジトリの Issue を見る:

```bash
gh issue view 123 --comments
```

JSON で構造化して見る:

```bash
gh issue view 123 --json number,title,state,author,labels,assignees,milestone,body,url,createdAt,updatedAt,comments
```

URL の Issue を見る:

```bash
gh issue view 123 --repo owner/repo --comments
```

## 出力形式

次の順で簡潔に報告してください。

1. **Issue**: `#番号 タイトル`、状態、URL
2. **要約**: 何を解決したい Issue か
3. **要件**: 実装・修正で満たすべき条件
4. **背景/コメント**: コメントから分かる補足や決定事項
5. **不明点**: 実装前に確認が必要な点。なければ「特になし」
6. **影響範囲候補**: 関連しそうなファイル、機能、テスト。推測の場合は推測と書く
7. **ブランチ名案**: `<prefix>/#Issue番号_english-english` 形式の候補を 1 つ
8. **次のアクション**: 調査、設計、実装、テストの最小ステップ

## 注意

- Issue 本文やコメントをそのまま長く貼らず、要点に圧縮する
- 仕様が曖昧な場合は勝手に決めず、不明点として分離する
- 実装依頼に変わった場合は、まず Issue から作業範囲を再確認してから着手する
- ブランチ名を提案しても、明示依頼がない限りブランチ作成はしない
