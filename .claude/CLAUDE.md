# プロジェクト設定

## 基本方針
- 日本語で応対してください
- コード変更時は既存のスタイル・規約に従ってください

## 利用可能なスキル（スラッシュコマンド）
- `/review` - コードレビュー
- `/test-gen <ファイル>` - テスト生成
- `/explain <ファイルまたはキーワード>` - コード解説
- `/security-check [ファイル]` - セキュリティ検査
- `/refactor <ファイル>` - リファクタリング
- `/debug <エラー>` - デバッグ支援
- `/performance [ファイル]` - パフォーマンス分析
- `/git-summary` - Git変更サマリー
- `/issue-worktree <Issue番号>` - Issue単位のブランチ/worktree作成と開発
- `/multi-issue-worktree-agents <Issue番号...>` - 複数Issueをworktreeとサブエージェントで並列開発

## 利用可能なエージェント
- `@code-reviewer` - コードレビュー専門家
- `@test-writer` - テスト生成専門家
- `@security-auditor` - セキュリティ監査専門家
- `@debugger` - デバッグ専門家
- `@architect` - アーキテクチャ分析専門家
