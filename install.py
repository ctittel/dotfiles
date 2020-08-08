import os
import platform
from pathlib import Path, PosixPath
from vimfiles.setup import vim_setup

is_windows = (platform.system() == 'Windows')
is_linux = (platform.system() == "Linux")

def create_symlink(src, dest, is_dir=False):
    """ Returns True if symlink is created, False if it already exists.
    src: existing file
    dest: doesnt exist yet, place where symlink is created """

    print("Creating symlink with src: ", src, " dest: ", dest)

    if dest.exists():
        print(dest, "exists already, updating")
        os.remove(dest)
        os.symlink(src, dest, is_dir)
        return False
    else:
        os.symlink(src, dest, is_dir)
        return True

local = Path(__file__).parent.absolute()
if is_windows:  
    user = Path.home()
elif is_linux:
    user = PosixPath('~')
    user = user.expanduser()

print("local: ", local)
print("user: ", user)

if is_windows:
    print("Setting up symlinks for Windows")
    create_symlink(local / ".emacs.d", user / "AppData" / "Roaming" / ".emacs.d", is_dir=True)
    create_symlink(local / "vimfiles", user / "vimfiles", is_dir = True)
    vim_setup()
elif is_linux:
    print("Setting up symlinks for Linux")
    create_symlink(local / ".emacs.d", user / ".emacs.d", True)
    create_symlink(local / "vimfiles", user / ".vim", True)
    vim_setup()
