#! /bin/bash

set -x

if [ ! -d INPUTS ] ; then 
    
    for i in MCC-INPUTS.tgz ;
    do 
	if [ ! -f $i ] ; then 
	    wget http://mcc.lip6.fr/archives/$i
	fi
	tar xzf $i
	rm -f $i
    done
    mv BenchKit/INPUTS .
    \rm -r BenchKit
fi

