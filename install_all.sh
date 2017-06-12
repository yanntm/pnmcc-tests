#! /bin/bash

set -x
set -e


./install_eclipse.sh

# z3 4.5 
./install_z3.sh

# ./install_inputs.sh

./install_yices.sh

./install_ltsmin.sh

