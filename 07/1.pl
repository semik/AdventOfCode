#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use List::Util qw(min max sum);

my @in = map { chomp($_); $_} split(',', <>);

my $min_pos = min(@in);
my $max_pos = max(@in);

print "minimum pos = $min_pos; maximum pos = $max_pos\n";
#sleep 5;

my %posFuel;

for (my $pos = $min_pos; $pos <= $max_pos; $pos++) {
  my @fuel;
  foreach my $crab (@in) {
    my $fuel = max($crab, $pos) - min($crab, $pos);
    push @fuel, $fuel;
    #print "Move from $crab to $pos: $fuel fuel\n";
  };
  my $totalFuel = sum(@fuel);

  push @{$posFuel{$totalFuel}}, $pos;
  print "Total fuel = $totalFuel to move pos = $pos -----\n";
#  sleep 1;
};

my @pf = sort {$a <=> $b} keys %posFuel;

#warn Dumper(@pf);

print "Most cheapest position = ".$posFuel{$pf[0]}->[0]." it costs = ".$pf[0]."\n";
