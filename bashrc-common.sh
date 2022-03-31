#######################################################################
# Aliases
alias cdgitroot='cd "$(git rev-parse --show-cdup)"'

#######################################################################
# Environment variables
export EDITOR=nvim
export VISUAL=nvim

export BAT_THEME=OneHalfDark

export PYENV_VIRTUALENV_DISABLE_PROMPT=1

#######################################################################
# Shell variables
HISTSIZE=20000
HISTFILESIZE=20000

#######################################################################
# Prompt

PROMPT_COMMAND='history -a; history -r'

# Make sure Windows Terminal duplicates new WSL tabs/panes in same directory
# https://docs.microsoft.com/en-us/windows/terminal/tutorials/new-tab-same-directory#bash
if [[ -n "$(which wslpath)" ]]; then
    PROMPT_COMMAND=${PROMPT_COMMAND:+"$PROMPT_COMMAND; "}'printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"'
fi

eval "$(oh-my-posh prompt init bash --config 'https://raw.githubusercontent.com/shyun3/dotfiles/main/mytheme.omp.json')"

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
