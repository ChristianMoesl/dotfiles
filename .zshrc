# Enable ZSH profiling
# zmodload zsh/zprof

setopt HIST_IGNORE_SPACE

path_prepend() {
  [[ -n "$1" && -d "$1" ]] || return
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}

path_prepend "$HOME/.cargo/bin"
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/go/bin"
path_prepend "$HOME/.pi/agent/bin"

# Common config
[[ -f ~/.zshrc.common ]] && source ~/.zshrc.common

# OS-specific config
if [[ -n "$WSL_DISTRO_NAME" ]]; then
  [[ -r ~/.zshrc.windows ]] && source ~/.zshrc.windows
else
  case "$(uname -s)" in
  Linux)
    [[ -r ~/.zshrc.linux ]] && source ~/.zshrc.linux
    ;;
  Darwin)
    [[ -r ~/.zshrc.darwin ]] && source ~/.zshrc.darwin
    ;;
  esac
fi

# Machine-specific/private config, not synced
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Configuration before oh-my-zsh is initialized
# speedup fzf with ripgrep
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
export FZF_DEFAULT_OPTS=" \
--color=bg:#1e1e2e,bg+:#313244,gutter:#1e1e2e,selected-bg:#45475a \
--color=fg:#cdd6f4,fg+:#cdd6f4,hl:#f38ba8,hl+:#f38ba8 \
--color=header:#f38ba8,info:#cba6f7,prompt:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,spinner:#f5e0dc,border:#313244,label:#cdd6f4"

# Configure Catppuccin for zsh-syntax-highlighting
[[ -r "$HOME/.config/zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh" ]] && source "$HOME/.config/zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh"

# Setup ZSH builtins

# Add path for custom completions
fpath=("$HOME/.config/zsh/completions" $fpath)

# Edit command line in neovim with ctrl-e
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

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
  kubectl
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf
)

[[ "$(uname -s)" == Darwin ]] && plugins+=(macos)

[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# User configuration

# for gpg sign with pinentry
# export GPG_TTY=$(tty)
# use GPG for SSH authentication
# export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
# gpgconf --launch gpg-agent

# Custom aliases and functions

alias l='ls -lahG'
alias ls='ls -G'
alias la='ls -lAhG'
alias ll='ls -lhG'
alias lsa='ls -lahG'

alias cat='bat'

alias gcob='git branch | fzf | xargs git checkout'

unalias gsw 2>/dev/null || true
# change branch with fzf
gsw() {
  local name=$(git branch | fzf | cut -c 3-)
  [ -n "$name" ] && git switch "$name"
}

workspaces() {
  echo $(ls -1d "$HOME/workspace" "$HOME/Workspace" "$HOME/rbmh" 2>/dev/null)
}

openCodeWorkspace() {
  echo $(ls -1df ~/OpenCode 2>/dev/null)
}

projects() {
  workspaces | xargs rg --files --hidden --max-depth 2 --null | xargs -0 dirname | sort -u
}

openCodeProjects() {
  openCodeWorkspace | xargs rg --files --hidden --max-depth 2 --null | xargs -0 dirname | sort -u
}

worktrees() {
  git worktree list | awk '{print $1}'
}

# (S)witch to different (p)roject in Workspace directory and open in editor
so() {
  local directory
  directory=$(openCodeProjects | fzf)
  if [ "$?" -eq "0" ]; then
    cd "$directory"
    nvim .
  fi
}

# (S)witch to different (p)roject in Workspace directory and open in editor
sp() {
  local directory
  directory=$(
    projects |
      awk -v home="$HOME" '{ display=$0; sub("^" home, "~", display); print display "\t" $0 }' |
      fzf --delimiter='\t' --with-nth=1 |
      cut -f2-
  )

  if [ "$?" -eq "0" ]; then
    cd "$directory"
    nvim .
  fi
}

# (S)witch to different (p)roject in Workspace directory and open in editor
sw() {
  local directory
  directory=$(worktrees | fzf)
  if [ "$?" -eq "0" ]; then
    cd "$directory"
    nvim .
  fi
}

# (E)dit file in located in any workspace
e() {
  local file
  file=$(workspaces | xargs rg --files | fzf)
  if [ "$?" -eq "0" ]; then
    echo "open $file"
    nvim $file
  fi
}

# (E)dit (m)ultiple files in located in any workspace
em() {
  local files
  files=$(workspaces | xargs rg --files | fzf --multi)
  if [ "$?" -eq "0" ]; then
    nvim -c "tab all" $files
  fi
}

unalias gpr 2>/dev/null || true
# checkout a pull request with fuzzy search
gpr() {
  local id=$(gh pr list \
    --json number,title,headRefName,author \
    --template '{{range .}}{{tablerow (printf "#%v" .number | autocolor "green") .title (.headRefName | color "cyan") (.author.login | color "yellow") .isDraft }}{{end}}' |
    fzf --ansi | cut -d ' ' -f 1 | cut -c 2-)
  [ -n "$id" ] && gh pr checkout "$id"
}

# Virtual environments for different languages
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

eval "$(starship init zsh)"

command -v fnm >/dev/null 2>&1 && eval "$(fnm env --use-on-cd --shell zsh)"

[[ -s ~/.work-setup.sh ]] && source ~/.work-setup.sh

# Print startup profile
# zprof

# pnpm
if [[ -z "$PNPM_HOME" ]]; then
  case "$(uname -s)" in
    Darwin) export PNPM_HOME="$HOME/Library/pnpm" ;;
    *) export PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm" ;;
  esac
fi
path_prepend "$PNPM_HOME/bin"
path_prepend "$PNPM_HOME"
# pnpm end
