#!/bin/bash
# Claude Code 설정 자동 백업 스크립트
# cron: 0 9 * * * ~/dotfiles/.claude/auto-backup.sh

set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
LOG_FILE="$SCRIPT_DIR/.backup.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log "=== 백업 시작 ==="

# 백업 실행
"$SCRIPT_DIR/backup.sh" >> "$LOG_FILE" 2>&1

# Git 작업
cd "$DOTFILES_DIR"

# 변경사항 확인
if git diff --quiet .claude/ && git diff --cached --quiet .claude/; then
    log "변경사항 없음, 스킵"
else
    git add .claude/
    git commit -m "auto: Claude Code 설정 백업 ($(date '+%Y-%m-%d'))" >> "$LOG_FILE" 2>&1
    git push >> "$LOG_FILE" 2>&1
    log "✓ 커밋 및 push 완료"
fi

log "=== 백업 완료 ==="
