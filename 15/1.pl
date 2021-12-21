#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use Term::ANSIColor;
use List::Util qw(min max sum);

sub walkMap {
  my $level = shift;
  my $map = shift;
  my $paths = shift;
  my @path = @_;

  my %mm = %{$map};
  my $pos = $path[$#path];
  my $plen = scalar(@path);
  my $p = join(',', @{$pos});

  $mm{$pos->[1]}->{$pos->[0]}->{visited} = 1;

  if (($pos->[0] == $mm{maX}) and ($pos->[1] == $mm{maY})) {
    # dosahli jsme konce mapy
    push @{$paths}, @path;
    print "$level: ($p) konec cesty len = $plen\n";
    return 0;
  };

  # zkusit jit doprava
  if (($pos->[0]+1 <= $mm{maX}) and (not exists $mm{$pos->[1]}->{$pos->[0]+1}->{visited})) {
    print "$level: ($p) doprava len = $plen\n";
    push @path, [$pos->[0]+1, $pos->[1]];
    walkMap($level+1, \%mm, $paths, @path);
  };

  # zkusit jit dolu
  if (($pos->[1]+1 <= $mm{maY}) and (not exists $mm{$pos->[1]+1}->{$pos->[0]}->{visited})) {
    print "$level: ($p) dolu len = $plen\n";
    push @path, [$pos->[0], $pos->[1]+1];
    walkMap($level+1, \%mm, $paths, @path);
  };

  # zkusit jit nahoru
  if (($pos->[1]-1 >= 0) and (not exists $mm{$pos->[1]-1}->{$pos->[0]}->{visited})) {
    print "$level: ($p) nahoru len = $plen\n";
    push @path, [$pos->[0], $pos->[1]-1];
    walkMap($level+1, \%mm, $paths, @path);
  };

  # zkusit jit doleva
  if (($pos->[0]-1 >= 0) and (not exists $mm{$pos->[1]}->{$pos->[0]-1}->{visited})) {
    print "$level: ($p) doleva len = $plen\n";
    push @path, [$pos->[0]-1, $pos->[1]];
    walkMap($level+1, \%mm, $paths, @path);
  };

  return 1;
};


my %map;

my $y = 0;
while(my $line = <>) {
  chomp($line);
  my $x = 0;
  foreach my $c (split('', $line)) {
    $map{$y}->{$x++}->{risk} = $c;
  };
  $map{maX} = $x-1;
  $y++;
};
$map{maY} = $y-1;

my @paths;

walkMap(0, \%map, \@paths, [0, 0]);

#warn Dumper(\@paths);

