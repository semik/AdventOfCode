#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use List::Util qw(sum);

sub nextDay {
  my $fish = shift;
  my %nextFish;

  # klic    - stari ryby
  # hodnota - pocet ryb
  foreach my $key (keys %{$fish}) {
    next if ($fish->{$key} == 0);

    if ($key > 0) {
      $nextFish{$key-1} += $fish->{$key};
    } else {
      print "---\n";
      $nextFish{6} += $fish->{$key};
      $nextFish{8} += $fish->{$key};
    };
  };

  return \%nextFish;
};

sub printDay {
  my $fish = shift;
  my $day = shift;

  print sum(values %{$fish})." #$day\n";
};

my @in = map { $_ =~ s/\s*$//m; $_ } split(',', <>);
my %inFish;

foreach my $f (@in) {
  $inFish{$f}++;
};

my $fish = \%inFish;
for (my $d=0; $d<=256; $d++) {
  printDay($fish, $d);
  $fish = nextDay($fish);
};
