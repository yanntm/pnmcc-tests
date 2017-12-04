#! /bin/bash

set -e

for i in oracle/*RC.out oracle/*RF.out ;
do
      oarsub -l "{host='big6' or host='big7' or host='big8' or host='big9' or host='big10' or host='big11' or host='big12' or host='big13' or host='big14'}/nodes=1/core=2"  --notify "mail:yann.thierry-mieg@lip6.fr" "cd /home/ythierry/test/ITS-Tools-pnmcc && ./run_test.pl $i -smt"
done;

