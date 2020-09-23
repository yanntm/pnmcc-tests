#! /bin/bash

set -x

if [ ! -d INPUTS ] ; then
    mkdir INPUTS
fi

cd INPUTS

if [ ! -f $1.tgz ] ; then 
    wget --progress=dot:mega https://yanntm.github.io/pnmcc-models-2020/INPUTS/$1.tgz
fi

if [ ! -d "$1$2" ] ; then
    mkdir "$1$2"
    cd "$1$2"
    tar xzf ../$1.tgz
    mv $1/* .
    \rm -r $1
    cd ..
fi

cd ..

