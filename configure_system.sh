#!/usr/bin/env bash

# set script dir as working dir
cd "$(dirname "$0")"

# Disable finder animations
echo "Disabling finder animations..."
defaults write com.apple.finder DisableAllAnimations -bool true
killall Finder

# Hide Dock
echo "'Permanently' hiding the dock..."
defaults write com.apple.dock autohide -bool true        # false as default
defaults write com.apple.dock autohide-delay -float 1000 # delete to revert
defaults write com.apple.dock launchanim -bool false     # true as default
killall Dock

# Install Fonts
echo "Installing fonts (user level)..."
cp -r fonts/* ~/Library/Fonts/

