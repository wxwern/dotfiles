#!/usr/bin/env bash

# set script dir as working dir
cd "$(dirname "$0")"

# --- Helpers ---
phase-header() {
  echo
  printf "\033[1;34m"
  LEN=$(echo "PHASE $1: $2" | wc -c)
  printf "%*s\n" $((LEN+4)) | tr ' ' '='
  printf "  PHASE %s: %s  \n" "$1" "$2"
  printf "%*s\n" $((LEN+4)) | tr ' ' '='
  printf "\033[0m"
  echo
}

echo_item() {
  echo "  - $1"
}

echo_title() {
  echo -e "\033[1;32m$1\033[0m"
}

set_nested_default() {
  # write a single nested key in a domain (defaults write cannot), preserving all other keys
  local domain="$1" key_path="$2" type="$3" value="$4"
  local plist part parent
  plist=$(mktemp)
  defaults export "$domain" "$plist"
  local IFS='.'
  for part in $key_path; do
    if [ -z "$parent" ]; then parent="$part"; else parent="$parent.$part"; fi
    plutil -insert "$parent" -dictionary "$plist" 2>/dev/null || true
  done
  plutil -replace "$key_path" "-$type" "$value" "$plist"
  defaults import "$domain" "$plist"
  rm "$plist"
}

# PHASE 0
# Prelim checks
if [ "$TERM_PROGRAM" = "iTerm.app" ]; then
  echo "Relaunching script in Terminal.app (iTerm2 cannot be open while the config is applied)..."
  open -a Terminal "$0"
  exit $?
fi

# PHASE 1
phase-header "1" "System Configuration"

# --- Finder Operations ---
# Reference: https://macos-defaults.com/finder/
echo_title "Configuring Finder..."
echo_item "Disabling Finder animations"
defaults write com.apple.finder DisableAllAnimations -bool true

echo_item "Setting default view style to list"
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

echo_item "Showing pathbar, status bar, sidebar"
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowSidebar -bool true
echo_item "Hiding preview pane, tab bar"
defaults write com.apple.finder ShowPreviewPane -bool false
defaults write com.apple.finder ShowTabView -bool false

echo_item "Disabling tab spawning in Finder"
defaults write com.apple.finder FinderSpawnTab -bool false

echo_item "Showing all drives on desktop"
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

echo_item "Enabling desktop Stacks, arranged by kind, sorted by name"
defaults write com.apple.finder "com.apple.finder.desktop.stacks-enabled" -bool true
defaults write com.apple.finder DesktopViewSettings -dict-add GroupBy -string "Kind"
defaults write com.apple.finder FXPreferredGroupBy -string "Kind"

echo_item "Sorting desktop Stacks by name"
set_nested_default com.apple.finder "DesktopViewSettings.IconViewSettings.arrangeBy" string name

echo_item "Setting new windows to open to home directory"
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file:///Users/$USER/"

echo_item "Setting search defaults (current folder, list view)"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXPreferredSearchViewStyle -string "Nlsv"

echo_item "Configuring iCloud sidebar (visible, desktop/docs sync disabled)"
defaults write com.apple.finder SidebarShowingSignedIntoiCloud -bool true
defaults write com.apple.finder FXICloudDriveDesktop -bool false
defaults write com.apple.finder FXICloudDriveDocuments -bool false

echo_item "Enabling trash auto-remove"
defaults write com.apple.finder FXRemoveOldTrashItems -bool true

echo_item "Sorting folders before files"
defaults write com.apple.finder "_FXSortFoldersFirst" -bool true

echo_item "Showing Library folder"
chflags nohidden ~/Library

# Restart
echo_item "Restarting Finder to apply changes"
killall Finder
sleep 1

# --- Menu Bar Operations ---
echo_title "Configuring Menu Bar..."
echo_item "Setting status item spacing and padding (requires logout)"
defaults -currentHost write -globalDomain NSStatusItemSpacing -int 12
defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 8

# --- Dock & Mission Control Operations ---
# Reference: https://macos-defaults.com/dock/
echo_title "Configuring Dock and Mission Control..."
echo_item "Enabling autohide with 1s delay"
defaults write com.apple.dock autohide -bool true        # false as default
defaults write com.apple.dock autohide-delay -float 1000 # delete to revert

echo_item "Displaying CMD-Tab app switcher on all displays"
defaults write com.apple.dock appswitcher-all-displays -bool true

echo_item "Setting dock minimize effect to suck"
defaults write com.apple.dock mineffect -string suck;

# Reference: https://macos-defaults.com/mission-control/
echo_item "Not auto-rearranging spaces"
defaults write com.apple.dock "mru-spaces" -int 0

echo_item "Switching to a space with open windows for an application"
defaults write -g "AppleSpacesSwitchOnActivate" -bool true

echo_item "Grouping windows by application"
defaults write com.apple.dock "expose-group-apps" -bool true

echo_item "Entering Mission Control by dragging windows to top edge"
defaults write com.apple.dock "enterMissionControlByTopWindowDrag" -bool true

echo_item "Separate spaces per display (requires logout)"
defaults write com.apple.spaces "spans-displays" -bool false

# Restart
echo_item "Restarting Dock to apply changes"
killall Dock
sleep 1

# --- GUI Operations ---
echo_title "Configuring GUI..."
echo_item "Enabling Ctrl+Cmd+Drag to move windows (requires logout)"
defaults write -g NSWindowShouldDragOnGesture -bool true

# --- Fonts ---
echo_title "Installing fonts (user level)..."
echo_item "Copying fonts to ~/Library/Fonts"
cp -r fonts/* ~/Library/Fonts/

# -- Symlinks ---
echo_title "Creating system-wide symlinks..."
echo_item "Linking ~/.cache to ~/Library/Caches/dotcache"
if [ ! -d "$HOME"/Library/Caches/dotcache ]; then
  if [ -d "$HOME"/.cache ]; then
    mv "$HOME"/.cache "$HOME"/Library/Caches/dotcache
  else
    mkdir -p "$HOME"/Library/Caches/dotcache
  fi
  rm "$HOME"/.cache 2>/dev/null || true
  ln -s "$HOME"/Library/Caches/dotcache "$HOME"/.cache
fi

# PHASE 2
phase-header "2" "Software Configuration"

# --- Homebrew Operations ---
echo_title "Configuring Homebrew autoupdate..."
echo_item "Reconfiguring autoupdate (including upgrade, cleanup, sudo)"
brew tap DomT4/homebrew-autoupdate
brew trust --command domt4/autoupdate/autoupdate
brew autoupdate stop
brew autoupdate start --upgrade --cleanup --sudo

# --- Safari Operations ---
echo_title "Configuring Safari..."
if pgrep -x "Safari" > /dev/null; then
  read -p "Safari is running - quit it now so these settings take effect (might not work otherwise)? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo_item "Quitting Safari"
    killall Safari
    sleep 1
  fi
fi

echo_item "Show Full URL in address bar"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# --- iTerm2 Operations ---
echo_title "Configuring iTerm2..."
if pgrep -x "iTerm2" > /dev/null; then
  read -p "iTerm2 is running - quit it now so these settings take effect (might not work otherwise)? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo_item "Quitting iTerm2"
    killall iTerm2
    sleep 1
  else
    echo_item "iTerm2 left running - these settings may be overwritten on exit"
  fi
fi
echo_item "Allowing clipboard access"
defaults write com.googlecode.iterm2 "AllowClipboardAccess" -bool true

echo_item "Enabling bracketed paste mode"
defaults write com.googlecode.iterm2 "BracketedPasteMode" -bool true

echo_item "Converting DOS newlines"
defaults write com.googlecode.iterm2 "ConvertDosNewlines" -bool true

echo_item "Enabling default wide mode"
defaults write com.googlecode.iterm2 "DefaultWideMode" -bool true

echo_item "Dimming background windows and text"
defaults write com.googlecode.iterm2 "DimBackgroundWindows" -bool true
defaults write com.googlecode.iterm2 "DimOnlyText" -bool true

echo_item "Disabling division view and proxy icon"
defaults write com.googlecode.iterm2 "EnableDivisionView" -bool false
defaults write com.googlecode.iterm2 "EnableProxyIcon" -bool false

echo_item "Not escaping shell chars with backslash"
defaults write com.googlecode.iterm2 "EscapeShellCharsWithBackslash" -bool false

echo_item "Hiding scrollbars and tabs"
defaults write com.googlecode.iterm2 "HideScrollbar" -bool true
defaults write com.googlecode.iterm2 "HideTab" -bool true

echo_item "Not blocking system shutdown"
defaults write com.googlecode.iterm2 "NeverBlockSystemShutdown" -bool true

echo_item "Opening no windows at startup"
defaults write com.googlecode.iterm2 "OpenNoWindowsAtStartup" -bool true

echo_item "Hiding tab bar in fullscreen"
defaults write com.googlecode.iterm2 "ShowFullScreenTabBar" -bool false

echo_item "Setting window tabbing mode to manual"
defaults write com.googlecode.iterm2 "AppleWindowTabbingMode" -string manual

echo_item "Dimming inactive splits"
defaults write com.googlecode.iterm2 "SplitPaneDimmingAmount" -float 0.2

echo_item "Not adjusting window size for font size changes"
defaults write com.googlecode.iterm2 "AdjustWindowForFontSizeChange" -bool false

echo_item "Setting default profile (Zsh)"
defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "C79F6F01-DF78-4D7F-A9C9-740213AA169A"
