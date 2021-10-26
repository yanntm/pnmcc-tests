#! /usr/bin/perl


use strict vars;


print "log,Model,Examination,Formula ID,verdict ori,time ori,verdict red,time red\n";

my @files = <*out>;
#print "working on files : @files";
foreach my $file (@files) {
    if ( $file =~ /out$/ ) {	
	#print "looking at file : $file"
	my $model,my $exam,my $id; # strings
	my $verdictori="?", my $verdictred="?";
	my $timeori, my $timered;
	my $tot=0, my $fail=0, my $fin=0, my $dur=0, my $init=0, my $taut=0, my $sdd=0, my $bmc=0, my $kind=0, my $pins=0, my $por=0, my$itstime=0, my $itsmem=0;
	open IN, "< $file";
	my $mode = 0;
	while (my $line=<IN>) {
	    chomp $line;
	    if ($line =~ /^form=INPUTS\/([\w\-\d]+)\/(\w+)\.(\d+)\.xml/ ) {
		$model=$1;
		$exam=$2;
		$id=$3;
	    } elsif ($line =~ /^NO REDUCTION/) {
		$mode = 1;
	    } elsif ($line =~ /^REDUCTION/) {
		$mode = 2;
	    } elsif ($line =~ /^FORMULA/) {
		if ($mode == 1) {
			my @words=split(" ",$line);
			$verdictori=@words[2];
		} elsif ($mode == 2) {
			my @words=split(" ",$line);
			$verdictred=@words[2];
		} else {
		   die "Error bad mode in log file : $file \n";		
		}
	    }
	}
	close IN;
	my $fileerr=$file;
	$fileerr=~ s/out$/err/g ;
	open IN, "< $fileerr";
	my $mode = 0;
	while (my $line=<IN>) {
		# print $line;
	    chomp $line;
	    if ($line =~ /^real\t(\d+)m(.*)s/) {
		my $min=$1;
		my $sec=$2;
		my $time=60000*$1 + $2*1000;
		if ($mode==0) {
			$timeori=$time;
			$mode=1;
		} else {
			$timered=$time;
		}
	    }
	}
	close IN;
	print "$file,$model,$exam,$id,$verdictori,$timeori,$verdictred,$timered\n";
    }
}   

    

