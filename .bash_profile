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
    local REPO_ROOT 
    REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo -e "\e[43m \e[0m Not inside a git repository"; return 1; }

	git status; 
	latest=`git for-each-ref --format="%(refname:short)" --sort=-version:refname --count=1 'refs/tags/v*'`
	release=`git for-each-ref --format="%(refname:short)" --sort=-authordate --count=1 refs/tags/releases`
	echo "Latest: $latest"
	echo "Release: $release"
    
    submodule-status
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

alias fetch=fetch_origin_and_checkout_tag
function fetch_origin_and_checkout_tag() {
        git fetch origin ;
        git checkout "v"$1
}

alias gccr=git-commit-from-changelog-release
function git-commit-from-changelog-release() {
    local file="$1"
    local msg version

    YELLOW="\e[43m"
    GREY="\e[90m"
    RESET="\e[0m"

    if [ -z "$file" ]; then
        for candidate in CHANGELOG.md docs/build/changelog.md; do
            if [ -f "$candidate" ]; then
                file="$candidate"
                break
            fi
        done
        file="${file:-CHANGELOG.md}"
    fi

    version=$(awk '/^## / { print; exit }' "$file" | sed -e 's/^## *//')

    msg=$(awk '
        /^## / { if (started) exit; started=1; next }
        started && /^\*\*/ { exit }
        started { print }
    ' "$file" | sed -e :a -e '/^\n*$/{$d;N;ba' -e '}')

    if [ -z "$msg" ]; then
        echo "Could not find a release message in $file" >&2
        return 1
    fi

    echo ""
    echo -e "${YELLOW}  ${RESET} The following commit message will be created for release ${version}:"
    echo ""
    echo -e "${GREY}${msg}${RESET}"
    echo ""
    echo -ne "${YELLOW}  ${RESET} Proceed? [y/N] "
    read CONFIRM
    if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
        echo "Aborted."
        return 1
    fi

    git commit -m "$msg"
}

alias gaccrd=git-add-commit-changelog-release-deploy
function git-add-commit-changelog-release-deploy() {
    git add . &&
    git-commit-from-changelog-release &&
    .bin/deploy.sh ${1:+"$1"}
}

alias submodulestats=submodule-status
function submodule-status() {
    local REPO_ROOT GITMODULES

    REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "not inside a git repository"; return 1; }
    GITMODULES="$REPO_ROOT/.gitmodules"

    [ -f "$GITMODULES" ] || return 0

    git config --file "$GITMODULES" --get-regexp '\.path$' | while read -r _ SUBMODULE_PATH; do
        local SUBMODULE_DIR="$REPO_ROOT/$SUBMODULE_PATH"

        if [ ! -d "$SUBMODULE_DIR/.git" ] && [ ! -f "$SUBMODULE_DIR/.git" ]; then
            echo -e "\e[41m  \e[0m $SUBMODULE_PATH: submodule not initialized"
            continue
        fi

        (
            cd "$SUBMODULE_DIR" || exit 1

            git fetch origin --quiet 2>/dev/null

            LOCAL_SHA="$(git rev-parse --verify --quiet HEAD)"

            SYMREF_OUTPUT="$(git ls-remote --symref origin HEAD 2>/dev/null)"

            if [ -z "$SYMREF_OUTPUT" ]; then
                echo -e "\e[41m  \e[0m $SUBMODULE_PATH: could not reach origin, skipping check"
                exit 0
            fi

            REMOTE_SHA="$(awk '$2 == "HEAD" && $1 != "ref:" {print $1}' <<< "$SYMREF_OUTPUT")"
            REMOTE_BRANCH="$(awk '$1 == "ref:" {sub("refs/heads/", "", $2); print $2}' <<< "$SYMREF_OUTPUT")"

            if [ "$LOCAL_SHA" = "$REMOTE_SHA" ]; then
                echo -e "\e[42m  \e[0m $SUBMODULE_PATH: up to date"
                exit 0
            fi

            BEHIND_COUNT="$(git rev-list --count "$LOCAL_SHA..$REMOTE_SHA")"
            AHEAD_COUNT="$(git rev-list --count "$REMOTE_SHA..$LOCAL_SHA")"

            echo -e "\e[43m  \e[0m $SUBMODULE_PATH: out of sync with origin/${REMOTE_BRANCH:-master}"

            if [ "$BEHIND_COUNT" -gt 0 ]; then
                echo "    $BEHIND_COUNT commit(s) behind:"
                git log "$LOCAL_SHA..$REMOTE_SHA" --oneline | sed 's/^/      /'
            fi

            if [ "$AHEAD_COUNT" -gt 0 ]; then
                echo "    $AHEAD_COUNT commit(s) ahead (not yet pulled by other checkouts):"
                git log "$REMOTE_SHA..$LOCAL_SHA" --oneline | sed 's/^/      /'
            fi
        )
    done
}

if [ -f ~/.dotfiles/wp-completion.bash ]; then
    source ~/.dotfiles/wp-completion.bash
fi
