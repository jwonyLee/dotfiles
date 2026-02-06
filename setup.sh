#!/bin/bash
set -e
echo "=== Mac 초기 설정 시작 ==="

# 1. Homebrew 설치
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# 2. Brewfile로 패키지 설치
brew bundle --file="$HOME/dotfiles/Brewfile"

# 3. 심볼릭 링크 생성
bash "$HOME/dotfiles/symlink.sh"

# 4. macOS 시스템 설정
bash "$HOME/dotfiles/macos/defaults.sh"

# 5. Zsh 플러그인
mkdir -p "$HOME/.zsh"
[ ! -d "$HOME/.zsh/zsh-autosuggestions" ] && \
  git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
[ ! -d "$HOME/.zsh/zsh-syntax-highlighting" ] && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.zsh/zsh-syntax-highlighting"

echo ""
echo "=== 완료! 수동 작업 필요 ==="
echo "1. SSH 키 생성: ssh-keygen -t ed25519 -C 'rieul@rieul.tech'"
echo "2. GitHub SSH 키 등록: https://github.com/settings/keys"
echo "3. gh auth login"
echo "4. Claude Code 복원: CLAUDE.md의 'Claude Code 복원' 섹션 참고"
echo "5. apps.md 참고하여 수동 앱 설치"
