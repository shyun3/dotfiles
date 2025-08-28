# The tealdeer completion installed through the system package doesn't seem to
# get picked up by compinit (maybe because the filename doesn't start with an
# underscore)
cp /usr/share/zsh/vendor-completions/tldr.zsh $ZSH_CACHE_DIR/completions/_tldr
