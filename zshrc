# custom prompts if login session
if [[ -o login ]]; then

    printf '\n\033[0;1;196mWelcome, Wern.\033[0m\n'

    # brew upgrade reminders
    outdated_motd="$(cat ~/tmp/brew_outdated_motd.txt)"
    if [[ -n "$outdated_motd" ]]; then
        echo "$outdated_motd"
    fi

    # check if brew exists
    if [[ -x "$(command -v brew)" ]]; then

        # if so, intercept updates
        brew() {
            /usr/local/bin/brew "$@"
            if [[ "$1" == "upgrade" || "$1" == "outdated" ]]; then
                ~/Scripts/updateBrewOutdated
            fi

        }
    else

        # otherwise, remove the txt
        rm ~/tmp/brew_outdated_motd.txt

    fi
fi

source ~/bin/pwdt

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="false"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

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
HIST_STAMPS="yyyy-mm-dd"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git python macos zsh-autosuggestions zsh-syntax-highlighting)

# Source oh my zsh
[[ ! -f $ZSH/oh-my-zsh.sh ]] || source $ZSH/oh-my-zsh.sh

# Source p10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ZSH: Do not include commands with trailing spaces into history
setopt histignorespace

# User configuration
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export MANPATH="/usr/local/man:$MANPATH"

# iTerm2 Shell Integration
export ITERM2_SQUELCH_MARK=1
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Homebrew and misc
export PATH=$HOME/bin:/usr/local/bin:/opt/homebrew/bin:$PATH

# Rust cargo
. "$HOME/.cargo/env"

# Golang
export PATH="$HOME/go/bin:$PATH"

# Ruby
#export PATH="/usr/local/opt/ruby/bin:$PATH"
#export LDFLAGS="-L/usr/local/opt/ruby/lib"
#export CPPFLAGS="-I/usr/local/opt/ruby/include"
#export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"

# include linux utils
export PATH="/usr/local/opt/util-linux/bin:$PATH"
export PATH="/usr/local/opt/util-linux/sbin:$PATH"
export LDFLAGS="-L/usr/local/opt/util-linux/lib"
export CPPFLAGS="-I/usr/local/opt/util-linux/include"
export PKG_CONFIG_PATH="/usr/local/opt/util-linux/lib/pkgconfig"

# Android
export ANDROID_HOME=/Users/$USER/Library/Android/sdk
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export ANDROID_SDK=$HOME/Library/Android/sdk
export ANDROID_NDK_HOME=$HOME/Library/Android/sdk/ndk/21.3.6528147/
export PATH=$ANDROID_SDK/emulator:$ANDROID_SDK/tools:$PATH

# fastlane
export PATH="$HOME/.fastlane/bin:$PATH"

# Plugin config
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#606060"
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_HISTORY_IGNORE="(?(#c50,)|(cd|rm|rmdir|sudo|git commit|vim|nvim) *)"
export ZSH_AUTOSUGGEST_COMPLETION_IGNORE="(rm|rmdir|sudo) *"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# bun completions
[ -s "/usr/local/Cellar/bun/1.0.11/share/zsh/site-functions/_bun" ] && source "/usr/local/Cellar/bun/1.0.11/share/zsh/site-functions/_bun"

# homebrew config
export HOMEBREW_NO_AUTO_UPDATE=1

# colors!!!!
export CLICOLOR=1
export TERM="xterm-256color"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

#prompt_context() {
#    if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
#        prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
#    fi
#}

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# === My aliases and helper functions ===
alias vim="echo 'note: using nvim'; nvim" # use nvim instead of vim, old habits die hard
alias ctfvm="limactl shell ctfvm"
alias tetris="autoload -Uz tetriscurses && tetriscurses"
alias obsbrowsercam="/Applications/OBS.app/Contents/MacOS/obs --enable-gpu --use-fake-ui-for-media-stream >> /dev/null 2>&1"

docker() {
  echo "running docker command as nerdctl via lima-vm"
  echo " ~> lima nerdctl $@"
  lima nerdctl "$@"
}

docker-compose() {
  echo "running docker-compose command as nerdctl compose via lima-vm"
  echo " ~> lima nerdctl compose $@"
  lima nerdctl compose "$@"
}

ctf() {
    echo "Setting Up CTF environment..."

    alias ls='ls -lGa'
    PATH=$HOME/CTF/Tools/bin:$PATH
    cd ~/CTF
}

ana() {
    echo "Note: Using Anaconda Environment" && \
        echo "Anaconda's installation of python and other libraries are added to PATH in this session"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/usr/local/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
}

gnuify() {
    echo "Including GNU utils in PATH (replaces macOS utils if present)"
    echo "*** Warning: Stuff dependent on system utils might break! ***"

    export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
}

videospeed() {
    if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]; then
        echo "Usage"
        echo "  $ $0 inFile speedupNumber outFile"
        echo "Example"
        echo "  $ $0 demo.mp4 2 demo2x.mp4"
        return 0;
    fi

    case $2 in
        ''|*[!0-9]*) echo "Error: Speed '$2' is not a number"; return 1 ;;
        *) ;;
    esac

    echo "[$1] --- $2""x speed --> [$3]"
    echo
    sleep 1
    ffmpeg -i "$1" -vf "setpts=PTS/$2" -filter:a "atempo=$2" "$3"
}

xcSimStatusOverride() {
    xcrun simctl status_bar booted override --time "9:41 AM" --batteryState charged --batteryLevel 100 --wifiMode active --wifiBars 3 --cellularMode active --cellularBars 4 --operatorName ""
}

ggcc() {
    # gnu gcc
    "$(compgen -c | grep -Eo "^gcc-[0-9]+$")" "$@"
}

javaver() {
    case $1 in
        ''|*[!0-9]*)
            echo "Sets Java version."
            echo "Usage"
            echo "  $ javaver 11"
            echo
            echo "Current:"
            echo
            java -version
            return 0;;
    esac

    PATH="$(dirname /usr/local/Cellar/openjdk@"$1"/"$1"*/bin/java):$PATH"

    if [[ "$?" == "0" ]]; then
        echo "Set to Java $1!"
    else
        echo "Could not set: Java $1"
    fi

    echo

    java -version
}


# === Uni Work ===
s() {
    if [[ -z "$1" ]]; then
        echo "Usage: s <modcode>"
        echo "Example: s 3230"
    else
        cd ~/Projects/*"$1"*
    fi
}

stuscp() {
    if [[ "$1" == "d" ]]; then
        if [[ -z "$2" || -z "$3" ]]; then
            echo "Usage: stuscp d <modcode> <dirname> [username@domain] [port]"
        else
            mkdir -p ~/Projects/"$2"/
            echo "Clearing ~/Projects/$2/$3/"
            echo
            rm -r ~/Projects/"$2"/"$3"/

            echo "Downloading from server..."
            scp -P "${5:-22}" -r "${4:-stu.comp.nus.edu.sg}":~/"$2"/"$3" ~/Projects/"$2"/ &&
                cd ~/Projects/"$2"/"$3" &&
                echo &&
                echo "Now at ~/Projects/$2/$3/"
        fi
    elif [[ "$1" == "u" ]]; then
        if [[ -z "$2" || -z "$3" ]]; then
            echo "Usage: stuscp u <modcode> <dirname> [username@domain] [port]"
        else
            tmp_pwd="$(pwd)"

            echo "Now at ~/Projects/$2/" &&
                cd ~/Projects/"$2"/ &&
                scp -P "${5:-22}" -r "./$3" "${4:-stu.comp.nus.edu.sg}":~/"$2"/

            cd "$tmp_pwd"
        fi
    else
        echo "Usage: stuscp (u|d) <modcode> <dirname> [username@domain] [port]"
    fi
}

proctorScreenRec() {
    ffmpeg -f avfoundation -r 1 -probesize 20M -threads 1 -i "$(ffmpeg -f avfoundation -list_devices true -i "" 2>&1 | grep "Capture screen" | cut -d ' ' -f 5 | cut -c 2):" -vcodec libx264 -b:v 128k -s hd1080 ~/Desktop/proctor_screenrec_$(date +"%Y%m%d_%H%M%S").mp4
}

# sourced configs
source ~/bin/hoard



