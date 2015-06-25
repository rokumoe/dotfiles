#!/bin/bash

cd `dirname $0`
curdir=`pwd`
git submodule init
git submodule update
ln -sf $curdir/_vimrc ~/.vimrc
mkdir -p ~/.vim/colors/
ln -sf $curdir/git/molokai/colors/molokai.vim ~/.vim/colors/molokai.vim
