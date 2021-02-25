#! /usr/bin/perl


use strict vars;
use List::Util qw[min max];

print "Family,Model,Examination,Techniques,Test started,Test fail,Test fin,duration(ms),Col |P|,Col |T|,|P|,|T|,min |P|, min |T|,No SCC,Source,Initial,c-ex length,|Inv|,Real Pos Inv,Real Gen Inv,Real SE,Nat Pos Inv,Nat Gen Inv,Nat SE,Traps,Total SMT,Random Walk,Best Walk,Prob Walk,Parikh Walk,Pre Agglo,Post Agglo,Free Agglo,Partial Post,Partial Free,Symm Choice,PoI,Free SCC,Siphons,SMT Implicit,SMT Dead,SR total,SDD,Lola,BMC,Induction,PINS,PINSPOR,Other,Solved,ITS,versio,log\n";

my $version="202102221516";

my @files = <*out>;
#print "working on files : @files";
foreach my $file (@files) {
    if ( $file =~ /out/ ) {	
	#print "looking at file : $file";
	my $model,my $exam,my $tech; # strings
	my $family;
	my $tot=0, my $fail=0, my $fin=0, my $dur=0, my $init=0, my $taut=0, my $sdd=0, my $bmc=0, my $kind=0, my $pins=0, my $por=0, my$itstime=0, my $itsmem=0;
	my $solved=0;
	my $lola = 0;
	# Initial : Colored place and t counts, PT place and tc count
	my $colp=0, my $colt=0,my $nbp=0, my $nbt=0, my $nbpr, my $nbtr;
	
	# This block can be used for MCC logs     
	if (0) {
	    my @elts = split /_/,$file;
	    $tech = @elts[0];
	    $model = @elts[1];
	    $family = (split /-/,$model) [0];
	    $exam = @elts[2];
	}
	
	
	# deadlock sufficient properties 
	my $NosccRule = 0;
	my $sourceRule = 0;
	# safety sufficient property
	my $initial=0;
	my $walk = 0;
	my $randwalk=0, my $bestwalk=0, my $probwalk=0, my $parikhwalk=0;
	my $invar = 0;
	# SMT based answers : positive invariants only, genralized invariants, state equation in Nat domain
	my $natpi=0, my $natgi=0, my $natse=0;
	# SMT based answers : positive invariants only, genralized invariants, state equation in Nat domain
	my $realpi=0, my $realgi=0, my $realse=0;
	# SMT : trap answers
	my $traps=0;

	# reductions
	# agglomeration
	my $preag=0, my $postag=0, my $fag=0;
	my $ppreag=0; # unused currently
	my $ppostag=0, my $pfag=0;
	my $sr =0;
	# symmetry
	my $symchoice =0;
	# prefix of interest
	my $prefix = 0;
	# free SCC
	my $freeSCC=0;
	# siphons
	my $siphons=0;
	# smt tests
	my $smt = 0;
	my $smtimplicit =0;
	my $smtdead =0;
	# the rest
	my $other=0;
	
	open IN, "< $file";
	while (my $line=<IN>) {
	    chomp $line;
	    # don't consume the line.
	    if ($line =~ / place count (\d+) transition count (\d+)/) {
		$nbpr = min($1,$nbpr);
		$nbtr = min($2,$nbtr);
	    }
	    if ($line =~ /Imported (\d+) HL places and (\d+) HL transitions/) {
		$colt = $1;
		$colp = $2;
		
	   
	    } elsif ($line =~ /syscalling/) {
	    # this block is better for test logs
		my @words = split / /,$line;
		$model = @words[3];
		$exam = @words[4];
		$family = (split /-/,$model) [0];
		$tech = join ' ', @words[5..$#words];
		$tech =~ s# /[^ ]*##g;  #remove ltsminpath
		$tech =~ s# /[^ ]*$##g; # even if at end of args
		$tech =~ s/^\s*// ;
		$tech =~ s/\s+/ /g ;
	    } elsif ($line =~ /Unfolded HLPN to a Petri net with (\d+) places and (\d+) transitions/) {
		$nbp = $1;
		$nbt = $2;
		$nbpr = $nbp;
		$nbtr = $nbt;
	    } elsif ($line =~ /Parsed PT model containing (\d+) places and (\d+) transitions/) {
		$nbp = $1;
		$nbt = $2;
		$nbpr = $nbp;
		$nbtr = $nbt;	    
	    } elsif ($line =~ /Finished structural reductions, in \d+ iterations. Remains : (\d+)\/\d+ places, (\d+)\/\d+ transitions/) {
		$nbpr = min($1,$nbpr);
		$nbtr = min($2,$nbtr);
	    } elsif ($line =~ /Starting structural reductions, iteration \d+ : (\d+)\/\d+ places, (\d+)\/\d+ transitions/) {
		$nbpr = min($1,$nbpr);
		$nbtr = min($2,$nbtr);
	    } elsif ($line =~ /Complete graph has no SCC; deadlocks are unavoidable/) {
		$NosccRule = 1;
	    } elsif ($line =~ /Finished Parikh directed walk after (\d+)  steps, including \d+ resets, run found a deadlock/) {
		$walk = $1;		
	    } elsif ($line =~ /Computed (\d+) place invariants/) {
		$invar = max($1,$invar);
	    } elsif ($line =~ /\[Nat\]Absence check using\s+\d+ positive place invariants in \d+ ms returned unsat/) {
		$natpi+= 1;
	    } elsif ($line =~ /\[Real\]Absence check using\s+\d+ positive place invariants in \d+ ms returned unsat/) {
		$realpi ++;
	    } elsif ($line =~ /\[Real\]Absence check using  \d+ positive and \d+ generalized place invariants in \d+ ms returned unsat/) {
		$realgi ++;
	    } elsif ($line =~ /\[Nat\]Absence check using  \d+ positive and \d+ generalized place invariants in \d+ ms returned unsat/) {
		$natgi ++;
	    } elsif ($line =~ /\[Real\]Absence check using state equation in \d+ ms returned unsat/) {
		$realse ++;
	    } elsif ($line =~ /\[Nat\]Absence check using state equation in \d+ ms returned unsat/) {
		$natse ++;
	    } elsif ($line =~ /Trap strengthening procedure managed to obtain unsat/) {
		$traps ++;
	    } elsif ($line =~ /Performed \d+ Pre agglomeration using Quasi-Persistent/) {
		$preag ++;
	    } elsif ($line =~ /Partial Post-agglomeration rule applied \d+ times/) {
		$ppostag ++;
	    } elsif ($line =~ /Performed \d+ Post agglomeration using F-continuation condition/) {
		$postag ++;
	    } elsif ($line =~ /Partial Free-agglomeration rule applied \d+ times/) {
		$pfag ++;
	    } elsif ($line =~ /Free-agglomeration rule  applied \d+ times/) {
		$fag ++;
	    } elsif ($line =~ /Removing \d+ places using SCC suffix rule/) {
		$prefix ++;		
	    } elsif ($line =~ /Free SCC test removed \d+ places/) {
		$freeSCC ++;
	    } elsif ($line =~ /Implicit Place search using SMT.*to find 0 implicit places./) {
		# skip this 0 line
	    } elsif ($line =~ /Implicit Place search using SMT.*to find \d+ implicit places./) {
		$smtimplicit ++;
	    } elsif ($line =~ /Found \d+ dead transitions using SMT./) {
		$smtdead ++;
	    } elsif ($line =~ /Deduced a syphon composed of \d+ places/) {
		$siphons ++;
	    } elsif ($line =~ /Symmetric choice reduction at/) {
		$symchoice ++;
		} elsif ($line =~ /Running Version/) {
		my @words = (split /\./,$line);
		$version = @words[$#words-1];		
	    } elsif ($line =~ /TECHNIQUES/) {
		$solved++;
		
		if ($exam=~ /ReachabilityDeadlock/ && $line =~ /FALSE TECHNIQUES TOPOLOGICAL STRUCTURAL_REDUCTION/) {
		    $sourceRule++;
		} elsif ($line =~ /RANDOM_WALK/) {
		    $randwalk++;
		} elsif ($line =~ /BESTFIRST_WALK/) {
		    $bestwalk++;
		} elsif ($line =~ /EXHAUSTIVE_WALK/ || $line =~ /PROBABILISTIC_WALK/) {
		    $probwalk++;
		} elsif ($line =~ /PARIKH_WALK/) {
		    $parikhwalk++;		    
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
		} elsif ($line =~ /INITIAL_STATE/) {
		    $initial++;
		} elsif ($line =~ /EXPLICIT/) {
		    $lola++;
		} elsif ($line =~ /STRUCTURAL_REDUCTION/ && $line=~/TOPOLOGICAL/ && $line=~/SAT_SMT/) {
		    $smt++;
		} elsif ($line =~ /TOPOLOGICAL STRUCTURAL_REDUCTION/) {
		    $sr++;
		} else {
			print STDERR "Other techniques : $line";
			$other++;
		}
	    } elsif ($line =~ /Running Version/) {
		my @words = (split /\./,$line);
		$version = @words[$#words-1];
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
	    
	    } elsif ($line =~ /^(.*,){12}(.*)$/) {
		if ($line =~ /Model ,|S| ,Time ,Mem(kb) ,fin. SDD ,fin. DDD ,peak SDD ,peak DDD ,SDD Hom ,SDD cache peak ,DDD Hom ,DDD cachepeak ,SHom cache/) {
		    next;
		}
		#print "match :$line";
		my @words = split(/,/,$line);
		$itstime = $itstime < @words[2] ? @words[2] : $itstime ;
		$itsmem = $itsmem < @words[3] ? @words[3] : $itsmem ;
	    } 
	}	
	close IN;
	print "$model,$family,$exam,$tech,$tot,$fail,$fin,$dur,$colp,$colt,$nbp,$nbt,$nbpr,$nbtr,$NosccRule,$sourceRule,$initial,$walk,$invar,$realpi,$realgi,$realse,$natpi,$natgi,$natse,$traps,$smt,$randwalk,$bestwalk,$probwalk,$parikhwalk,$preag,$postag,$fag,$ppostag,$pfag,$symchoice,$prefix,$freeSCC,$siphons,$smtimplicit,$smtdead,$sr,$sdd,$lola,$bmc,$kind,$pins,$por,$other,$solved,$version,$file\n";
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
