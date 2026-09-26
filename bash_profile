export LC_ALL=en_US.UTF-8

# homebrew config
export HOMEBREW_NO_AUTO_UPDATE=1

if [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# prevent repeated bash history items
HISTCONTROL=erasedups:ignorespace
PROMPT_COMMAND='history -w'

# commands
alias ll='ls -lGaf'

# colors!!!!
export CLICOLOR=1
export TERM="xterm-color"
export LSCOLORS=GxFxCxDxBxegedabagaced #export LSCOLORS=ExGxFxdxCxDxDxxbaDecac
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/wern/.lmstudio/bin"
# End of LM Studio CLI section

# custom binaries
export PATH=$HOME/bin:$PATH

# setup ~/.cache in ~/Library/Caches/dotcache and symlinked
if [ ! -d "$HOME"/Library/Caches/dotcache ]; then
  if [ -d "$HOME"/.cache ]; then
    mv "$HOME"/.cache "$HOME"/Library/Caches/dotcache
  else
    mkdir -p "$HOME"/Library/Caches/dotcache
  fi
  if [ ! -L "$HOME"/.cache ]; then
    ln -s "$HOME"/Library/Caches/dotcache "$HOME"/.cache
  fi
fi
