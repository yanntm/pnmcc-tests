#! /bin/bash

#set -x

export BINDIR=$(pwd)

export MODELNAME=$(echo $1 | sed -e 's/-\w+\.out//' | sed 's/oracle\///g')

./install_input.sh $MODELNAME $$

cd INPUTS
cd "$MODELNAME$$"

# Default to 15 minute timeout.
if [[ -z "${BK_TIME_CONFINEMENT}" ]]; then
    export BK_TIME_CONFINEMENT=900    
fi

export BK_EXAMINATION=$2

time -p $BINDIR/limit_time.pl $BK_TIME_CONFINEMENT $BINDIR/BenchKit_head.sh ${@:2}

cd ..

# remove or not as you wish
\rm -rf "$MODELNAME$$"

cd ..
