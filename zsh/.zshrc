export FZF_BASE="/opt/homebrew/opt/fzf"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/chris/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
#github See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME=powerlevel10k/powerlevel10k

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

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
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  docker
  web-search
  macos
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# speedup fzf with ripgrep
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/Users/chris/.dotnet/tools:$PATH"
export PATH="$HOME/go/bin:$PATH"


export NODE_PATH=/usr/local/lib/node_modules
export NODE_EXTRA_CA_CERTS="$(mkcert -CAROOT)/rootCA.pem"

# for gpg sign with pinentry
export GPG_TTY=$(tty)
# use GPG for SSH authentication
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

export TERM=screen-256color

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# shortcut to fuzzy find file and edit it
se() { fzf | xargs $EDITOR ; }

alias gcob='git branch | fzf | xargs git checkout'

alias l='ls -lahG'
alias ls='ls -G'
alias la='ls -lAhG'
alias ll='ls -lhG'
alias lsa='ls -lahG'

alias cat='bat --plain --theme=Nord'

export BAT_THEME='Nord'

# rebase all changes from latest origin/HEAD commit onwards interactively
grchanges () {
  current_branch="$(git branch --show-current)"
  base_branch="$(git rev-parse --abbrev-ref origin/HEAD)"
  head_commit="$(git merge-base $current_branch $base_branch)"
  git rebase -i $head_commit
}

# push git branch to github and create draft pull request
gprc() {
  git push -u
  gh pr create --draft --fill
}

# add all changes, commit them and push
gacp() {
  git add --all
  git commit -v --amend --no-edit
  git push -u --force-with-lease
}

unalias gsw
# change branch with fzf
gsw() {
  name=$(git branch | fzf | cut -c 3-)
  [ -n "$name" ] && git switch $name
}

# mark github pull request as ready and add assignee's
gprmr() {
  gh pr ready
  gh pr edit --add-assignee PatrickSchuster,pablotp,mteufner,mh-it,StefanMensik
}

# garbage collect local branches
gbgc() {
  default_branch=$(gh default-branch show --name-only)
  echo "remove merged branches"
  git branch --merged $default_branch | grep -v "^[ *]*${default_branch}\$" | xargs git branch -d
  echo "prune remote branches"
  git remote prune origin
  echo "remove branches with 'gone' remote"
  git branch -v | grep "\[gone\]" | cut -c 3- | cut -d' ' -f1 | xargs git branch -D
  echo "delete local branches without remote"
  git for-each-ref --format '%(refname:short) %(upstream)' refs/heads | awk '{if (!$2) print $1;}' | xargs git branch -D
}

# switch to default branch, clear garbage branches and pull from remote
greset() {
  git switch "$(gh default-branch show --name-only)"
  gbgc
  git pull
}

# switch to different project in Workspace directory and open in editor
pr() {
  directory=$(rg --files --max-depth 2 ~/Workspace | xargs dirname | sort -u | fzf)
  if [ "$?" -eq "0" ]; then
    cd "$directory"
    $EDITOR .
  fi
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


# setup autocomplete
autoload -Uz compinit
compinit

if [ /usr/local/bin/gh ]; then source <(gh completion -s zsh); fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

[ -f "/Users/chris/.ghcup/env" ] && source "/Users/chris/.ghcup/env" # ghcup-env
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
