#!/usr/bin/env bash

cd $(dirname "$0")
DIR=$(pwd)
echo $DIR
echo "Attempting to install dotfiles via soft links to ~"

import() {
    find . -name "$1" -print0 | while read -d $'\0' file
    do
        f=$(basename -- "$file")
        cd ~
        echo "Importing $f -> ~/.$f"
        ln $2 -s "$DIR/$f" ".$f"
        cd "$DIR"
    done
}
importCustom() {
    echo "importing $1 -> ~/$2"
    cd ~
    ln $3 -s "$DIR/$1" "$HOME/$2"
    cd "$DIR"
}

import "*rc" $1
importCustom "vimrc" ".config/nvim/init.vim" $1
import "*profile" $1

echo "Procedure complete"
echo "Some requirements, like vim-plug, are not installed automatically by this script."
