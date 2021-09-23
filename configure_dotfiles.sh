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
        echo "Importing $f"
        ln $2 -s "$DIR/$f" ".$f"
        cd "$DIR"
    done
}
import "*rc" $1
import "*profile" $1

echo "Procedure complete"
