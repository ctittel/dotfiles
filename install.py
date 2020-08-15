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

config_file_path = local / "config.txt"

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

def read_config():
    if config_file_path.exists():
        with open(config_file_path) as f:
            a = f.read()
        a.split("\n")
        return a
    else:
        print("Config file not found! Creating ", config_file_path)
        print("Enter your configuration, possible: 'vim', 'emacs', 'bash' (each on a new line)")
        config_file_path.touch()
        return None

def vim():
    uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    path = pathlib.Path(__file__).parent.absolute() / '.vim/autoload/plug.vim'
    path.parents[0].mkdir(parents=True, exist_ok=True)
    urllib.request.urlretrieve(uri,path )
    if is_windows:
        create_symlink(local / ".vim", user / "vimfiles", is_dir = True)
    elif is_linux:
        create_symlink(local / ".vim", user / ".vim", True)

def emacs():
    if is_windows:
        create_symlink(local / ".emacs.d", user / "AppData" / "Roaming" / ".emacs.d", is_dir=True)
    elif is_linux:
        create_symlink(local / ".emacs.d", user / ".emacs.d", True)

def bash():
    if is_linux:
        create_symlink(local / ".bashrc", user / ".bashrc", False)
        create_symlink(local / ".bash_profile", user / ".bash_profile", False)


def main():
    config = read_config()

    if config:
        print("local: ", local)
        print("user: ", user)

        if is_windows:
            print("Windows detected")
        elif is_linux:
            print("Linux detected")

        if "vim" in config:
            vim()
        if "emacs" in config:
            emacs()
        if "bash" in config:
            bash()

if __name__ == "__main__":
    main()
