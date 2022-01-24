PROMPT_COMMAND='history -a'

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%d/%m/%y %T "

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
. ~/.dotfiles/.bash_aliases
. ~/.dotfiles/.bash_prompt

alias s=repo_status
function repo_status() {
	git status; 
	latest=`git for-each-ref --format="%(refname:short)" --sort=-authordate --count=1 refs/tags`
	release=`git for-each-ref --format="%(refname:short)" --sort=-authordate --count=1 refs/tags/releases`
	echo "Latest: $latest"
	echo "Release: $release"
}

alias upd=edit_and_source_file
function edit_and_source_file() {
	vim $1 ; 
	source $1
}

alias ts=convert_date_to_utc_timestamp
function convert_date_to_utc_timestamp() {
    date -d "$1:00 UTC" +%s
}

if [ -f ~/.dotfiles/wp-completion.bash ]; then
    source ~/.dotfiles/wp-completion.bash
fi