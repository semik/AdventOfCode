#!/usr/bin/perl -w

use strict;
use Data::Dumper;

sub sortOutput {
  my $a = shift;

  return join('', sort split(//, $a));
};

my $segments = {
		2 => 1,
		4 => 4,
		3 => 7,
		7 => 8,
	       };



my $known = 0;
while (my $line = <>) {
  chomp($line);
warn $line;
  my %digits;
  # identifikovat cisla ktery jsou jasny
  my @output = split(/ /, $line);
  foreach my $output (map { sortOutput($_) } @output) {
    if (exists $segments->{length($output)}) {
      $known++;
      print "$output\n";
    };
  };
  print "--\n";
};

#print "$known\n";
