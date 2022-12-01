#!/usr/bin/perl -w

use strict;

my $pos = 0;
my $depth = 0;

while (my $in = <>) {
  chomp($in);

  if ($in =~ /^forward\s+(\d+)$/) {
    $pos += $1;
  } elsif ($in =~ /^down\s+(\d+)$/) {
    $depth += $1;
  } elsif ($in =~ /^up\s+(\d+)$/) {
    $depth -= $1;
  } else {
    die "Failed to parse: $in";
  };
};

print "pos=$pos, depth=$depth, mult=".($pos*$depth)."\n";
