#! /bin/bash

set -x
set -e

if [ ! -f oracle.tar.gz ] 
		wget --progress=dot:mega https://yanntm.github.io/pnmcc-models-2020/oracle.tar.gz
fi
if [ ! -d oracle/ ] 
		tar xzf oracle.tar.gz
fi

