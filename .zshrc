# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/LWJ/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git python osx zsh-autosuggestions) #zsh-syntax-highlighting)

# Source oh my zsh
source $ZSH/oh-my-zsh.sh

# User configuration

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export MANPATH="/usr/local/man:$MANPATH"

#Plugin config
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#606060"
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_HISTORY_IGNORE="(?(#c50,)|(cd|rm|rmdir|sudo|git) *)"
export ZSH_AUTOSUGGEST_COMPLETION_IGNORE="(rm|rmdir|sudo) *"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

#replace macos utils with gnu utils
#export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
#export PATH="/usr/local/opt/cross/arm-linux:$PATH"

# android
export ANDROID_HOME=/Users/$USER/Library/Android/sdk
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export ANDROID_SDK=$HOME/Library/Android/sdk
export ANDROID_NDK_HOME=$HOME/Library/Android/sdk/ndk/21.3.6528147/
export PATH=$ANDROID_SDK/emulator:$ANDROID_SDK/tools:$PATH

# c4ev3
export PATH=~/Repositories/c4ev3/c4ev3-gcc-2018-05-15.macOS/bin/:$PATH

# Setting PATH for Python 3.8
export PATH="/Library/Frameworks/Python.framework/Versions/3.8/bin:${PATH}"
export PATH="/Users/LWJ/Library/Python/3.8/bin:${PATH}"

# fastlane
export PATH="$HOME/.fastlane/bin:$PATH"

# ruby from homebrew
#export PATH="/usr/local/opt/ruby/bin:$PATH"
#export LDFLAGS="-L/usr/local/opt/ruby/lib"
#export CPPFLAGS="-I/usr/local/opt/ruby/include"
#export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"

# homebrew config
export HOMEBREW_NO_AUTO_UPDATE=1

# force macos 11 reporting
export SYSTEM_VERSION_COMPAT=0

# colors!!!!
export CLICOLOR=1
export TERM="xterm-color"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

prompt_context() {
    if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
        prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
    fi
}

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias tetris="autoload -Uz tetriscurses && tetriscurses"
#alias ssh='~/Repositories/external/ssh-ident/ssh-ident'
alias kali-vm='(echo "Starting VM..." && vmrun -T fusion start "/Users/LWJ/Documents/VMWare/Kali.vmwarevm" nogui && echo "Connecting via SSH...") && ssh lwj@kali-vm.local'
alias ubuntu-vm='(echo "Starting VM..." && vmrun -T fusion start "/Users/LWJ/Documents/VMWare/Ubuntu.vmwarevm" nogui && echo "Connecting via SSH...") && ssh lwj@ubuntu-vm.local'
alias ev3='~/Repositories/internal/c4ev3/ev3duder/ev3duder'
alias ev3upload='~/Repositories/internal/c4ev3/scripts/ev3upload'
alias ev3build='~/Repositories/internal/c4ev3/scripts/ev3build'
alias ev3buildUpload='~/Repositories/internal/c4ev3/scripts/ev3buildUpload'
alias mcmodvchange="'/Users/LWJ/Library/Application Support/minecraft/mods_change.sh'"
alias xcSimStatusOverride='xcrun simctl status_bar booted override --time "9:41 AM" --batteryState charged --batteryLevel 100 --wifiMode active --wifiBars 3 --cellularMode active --cellularBars 4 --operatorName ""'
proctorScreenRec() {
    ffmpeg -f avfoundation -r 1 -probesize 20M -threads 1 -i "$(ffmpeg -f avfoundation -list_devices true -i "" 2>&1 | grep "Capture screen" | cut -d ' ' -f 5 | cut -c 2):" -vcodec libx264 -b:v 128k -s hd1080 ~/Desktop/proctor_screenrec_$(date +"%Y%m%d_%H%M%S").mp4
}
ctf() {
    alias ls='ls -lGaf'
    PATH=$HOME/CTF/Tools/bin:$PATH
    cd ~/CTF
}
alias ll='ls -lGaf'

# zsh ignore spaces
setopt histignorespace

# print login logo
if [[ -o login ]]; then
    echo && neofetch --logo
fi

# sourced configs
source ~/bin/pwdt
source ~/bin/hoard

#export PATH="/usr/local/opt/zip/bin:$PATH"
#export PATH="/usr/local/opt/unzip/bin:$PATH"
