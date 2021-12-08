#!/usr/bin/perl -w

use strict;
use Data::Dumper;

my $segments = {
    2 => 1,
    4 => 4,
    3 => 7,
    7 => 8,
};

my $known = 0;
while (my $line = <>) {
  chomp($line);
  $line =~ s/^.*\| //;

  my @output = split(/ /, $line);
  foreach my $output (@output) {
    if (exists $segments->{length($output)}) {
      $known++;
      print "$output\n";
    };
  };
};

print "$known\n";
