---
name: multi-issue-worktree-agents
description: 複数の GitHub Issue 番号を受け取り、Issue ごとに専用ブランチと Git worktree を作成して、各 worktree にサブエージェントを割り当てる
---

# Multi Issue Worktree Agents

複数 Issue を並列で進めるために、Issue ごとに branch/worktree/worker agent を分離してください。

## 使う場面

- ユーザーが複数 Issue 番号を渡し、それぞれを並列に実装したいとき
- 変更範囲が独立しており、別々の worktree に分けられるとき
- サブエージェントを使って作業を分担する明示的な依頼があるとき

## 基本方針

- 1 Issue = 1 branch = 1 worktree = 1 worker agent
- worker には担当 Issue、担当 worktree、触ってよい範囲、完了条件を明示する
- 複数 worker が同じファイルを大きく変更しそうな場合は、先に分割方針を決める
- 親エージェントは作成、割り当て、進捗確認、結果統合を担当する
- worker は他の worker の変更を戻さない

## 手順

1. Issue 番号一覧を抽出する。
2. 起点ブランチを確認する。指定がなければ `main`、存在しなければ `master` を候補にする。
3. `git status --short` と `git worktree list` で、親 checkout の状態と既存 worktree を確認する。
4. `issue-worktree` スキルのスクリプトで、Issue ごとの branch/worktree を作成する。
5. 作成結果の `issue / branch / worktree` 対応表を作る。
6. Issue ごとに worker agent を起動する。依頼文には必ず以下を含める。
   - 担当 Issue 番号
   - 作業する worktree の絶対パス
   - ブランチ名
   - 作業範囲
   - 実行すべき検証
   - 他 agent の変更を戻さないこと
7. worker の結果を待ち、各 worktree で `git status --short` と必要なテストを確認する。
8. 競合や重複変更があれば親エージェントが調整する。
9. 最終報告では Issue ごとの branch、worktree、変更概要、検証結果、残タスクを一覧にする。

## 作成コマンド

```bash
.agents/skills/issue-worktree/scripts/create_issue_worktrees.sh 123 124 125
```

起点ブランチを指定する場合:

```bash
.agents/skills/issue-worktree/scripts/create_issue_worktrees.sh --base develop 123 124 125
```

## worker への依頼テンプレート

```text
Issue #<number> を担当してください。

作業ディレクトリ: <absolute-worktree-path>
ブランチ: <branch-name>

このリポジトリでは複数の worker が並行作業しています。
他 worker の変更を戻さず、この Issue に必要な範囲だけを変更してください。

まず Issue 内容と関連コードを確認し、実装してください。
完了時は変更ファイル、検証コマンド、未解決事項を報告してください。
```

## 並列化の判断

並列化してよい:

- Issue 間の変更ファイルが明確に分かれている
- 片方が調査、片方が実装など、成果物が衝突しにくい
- 各 Issue の完了条件が独立している

並列化を避ける:

- 同じ設計判断に依存している
- 同じ中核ファイルを大きく書き換える
- DB schema、API contract、共通型などの順序依存が強い
- 片方の結果を見ないともう片方の実装方針が決められない

## 根拠

- Git worktree は複数 branch の作業ディレクトリを並行して持てるため、Issue ごとの分離に向いている。
- Git は同一 branch の複数 checkout を制限するため、Issue ごとの専用 branch が必要。
- Codex app の worktree は foreground の local checkout を乱さず background 作業を進めるための仕組みで、複数作業の分離と相性がよい。
- サブエージェントは独立した具体タスクに使い、親エージェントは重複作業を避けて統合と検証に集中する。
