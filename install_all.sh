#! /bin/bash

set -x
set -e


./install_eclipse.sh

# no z3 needed (and build broken on 4.4, need 4.3 or update to jSMTlib)
# ./install_z3.sh

./install_inputs.sh

./install_yices.sh

./install_ltsmin.sh

