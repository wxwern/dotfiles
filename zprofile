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
