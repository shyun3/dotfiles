if ! (($+commands[ratarmount])); then
    return
fi

USER_RUN_DIR="/run/user/$UID"
RATARMOUNT_VFS="$USER_RUN_DIR/ratarmount"
if [[ -d $USER_RUN_DIR ]] && [[ -w $USER_RUN_DIR ]]; then
    mkdir -p "$RATARMOUNT_VFS"
    if ! mountpoint -q "$RATARMOUNT_VFS"; then
        if [[ -z "$(ls -A $RATARMOUNT_VFS)" ]]; then
            ratarmount --index-file ':memory:' --lazy --debug 0 -r / "$RATARMOUNT_VFS"
        else
            print -r -u 2 -- "ratarmount: $RATARMOUNT_VFS was non-empty"
        fi
    fi
else
    print -r -u 2 -- "ratarmount: Could not access $USER_RUN_DIR"
fi

unset USER_RUN_DIR RATARMOUNT_VFS
