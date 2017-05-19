#! /bin/bash

set -x

export BINDIR=$(pwd)

./install_input.sh $1

cd INPUTS
cd $1

export MODEL=$(pwd)

$BINDIR/runeclipse.sh $MODEL ${@:2}

cd ..

\rm -rf $1

cd ..
