#! /bin/bash

set -x
set -e

if [ ! -f oracle.tar.gz ] ;
	do
		wget --progress=dot:mega https://yanntm.github.io/pnmcc-models-2020/oracle.tar.gz
	done
fi
if [ ! -d oracle/ ] ;
	do 
		tar xzf oracle.tar.gz
	done
fi

