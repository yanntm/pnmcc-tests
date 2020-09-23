# Petri Net Model Checking Competition : Test harness

This project contains a test harness to submit a tool competing in the MCC to a regression test suite.

While it should run anywhere we have bash and perl, it is only really tested on linux since these are the contest conditions.

## Instructions

1. Install your MCC compliant tool

This means you now have a folder containing `BenchKit_head.sh`. 

In the MCC, this header script should additionally be at the hard coded location `/home/mcc/BenchKit/BenchKit_head.sh`,
 but for our purposes we only need it to run without issues regardless of the working directory it is invoked from.

2. Download and deploy this test framework 

You can download the latest release from the side bar to your right, or use the below script.
*NB:* You must unpackage these files in the same folder as `BenchKit_head.sh`.

```
wget 
tar xzf 
```

The package contains some perl and shell scripts to run the tool and compares the results to the oracles from https://github.com/yanntm/pnmcc-models-2020.

3. Install the oracle files

Running the script `./install_oracle.sh` should do the trick.

4. Run one or many tests

Running one test with default settings :
```
./run_test.pl oracle/TokenRing-PT-005-LTLC.out
```

Specify a timeout in seconds with flag `-t` immediately after the oracle file name. Default is 15 minutes or 900 seconds.
``` 
./run_test.pl oracle/TokenRing-PT-005-LTLC.out -t 100
```

Any additional flags are handed as is to the `BenchKit_head.sh` script. Some tools (e.g. ITS-Tools) support
additional non MCC compliant flags, and it can help when testing.

Run a series of tests if you have more time (here, every RF=ReachabilityFireability from MCC 2020):

```
export TEST=oracle/*-RF.out
export FLAGS="-ltsmin -its -smt"
(rc=0 ; for MODEL in $TEST ; do ./run_test.pl $MODEL -t 300 $FLAGS || rc=$? ; done; exit $rc)
```

5. Interpret the results

The command `run_test.pl` returns a zero value only if the test passed. 

The above invocation with `$rc` lets the whole line or set of tests return `0` if and only if all tests were ok. 

You also get traces in the log, prefixed by `[##teamcity ...` (for historical reasons) that indicate whether the tests failed or passed.

To ease your analysis, the `analysis/` folder contains a few scripts that can help build data points in a CSV from these logs. 

The `logs2csv.pl` script may need to be adapted a bit for each tool, but it already can parse raw output logs to produce CSV lines with e.g. number of tests passed and failed, and duration of tests.

## License

This project is made available in the hope it may prove useful, under a Gnu Public License v3.

(c) Yann Thierry-Mieg. LIP6, Sorbonne Université, CNRS.