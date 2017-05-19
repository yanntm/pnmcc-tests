#! /bin/sh

DD=`date +'%Y%m%d%H%M%S'`
cd website
sed -i  index.html -e "s/DATETIME/$DD/"
cd ..
