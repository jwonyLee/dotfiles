#!/bin/bash
set -e
BACKUP_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Claude Code 설정 복원 중..."

# 디렉토리 생성
mkdir -p "$CLAUDE_DIR/plugins"

# 기존 설정 백업
[[ -f "$CLAUDE_DIR/settings.json" ]] && \
  cp "$CLAUDE_DIR/settings.json" "$CLAUDE_DIR/settings.json.bak"

# 설정 복원
cp "$BACKUP_DIR/settings.json" "$CLAUDE_DIR/"
cp "$BACKUP_DIR/CLAUDE.md" "$CLAUDE_DIR/" 2>/dev/null || true

# plugins 설정 복원
cp "$BACKUP_DIR/plugins/installed_plugins.json" "$CLAUDE_DIR/plugins/"
cp "$BACKUP_DIR/plugins/known_marketplaces.json" "$CLAUDE_DIR/plugins/"

# 플러그인별 설정 복원
for dir in "$BACKUP_DIR/plugins"/*/; do
  if [[ -d "$dir" && -f "$dir/config.json" ]]; then
    plugin_name=$(basename "$dir")
    mkdir -p "$CLAUDE_DIR/plugins/$plugin_name"
    cp "$dir/config.json" "$CLAUDE_DIR/plugins/$plugin_name/"
  fi
done

# skills 폴더 복원
if [[ -d "$BACKUP_DIR/skills" ]]; then
  rm -rf "$CLAUDE_DIR/skills"
  cp -r "$BACKUP_DIR/skills" "$CLAUDE_DIR/"
fi

echo "✓ 복원 완료"
echo ""
echo "다음 단계:"
echo "1. Claude Code 재시작"
echo "2. /plugin update 실행하여 플러그인 캐시 재설치"
