for i in $(ls oracle/*.out | perl -pi -e 's/\-\w+.out//g' | sort | uniq) ; do
    OUT="$i-SS.out"
    GREP="grep STATE_SPACE"
    CMD="./runatest.sh $i StateSpace -its"
    if [ ! -f $OUT ]; then
	echo "need to build this : $OUT"
	echo $CMD > $OUT
	oarsub -l  "{host='big6' or host='big7' or host='big8' or host='big9' or host='big10' or host='big11' or host='big12' or host='big13' or host='big14'}/nodes=1/core=1,walltime=0:30:0" "($CMD | $GREP) 2> /dev/null >> $OUT"
    fi
done ;
