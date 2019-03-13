#! /bin/perl


while (my $line = <STDIN>) {
    # print $line;
    chomp $line;
  my @fields = split /,/, $line;
  my $abbrev = "ReachabilityDeadlock";
  my $prefix = @fields[0]."-".$abbrev;
  my $verdict = @fields[1];

  $abbrev =~ s/[a-z]//g;
  my $outff = @fields[0]."-".$abbrev.".out";

  if (-f $outff) {
      print "Not overwriting existing oracle file $outff\n";
  } else {
      print "doing $prefix, in file $outff has 1 entries \n";  
      open OUT, "> $outff";
      print OUT "./runatest.sh ".@fields[0]." ReachabilityDeadlock \n";
      my $res = $verdict;   
      $res =~ s/F/FALSE/g;
      $res =~ s/T/TRUE/g;
      print OUT "FORMULA ".$prefix."-0 ".$res." TECHNIQUES ORACLE2017\n";
      close OUT;
  }
}

# for COL formula names in PT models, it might be necassary to run this in sh.
# for j in `(for i in *COL*.out ; do echo $i | sed 's/-.*\.out//'  ; done) | uniq ` ; do for k in $j*PT*.out ; do cat $k | sed -re 's/(FORMULA.*)PT(.*)/\1COL\2/g' > $k.bak ; \mv $k.bak $k  ; done ; done 
