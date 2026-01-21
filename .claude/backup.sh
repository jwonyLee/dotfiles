#!/bin/bash
set -e
BACKUP_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Claude Code 설정 백업 중..."

# 핵심 설정
cp "$CLAUDE_DIR/settings.json" "$BACKUP_DIR/"
cp "$CLAUDE_DIR/CLAUDE.md" "$BACKUP_DIR/" 2>/dev/null || true

# plugins 설정
mkdir -p "$BACKUP_DIR/plugins"
cp "$CLAUDE_DIR/plugins/installed_plugins.json" "$BACKUP_DIR/plugins/"
cp "$CLAUDE_DIR/plugins/known_marketplaces.json" "$BACKUP_DIR/plugins/"

# 플러그인별 설정
for dir in "$CLAUDE_DIR/plugins"/*/; do
  if [[ -d "$dir" && -f "$dir/config.json" ]]; then
    plugin_name=$(basename "$dir")
    mkdir -p "$BACKUP_DIR/plugins/$plugin_name"
    cp "$dir/config.json" "$BACKUP_DIR/plugins/$plugin_name/"
  fi
done

# skills 폴더
if [[ -d "$CLAUDE_DIR/skills" ]]; then
  rm -rf "$BACKUP_DIR/skills"
  cp -r "$CLAUDE_DIR/skills" "$BACKUP_DIR/"
fi

echo "✓ 백업 완료: $BACKUP_DIR"
