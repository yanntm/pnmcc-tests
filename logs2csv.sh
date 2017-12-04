#! /bin/bash

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
    echo "$model,$exam,$tech,$tot,$fail,$fin,$dur"
done

