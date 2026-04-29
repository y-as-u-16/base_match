---
name: issue-worktree
description: 指定された GitHub Issue 番号から専用ブランチと Git worktree を作成し、その worktree 内で開発を進める
---

# Issue Worktree

GitHub Issue 1件を、専用ブランチと専用 worktree に分離して作業してください。

## 前提

- Git リポジトリ内で実行する
- GitHub Issue を使う場合は `gh` が利用可能で認証済みであることが望ましい
- worktree は原則としてリポジトリ直下ではなく、兄弟ディレクトリに作る
- 1つのブランチを複数 worktree で同時に checkout しない

## 推奨命名

- ブランチ: `issue/<issue-number>-<short-slug>`
- worktree: `../<repo-name>-worktrees/<branch-slug>`

例:

```bash
git worktree add ../my-app-worktrees/issue-123-login-fix issue/123-login-fix
```

## 手順

1. Issue 番号、起点ブランチ、作成先を確認する。起点ブランチ指定がなければ `main`、存在しなければ `master` を候補にする。
2. `git status --short` で現在の作業ツリーが汚れていないか確認する。未コミット変更がある場合は、作業中の変更を巻き込まないようユーザーに確認する。
3. `gh issue view <number>` で Issue のタイトルと本文を確認する。`gh` が使えない場合は、Issue 番号だけを使ってブランチ名を作る。
4. `scripts/create_issue_worktrees.sh` を使って、Issue 用ブランチと worktree を作成する。
5. 作成された worktree に移動し、Issue 内容を読み直して実装範囲を決める。
6. 実装、テスト、差分確認は必ず作成した worktree 内で行う。
7. 完了時は worktree パス、ブランチ名、実行した検証、残タスクを報告する。

## 作成コマンド

```bash
.claude/skills/issue-worktree/scripts/create_issue_worktrees.sh 123
```

起点ブランチを指定する場合:

```bash
.claude/skills/issue-worktree/scripts/create_issue_worktrees.sh --base develop 123
```

worktree 作成先を指定する場合:

```bash
.claude/skills/issue-worktree/scripts/create_issue_worktrees.sh --root ../worktrees 123
```

## 実装ルール

- Issue ごとにブランチと worktree を分ける
- 作業対象外の worktree や親 checkout の変更を触らない
- `git worktree list` で既存 worktree とブランチ衝突を確認する
- 依存関係のインストール、ビルド成果物、`.env` などは worktree ごとに分離する
- 作業が終わった worktree は、マージ後に `git worktree remove <path>` で片付ける

## 根拠

- Git 公式ドキュメントでは、1つのリポジトリに複数の working tree を持ち、複数ブランチを同時に checkout できると説明されている。
- Git は同じブランチを複数 worktree で同時に checkout することを制限するため、Issue ごとに専用ブランチを作る。
- GitHub CLI には Issue に紐づく開発ブランチを作る `gh issue develop` があるため、利用可能ならそれを優先する。
- Codex app も worktree を foreground/local checkout から分離した並列作業環境として扱っている。
