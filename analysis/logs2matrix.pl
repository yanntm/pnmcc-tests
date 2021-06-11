#! /usr/bin/perl


use strict vars;

my %results = {};
my $max = 0;

while (my $line=<STDIN>) {
	if ($line =~ /^FORMULA/) {
		my @words = split / /,$line;
		my $key = @words[1];
		$key =~ s/^.// ;
		$key = int($key); 
		my $res = @words[2]=~/TRUE/ ? 0 : 1;
		$results{$key} = $res;
	} elsif ($line =~ /Parsed (\d+) properties/) {
		$max = $1;
	}
}

for (my $i=0 ; $i < $max ; $i++) {
	my $res = $results{$i};
	if (defined $res) {
		print $res;
	} else {
		print '.';
	}
}
print "\n";

#foreach my $key (sort keys %results) {
#  print "$key $results{$key}\n";
#}
