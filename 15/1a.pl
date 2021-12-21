#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use Term::ANSIColor;
use List::Util qw(min max sum);

my @best_path; # 1132 je zatim nejmin co jsme nasli
my $best_risk = 1100;

my $cnt = 0;

sub visited {
  my $path = shift;
  my $x = shift;
  my $y = shift;

  return unless $path;

  foreach my $point (@{$path}) {
    return 1 if (($x == $point->[0]) and ($y == $point->[1]));
  };

  return 0;
};

sub printMap {
  my $map = shift;
  my $path = shift;

  for(my $y=0; $y <= $map->{maY}; $y++) {
    for(my $x=0; $x <= $map->{maX}; $x++) {
      print color('red') if (visited($path, $x, $y));
      print $map->{$y}->{$x}.color('reset');
    };
    print "\n";
  };
};

sub walkMap {
  my $level = shift;
  my $map = shift;
  my $risk = shift;
  my @path = @_;

  my $p = $path[$#path]; # posledni bod cesty
  my $plen = scalar(@path);

  #  print "level=$level  IN($plen):\n";

  if (($cnt % 50000 == 0) and ($cnt > 0)) {
    print "iterace=$cnt; nejmensi riziko=$best_risk\n";
    printMap($map, \@path);
  };
  $cnt++;

  if ((defined $best_risk) and ($risk >= $best_risk)) {
    #print "prilis riskantni risk=$risk best_risk=$best_risk\n";
    return;
  };

  if (($p->[0] == $map->{maX}) and ($p->[1] == $map->{maY})) {
    # pravy dolni roh - nas cil!
    print "risk=$risk\n";
    printMap($map, \@path);

    if ((not defined($best_risk)) or ($risk < $best_risk)) {
      @best_path = @path;
      $best_risk = $risk;
    };

    #sleep 1;
    return 0;
  };

  my ($x, $y);
  # zkusit jit doprava
  $x = $p->[0]+1;
  $y = $p->[1];
  if (($x <= $map->{maX}) and not visited(\@path, $x, $y)) {
    #print "doprava ($plen)\n";
    walkMap($level+1, $map, $risk+$map->{$y}->{$x}, @path, [$x, $y]);
  };

  # zkusit jit dolu
  $x = $p->[0];
  $y = $p->[1]+1;
  if (($y <= $map->{maY}) and not visited(\@path, $x, $y)) {
    #print "dolu ($plen)\n";
    walkMap($level+1, $map, $risk+$map->{$y}->{$x}, @path, [$x, $y]);
  };

  # zkusit jit doleva
  $x = $p->[0]-1;
  $y = $p->[1];
  if (($x >= 0) and not visited(\@path, $x, $y)) {
    #print "doleva ($plen)\n";
    walkMap($level+1, $map, $risk+$map->{$y}->{$x}, @path, [$x, $y]);
  };

  # zkusit jit nahoru
  $x = $p->[0];
  $y = $p->[1]-1;
  if(($y >= 0) and not visited(\@path, $x, $y)) {
    #print "nahoru ($plen)\n";
    walkMap($level+1, $map, $risk+$map->{$y}->{$x}, @path, [$x, $y]);
  };

  #print "slepa ($plen)\n";
};

my %map;

my $y = 0;
while(my $line = <>) {
  chomp($line);
  my $x = 0;
  foreach my $c (split('', $line)) {
    $map{$y}->{$x++} = $c;
  };
  $map{maX} = $x-1;
  $y++;
};
$map{maY} = $y-1;

walkMap(0, \%map, 0, ([0, 0]));

#printMap(\%map, [[0,0]]);
