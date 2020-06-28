#!/usr/bin/env bash

cd $(dirname "$0")
DIR=$(pwd)
echo $DIR
echo "Attempting to install dotfiles via soft links to ~"
ln -s $DIR/.*rc ~
ln -s $DIR/.*profile ~
echo "Procedure complete"
