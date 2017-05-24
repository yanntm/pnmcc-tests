#! /bin/bash

set -x

export BINDIR=$(pwd)

export MODELNAME=$(echo $1 | sed 's/-\w+\.out//' | sed 's/oracle\///g')
./install_input.sh $MODELNAME

cd INPUTS
cd $1

export MODEL=$(pwd)

$BINDIR/runeclipse.sh $MODEL ${@:2}

cd ..

\rm -rf $1

cd ..
