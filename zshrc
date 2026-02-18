# custom prompts if login session
if [[ -o login ]]; then

    printf '\n'
    if [[ "$(uname -s)" != "Darwin" ]]; then
        printf '\033[0;31m'
        printf 'This is not a macOS system - this zshrc may not work as expected.\n'
        printf '\033[0m'
    fi

    DISPLAY_NAME="$(id -F)"
    # DISPLAY_NAME="$(id -u -n | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')"

    if [[ -n "$DISPLAY_NAME" ]]; then
        printf '\033[1m'
        printf "Welcome, $DISPLAY_NAME.\n\n"
        printf '\033[0m'
    else
        printf '\033[1m'
        printf "Welcome.\n\n"
        printf '\033[0m'
    fi

    # brew upgrade reminders
    if [[ -f ~/tmp/brew_outdated_motd.txt ]]; then
        _outdated_motd="$(cat ~/tmp/brew_outdated_motd.txt)"
        if [[ -n "$_outdated_motd" ]]; then
            echo "$_outdated_motd"
        fi
    fi

    # check if brew exists
    if [[ -x "$(command -v brew)" ]]; then

        # get the standard brew path
        _BREW_COMMAND_PATH="$(command -v brew)"

        # motd updater
        brew-updatemotd() {
            _new_motd=""
            _brew_outdated_count="$("$_BREW_COMMAND_PATH" outdated | wc -l | xargs)"
            if (( $_brew_outdated_count != 0 )); then
                _new_motd="You have $_brew_outdated_count outdated packages. Please upgrade them."
            fi

            if [[ ! -f ~/tmp/brew_outdated_motd.txt ]]; then
                mkdir -p ~/tmp
                touch ~/tmp/brew_outdated_motd.txt
            fi

            if [[ "$(cat ~/tmp/brew_outdated_motd.txt)" != "$_new_motd" ]]; then
                printf "$_new_motd\n" > ~/tmp/brew_outdated_motd.txt
            fi
        }

        # brew wrapper
        brew() {
            # locate the brew binary and run it
            "$_BREW_COMMAND_PATH" "$@"

            # for updates and upgrades, we intercept the output to update the motd
            if [[ "$1" == "upgrade" || "$1" == "outdated" ]]; then
                brew-updatemotd
            fi
        }

    else
        # otherwise, remove the txt if it exists
        [[ -f ~/tmp/brew_outdated_motd.txt ]] &&
            rm ~/tmp/brew_outdated_motd.txt
    fi

    # add alias to arm brew if it exists
    if [[ -x /opt/homebrew/bin/brew ]]; then
        alias brew-arm64="arch -arm64 /opt/homebrew/bin/brew"
        alias brew-arm="arch -arm64 /opt/homebrew/bin/brew"
    fi

    # add alias to x86 brew if it exists
    if [[ -x /usr/local/bin/brew ]]; then
        alias brew-x86_64="arch -x86_64 /usr/local/bin/brew"
        alias brew-rosetta="arch -x86_64 /usr/local/bin/brew"
    fi

    printf '\n'
fi

# zsh completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

# pwd transfer
[[ ! -f ~/bin/pwdt ]] || source ~/bin/pwdt

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

# Prevent auto-corrections to target filenames.
CORRECT_IGNORE_FILE="[.|_]*"

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
plugins=(git python macos zsh-autosuggestions zsh-syntax-highlighting copyfile)

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

# iTerm2 Shell Integration
export ITERM2_SQUELCH_MARK=1
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# bun
export PATH=$HOME/.bun/bin:$PATH

# Rust cargo
if [[ -d "$HOME/.cargo" ]]; then
    . "$HOME/.cargo/env"
fi

# Golang
export PATH="$HOME/go/bin:$PATH"

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/Users/wern/.opam/opam-init/init.zsh' ]] || source '/Users/wern/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration

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
export FZF_DEFAULT_COMMAND='
    fd --type f --strip-cwd-prefix --follow \
        --exclude .git --exclude node_modules \
        --exclude build --exclude dist --exclude target --exclude pkg
'

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
if [[ -x "$(command -v nvim)" ]]; then
    alias vim="nvim"
else
    alias nvim="vim"
fi
alias python="python3"
alias cp="cp -c" # use macOS APFS cloning by default
alias tetris="autoload -Uz tetriscurses && tetriscurses"

# On macOS, alias reboot to use AppleScript to send System Events to be graceful to GUI apps
reboot() {
    osascript -e 'tell application "System Events" to restart' && \
        echo "Restart has been scheduled and is underway." && \
        echo "You will be logged out shortly."
}


# VM helpers

# 1. lima shorthand for launching lima (is built-in)

# 2. lima open/import/export helpers
lima-open-from() {
    echo "Opening the equivalent non-shared directory in Lima VM filesystem..."
    echo

    if [ -z "$1" ]; then
        echo "Usage: lima-open-from <path-to-directory>"
        echo
        echo "Assuming current working directory by default!"
        echo
        __HOST_PATH="$(cd . && pwd)"
    else
        __HOST_PATH="$(cd "$1" && pwd)"
    fi

    # open the directory from the lima home
    # get the full path
    if [ "$?" -ne 0 ]; then
        echo "Error: Could not access path '$1'"
        return 1
    fi

    lima true || return 1
    limactl ls default | grep "Running" >/dev/null 2>&1 ||
    { echo "Error: Lima VM 'default' is not running"; return 1; }

    __LIMA_HOME="$(lima sh -c 'printf "''$HOME''"')"
    __ORIGIN_PATH="${__HOST_PATH/#$HOME/$__LIMA_HOME}"

    lima sh -c '[ -d "'"$__ORIGIN_PATH"'" ]' ||
    { echo "Error: Directory '$__ORIGIN_PATH' does not exist in Lima VM"; return 1; }

    limactl shell --workdir="$__ORIGIN_PATH" default
}

lima-import-from() {
    echo "Importing this directory from host into the Lima VM filesystem..."
    echo

    if [ -z "$1" ]; then
        echo "Usage: lima-import-from <path-to-directory>"
        echo
        echo "Assuming current working directory by default!"
        echo
        __HOST_PATH="$(cd . && pwd)"
    else
        __HOST_PATH="$(cd "$1" && pwd)"
    fi

    # import the directory into the same location at the lima home
    # get the full path
    if [ "$?" -ne 0 ]; then
        echo "Error: Could not access path '$1'"
        return 1
    fi

    lima true || return 1
    limactl ls default | grep "Running" >/dev/null 2>&1 ||
    { echo "Error: Lima VM 'default' is not running"; return 1; }

    __LIMA_HOME="$(lima sh -c 'printf "''$HOME''"')"

    __ORIGIN_PATH="$__HOST_PATH"
    __TARGET_PATH="${__HOST_PATH/#$HOME/$__LIMA_HOME}"

    # truncate the target directory from path, as rsync will create a nested dir otherwise
    # e.g. /path/to/dir -> /path/to
    __TARGET_PATH="${__TARGET_PATH%/*}"

    echo "Importing directory:"
    echo " > From: $__ORIGIN_PATH"
    echo " > To:   $__TARGET_PATH"
    echo

    echo "[Ctrl-C to abort]"
    sleep 1

    [ -d "$__ORIGIN_PATH" ] ||
    { echo "Error: Directory '$__ORIGIN_PATH' does not exist on host"; return 1; }

    lima mkdir -p "$__TARGET_PATH" ||
    { echo "Error: Could not create directory '$__TARGET_PATH' in Lima VM"; return 1; }

    limactl copy --backend=rsync -v -r "$__ORIGIN_PATH" default:"$__TARGET_PATH"
    __EXIT_CODE=$?
    if [ "$__EXIT_CODE" -ne 0 ]; then
        return $__EXIT_CODE
    fi

    __DIRNAME="$(basename "$__ORIGIN_PATH")"
    __TARGET_PATH="$__TARGET_PATH/$__DIRNAME"
    limactl shell --workdir="$__TARGET_PATH" default
}

lima-export-to() {
    echo "Exporting equivalent directory from Lima VM filesystem to host..."
    echo

    if [ -z "$1" ]; then
        echo "Usage: lima-export-to <path-to-directory>"
        echo
        echo "Assuming current working directory by default!"
        echo
        __HOST_PATH="$(cd . && pwd)"
    else
        __HOST_PATH="$(cd "$1" && pwd)"
    fi

    # export the directory from the lima home to the same location on host

    # get the full path
    if [ "$?" -ne 0 ]; then
        echo "Error: Could not access path '$1'"
        return 1
    fi

    lima true || return 1
    limactl ls default | grep "Running" >/dev/null 2>&1 ||
    { echo "Error: Lima VM 'default' is not running"; return 1; }

    __LIMA_HOME="$(lima sh -c 'printf "''$HOME''"')"
    __ORIGIN_PATH="${__HOST_PATH/#$HOME/$__LIMA_HOME}"
    __TARGET_PATH="$__HOST_PATH"

    # truncate the target directory from path, as rsync will create a nested dir otherwise
    # e.g. /path/to/dir -> /path/to
    __TARGET_PATH="${__TARGET_PATH%/*}"

    echo "Exporting directory:"
    echo " > From: $__ORIGIN_PATH"
    echo " > To:   $__TARGET_PATH"
    echo

    echo "[Ctrl-C to abort]"
    sleep 1

    lima sh -c '[ -d "'"$__ORIGIN_PATH"'" ]' ||
    { echo "Error: Directory '$__ORIGIN_PATH' does not exist in Lima VM"; return 1; }

    mkdir -p "$__TARGET_PATH" ||
    { echo "Error: Could not create directory '$__TARGET_PATH' on host"; return 1; }

    limactl copy --backend=rsync -v -r default:"$__ORIGIN_PATH" "$__TARGET_PATH"
    return $?
}

# 3. lima ctfvm shortcuts
alias ctfvm="limactl shell ctfvm"
alias ctfvmrosetta="limactl shell ctfvm-rosetta"

# 4. android vm management
androidvm() {
    ANDROID_VM_PID=$(pgrep -L qemu-system | grep -e Android_VM | awk '{print $1}')

    if [ -z "$1" ]; then
        echo 'Usage: androidvm (start|stop) [args]'
        echo
        if [ -n "$ANDROID_VM_PID" ]; then
            echo 'Android VM is running.'
            echo " > PID: $ANDROID_VM_PID"
            echo
            echo 'Use `androidvm stop` to stop it.'
        else
            echo 'Android VM is not running.'
            echo
            echo 'Use `androidvm start` to start it.'
        fi
        return 0
    fi

    if [ "$1" = "start" ]; then
        if [ -n "$ANDROID_VM_PID" ]; then
            echo 'Android VM already running.'
            echo " > PID: $ANDROID_VM_PID"
            echo 'Use `androidvm stop` to stop it.'
        else
            ANDROID_VM_ARGS=${@:2}

            echo "Starting Android VM..."
            echo " > emulator -avd Android_VM $ANDROID_VM_ARGS -feature -Vulkan"
            eval "emulator -avd Android_VM $ANDROID_VM_ARGS -feature -Vulkan" &>/dev/null & disown;
            echo "Launched Android VM."
        fi
    elif [ "$1" = "stop" ]; then
        if [ -z "$ANDROID_VM_PID" ]; then
            echo 'Android VM not running.'
            return 0
        fi

        echo "Stopping Android VM (PID: $ANDROID_VM_PID)..."
        kill -15 "$ANDROID_VM_PID" && echo 'Sent SIGTERM.'

        if [ "$?" -ne 0 ]; then
            echo "Error: Could not stop Android VM."
            return 1
        else
            # wait for the process to exist
            echo "Waiting for Android VM to stop..."
            while (ps -p "$ANDROID_VM_PID" > /dev/null); do
                sleep 1
            done
            echo "Android VM stopped."
        fi
    else
        echo 'Usage: androidvm (start|stop) [args]'
    fi
}

# tools

yarn-sync() {
    # sync package.json to match yarn.lock
    # (https://gist.github.com/bartvanandel/0418571bad30a3199afdaa1d5e3dbe25)

    if [ ! -f yarn.lock ]; then
        echo "Error: yarn.lock not found"
        return 1
    fi

    bun ~/Scripts/yarn-sync.js
}

rmtimecode() {
    echo "Generating new no timecode files from .mov files in this directory..."
    echo "Processing into temporary files..."

    if [[ -z "$(command -v ffmpeg)" ]]; then
        echo "Error: ffmpeg not found"
        return 1
    fi

    for file in *.mov; do
        # skip is there's already a _noTC file
        if [[ -f "${file%.*}_noTC.${file##*.}" ]]; then
            continue
        fi
        # skip if the file itself is a _noTC file
        if [[ "$file" == *_noTC.mov ]]; then
            continue
        fi
        # convert
        ffmpeg -i "$file" -write_tmcd 0 -c copy "${file%.*}_noTC.${file##*.}";
    done

    echo "Results generated!"
    echo
    echo "Are you sure you want to remove timecode from all original .mov files in this directory?"
    echo "This is irreversible!"

    read REPLY"? Continue? [y/N] "
    echo
    if [[ ! $REPLY =~ ^[Yy] ]]; then
        echo "Aborting..."
        return 1
    fi

    echo "Proceeding..."

    for file in *_noTC.mov; do
        original="${file%_noTC.mov}.mov";
        mv "$file" "$original" && echo "Removed timecode from $original" || echo "Error processing $original";
    done

    echo "Done!"
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
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
}

gnuify() {
    echo "Including GNU utils in PATH (replaces macOS utils if present)"
    echo "*** Warning: Stuff dependent on system utils might break! ***"

    if [[ -z "$HOMEBREW_PREFIX" ]]; then
        echo "Error: Homebrew prefix not found"
        return 1
    fi

    export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
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

xcPredictiveCompletion() {
    if [[ "$1" == "on" ]]; then
        defaults write com.apple.dt.Xcode IDEModelAccessHasUserConsentForOnDeviceInteractions -bool YES
        echo "Xcode predictive completion enabled."
        echo "Restart Xcode to apply changes."

    elif [[ "$1" == "off" ]]; then
        defaults write com.apple.dt.Xcode IDEModelAccessHasUserConsentForOnDeviceInteractions -bool NO
        echo "Xcode predictive completion disabled."
        echo "Restart Xcode to apply changes."

    else
        echo "Usage: xcPredictiveCompletion (on|off)"
    fi
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

    echo "Locating Java $1..."
    echo "  >>> Accessing... $HOMEBREW_PREFIX/Cellar/openjdk@$1/$1*/bin/java"

    if [[ ! -d "$HOMEBREW_PREFIX/Cellar/openjdk@$1" ]]; then
        echo "Error: Java $1 not found"
        return 1
    fi

    PATH="$(dirname $HOMEBREW_PREFIX/Cellar/openjdk@"$1"/"$1"*/bin/java):$PATH"

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
[ ! -f ~/bin/hoard ] || [ ! -x ~/bin/hoard ] || source ~/bin/hoard

