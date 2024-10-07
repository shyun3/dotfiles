#######################################################################
# Aliases
alias cdgitroot='cd "$(git rev-parse --show-cdup)"'

#######################################################################
# Environment variables
export EDITOR=nvim
export VISUAL=nvim

export BAT_THEME=OneHalfDark

#######################################################################
# Shell variables
HISTSIZE=20000
HISTFILESIZE=20000

#######################################################################
# Prompt
_RED='\[$(tput setaf 1)\]'
_RESET='\[$(tput sgr0)\]'

# Add red git branch in front of prompt
PS1="$_RED\$(__git_ps1 '[%s] ')$_RESET$PS1"

#######################################################################
# Tilix
# See https://github.com/gnunn1/tilix/wiki/VTE-Configuration-Issue
if [[ $TILIX_ID ]]; then
    source /etc/profile.d/vte.sh
fi

#######################################################################
# fzf
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf --height 40% -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}
