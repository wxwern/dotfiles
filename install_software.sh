#!/usr/bin/env bash

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

# PHASE 1
phase-header "1" "Prerequisites Installation"
echo "Checking for required dependencies to install software via Brewfile..."

if ! xcode-select -p &>/dev/null; then
    echo " - Xcode command line tools not found. Installing..."
    xcode-select --install
fi

echo "   Waiting for Xcode command line tools installation to complete..."
until xcode-select -p &>/dev/null; do
    sleep 5 || exit 1
done

if ! command -v brew &>/dev/null; then
    echo " - Installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
if ! command -v brew &>/dev/null; then
    echo "   Brew installation failed. Please check the installation logs."
    exit 1
fi

echo "Prerequisites installation complete."

# PHASE 2
phase-header "2" "Software Installation"
echo "Installing all software referenced in Brewfile..."
cd "$(dirname "$0")"
brew bundle install --file=./Brewfile || exit 1

# PHASE 3
phase-header "3" "Post-Installation Configuration"
echo "Performing post-installation configuration..."

open -a "System Settings" "x-apple.systempreferences:com.apple.preference.security"
(skhd --install-service || true) && skhd --start-service && echo 'skhd has started'
(yabai --install-service || true) && yabai --start-service && echo 'yabai has started'

echo "You may need to grant permissions. Press Enter to perform a restart of these services once done, or Ctrl+C to abort"
read -p ''
skhd --restart-service
yabai --restart-service
