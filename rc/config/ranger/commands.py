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


# Taken from:
# https://github.com/ranger/ranger/wiki/Custom-Commands#fzf-integration
class fzf_select(Command):
    """
    :fzf_select
    Find a file using fzf.
    With a prefix argument to select only directories.

    See: https://github.com/junegunn/fzf
    """

    def execute(self):
        import os
        import subprocess

        from ranger.ext.get_executables import get_executables

        if "fzf" not in get_executables():
            self.fm.notify("Could not find fzf in the PATH.", bad=True)
            return

        fd = None
        if "fdfind" in get_executables():
            fd = "fdfind"
        elif "fd" in get_executables():
            fd = "fd"

        if fd is not None:
            hidden = "--hidden" if self.fm.settings.show_hidden else ""
            exclude = "--no-ignore-vcs --exclude '.git' --exclude '*.py[co]' --exclude '__pycache__'"
            only_directories = "--type directory" if self.quantifier else ""
            fzf_default_command = "{} --follow {} {} {} --color=always".format(
                fd, hidden, exclude, only_directories
            )
        else:
            hidden = (
                "-false" if self.fm.settings.show_hidden else r"-path '*/\.*' -prune"
            )
            exclude = r"\( -name '\.git' -o -name '*.py[co]' -o -fstype 'dev' -o -fstype 'proc' \) -prune"
            only_directories = "-type d" if self.quantifier else ""
            fzf_default_command = (
                "find -L . -mindepth 1 {} -o {} -o {} -print | cut -b3-".format(
                    hidden, exclude, only_directories
                )
            )

        env = os.environ.copy()
        env["FZF_DEFAULT_COMMAND"] = fzf_default_command
        env["FZF_DEFAULT_OPTS"] = (
            '--height=40% --layout=reverse --ansi --preview="{}"'.format(
                """
            (
                batcat --color=always {} ||
                bat --color=always {} ||
                cat {} ||
                tree -ahpCL 3 -I '.git' -I '*.py[co]' -I '__pycache__' {}
            ) 2>/dev/null | head -n 100
        """
            )
        )

        fzf = self.fm.execute_command(
            "fzf --no-multi", env=env, universal_newlines=True, stdout=subprocess.PIPE
        )
        stdout, _ = fzf.communicate()
        if fzf.returncode == 0:
            selected = os.path.abspath(stdout.strip())
            if os.path.isdir(selected):
                self.fm.cd(selected)
            else:
                self.fm.select_file(selected)


# Taken from:
# https://github.com/ranger/ranger/wiki/Custom-Commands#mkcd-mkdir--cd
class mkcd(Command):
    """
    :mkcd <dirname>

    Creates a directory with the name <dirname> and enters it.
    """

    def execute(self):
        import re
        from os import makedirs
        from os.path import expanduser, join, lexists

        dirname = join(self.fm.thisdir.path, expanduser(self.rest(1)))
        if not lexists(dirname):
            makedirs(dirname)

            match = re.search("^/|^~[^/]*/", dirname)
            if match:
                self.fm.cd(match.group(0))
                dirname = dirname[match.end(0) :]

            for m in re.finditer("[^/]+", dirname):
                s = m.group(0)
                if s == ".." or (
                    s.startswith(".") and not self.fm.settings["show_hidden"]
                ):
                    self.fm.cd(s)
                else:
                    ## We force ranger to load content before calling `scout`.
                    self.fm.thisdir.load_content(schedule=False)
                    self.fm.execute_console("scout -ae ^{}$".format(s))
        else:
            self.fm.notify("file/directory exists!", bad=True)
