#!/bin/bash

# 키보드 반복 속도
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# 자동수정 비활성화
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# ForkLift 기본 파일 뷰어
defaults write -g NSFileViewer -string com.binarynights.ForkLift-3

# iTerm2 설정을 dotfiles에서 로드
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/dotfiles/terminal/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

echo "macOS defaults 설정 완료. 일부 설정은 재시작 후 적용됩니다."
