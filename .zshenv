
#AWSume alias to source the AWSume script
alias awsume="source \$(pyenv which awsume)"

alias gcob='git branch | fzf | xargs git checkout'

alias l='ls -lahG'
alias ls='ls -G'
alias la='ls -lAhG'
alias ll='ls -lhG'
alias lsa='ls -lahG'

# rebase all changes from latest origin/HEAD commit onwards interactivly
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

# add all changes and commit them
gac() {
  git add --all
  git commit -v --amend --no-edit
}

# add all changes, commit them and push
gacp() {
  gac
  git push -u --force-with-lease
}

# add all changes, create a fixup commit and push
gafp() {
  git add --all
  git fixup
  git push -u
}

# mark github pull request as ready and add assignee's
gprmr() {
  gh pr ready
  gh pr edit --add-assignee mteufner,jkanzler,apostolosrousalis,rubeninoto
}

# mark github pull request as ready and add assignee's including ABS only devs
gprmrabs() {
  gh pr ready
  gh pr edit --add-assignee mteufner,jkanzler,SebastianFrk,StefanMensik,LiamHiscox1997,apostolosrousalis,rubeninoto
}

# garbage collect merged branches
gbgc() {
  default_branch=$(gh default-branch show --name-only)
  git switch $default_branch
  echo "remove merged branches"
  git branch --merged $default_branch | grep -v "^[ *]*${default_branch}\$" | xargs git branch -d
  echo "prune remote branches"
  git remote prune origin
  git pull
}

# garbage collect merged/local branches without remote
greset() {
  default_branch=$(gh default-branch show --name-only)
  git switch $default_branch
  echo "remove merged branches"
  git branch --merged $default_branch | grep -v "^[ *]*${default_branch}\$" | xargs git branch -d
  echo "prune remote branches"
  git remote prune origin
  echo "remove branches with 'gone' remote"
  git branch -v | grep "\[gone\]" | cut -c 3- | cut -d' ' -f1 | xargs git branch -D
  echo "delete local branches without remote"
  git for-each-ref --format '%(refname:short) %(upstream)' refs/heads | awk '{if (!$2) print $1;}' | xargs git branch -D
  git pull
}

uuid() {
  uuidgen | tr '[:upper:]' '[:lower:]'
}

#Auto-Complete function for AWSume
fpath=(~/.awsume/zsh-autocomplete/ $fpath)
