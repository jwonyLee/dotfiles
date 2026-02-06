# dotfiles

Mac 초기화 후 복원을 위한 설정 백업.

## 빠른 시작

```bash
git clone git@github.com:jwonyLee/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

## 구조

```
~/dotfiles/
├── shell/.zshrc              # Zsh 플러그인 + alias
├── git/
│   ├── .gitconfig            # Git 사용자/훅/push 설정
│   ├── .gitignore_global     # Global gitignore
│   └── prepare-commit-msg    # Jira 티켓 자동 삽입 훅
├── terminal/
│   ├── ghostty/config        # Ghostty 터미널 설정
│   └── iterm2/               # iTerm2 설정 (커스텀 폴더 로드)
├── xcode/FontAndColorThemes/  # Xcode 커스텀 테마
├── macos/
│   ├── DefaultkeyBinding.dict # ₩ → backtick 매핑
│   └── defaults.sh           # macOS 시스템 설정 복원
├── nvim/                     # Neovim 설정
├── .hammerspoon/             # Hammerspoon 설정
├── .claude/                  # Claude Code 플러그인/설정
├── aliases.zsh               # Zsh aliases + git worktree 함수
├── Brewfile                  # Homebrew 패키지 목록
├── apps.md                   # 수동 설치 앱 목록
├── setup.sh                  # 초기화 후 복원 부트스트랩
└── symlink.sh                # 심볼릭 링크 생성
```

## 복원 스크립트

### setup.sh

초기화 후 원스톱 복원. 순서대로 실행:

1. Homebrew 설치
2. Brewfile로 패키지 설치
3. 심볼릭 링크 생성 (symlink.sh)
4. macOS 시스템 설정 (defaults.sh)
5. Zsh 플러그인 설치

### symlink.sh

각 설정 파일을 원래 위치에 심볼릭 링크:

| dotfiles 경로 | 링크 위치 |
|----------------|-----------|
| `shell/.zshrc` | `~/.zshrc` |
| `git/.gitconfig` | `~/.gitconfig` |
| `git/.gitignore_global` | `~/.config/git/ignore` |
| `git/prepare-commit-msg` | `~/.githooks/prepare-commit-msg` |
| `terminal/ghostty/config` | `~/.config/ghostty/config` |
| `macos/DefaultkeyBinding.dict` | `~/Library/KeyBindings/DefaultkeyBinding.dict` |
| `xcode/FontAndColorThemes/*.xccolortheme` | `~/Library/Developer/Xcode/UserData/FontAndColorThemes/` |
| `nvim/` | `~/.config/nvim` |
| `.hammerspoon/` | `~/.hammerspoon` |
| `.claude/settings.json` | `~/.claude/settings.json` |
| `.claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |

## 각 항목 설명

### Shell

Zsh 플러그인(autosuggestions, syntax-highlighting)과 alias 설정. `.zshrc`에서 `aliases.zsh`를 자동으로 source.

### Git

- `.gitconfig` — 사용자 정보, 커스텀 훅 경로, autoSetupRemote
- `prepare-commit-msg` — 브랜치명에서 Jira 티켓 추출하여 커밋 메시지에 자동 삽입
- `.gitignore_global` — 전역 gitignore

### Ghostty

JetBrainsMonoHangul 폰트, 12pt, working-directory 설정.

### iTerm2

`terminal/iterm2/`에 설정 저장. iTerm2의 "Load preferences from a custom folder" 기능을 사용하며, `defaults.sh`가 자동으로 경로를 설정.

### macOS

- `DefaultkeyBinding.dict` — ₩ 키를 backtick(`)으로 매핑
- `defaults.sh` — 키보드 반복 속도, 자동수정 비활성화, ForkLift 기본 파일 뷰어

### Neovim

```bash
ln -sf ~/dotfiles/nvim ~/.config/nvim
```

### Hammerspoon

```bash
ln -sf ~/dotfiles/.hammerspoon ~/.hammerspoon
```

### Claude Code

settings.json과 CLAUDE.md만 백업. 심볼릭 링크로 항상 최신 상태 유지. 플러그인/스킬은 `CLAUDE.md`에 설치 목록 문서화.

```bash
# symlink.sh가 자동 처리. 이후 CLAUDE.md의 "Claude Code 복원" 섹션 참고하여 플러그인 설치
```

### Brewfile

선별된 Homebrew 패키지. `brew bundle --file=Brewfile`로 설치.

### apps.md

Homebrew로 관리되지 않는 앱 목록. 초기화 후 참고하여 수동 설치.

## setup.sh 실행 후 수동 작업

1. SSH 키 생성: `ssh-keygen -t ed25519 -C 'rieul@rieul.tech'`
2. GitHub SSH 키 등록: https://github.com/settings/keys
3. `gh auth login`
4. Claude Code 복원: `CLAUDE.md`의 "Claude Code 복원" 섹션 참고
5. `apps.md` 참고하여 수동 앱 설치
