#! /bin/sh

set -e


./install_all.sh

#echo "##teamcity[testSuiteStarted name='PNMCC SMT/Z3 perfs']"

for i in oracle/*RC.out oracle/*RF.out ; do
    ./run_test.pl $i -smt;
done;

#echo "##teamcity[testSuiteFinished name='PNMCC SMT/Z3 perfs']"


