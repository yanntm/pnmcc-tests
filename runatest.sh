#! /bin/bash

#set -x

export BINDIR=$BK_BIN_PATH

export MODELNAME=$1;
# Older oracles had more noise in them.
# $(echo $1 | sed -e 's/-\w+\.out//' | sed 's/oracle\///g')
export BK_EXAMINATION=$2

./install_input.sh $MODELNAME

cd INPUTS
cd "$MODELNAME"

# Default to 15 minute timeout.
if [[ -z "${BK_TIME_CONFINEMENT}" ]]; then
    export BK_TIME_CONFINEMENT=900    
fi


time -p $BINDIR/limit_time.pl $BK_TIME_CONFINEMENT $BINDIR/BenchKit_head.sh ${@:2}

cd ..

# remove or not as you wish
# \rm -rf "$MODELNAME"

cd ..
