if ! (( $+commands[mountavfs] )); then
    return
fi

if mountpoint -q ~/.avfs; then
    return
fi

if [[ -e ~/.avfs && ! -d ~/.avfs ]]; then
    return
fi

mkdir -p ~/.avfs
if [[ -z "$(ls -A ~/.avfs)" ]]; then
    mountavfs > /dev/null
fi
