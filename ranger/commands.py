# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# A simple command for demonstration purposes follows.
# -----------------------------------------------------------------------------

from __future__ import absolute_import, division, print_function

# You can import any python module as needed.
import os
import os.path

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import Command


# Taken from:
# https://github.com/SL-RU/ranger-config/blob/bdc60e516e8c213c69807bfab8ea25cd7eca9371/avfs.py
#
# Tested with ranger 1.9.1
#
# A very simple and possibly buggy support for AVFS
# (http://avf.sourceforge.net/), that allows ranger to handle
# archives.
#
# Run `:avfs' to browse the selected archive.
class avfs(Command):  # pylint: disable=invalid-name
    avfs_root = os.path.join(os.environ["HOME"], ".avfs")
    avfs_suffix = "#"

    def execute(self):
        if os.path.isdir(self.avfs_root):
            archive_directory = "".join(
                [
                    self.avfs_root,
                    self.fm.thisfile.path,
                    self.avfs_suffix,
                ]
            )
            name = os.path.basename(self.fm.thisfile.path)
            if os.path.isdir(archive_directory):
                self.fm.tab_open(name, archive_directory)
            else:
                self.fm.notify("This file cannot be handled by avfs.", bad=True)
        else:
            self.fm.notify("Install `avfs' and run `mountavfs' first.", bad=True)
