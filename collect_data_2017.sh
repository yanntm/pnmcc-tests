#! /bin/sh

# invoke me like this :
#  ./collect_data.sh  $(\ls -1 INPUTS/ | sed 's/.tgz//')

# another variant based on existing reachability runs
# \ls -1 oracle/*SS.out | sed 's/\-SS\.out//' | sed 's/oracle\///'

for i in "$@" ; do
    OUT=oracle/$i-SS.out
    GREP="grep STATE_SPACE"
    CMD="./runmarcietest.sh $i StateSpace"
    echo $CMD > $OUT
    ($CMD | $GREP) 2> /dev/null >> $OUT
    OUT=oracle/$i-RF.out
    GREP="grep FORMULA"
    CMD="./runmarcietest.sh $i ReachabilityFireability"
    echo $CMD > $OUT
    ($CMD | $GREP) 2> /dev/null >> $OUT
    OUT=oracle/$i-RC.out
    CMD="./runmarcietest.sh $i ReachabilityCardinality"
    echo $CMD > $OUT
    ($CMD | $GREP) 2> /dev/null >> $OUT
    OUT=oracle/$i-CTLF.out
    CMD="./runmarcietest.sh $i CTLFireability"
    echo $CMD > $OUT
    ($CMD | $GREP) 2> /dev/null >> $OUT
    OUT=oracle/$i-CTLC.out
    CMD="./runmarcietest.sh $i CTLCardinality"
    echo $CMD > $OUT
    ($CMD | $GREP) 2> /dev/null >> $OUT
    OUT=oracle/$i-UB.out
    CMD="./runmarcietest.sh $i UpperBounds"
    echo $CMD > $OUT
    ($CMD | $GREP) 2> /dev/null >> $OUT
    OUT=oracle/$i-RD.out
    CMD="./runmarcietest.sh $i ReachabilityDeadlock"
    echo $CMD > $OUT
    ($CMD | $GREP) 2> /dev/null >> $OUT
done

# for i in $(ls -1 *SS* | sed 's/-SS.out//') ; do cat verdicts.csv | grep "^$i" | grep ReachabilityFireabilitySimple ; done

# grab lines with good confidence level
# for i in $(ls -1 *SS* | sed 's/-SS.out//') ; do cat verdicts.csv | grep "^$i" | grep ReachabilityFireabilitySimple | ../csv_to_control.pl ; done


# adapt PT results to COL
# for i in *RFS* ; do j=$(echo $i | sed 's/PT/COL/'` ; if [ ! -f $j ]; then k=`echo $j | sed 's/RFS/SS/') ; if [ -f $k ]; then cat $i | sed 's/PT/COL/' | sed 's/TECHNIQUES/TECHNIQUES FROM_PT/' > $j ; fi ; fi ;done ;
