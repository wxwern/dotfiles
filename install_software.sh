#!/usr/bin/env bash

echo "Installing Xcode command line tools if necessary..."
xcode-select --install >> /dev/null 2>&1

echo "Installing brew if necessary..."
command -v brew >/dev/null 2>&1 || {
    echo "Installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

brew bundle install --file=./Brewfile

echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

