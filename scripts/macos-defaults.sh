#!/bin/zsh
set -euo pipefail

sudo -v

# Firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# Finder
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
killall Finder >/dev/null 2>&1 || true

# SystemUIServer
defaults write com.apple.menuextra.clock ShowSeconds -bool true
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location "$HOME/Pictures/Screenshots"
killall SystemUIServer >/dev/null 2>&1 || true
