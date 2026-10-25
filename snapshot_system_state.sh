#!/usr/bin/env bash

cd "$(dirname "$0")" || exit 1

# generate Brewfile
brew bundle dump --file=./Brewfile --force

# generate coc extensions install script
# https://vi.stackexchange.com/a/39383
echo "let g:coc_global_extensions = " > install-coc-extensions.vim
  jq '.dependencies | keys' ~/.config/coc/extensions/package.json |
  sed "s/\"/'/g" | sed 's/^/  \\/g' >> install-coc-extensions.vim
