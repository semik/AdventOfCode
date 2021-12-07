#!/usr/bin/perl -w

use strict;
use Data::Dumper;

sub printState {
  my $f = shift;
  my $d = shift || 0;

#  print "Days $d: ".join(',', @{$f})." #".scalar(@{$f})."\n";
  print "Days $d: #".scalar(@{$f})."\n";
};

my @fish = map { $_ =~ s/\s*$//m; $_ } split(',', <>);

printState(\@fish);

for (my $d=0; $d<80; $d++) {
  my $oldFishes = scalar(@fish);
  for (my $i = 0; $i < $oldFishes; $i++) {
    if ($fish[$i] > 0) {
      $fish[$i]--;
    } else {
      $fish[$i] = 6;
      push @fish, 8;
    };
  };

  printState(\@fish, $d+1);
};

# 48GB nestacilo na 256 iteraci
