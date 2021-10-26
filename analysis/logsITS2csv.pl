#! /usr/bin/perl


use strict vars;


print "log,Model,Examination,Formula ID,is reduced,verdict,time (real),time ITS\n";

my @files = <*out>;
#print "working on files : @files";
foreach my $file (@files) {
    if ( $file =~ /out$/ ) {	
	#print "looking at file : $file"
	my $model,my $exam,my $id; # strings
	my $verdict="?";
	my $isred=-1;
	my $time;
	my $itstime=-1;
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
		$isred=0;
	    } elsif ($line =~ /^REDUCTION/) {
		$mode = 2;
		$isred=1;
	    } elsif ($line =~ /^FORMULA/) {
		my @words=split(" ",$line);
		$verdict=@words[2];
	    } elsif ($line =~ /^Treatment of .* in (\d+) ms/) {
		$itstime = $1;
	    }
	}
	close IN;
	my $fileerr=$file;
	$fileerr=~ s/out$/err/g ;
	open IN, "< $fileerr";
	while (my $line=<IN>) {
		# print $line;
	    chomp $line;
	    if ($line =~ /^real\t(\d+)m(.*)s/) {
		my $min=$1;
		my $sec=$2;
		$time=60000*$1 + $2*1000;
		}
	}
	close IN;
	print "$file,$model,$exam,$id,$isred,$verdict,$time,$itstime\n";
    }
}   

    

