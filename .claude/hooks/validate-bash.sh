#!/bin/bash
# Bashコマンドの安全性を検証するフック
# 危険なコマンドをブロックする
set -e

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# 危険なコマンドパターン
DANGEROUS_PATTERNS=(
  "rm -rf /"
  "rm -rf ~"
  "rm -rf \."
  "> /dev/sda"
  "mkfs\."
  "dd if=.* of=/dev/"
  ":(){:|:&};:"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    echo "危険なコマンドがブロックされました: $pattern に一致" >&2
    exit 2
  fi
done

exit 0