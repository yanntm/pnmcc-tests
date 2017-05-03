#! /bin/bash

set -x
# invoke me like this :
#  ./collect_data.sh  $(\ls -1 INPUTS/ | sed 's/.tgz//')

# another variant based on existing reachability runs
# \ls -1 oracle/*SS.out | sed 's/\-SS\.out//' | sed 's/oracle\///'

for i in "$@" ; do
    OUT=oracle/$i-SS.out
    GREP="grep STATE_SPACE"
    CMD="./runmarcietest.sh $i StateSpace"
    if [ ! -f $OUT ]; then 
	echo $CMD > $OUT
	($CMD | $GREP) 2> /dev/null >> $OUT
    fi
    OUT=oracle/$i-RF.out
    GREP="grep FORMULA"
    CMD="./runmarcietest.sh $i ReachabilityFireability"
    if [ ! -f $OUT ]; then 
	echo $CMD > $OUT
	($CMD | $GREP) 2> /dev/null >> $OUT
    fi
    OUT=oracle/$i-RC.out
    CMD="./runmarcietest.sh $i ReachabilityCardinality"
    if [ ! -f $OUT ]; then 
	echo $CMD > $OUT
	($CMD | $GREP) 2> /dev/null >> $OUT
    fi
    OUT=oracle/$i-CTLF.out
    CMD="./runmarcietest.sh $i CTLFireability"
    if [ ! -f $OUT ]; then 
	echo $CMD > $OUT
	($CMD | $GREP) 2> /dev/null >> $OUT
    fi
    OUT=oracle/$i-CTLC.out
    CMD="./runmarcietest.sh $i CTLCardinality"
    if [ ! -f $OUT ]; then 
	echo $CMD > $OUT
	($CMD | $GREP) 2> /dev/null >> $OUT
    fi
    OUT=oracle/$i-UB.out
    CMD="./runmarcietest.sh $i UpperBounds"
    if [ ! -f $OUT ]; then 
	echo $CMD > $OUT
	($CMD | $GREP) 2> /dev/null >> $OUT
    fi
    OUT=oracle/$i-RD.out
    CMD="./runmarcietest.sh $i ReachabilityDeadlock"
    if [ ! -f $OUT ]; then 
	echo $CMD > $OUT
	($CMD | $GREP) 2> /dev/null >> $OUT
    fi
    OUT=oracle/$i-LTLF.out
    CMD="./runatest.sh $i LTLFireability -its"
    if [ ! -f $OUT ]; then 
	echo $CMD > $OUT
	($CMD | $GREP) 2> /dev/null >> $OUT
    fi
    OUT=oracle/$i-LTLC.out
    CMD="./runatest.sh $i LTLCardinality -its"
    if [ ! -f $OUT ]; then 
	echo $CMD > $OUT
	($CMD | $GREP) 2> /dev/null >> $OUT
    fi
done

# for i in $(ls -1 *SS* | sed 's/-SS.out//') ; do cat verdicts.csv | grep "^$i" | grep ReachabilityFireabilitySimple ; done

# grab lines with good confidence level
# for i in $(ls -1 *SS* | sed 's/-SS.out//') ; do cat verdicts.csv | grep "^$i" | grep ReachabilityFireabilitySimple | ../csv_to_control.pl ; done


# adapt PT results to COL
# for i in *RFS* ; do j=$(echo $i | sed 's/PT/COL/'` ; if [ ! -f $j ]; then k=`echo $j | sed 's/RFS/SS/') ; if [ -f $k ]; then cat $i | sed 's/PT/COL/' | sed 's/TECHNIQUES/TECHNIQUES FROM_PT/' > $j ; fi ; fi ;done ;
