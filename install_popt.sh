#! /bin/bash

IDIR=$(pwd)/lts_install_dir && wget --progress=dot:mega http://rpm5.org/files/popt/popt-1.16.tar.gz && tar xzf popt-1.16.tar.gz && cd popt-1.16 && ./configure --prefix=$IDIR && make && make install && cd - && \rm  popt-1.16.tar.gz

