. "$HOME/.cargo/env"

source "$HOME/.secrets.sh"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='nvim'
else
	export EDITOR='nvim'
fi
export VISUAL="$EDITOR"

#AWSume alias to source the AWSume script
alias awsume="source \$(pyenv which awsume)"

# rebase all changes from latest origin/HEAD commit onwards interactively
grchanges() {
	local current_branch="$(git branch --show-current)"
	local base_branch="$(git rev-parse --abbrev-ref origin/HEAD)"
	local head_commit="$(git merge-base $current_branch $base_branch)"
	git rebase -i $head_commit
}

# switch to default branch, clear garbage branches and pull from remote
greset() {
	git switch "$(gh default-branch show --name-only)"
	gbgc
	git pull
}

# push git branch to github and create draft pull request
gprc() {
	git push -u
	gh pr create --draft --fill
}

# add all changes and commit them
gac() {
	git add --all
	git commit -v
}

# add all changes, commit them and push
gacp() {
	gac
	git push -u
}

# add all changes, create a fixup commit and push
gafp() {
	git add --all
	git fixup
	git push -u
}

# mark github pull request as ready and add everyone as assignee
gprmr() {
	gh pr ready
	gh pr edit --add-assignee "rubeninoto"
	gh pr edit --add-reviewer "Simon-Hayden-Dev"
}

# garbage collect merged branches
gbgc() {
	local default_branch=$(gh default-branch show --name-only)
	git switch $default_branch
	echo "remove merged branches"
	git branch --merged $default_branch | grep -v "^[ *]*${default_branch}\$" | xargs git branch -d
	echo "prune remote branches"
	git remote prune origin
	git pull
}

# garbage collect merged/local branches without remote
greset() {
	local default_branch=$(gh default-branch show --name-only)
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
