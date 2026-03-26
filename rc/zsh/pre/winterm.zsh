# Detect Windows Terminal
# Taken from https://stackoverflow.com/q/59733731
if [[ -z "$WT_SESSION" ]]; then
    return
fi

# Make sure Windows Terminal duplicates new WSL tabs/panes in same directory
# See: https://learn.microsoft.com/en-us/windows/terminal/tutorials/new-tab-same-directory#zsh
if [[ $(uname -r) =~ WSL ]]; then
    keep_current_path() {
      printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"
    }
    precmd_functions+=(keep_current_path)
fi

# Windows Terminal does not currently set COLORTERM, see:
# https://github.com/microsoft/terminal/issues/11057
#
# Some programs use this to detect true color capability
export COLORTERM=${COLORTERM:-truecolor}
