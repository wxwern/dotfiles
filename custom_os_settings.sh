#!/usr/bin/env bash

# Disable finder animations
defaults write com.apple.finder DisableAllAnimations -bool true
killall Finder

# Hide Dock
# defaults write com.apple.dock autohide -bool true
# defaults write com.apple.dock autohide-delay -float 1000
# defaults write com.apple.dock launchanim -bool false
# killall Dock

# Note: to restore Dock
# defaults write com.apple.dock autohide -bool false
# defaults delete com.apple.dock autohide-delay
# defaults write com.apple.dock launchanim -bool true
# killall Dock
