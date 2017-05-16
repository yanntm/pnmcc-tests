#! /bin/sh

set -e


./install_all.sh


# echo "##teamcity[testSuiteStarted name='PNMCC perfs']"

for i in oracle/*.out ; do
    n=$(echo $i | sed 's/oracle\///g' | sed 's/\.out//g' )
    ./run_test.pl $i $@ 2> logs/$n.err | tee logs/$n.out | grep test
done;

# echo "##teamcity[testSuiteFinished name='PNMCC perfs']"

