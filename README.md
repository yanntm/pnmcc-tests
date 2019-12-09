This project contains :
* support for download and install from command-line of ITS-tools run : ./install_all.sh
* support for invocation of its-tools from the command line for PNMCC style queries
* a large set of tests run on travis-ci : https://travis-ci.org/yanntm/ITS-Tools-pnmcc

We are building support for more command line flags.

It also contains infrastructure to test a MCC compliant linux tool, such as ITS-tools (or marcie).
* oracle files built from consensus results of past editions of the contest or collected
* run_test.pl invocator that compares oracles against invocation results

For the command line its Application, use ./runeclipse with flags :



* -pnfolder $(pwd)/INPUTS/AutoFlight-PT-01a  : (MANDATORY) Working folder containing model.pnml and examination.xml. 
NB : runatest.sh can decompress the appropriate folder, it just takes the model name as input, provided you ran install_inputs.sh.

* -examination ReachabilityCardinality : Examination name in PNMCC standard format

Depending on the examination lots of different things happen. 
-its responds to all examination, -smt only supports ReachabilityXX, -ltsmin only supports Reachability and LTL... 

MANDATORY (unless you only use -its), but already set by default, just make sure to run script ./install_yices.sh)

* -yices2path $(pwd)/yices/bin/yices  : Path to yices 
and/or
* -yices2path $(pwd)/z3/bin/z3  : Path to z3 4.3

You can also specify a path to z3 with -z3path, but behavior defaults to yices unless only -z3path and not -yices2path are defined.
Z3 install script currently broken (it downloads Z3 4.4), please manually download Z3 4.3.

Solution engines, activate as many as you wish, they run in portfolio : -its -smt -ltsminpath -onlyGal

* -its : Generates examination.gal and examination.prop/ctl/ltl, then calls ITS-tools + interprets results.

* -smt : Generate a pair of SMT solvers running BMC/KInduction for ReachabilityXXX properties.

* -ltsminpath $(pwd)/lts_install_dir 
Generate model.c/.h + compilation to gal.so + run ltsmin + interpret results
(Just run ./install_ltsmin.sh to download it from the build server)

For finer control :

* -disablePOR
Partial Order Reduction is only available with ltsmin target. 
But computing the POR matrices can be costly, so this flag disables that.
In combination with onlyGAL quickly maps pnml to .c/.h (+ gal.so if ltsminpath is set).
In combination with ltsminpath, disables computation of NES/NDS/COENABLED/DNA matrices and removes flags that activate POR from ltsmin invocations.

Mostly for debug, and for further reuse of the GAL target : 
* -onlyGal
Builds Examination.gal/Examination.prop (like -its but without running its-reach).
Builds model.c/model.h (like -ltsminpath) but does not run ltsmin.
If ltsminpath is set, also generates gal.so (we can't compile without ltsmin headers) but still does not run ltsmin.

More options are under development to leverage other existing transformations to GAL, please ask <mailto:yann.thierry-mieg@lip6.fr> if you
 need a command-line tool that processes some of the other languages we support with ITS-tools (e.g. Uppaaal xta, Tina tpn, Divine DVE, Spin promela...).
