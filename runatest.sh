#! /bin/bash

#set -x

# configure LTSmin to use a maximum of XGB of memory, this is neccessary
# because sysconf does not work in docker
# cg_ does not work on cluster with OAR but not cg_memory set
# cannot bound LTSmin memory if in portfolio with other methods...
# Basically guessing available memory and trying to take it all is a FBI
# "Fausse Bonne Idee",
# e.g. it will never support two LTSmin running different problems in parallel.
# 4 << 30 = 4294967296  4GB
# 8 << 30 = 8589934592  8GB
# 16 << 30 = 17179869184  16GB
export LTSMIN_MEM_SIZE=8589934592

export BINDIR=$(pwd)

export MODELNAME=$(echo $1 | sed -e 's/-\w+\.out//' | sed 's/oracle\///g')

echo "Running Version $(ls eclipse/plugins/fr.lip6.move.gal.application.pnmcc*)"

./install_input.sh $MODELNAME $$

cd INPUTS
cd "$MODELNAME$$"

export MODEL=$(pwd)

time -p $BINDIR/limit_time.pl 900 $BINDIR/runeclipse.sh $MODEL ${@:2}
#killall -r 'its.*'
#killall 'z3'
#killall -r 'pins2.*'

cd ..

\rm -rf "$MODELNAME$$"

cd ..
