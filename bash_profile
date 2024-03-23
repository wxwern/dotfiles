export LC_ALL=en_US.UTF-8

#homebrew config
export HOMEBREW_NO_AUTO_UPDATE=1

if [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

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

#custom stuff
export PATH=$HOME/bin:$PATH
