#! /bin/bash

set -x

if [ ! -d lts_install_dir ] ; then 
    
    yname=ltsmin_linux_64.tar.gz
    if [ ! -f $yname ] ; then 
	wget "https://yanntm.github.io/ITS-Tools-Dependencies/$yname"
    fi

    tar xzf $yname
    
fi

