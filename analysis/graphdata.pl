#!/usr/bin/perl -w
use Getopt::Std;
use strict;


if ($#ARGV < 3)
{
    print STDERR "syntax: graphdata.pl [-v] meth1 meth2 column files...\n";
    print STDERR "\n  -v distinguish verdicts instead of models";
    exit(2);
}

my $opt_v = 0;
if ($ARGV[0] eq '-v')
{
    $opt_v = 1;
    shift @ARGV;
}

my %verdict = ( 0 => "empty", 1 => "non-empty", 2 => "unknown" );

my $opt_x = shift @ARGV;
my $opt_y = shift @ARGV;
my $opt_c = (shift @ARGV);


my $max = 0;

my $count = 0;
my $fail = 0;

my $head = <>;
my @head = split(',', $head);
shift @head;
shift @head;
shift @head;
shift @head;

my %result;

while (my $line=<>)
{
    next if ($line =~ /^\w*$/) or ($line eq $head);

    chomp $line;

#    print "read line :".$line."\n"; 

    my @res = split(',',$line);
    my $log = @res[-1];
    my $model = @res[0];
    my $formula = @res[2];
    # my $meth = shift @res;
    if (defined $res[$opt_c] && $res[$opt_c] !~ /^\s*$/) {
	if ($res[$opt_c] > $max) {
	    $max = $res[$opt_c];
	}
    } else {
      $res[$opt_c] = -1;
    }

    my $key="$model,$formula";
    my $meth = "other";
    if ($line =~ /$opt_x/) {
    	$meth = $opt_x;
    } elsif ($line =~ /$opt_y/ ) {
    	$meth = $opt_y;
    }
	$result{$key}{$meth} = [@res];
    

#    print "Obtained : key=$key ; meth=$meth ; val=@res"


#    if (defined  $result{$key}{$meth}) {
#	my $t1 = $result{$key}{$meth};
#	my $version = $t1->[11]; # version column = 11
#	if ($version < $res[11]) {
#	   # print STDERR "supersede results from $version with newer @res[11] \n";
#	    $result{$key}{$meth} = [@res];
#	} else {
#	   # print STDERR "supersede existing result is more recent ($version versus $res[11]) \n";
#	}
#    } else {
#	#    print "read : model=$model, form=$formula, meth=$meth, res=@res\n";
#	$result{$key}{$meth} = [@res];
#    }
}

my $awin0=0;
my $bwin0=0;
my $awin1=0;
my $bwin1=0;
my $awin2=0;
my $bwin2=0;
my $nbvalues =0;
my $faila=0;
my $failb=0;
my $failureanotb=0;
my $failurebnota=0;
my $fullfail=0;
my $timea =0;
my $timeb =0;


foreach my $key (keys %result)
{
    if (defined $result{$key}{$opt_x}
	and defined $result{$key}{$opt_y})
    {	
	my $t1 = $result{$key}{$opt_x};
	my $val1 = $t1->[$opt_c];
	# || (2 <= int($t1->[1]))
	if ((! defined $val1) || $val1 =~ /^\s*$/ || $val1 == -1 ) {
	    $val1 = 3* $max;
	    $faila=1;
	}
	my $t2 = $result{$key}{$opt_y};
	my $val2 = $t2->[$opt_c];
	# || (2 <= int($t2->[1]))
	if ((! defined $val2) || $val1 =~ /^\s*$/ || $val2 == -1 ) {
	    $val2 = 3* $max;
	    $failb=1;
	}
	my $model;

	if ($opt_v)
	{
	    my $v1 = int $t1->[1]; # failed tests by a
	    if ($v1 > 18) { $v1= 18; }
	    my $v2 = int $t2->[1]; # failed tests by b
	    if ($v2 > 18) { $v2= 18; }
	    if ($v1 == 0 && $v2 == 0) {
		$model = "success";
	    } else {
		my $delta = (int $t2->[2] - int $t1->[2]);
		my $sign;
		if ($delta > 0) {
		    $delta = int ( $delta / 6 );		
		    $model = "DeltaDone".($delta*6)."to".(($delta+1)*6);
		} else {
		    $delta = int ( $delta / 6 );		
		    $model = "DeltaDone".($delta*6)."to".(($delta-1)*6);
		}
		if ($delta != 0) {
		    print STDERR "Delta $delta for : $opt_x :$val1 vs $opt_y :$val2 FOR  $key \n";
		}
	    }
	}
	else
	{
	    ($model = $key) =~ s,.*?/?([^/]*).net.*,$1,;
	    $model =~ s/\dnm/-nm/;
	    $model =~ s/\d+//;
	    $model =~ s/,.*//;
	}
	print "$model $val1 $val2\n";
	$nbvalues++;

	if ($faila && ! $failb) {
	  $failureanotb++;
	} elsif (!$faila && $failb) {
	  $failurebnota++;
	} elsif ($faila && $failb) {
	  $fullfail++;
	} elsif ($val1 > 100 * $val2) {
	  $awin2++;
	  $awin1++;
	  $awin0++;
	  print STDERR "Over 2 orders of magnitude : $opt_x :$val1 > $opt_y :$val2 FOR  $key\n";
	} elsif ( $val2 > 100 * $val1) {
	  $bwin2++;
	  $bwin1++;
	  $bwin0++;
	  print STDERR "Over 2 orders of magnitude : $opt_y :$val2 > $opt_x :$val1  FOR  $key\n";
	} elsif  ($val1 > 10 * $val2) {
	    print STDERR "Over 1 orders of magnitude : $opt_x :$val1 > $opt_y :$val2 FOR  $key\n";
	  $awin1++;$awin0++;
	} elsif  ($val2 > 10 * $val1) {
	    print STDERR "Over 1 orders of magnitude :  $opt_y :$val2 > $opt_x :$val1 FOR  $key\n";	  $bwin1++;$bwin0++;
	} elsif  ($val1 > 2 * $val2) {
	  $awin0++;
	} elsif  ($val2 > 2 * $val1) {
	  $bwin0++;
	}
	$faila=0;
	$failb=0;
    }
}

my $col = @head[$opt_c];

print STDERR "In total for $nbvalues experiments (- $fullfail failures), significant differences on column $col:\n";
print STDERR "$opt_x failed for $failureanotb, $opt_y failed for $failurebnota when the other reached verdict.:\n";
if ($awin2 > 0) {
  print STDERR "$opt_x > 100*$opt_y in $awin2 (*10 in $awin1, *2 in $awin0) cases\n";
} elsif ($awin1 > 0) {
  print STDERR "$opt_x > 10*$opt_y in $awin1 (*2 in $awin0) cases\n";
} elsif ($awin0 > 0) {
  print STDERR "$opt_x > 2*$opt_y in $awin0 cases\n";
}

if ($bwin2 > 0) {
  print STDERR "$opt_y > 100*$opt_x in $bwin2 (*10 in $bwin1, *2 in $bwin0) cases\n";
} elsif ($bwin1 > 0) {
  print STDERR "$opt_y > 10*$opt_x in $bwin1 (*2 in $bwin0) cases\n";
}  elsif ($bwin0 > 0) {
  print STDERR "$opt_y > 2*$opt_x in $bwin0 cases\n";
}


