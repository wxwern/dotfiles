#!/usr/bin/env bash

echo "Installing Xcode command line tools if necessary..."
xcode-select --install >> /dev/null 2>&1

echo "Installing brew if necessary..."
command -v brew >/dev/null 2>&1 || {
    echo "Installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

echo "Running brew update and brew upgrade..."
brew update
brew upgrade

echo "Installing cli tools..."
brew install \
    bash zsh fish \
    git wget tmux vim neovim \
    gcc python python3 node npm \
    openssl ssh-copy-id telnet nmap \
    ffmpeg imagemagick cocoapods \
    neofetch youtube-dl \
    mas \
    coreutils findutils util-linux gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt

echo "Installing gui tools..."
brew cask install \
    iterm2 \
    visual-studio-code android-studio \
    firefox google-chrome microsoft-edge tor-browser \
    discord mtmr mounty \
    vnc-viewer vnc-server virtualbox \
    google-earth-pro


echo "Installing mac app store apps..."
mas install 497799835  #Xcode
mas install 1451685025 #Wireguard
mas install 1147396723 #WhatsApp
mas install 1480068668 #FB Messenger
mas install 747648890  #Telegram
mas install 863486266  #Sketchbook
mas install 1470168007 #Vectornator Pro
mas install 937984704  #Amphetamine
mas install 462054704  #MS Word
mas install 462058435  #MS Excel
mas install 462062816  #MS Powerpoint
mas install 784801555  #MS OneNote

echo "Installing tiling window manager and custom bar..."
brew install \
    koekeishiya/formulae/yabai \
    koekeishiya/formulae/skhd
brew cask install ubersicht

echo
echo "Automated installations are done!"
echo
echo "To start up yabai, skhd and Übersicht:"
echo " brew services start yabai "
echo " brew services start skhd "
echo " open /Applications/Übersicht.app"
echo
