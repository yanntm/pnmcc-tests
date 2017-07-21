#! /bin/bash

set -x
set -e


# distrib is : z3-4.4.0.b6c40c6c0eaf-x64-ubuntu-14.04.zip
if [ ! -f z3.zip ] ; then
	# Following code was for CodePlex based distributions, but CodePlex is going down.
	 
    # grab the variable url from codeplex
    # The query url is stable : http://z3.codeplex.com/downloads/get/1441362
    # gives a big html garbage page with js inside to hide the url
    # from there we grab a url to a png, that is given in plain form, | grep Build | cut -f 4 -d '"'
    ## e.g : http://download-codeplex.sec.s-msft.com/Download?ProjectName=z3&DownloadId=491381&Build=21018
    
    # finally, we replace the artifactid with target id  for linux x64 (1441362 is our target)
    # and add a magic number filetime
    # and add "/Release" to url
#    export DLURL=$(curl 'http://z3.codeplex.com/downloads/get/1441362' | grep Build | cut -f 4 -d '"' | sed 's/491381/1441362\&FileTime=130718577284870000/' | sed 's/Download/Download\/Release/' )
#    curl $DLURL > z3.zip


	# using z3 4.5, available on GitHub
	export DLURL=https://github.com/Z3Prover/z3/releases/download/z3-4.5.0/z3-4.5.0-x64-ubuntu-14.04.zip
	wget --progress=dot:mega $DLURL
	mv z3-4.5.0-x64-ubuntu-14.04.zip z3.zip
fi

if [ ! -d z3 ] ; then 
    unzip z3.zip
    mv z3*/ z3/ 
fi

