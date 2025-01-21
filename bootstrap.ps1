scoop bucket add nerd-fonts
scoop install JetBrainsMono-NF

# Python installed by uv doesn't seem to be put on the PATH
scoop install python main/uv file gow
uv tool install "dotdrop>=1.15"
