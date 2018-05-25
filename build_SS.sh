for i in $(ls oracle/*.out | perl -pi -e s/-w+.out//g | sed s#oracle/## | sort | uniq) ; do echo $i ; done ;
