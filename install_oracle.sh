#! /bin/bash

set -x
set -e

if [ ! -f oracle.tar.gz ] ; then 
	wget --progress=dot:mega https://yanntm.github.io/pnmcc-models-2020/oracle.tar.gz 
fi

if [ ! -d oracle/ ] ; then 
	tar xzf oracle.tar.gz 
fi

if [ ! -f poracle.tar.gz ] ; then 
	wget --progress=dot:mega https://yanntm.github.io/pnmcc-models-2020/poracle.tar.gz 
fi

if [ ! -d poracle/ ] ; then 
	tar xzf poracle.tar.gz 
fi

