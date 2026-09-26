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

echo_title() {
  echo -e "\033[1;32m$1\033[0m"
}

echo_item() {
  echo "  - $1"
}

echo_warn() {
    echo -e "\033[1;31m  - $1\033[0m"
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
echo_title "Homebrew"
if [ -z $(which brew) ]; then
    read -p "Install Homebrew? (y/N) " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo_item "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
fi

if [ -z $(which brew) ]; then
    echo_warn "Homebrew is required to install dependencies. Aborting..."
    exit 1
fi

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

echo_title "Homebrew Dependencies"
read -p "Check/install preferred primary Homebrew dependencies? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo_item "Installing..."
    brew install python3 neovim vim fd node npm oven-sh/bun/bun gcc cmake && \
    echo_item "Dependencies installed." || \
    echo_warn "Dependency installation failed. Please check the installation logs."
else
    echo_warn "Skipping primary dependency installation. Other related installations may fail!"
fi

# install oh-my-zsh?
echo_title "oh-my-zsh"
if [ ! -d ~/.oh-my-zsh ]; then
    read -p "Install oh-my-zsh? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo_item "Installing oh-my-zsh"
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
fi

# install powerlevel10k?
echo_title "powerlevel10k"
if [[ -d ~/.oh-my-zsh && ! -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k ]]; then
    read -p "Install powerlevel10k? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo_item "Installing powerlevel10k"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    fi
fi

# install zsh-autosuggestions?
echo_title "zsh-autosuggestions"
if [[ -d ~/.oh-my-zsh && ! -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]]; then
    read -p "Install zsh-autosuggestions? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo_item "Installing zsh-autosuggestions"
        git clone --depth 1 -- https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
fi

# install zsh-syntax-highlighting?
echo_title "zsh-syntax-highlighting"
if [[ -d ~/.oh-my-zsh && ! -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]]; then
    read -p "Install zsh-syntax-highlighting? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo_item "Installing zsh-syntax-highlighting"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi
fi

# install vim and neovim?
if [[ ! -d ~/.vim || ! -d ~/.config/nvim || -z $(which vim) || -z $(which nvim) ]]; then
    read -p "Install vim and neovim configurations? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo_item "Installing vim"
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
            echo_item "Installing vim-plug for vim"
            curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
                https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        fi
        if [ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
            echo_item "Installing vim-plug for neovim"
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
    echo_warn "Aborting..."
    exit 1
fi


importDot() {
    find . -name "$1" -print0 | while read -d $'\0' file
    do
        f=$(basename -- "$file")
        cd ~
        echo_item "Importing $f -> ~/.$f"
        if [ -L ".$f" ]; then
            echo_warn "Replacing existing symlink .$f"
            rm ".$f"
        elif [ -f ".$f" ]; then
            TS=$(date +%s)
            echo_warn "Backing up existing .$f to .$f.$TS.bak"
            mv ".$f" ".$f.$TS.bak"
        fi
        ln $2 -s "$DIR/$f" ".$f" 2>&1 | sed 's/^/    /'
        cd "$DIR"
    done
}
importCustom() {
    cd ~
    echo_item "Importing $1 -> ~/$2"
    if [ -L "$2" ]; then
        echo_warn "Replacing existing symlink $2"
        rm "$2"
    elif [ -f "$2" ]; then
        TS=$(date +%s)
        echo_warn "Backing up existing $2 to $2.$TS.bak"
        mv "$2" "$2.$TS.bak"
    fi
    ln $3 -s "$DIR/$1" "$HOME/$2" 2>&1 | sed 's/^/    /'
    cd "$DIR"
}

echo
echo
echo_title "dotfiles"

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

# iterm2 dynamic profiles
if [ ! -d "$HOME/Library/Application Support/iTerm2/DynamicProfiles" ]; then mkdir -p "$HOME/Library/Application Support/iTerm2/DynamicProfiles"; fi
importCustom "others/iTermProfiles.json" "Library/Application Support/iTerm2/DynamicProfiles/iTermProfiles.json" $1

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
        echo_item "Installing plugins into vim & nvim"
        vim +PlugInstall +qall
        nvim +PlugInstall +qall
    fi
fi

if command -v skhd &>/dev/null; then
    # yabai cannot preserve state after a restart
    # so check to verify whether this is OK atm
    read -p "Restart yabai? (y/N) " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        yabai --restart-service || true
    fi
fi

if command -v skhd &>/dev/null; then
    # skhd has hot reload for config changes
    # service may however not play well due to link changes,
    # so we force a restart
    echo_item "Restarting skhd"
    skhd --restart-service || true
fi

# --- End ---
phase-header "4" "Next Steps"
echo "Dotfiles installation complete!"
echo
echo_warn "Manual review may be required if errors were encountered during the linking or installation phases."
echo
echo "Restart your terminal to apply all changes."
