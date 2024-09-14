if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  export SESSION_TYPE=remote/ssh
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) export SESSION_TYPE=remote/ssh;;
  esac
fi

# rust cargo
. "$HOME/.cargo/env"

# golang
export PATH="$HOME/go/bin:$PATH"

# homebrew
if [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# self
if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH"
fi

# completions
fpath=(/opt/homebrew/share/zsh/site-functions /usr/local/share/zsh/site-functions $fpath)

