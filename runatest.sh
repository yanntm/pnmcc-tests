#! /bin/bash

set -x

export BINDIR=$(pwd)

export MODELNAME=$(echo $1 | sed 's/-\w+\.out//' | sed 's/oracle\///g')

echo "Running Version $(ls eclipse/plugins/fr.lip6.move.gal.application.pnmcc*)"

./install_input.sh $MODELNAME

cd INPUTS
cd $1

export MODEL=$(pwd)

time -p $BINDIR/limit_time.pl 600 $BINDIR/runeclipse.sh $MODEL ${@:2}
#killall -r 'its.*'
#killall 'z3'
#killall -r 'pins2.*'

cd ..

#\rm -rf $1

cd ..
