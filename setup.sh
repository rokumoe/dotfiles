#!/bin/bash

cd `dirname $0`
curdir=`pwd`
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -sf $curdir/_vimrc ~/.vimrc
vim +PlugInstall +qall
