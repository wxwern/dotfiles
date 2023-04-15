export LC_ALL=en_US.UTF-8

alias ssh='~/Repositories/ssh-ident/ssh-ident'
alias ev3='~/Repositories/c4ev3/ev3duder/ev3duder'
alias ev3upload='~/Repositories/c4ev3/scripts/ev3upload'
alias ev3build='~/Repositories/c4ev3/scripts/ev3build'
alias ev3buildUpload='~/Repositories/c4ev3/scripts/ev3buildUpload'

#android
export ANDROID_HOME=/Users/$USER/Library/Android/sdk
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export ANDROID_SDK=$HOME/Library/Android/sdk
export PATH=$ANDROID_SDK/emulator:$ANDROID_SDK/tools:$PATH

#c4ev3
export PATH=~/Repositories/c4ev3/c4ev3-gcc-2018-05-15.macOS/bin/:$PATH

# Setting PATH for Python 3.8
PATH="/Library/Frameworks/Python.framework/Versions/3.8/bin:${PATH}"
export PATH

#fastlane
export PATH="$HOME/.fastlane/bin:$PATH"

#ruby from homebrew
#export PATH="/usr/local/opt/ruby/bin:$PATH"
#export LDFLAGS="-L/usr/local/opt/ruby/lib"
#export CPPFLAGS="-I/usr/local/opt/ruby/include"
#export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"

#homebrew config
export HOMEBREW_NO_AUTO_UPDATE=1

#prevent repeated bash history items
HISTCONTROL=erasedups:ignorespace
PROMPT_COMMAND='history -w'

#commands
alias ll='ls -lGaf'

#colors!!!!
export CLICOLOR=1
export TERM="xterm-color"
export LSCOLORS=GxFxCxDxBxegedabagaced #export LSCOLORS=ExGxFxdxCxDxDxxbaDecac
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

#nice stuff
echo && neofetch --logo #neofetch --disable term

#custom stuff
export PATH=$HOME/bin:$PATH
source ~/bin/pwdt
source ~/bin/hoard
. "$HOME/.cargo/env"
