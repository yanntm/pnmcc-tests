#! /bin/bash

set -x

if [ ! -d lts_install_dir ] ; then 
    
    yname=ltsmin_linux.tar.gz
    if [ ! -f $yname ] ; then 
	wget "https://yanntm.github.io/ITS-Tools-Dependencies/ltsmin_linux.tar.gz"
    fi

    tar xzf $yname
    
fi

