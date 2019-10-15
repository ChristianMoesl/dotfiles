autoload -U promptinit; promptinit
prompt pure

autoload -Uz compinit
compinit

export NODE_PATH=/usr/local/lib/node_modules

export PATH="/Users/cm/Workspace/wasmtime/target/release:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="$HOME/.gem/ruby/2.6.0/bin:$PATH"
export PATH="~/Library/Python/3.7/bin:$PATH"
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"

eval "$(rbenv init -)"

export GPG_TTY=$(tty)

if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
