import os
import platform
import pathlib
from pathlib import Path, PosixPath
import urllib.request

is_windows = (platform.system() == 'Windows')
is_linux = (platform.system() == "Linux")

local = Path(__file__).parent.absolute()
if is_windows:  
    user = Path.home()
elif is_linux:
    user = PosixPath('~')
    user = user.expanduser()

def create_symlink(src, dest, is_dir=False):
    """ Returns True if symlink is created, False if it already exists.
    src: existing file
    dest: doesnt exist yet, place where symlink is created """

    print("Creating symlink to src: ", src, " at dest: ", dest)

    if dest.exists():
        print(dest, "exists already, updating")
        os.remove(dest)
        os.symlink(src, dest, is_dir)
        return False
    else:
        os.symlink(src, dest, is_dir)
        return True

def vim_setup():
    uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    path = pathlib.Path(__file__).parent.absolute() / '.vim/autoload/plug.vim'
    path.parents[0].mkdir(parents=True, exist_ok=True)
    urllib.request.urlretrieve(uri,path )

def main():
    print("local: ", local)
    print("user: ", user)

    if is_windows:
        print("Setting up symlinks for Windows")
        create_symlink(local / ".emacs.d", user / "AppData" / "Roaming" / ".emacs.d", is_dir=True)
        create_symlink(local / ".vim", user / "vimfiles", is_dir = True)
        vim_setup()
    elif is_linux:
        print("Setting up symlinks for Linux")
        create_symlink(local / ".emacs.d", user / ".emacs.d", True)
        create_symlink(local / ".vim", user / ".vim", True)
        create_symlink(local / ".bashrc", user / ".bashrc", False)
        create_symlink(local / ".bash_profile", user / ".bash_profile", False)
        vim_setup()

if __name__ == "__main__":
    main()