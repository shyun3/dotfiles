if ! (( $+commands[ratarmount] )); then
    return
fi

RATARMOUNT_VFS="/run/user/$(id -u)/ratarmount"
if ! mountpoint -q $RATARMOUNT_VFS; then
    if [[ ! -e $RATARMOUNT_VFS ]]; then
        ratarmount --index-file ':memory:' --lazy -r / $RATARMOUNT_VFS
    else
        echo "Could not create ratarmount VFS at $RATARMOUNT_VFS" >&2
    fi
fi

unset RATARMOUNT_VFS
