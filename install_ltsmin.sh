#! /bin/bash

set -x

if [ ! -d lts_install_dir ] ; then 
    
    yname=ltsmin_linux_64.tar.gz
    if [ ! -f $yname ] ; then 
	wget "https://yanntm.github.io/LTSmin-BinaryBuilds/$yname"
    fi

    tar xzf $yname
    
fi

