#!/bin/sh

CURR=$(cd "$(dirname "$0")"; pwd)

# intall xcode command line tools
xcode-select --print-path
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
    echo " * Setting up Developer Tools CLI..."
    xcode-select --install
fi

if [ ! -f /usr/local/bin/brew ]; then
  echo "Installing: brew ..."
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
else
  echo "Found: brew"
fi

brew install ctags
brew install cmake
brew install macvim --with-lua

if [ ! -e ~/.vim/temp_dirs/undodir ]; then
    # make vim temp dir
    mkdir -p ~/.vim/temp_dirs/undodir
fi

# link vimrc
rm -rf ~/.vimrc
ln -s ${CURR}/config/vimrc ~/.vimrc

# install vundle
if [ ! -e ~/.vim/bundle/Vundle.vim ]; then
    echo "Installing: vim/vundle ..."
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

# install vundle
echo "Installing bundles ..."
mvim +PluginInstall +qall

# install tern's deps
echo "Installing tern deps ..."
cd ~/.vim/bundle/tern_for_vim/
npm i

cd ~/.vim/bundle/YouCompleteMe
./install.sh

cd ${CURR}
exit 
