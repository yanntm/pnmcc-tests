#! /bin/bash

#set -x

export BINDIR=$BK_BIN_PATH/../

export MODELNAME=$1;
# Older oracles had more noise in them.
# $(echo $1 | sed -e 's/-\w+\.out//' | sed 's/oracle\///g')
export BK_EXAMINATION=$2

./install_input.sh $MODELNAME

cd INPUTS
cd "$MODELNAME"

# this variable is not explicitly defined in MCC rules, but is convenient
# and it is in fact defined by the organizer scripts
export BK_INPUT=$PWD

# Default to 15 minute timeout.
if [[ -z "${BK_TIME_CONFINEMENT}" ]]; then
    export BK_TIME_CONFINEMENT=900    
fi

# Default to 16GB memory limit
if [[ -z "${BK_MEMORY_CONFINEMENT}" ]]; then
    export BK_MEMORY_CONFINEMENT=16384  
fi

# The tool name
if [[ -z "${BK_TOOL}" ]]; then
	export BK_TOOL="testTool"
fi

time -p $BINDIR/limit_time.pl $BK_TIME_CONFINEMENT $BINDIR/BenchKit_head.sh ${@:2}

cd ..

# remove or not as you wish
# \rm -rf "$MODELNAME"

cd ..
