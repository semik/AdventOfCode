#!/usr/bin/perl

use strict;
use Data::Dumper;

my @i;

while (my $i=<>) {
  chomp($i);

  push @i, $i;
};

my $last = undef;
my $cnt = 0;

for(my $p=0; $p<=scalar(@i)-2; $p++) {
  my $sum = $i[$p]+$i[$p+1]+$i[$p+2];

  if (defined($last) and ($last < $sum)) {
    $cnt++;
  };

  $last = $sum;
};

print "$cnt\n";
