if ! (($+commands[ratarmount])); then
    return
fi

USER_RUN_DIR="/run/user/$UID"
RATARMOUNT_VFS="$USER_RUN_DIR/ratarmount"
if [[ -d $USER_RUN_DIR ]] && [[ -w $USER_RUN_DIR ]]; then
    mkdir -p "$RATARMOUNT_VFS"
    if ! mountpoint -q "$RATARMOUNT_VFS"; then
        ratarmount --index-file ':memory:' --lazy -r / "$RATARMOUNT_VFS"
    fi
else
    print -r -- "ratarmount: Could not access $USER_RUN_DIR" >&2
fi

unset USER_RUN_DIR RATARMOUNT_VFS
