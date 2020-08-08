import os
import platform
from pathlib import Path
from vimfiles.setup import vim_setup

is_windows = (platform.system() == 'Windows')
is_linux = (platform.system() == "Linux")

def create_symlink(src, dest, is_dir=False, newname=None):
    """ Returns True if symlink is created, False if it already exists """

    if not newname:
        newname = src.name
    dest = dest / newname

    if dest.exists():
        print(dest, "exists already")
        return False
    else:
        os.symlink(src, dest, is_dir)
        return True
    

local = Path(__file__).parent.absolute()
user = Path.home()

if is_windows:
    print("Setting up symlinks for Windows")
    create_symlink(local / ".emacs.d", user / "AppData" / "Roaming", is_dir=True)
    if create_symlink(local / "vimfiles", user, is_dir = True):
        print("Run installation script for vim")
        vim_setup()
elif is_linux:
    print("Setting up symlinks for Linux")
    os.symlink(local / ".emacs.d", user, True)
    if os.symlink(local / "vimfiles", user, True, newname='.vim'):
        print("Run installation script for vim")
        vim_setup()
