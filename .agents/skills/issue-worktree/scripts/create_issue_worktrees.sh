#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  create_issue_worktrees.sh [--base <branch>] [--root <path>] [--prefix <prefix>] <issue> [<issue> ...]

Examples:
  create_issue_worktrees.sh 123
  create_issue_worktrees.sh --base develop 123 124
  create_issue_worktrees.sh --root ../worktrees --prefix issue 123
USAGE
}

base=""
root=""
prefix="issue"
issues=()

while [ "$#" -gt 0 ]; do
  case "$1" in
    --base)
      base="${2:-}"
      shift 2
      ;;
    --root)
      root="${2:-}"
      shift 2
      ;;
    --prefix)
      prefix="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      issues+=("$1")
      shift
      ;;
  esac
done

if [ "${#issues[@]}" -eq 0 ]; then
  usage >&2
  exit 2
fi

repo_root="$(git rev-parse --show-toplevel)"
repo_name="$(basename "$repo_root")"

if [ -z "$base" ]; then
  if git show-ref --verify --quiet refs/heads/main || git show-ref --verify --quiet refs/remotes/origin/main; then
    base="main"
  elif git show-ref --verify --quiet refs/heads/master || git show-ref --verify --quiet refs/remotes/origin/master; then
    base="master"
  else
    base="$(git branch --show-current)"
  fi
fi

if [ -z "$root" ]; then
  root="$(dirname "$repo_root")/${repo_name}-worktrees"
fi

mkdir -p "$root"

slugify() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-{2,}/-/g' \
    | cut -c 1-48
}

issue_title() {
  local issue="$1"
  if command -v gh >/dev/null 2>&1; then
    gh issue view "$issue" --json title --jq '.title' 2>/dev/null || true
  fi
}

create_branch() {
  local issue="$1"
  local branch="$2"

  if git show-ref --verify --quiet "refs/heads/$branch"; then
    return 0
  fi

  if command -v gh >/dev/null 2>&1; then
    if gh issue develop "$issue" --base "$base" --name "$branch" >/dev/null 2>&1; then
      git fetch origin "$branch:$branch" >/dev/null 2>&1 || true
      if git show-ref --verify --quiet "refs/heads/$branch"; then
        return 0
      fi
    fi
  fi

  git fetch origin "$base" >/dev/null 2>&1 || true
  if git show-ref --verify --quiet "refs/remotes/origin/$base"; then
    git branch "$branch" "origin/$base"
  else
    git branch "$branch" "$base"
  fi
}

for issue in "${issues[@]}"; do
  if ! [[ "$issue" =~ ^[0-9]+$ ]]; then
    echo "Issue must be a number: $issue" >&2
    exit 2
  fi

  title="$(issue_title "$issue")"
  title_slug="$(slugify "${title:-issue-$issue}")"
  if [ -z "$title_slug" ]; then
    title_slug="issue-$issue"
  fi

  branch="$prefix/$issue-$title_slug"
  path_slug="$(printf '%s' "$branch" | tr '/' '-')"
  worktree_path="$root/$path_slug"

  create_branch "$issue" "$branch"

  if [ -e "$worktree_path" ]; then
    echo "Skip existing path: $worktree_path"
  else
    git worktree add "$worktree_path" "$branch"
  fi

  printf 'issue=%s branch=%s worktree=%s\n' "$issue" "$branch" "$worktree_path"
done
