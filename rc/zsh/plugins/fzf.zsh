# Apply theme, making sure to remove the `bg` option to be compatible with a
# transparent terminal background
source $ANTIDOTE_CACHE/catppuccin/fzf/themes/catppuccin-fzf-mocha.sh
export FZF_DEFAULT_OPTS="$(echo "$FZF_DEFAULT_OPTS" | sed -E 's/,bg:[^,]+//g')"

# Display full command on preview window, taken from:
# https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings#full-command-on-preview-window
#
# CTRL-Y to copy the command into clipboard using wl-copy, derived from:
# https://junegunn.github.io/fzf/shell-integration/#ctrl-r
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window down:3:wrap --bind '?:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# Preview file content using bat, derived from:
# https://junegunn.github.io/fzf/shell-integration/#ctrl-t
# https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings#preview
export FZF_CTRL_T_OPTS="
  --preview '(bat -n --color=always {} 2> /dev/null || tree -C {}) 2> /dev/null | head -200'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# Print tree structure in the preview window, derived from:
# https://junegunn.github.io/fzf/shell-integration/#alt-c
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# fzf plugin updates this, but the default is good enough so reset it
export FZF_DEFAULT_COMMAND=""

# Taken from: https://github.com/junegunn/fzf/wiki/Examples#git
# fbr - checkout git branch
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf --height 40% -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# Derived from: https://github.com/junegunn/fzf/wiki/Examples#changing-directory
# fdr - cd to selected parent directory
fdr() {
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs "$(dirname "$1")"
    fi
  }
  local DIR=$(get_parent_dirs "$(realpath "${1:-$PWD}")" | fzf --height 40% --tac)
  cd "$DIR"
}

