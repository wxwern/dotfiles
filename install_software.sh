#!/usr/bin/env bash

echo "Installing Xcode command line tools if necessary..."
xcode-select --install

echo "Installing brew if necessary..."
command -v brew >/dev/null 2>&1 || {
    echo "Installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
}

brew bundle install --file=./Brewfile
