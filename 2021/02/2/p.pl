#!/usr/bin/perl -w

use strict;

my $aim = 0;
my $pos = 0;
my $depth = 0;

while (my $in = <>) {
  chomp($in);

  print "IN=$in:\t";

  if ($in =~ /^forward\s+(\d+)$/) {
      $pos += $1;
      $depth += $aim*$1;
  } elsif ($in =~ /^down\s+(\d+)$/) {
      #$depth += $1;
      $aim += $1;
  } elsif ($in =~ /^up\s+(\d+)$/) {
      #$depth -= $1;
      $aim -= $1;
  } else {
    die "Failed to parse: $in";
  };

  print "aim=$aim, pos=$pos, depth=$depth\n";
};

print "FIN: aim=$aim, pos=$pos, depth=$depth, mult=".($pos*$depth)."\n";

