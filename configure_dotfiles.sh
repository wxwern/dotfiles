#!/usr/bin/env bash

cd $(dirname "$0")

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

#
# --- Dependencies ---
#
# These are dependencies
# referenced within the dotfiles.
#

phase-header "1" "Prerequisites Installation"

echo "Some critical dependencies are referenced within the dotfiles."
echo "Critical dependencies that are possibly missing will be prompted for installation."
echo

# install prerequisites?
if [ -z $(which brew) ]; then
    read -p "Install Homebrew? (y/N) " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
fi

if [ -z $(which brew) ]; then
    echo "Homebrew is required to install dependencies. Aborting..."
    exit 1
fi

read -p "Check/install preferred primary Homebrew dependencies? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Installing..."
    brew install python3 neovim vim fd node npm oven-sh/bun/bun gcc cmake
else
    echo "Skipping primary dependency installation. Other related installations may fail!"
fi

# install oh-my-zsh?
if [ ! -d ~/.oh-my-zsh ]; then
    read -p "Install oh-my-zsh? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing oh-my-zsh"
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
fi

# install powerlevel10k?
if [[ -d ~/.oh-my-zsh && ! -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k ]]; then
    read -p "Install powerlevel10k? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing powerlevel10k"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    fi
fi

# install zsh-autosuggestions?
if [[ -d ~/.oh-my-zsh && ! -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]]; then
    read -p "Install zsh-autosuggestions? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing zsh-autosuggestions"
        git clone --depth 1 -- https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
fi

# install zsh-syntax-highlighting?
if [[ -d ~/.oh-my-zsh && ! -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]]; then
    read -p "Install zsh-syntax-highlighting? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing zsh-syntax-highlighting"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi
fi

# install vim and neovim?
if [[ ! -d ~/.vim || ! -d ~/.config/nvim || -z $(which vim) || -z $(which nvim) ]]; then
    read -p "Install vim and neovim configurations? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing vim"
        brew install vim neovim
        mkdir -p ~/.vim
        mkdir -p ~/.config/nvim
    fi
fi

# install vim-plug?
if [[ ! -f ~/.vim/autoload/plug.vim || ! -f ~/.local/share/nvim/site/autoload/plug.vim ]]; then

    read -p "Install vim-plug? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        if [ ! -f ~/.vim/autoload/plug.vim ]; then
            echo "Installing vim-plug for vim"
            curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
                https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        fi
        if [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
            echo "Installing vim-plug for neovim"
            mkdir -p ~/.local/share/nvim/site/autoload/
            cp ~/.vim/autoload/plug.vim ~/.local/share/nvim/site/autoload/plug.vim
        fi

    fi
fi

#
# --- Dotfiles ---
#
# These are the dotfiles that
# will be symlinked to target directories.
#

phase-header "2" "Dotfiles Installation"

cd $(dirname "$0")
DIR=$(pwd)
echo $DIR
echo "Dependencies checked."
echo "Attempting to install dotfiles via soft links to ~"

read -p "Continue? (y/N) " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo
    echo "Aborting..."
    echo "Will not continue with any post-installation steps."
    exit 1
fi


importDot() {
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

# rc files
importDot "*rc" $1

# neovim config
if [ ! -d ~/.config/nvim/ ]; then mkdir -p ~/.config/nvim/; fi
importCustom "vimrc" ".config/nvim/init.vim" $1

# coc.nvim config
if [ ! -d ~/.vim/ ]; then mkdir -p ~/.vim/; fi
importCustom "coc-settings.json" ".vim/coc-settings.json" $1
importCustom "coc-settings.json" ".config/nvim/coc-settings.json" $1

# borders config
if [ ! -d ~/.config/borders/ ]; then mkdir -p ~/.config/borders/; fi
importCustom "bordersrc" ".config/borders/bordersrc" $1

# zsh profile and p10k config
importDot "*profile" $1
importDot "p10k.zsh" $1

echo
echo "Dotfiles linkage complete."
echo


# --- Post-installation ---
phase-header "3" "Post-installation"

if [[ -f ~/.vim/autoload/plug.vim || -f ~/.local/share/nvim/site/autoload/plug.vim ]]; then
    # install vim plugins?
    read -p "Update/install vim plugins? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Installing plugins into vim & nvim"
        vim +PlugInstall +qall
        nvim +PlugInstall +qall
    fi
fi

# --- End ---
phase-header "4" "Next Steps"
echo "Dotfiles installation complete!"
echo
echo "Manual review may be required if errors were encountered during the linking or installation phases."
echo
echo "Restart your terminal to apply all changes."
