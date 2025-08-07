# Make sure Windows Terminal duplicates new WSL tabs/panes in same directory
# See: https://learn.microsoft.com/en-us/windows/terminal/tutorials/new-tab-same-directory#zsh
if [[ $(uname -r) =~ WSL ]]; then
    keep_current_path() {
      printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"
    }
    precmd_functions+=(keep_current_path)
fi
