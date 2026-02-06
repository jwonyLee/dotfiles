#!/bin/bash
DOTFILES="$HOME/dotfiles"

# Shell
ln -sf "$DOTFILES/shell/.zshrc" "$HOME/.zshrc"

# Git
ln -sf "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
mkdir -p "$HOME/.config/git"
ln -sf "$DOTFILES/git/.gitignore_global" "$HOME/.config/git/ignore"
mkdir -p "$HOME/.githooks"
ln -sf "$DOTFILES/git/prepare-commit-msg" "$HOME/.githooks/prepare-commit-msg"
chmod +x "$HOME/.githooks/prepare-commit-msg"

# Terminal
mkdir -p "$HOME/.config/ghostty"
ln -sf "$DOTFILES/terminal/ghostty/config" "$HOME/.config/ghostty/config"

# Neovim
ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"

# Hammerspoon
ln -sf "$DOTFILES/.hammerspoon" "$HOME/.hammerspoon"

# macOS 키보드 바인딩
mkdir -p "$HOME/Library/KeyBindings"
ln -sf "$DOTFILES/macos/DefaultkeyBinding.dict" "$HOME/Library/KeyBindings/DefaultkeyBinding.dict"

# Xcode themes
mkdir -p "$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"
ln -sf "$DOTFILES/xcode/FontAndColorThemes/"*.xccolortheme "$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes/"

# Claude Code
mkdir -p "$HOME/.claude"
ln -sf "$DOTFILES/.claude/settings.json" "$HOME/.claude/settings.json"
ln -sf "$DOTFILES/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

echo "심볼릭 링크 생성 완료"
