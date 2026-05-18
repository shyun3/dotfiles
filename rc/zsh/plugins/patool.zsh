# argcomplete doesn't support aliases with arguments, see argcomplete#222.
# Functions are being used here so that filenames will be completed. Using an
# alias attempts to complete the bare `patool` call.
pls() { patool list "$@"}
ppack() { patool create "$@"; }
punpack() { patool extract "$@"; }
