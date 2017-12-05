#! /bin/bash


echo "log,Model,Examination,Techniques,Test started,Test fail,Test fin,duration(ms),Initial,Tautology,ITS,BMC,Induction,PINS,PINSPOR"
for log in *out ;
do
    line=$(cat $log | grep syscalling)
    model=$(echo $line | cut -f 4 -d ' ')
    exam=$(echo $line | cut -f 5 -d ' ')
    tech=$(echo $line | cut -f 6- -d ' ' | sed -e 's#/[^ ]* ##g')
    tot=$(cat $log | grep testStarted | wc -l)
    fail=$(cat $log | grep testFailed | wc -l)
    fin=$(cat $log | grep testFinished | wc -l)
    dur=$(cat $log | grep testFinished | grep -e '\ball\b' | sed  's/[^0-9]//g')
    init=$(cat $log | grep TECHNIQUES | grep INITIAL_STATE | wc -l)
    taut=$(cat $log | grep TECHNIQUES | grep TAUTOLOGY | wc -l)
    sdd=$(cat $log | grep TECHNIQUES | grep DECISION_DIAGRAMS | wc -l)
    bmc=$(cat $log | grep TECHNIQUES | grep BMC | wc -l)
    kind=$(cat $log | grep TECHNIQUES | grep K_INDUCTION | wc -l)
    pins=$(cat $log | grep TECHNIQUES | grep LTSMIN | grep -v PARTIAL_ORDER | wc -l)
    por=$(cat $log | grep TECHNIQUES | grep LTSMIN | grep PARTIAL_ORDER | wc -l)
    echo "$log,$model,$exam,$tech,$tot,$fail,$fin,$dur,$init,$taut,$sdd,$bmc,$kind,$pins,$por"
done

