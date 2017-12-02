#! /bin/bash

for log in *.out ;
do
    model=$(echo $log | sed 's/.out//g');
    tot=$(cat $log | grep testStarted | wc -l)
    fail=$(cat $log | grep testFailed | wc -l)
    fin=$(cat $log | grep testFinished | wc -l)
    dur=$(cat $log | grep testFinished | grep all | sed  's/[^0-9]//g')
    echo "$model,$tot,$fail,$fin,$dur"
done

