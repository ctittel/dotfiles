import urllib.request
import pathlib

def vim_setup():
    uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    path = pathlib.Path(__file__).parent.absolute() / './autoload/plug.vim'
    path.parents[0].mkdir(parents=True, exist_ok=True)
    urllib.request.urlretrieve(uri,path )

if __name__ == "__main__":
    vim_setup()