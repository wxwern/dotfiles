#!/usr/bin/env bash

# set script dir as working dir
cd "$(dirname "$0")"

# --- Finder Operations ---
# Disable finder animations
echo "Disabling finder animations..."
defaults write com.apple.finder DisableAllAnimations -bool true
# Restart Finder
killall Finder
# ---

# --- Dock Operations ---
# Hide Dock
echo "'Permanently' hiding the dock..."
defaults write com.apple.dock autohide -bool true        # false as default
defaults write com.apple.dock autohide-delay -float 1000 # delete to revert
defaults write com.apple.dock launchanim -bool false     # true as default
# Show app switcher on all displays
echo "Displaying CMD-Tab app switcher on all displays..."
defaults write com.apple.dock appswitcher-all-displays -bool true
# Restart Dock
killall Dock
# ---

# --- GUI Operations ---
# Hide ugly center popup
launchctl unload -wF /System/Library/LaunchAgents/com.apple.OSDUIHelper.plist
# ---

# Install Fonts
echo "Installing fonts (user level)..."
cp -r fonts/* ~/Library/Fonts/


