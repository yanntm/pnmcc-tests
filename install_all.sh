#! /bin/bash

set -x
set -e


./install_eclipse.sh

./install_greatspn.sh


# z3 4.5 
./install_z3.sh

# ./install_inputs.sh
wget --progress=dot:mega https://yanntm.github.io/pnmcc-models-2019/oracle.tar.gz
tar xzf oracle.tar.gz

# yices page down Jun 18 : don't break builds we use z3
# ./install_yices.sh

./install_ltsmin.sh

