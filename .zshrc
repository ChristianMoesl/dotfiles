# Enable ZSH profiling
# zmodload zsh/zprof

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# Configuration before oh-my-zsh is initialized
export FZF_BASE="/opt/homebrew/opt/fzf"
# speedup fzf with ripgrep
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# Configure Catppuccin for zsh-syntax-highlighting
source ~/.config/zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

# Setup ZSH builtins

# Add path for custom completions
fpath=(~/.config/zsh/completions $fpath)

# Edit command line in neovim with ctrl-e
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Path to your oh-my-zsh installation.
export ZSH="/Users/chris/.oh-my-zsh"

# Theme will be overwritten by starship anyway
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  macos
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf
)

source $ZSH/oh-my-zsh.sh

# User configuration

# for gpg sign with pinentry
export GPG_TTY=$(tty)
# use GPG for SSH authentication
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# Custom aliases and functions

alias l='ls -lahG'
alias ls='ls -G'
alias la='ls -lAhG'
alias ll='ls -lhG'
alias lsa='ls -lahG'

alias cat='bat'

alias gcob='git branch | fzf | xargs git checkout'

unalias gsw
# change branch with fzf
gsw() {
  name=$(git branch | fzf | cut -c 3-)
  [ -n "$name" ] && git switch $name
}

# rebase all changes from latest origin/HEAD commit onwards interactively
grchanges () {
  current_branch="$(git branch --show-current)"
  base_branch="$(git rev-parse --abbrev-ref origin/HEAD)"
  head_commit="$(git merge-base $current_branch $base_branch)"
  git rebase -i $head_commit
}

# switch to different project in Workspace directory and open in editor
sp() {
  directory=$(rg --files --max-depth 2 ~/Workspace ~/rbmh | xargs dirname | sort -u | fzf)
  if [ "$?" -eq "0" ]; then
    cd "$directory"
    $EDITOR .
  fi
}

# (E)dit file in located in any workspace
e() {
  nvim $(rg --files ~/Workspace ~/rbmh | fzf)
}

# (E)dit (m)ultiple files in located in any workspace
em() {
  nvim -c "tab all" $(rg --files ~/Workspace ~/rbmh | fzf --multi)
}

unalias gpr
# checkout a pull request with fuzzy search
gpr() {
  id=$(gh pr list \
    --json number,title,headRefName,author \
    --template '{{range .}}{{tablerow (printf "#%v" .number | autocolor "green") .title (.headRefName | color "cyan") (.author.login | color "yellow") .isDraft }}{{end}}' \
    | fzf --ansi | cut -d ' ' -f 1 | cut -c 2-)
  [ -n "$id" ] && gh pr checkout "$id"
}

# Virtual environments for different languages
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

eval "$(starship init zsh)"

# Print startup profile
# zprof
