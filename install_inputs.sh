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
    
    mkdir test
	cd test
	cp ../scalar.tgz .
	tar xzf scalar.tgz
	cd ../INPUTS
	for i in $(ls -1 ../test/scalar); do tar xvzf $i.tgz && cp ../test/scalar/$i/* $i/ && \rm $i.tgz && tar cvzf $i.tgz $i/ && rm -rf $i/ ; done ;
	cd ..
	\rm -rf scalar/    
fi

