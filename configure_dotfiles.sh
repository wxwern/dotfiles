#!/usr/bin/env bash

cd $(dirname "$0")

#
# --- Dotfiles ---
#
# These are the dotfiles that
# will be symlinked to target directories.
#

DIR=$(pwd)
echo $DIR
echo "Attempting to install dotfiles via soft links to ~"

read -p "Continue? (y/n) " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo
    echo "Aborting..."
    exit 1
fi


import() {
    find . -name "$1" -print0 | while read -d $'\0' file
    do
        f=$(basename -- "$file")
        cd ~
        echo "* Importing $f -> ~/.$f"
        ln $2 -s "$DIR/$f" ".$f" 2>&1 | sed 's/^/    /'
        cd "$DIR"
    done
}
importCustom() {
    cd ~
    echo "* Importing $1 -> ~/$2"
    ln $3 -s "$DIR/$1" "$HOME/$2" 2>&1 | sed 's/^/    /'
    cd "$DIR"
}

echo
echo
import "*rc" $1
importCustom "vimrc" ".config/nvim/init.vim" $1
import "*profile" $1
import "p10k.zsh" $1

echo
echo "Dotfiles linkage complete."
echo
echo "Dependencies are referenced within the dotfiles."
echo "If prompted, they may be missing and should be installed."
echo

#
# --- Dependencies ---
#
# These are dependencies
# referenced within the dotfiles.
#

# install oh-my-zsh?
if [ ! -d ~/.oh-my-zsh ]; then
    read -p "Install oh-my-zsh? (y/n) " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing oh-my-zsh"
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
fi

# install powerlevel10k?
if [ ! -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]; then
    read -p "Install powerlevel10k? (y/n) " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing powerlevel10k"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    fi
fi

# install vim-plug?
if [ ! -f ~/.vim/autoload/plug.vim ]; then
    read -p "Install vim-plug? (y/n) " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        if [ ! -f ~/.vim/autoload/plug.vim ]; then
            echo "Installing vim-plug for vim"
            curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
                https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        fi
        if [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
            echo "Installing vim-plug for neovim"
            cp ~/.vim/autoload/plug.vim ~/.local/share/nvim/site/autoload/plug.vim
        fi


        # install vim plugins?
        read -p "Install vim plugins? (y/n) " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            echo "Installing plugins into vim & nvim"
            vim +PlugInstall +qall
            nvim +PlugInstall +qall
        fi
    fi
fi

