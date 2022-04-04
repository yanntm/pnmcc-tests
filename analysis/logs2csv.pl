#! /usr/bin/perl


use strict vars;


print "log,Model,Examination,Techniques,Test started,Test fail,Test fin,duration(ms),its run(ms),its mem(kb),Initial,Tautology,ITS,BMC,Induction,PINS,PINSPOR,version\n";

my $version="201712011534";

my @files = <*out>;
#print "working on files : @files";
foreach my $file (@files) {
    if ( $file =~ /out$/ ) {	
	#print "looking at file : $file";
	my $model,my $exam,my $tech; # strings
	my $tot=0, my $fail=0, my $fin=0, my $dur=0, my $init=0, my $taut=0, my $sdd=0, my $bmc=0, my $kind=0, my $pins=0, my $por=0, my $itstime=0, my $itsmem=0;
	my $nextDDstat=0;
	open IN, "< $file";
	while (my $line=<IN>) {
	    chomp $line;
	    if ($line =~ /syscalling/) {
		my @words = split / /,$line;
		$model = @words[3];
		$exam = @words[4];
		$tech = join ' ', @words[5..$#words];
		$tech =~ s# /[^ ]*##g;  #remove ltsminpath
		$tech =~ s# /[^ ]*$##g; # even if at end of args
		$tech =~ s/^\s*// ;
		$tech =~ s/\s+/ /g ;
		next;
	    } elsif ($line =~ /testStarted/) {
		$tot++;
	    } elsif ($line =~ /testFailed/) {
		$fail++;
	    } elsif ($line =~ /testFinished/) {
		$fin++;
		if ($line =~ /\ball\b/) {
		    $dur = $line;
		    $dur =~ s/\D//g;
		}
	    } elsif ($line =~ /TECHNIQUES/) {
		if ($line =~ /INITIAL_STATE/) {
		    $init++;
		} elsif ($line =~ /TAUTOLOGY/) {
		    $taut++;
		} elsif ($line =~ /DECISION_DIAGRAMS/) {
		    $sdd++;
		} elsif ($line =~ /BMC/) {
		    $bmc++;
		} elsif ($line =~ /K_INDUCTION/) {
		    $kind++;
		} elsif ($line =~ /LTSMIN/ && $line !~ /PARTIAL_ORDER/) {
		    $pins++;
		} elsif ($line =~ /LTSMIN/ && $line =~ /PARTIAL_ORDER/) {
		    $por++;
		}	
	    } elsif ($line =~ /Running Version/) {
                my @words = (split /\s/,$line);
                $version = @words[$#words];
	    } elsif ($line =~ /^Model.*SHom cache$/g) {
		# print "with $nextDDstat , match pre stat  :$line";
		$nextDDstat=1;
		next;
	    } elsif ($nextDDstat==1) {
		# print "with $nextDDstat , match :$line";
		$nextDDstat=0;
		my @words = split(/,/,$line);
		$itstime = $itstime < @words[2] ? @words[2] : $itstime ;
		$itsmem = $itsmem < @words[3] ? @words[3] : $itsmem ;
	    } 
	}	
	close IN;
	print "$file,$model,$exam,$tech,$tot,$fail,$fin,$dur,$itstime,$itsmem,$init,$taut,$sdd,$bmc,$kind,$pins,$por,$version\n";
    }
}   

    

#      
#echo "log,Model,Examination,Techniques,Test started,Test fail,Test fin,duration(ms),Initial,Tautology,ITS,BMC,Induction,PINS,PINSPOR"
#for log in *out ;
#do
#    line=$(cat $log | grep syscalling)
#    model=$(echo $line | cut -f 4 -d ' ')
#    exam=$(echo $line | cut -f 5 -d ' ')
#    tech=$(echo $line | cut -f 6- -d ' ' | sed -e 's# /[^ ]*##g' | sed -e 's# /[^ ]*$##g' )
#    tot=$(cat $log | grep testStarted | wc -l)
#    fail=$(cat $log | grep testFailed | wc -l)
#    fin=$(cat $log | grep testFinished | wc -l)
#    dur=$(cat $log | grep testFinished | grep -e '\ball\b' | sed  's/[^0-9]//g')
#    init=$(cat $log | grep TECHNIQUES | grep INITIAL_STATE | wc -l)
#    taut=$(cat $log | grep TECHNIQUES | grep TAUTOLOGY | wc -l)
#    sdd=$(cat $log | grep TECHNIQUES | grep DECISION_DIAGRAMS | wc -l)
#    bmc=$(cat $log | grep TECHNIQUES | grep BMC | wc -l)
#    kind=$(cat $log | grep TECHNIQUES | grep K_INDUCTION | wc -l)
#    pins=$(cat $log | grep TECHNIQUES | grep LTSMIN | grep -v PARTIAL_ORDER | wc -l)
#    por=$(cat $log | grep TECHNIQUES | grep LTSMIN | grep PARTIAL_ORDER | wc -l)
#    echo "$log,$model,$exam,$tech,$tot,$fail,$fin,$dur,$init,$taut,$sdd,$bmc,$kind,$pins,$por"
#done
#
#
