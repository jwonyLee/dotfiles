# dotfiles

## Neovim

```bash
cd ~/.config
ln -s ~/dotfiles/nvim
```

## Hammerspoon

```bash
ln -s ~/dotfiles/.hammerspoon ~/.hammerspoon
```

## Claude Code

Claude Code 플러그인 및 설정 백업.

### 백업된 항목

| 항목 | 설명 |
|------|------|
| `settings.json` | 활성화된 플러그인, 권한 설정 |
| `CLAUDE.md` | 사용자 지침 (Sisyphus 멀티에이전트 시스템) |
| `plugins/installed_plugins.json` | 설치된 플러그인 목록 |
| `plugins/known_marketplaces.json` | 등록된 마켓플레이스 |
| `plugins/claude-hud/config.json` | HUD 플러그인 설정 |
| `skills/` | 커스텀 스킬 |

### 설치된 플러그인

- swift-lsp
- code-simplifier
- code-review
- github
- context7
- oh-my-claude-sisyphus
- clarify
- suggest-tidyings
- claude-hud
- superpowers
- session-wrap

### 백업

```bash
~/.claude/../dotfiles/.claude/backup.sh
cd ~/dotfiles && git add .claude/ && git commit -m "update claude config" && git push
```

### 복원

```bash
git clone git@github.com:jwonyLee/dotfiles.git ~/dotfiles
~/dotfiles/.claude/restore.sh
# Claude Code 재시작 후 /plugin update 실행
```

## Zsh

```bash
# aliases.zsh를 .zshrc에서 source
echo 'source ~/dotfiles/aliases.zsh' >> ~/.zshrc
```
