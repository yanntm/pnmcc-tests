#! /bin/bash

set -x
set -e


./install_eclipse.sh

# z3 4.5 
./install_z3.sh

# ./install_inputs.sh

# yices page down Jun 18 : don't break builds we use z3
# ./install_yices.sh

./install_ltsmin.sh

