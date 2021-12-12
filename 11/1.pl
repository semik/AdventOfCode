#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use Term::ANSIColor;
use List::Util qw(min max sum);

sub addOne {
  my $map = shift;

  foreach my $y (keys %{$map}) {
    foreach my $x (keys %{$map}) {
      $map->{$y}->{$x}->{value}++;
    };
  };
};

sub flashOne {
  my ($map, $x, $y, $maX, $maY) = @_;

  my $o = $map->{$y}->{$x}->{value};
  if (($o > 9) and (not exists $map->{$y}->{$x}->{flashed})) {
    $map->{$y}->{$x}->{flashed} = 1;

    # radek nad aktualni Y pozici
    if ($y>0) {
      if ($x>0) {
	$map->{$y-1}->{$x-1}->{value}++;
      };
      $map->{$y-1}->{$x}->{value}++;
      if ($x<$maX) {
	$map->{$y-1}->{$x+1}->{value}++;
      };
    };
    # aktualni Y pozice
    if ($x>0) {
      $map->{$y}->{$x-1}->{value}++;
    };
    $map->{$y}->{$x}->{value}++;
    if ($x<$maX) {
      $map->{$y}->{$x+1}->{value}++;
    };
    # radek pod aktualni Y pozici
    if ($y<$maY) {
      if ($x>0) {
	$map->{$y+1}->{$x-1}->{value}++;
      };
      $map->{$y+1}->{$x}->{value}++;
      if ($x<$maX) {
	$map->{$y+1}->{$x+1}->{value}++;
      };
    };
    # zableskla aktualni chobnotnice, tahle fce nemuze vracet vic jak 1
    return 1;
  } else {
    return 0;
  };

  die "Sem se nesmime nikdy dostat";
};

sub flashMap {
  my $map = shift;

  my $miY = min(keys %{$map});
  my $maY = max(keys %{$map});
  my $miX = min(keys %{$map->{0}});
  my $maX = max(keys %{$map->{0}});

  my $flashes = 0;

  my $repeat;
  do {
    $repeat = 0;

    for (my $y=$miY; $y<=$maY; $y++) {
      for (my $x=$miX; $x<=$maX; $x++) {
	my $f = flashOne($map, $x, $y, $maX, $maY);
	$flashes += $f;
	$repeat = 1 if ($f);
      };
    };
  } while ($repeat > 0);

  return $flashes;
};

sub cleanMap {
  my $map = shift;

  my $miY = min(keys %{$map});
  my $maY = max(keys %{$map});
  my $miX = min(keys %{$map->{0}});
  my $maX = max(keys %{$map->{0}});

  for (my $y=$miY; $y<=$maY; $y++) {
    for (my $x=$miX; $x<=$maX; $x++) {
      if ($map->{$y}->{$x}->{value} > 9) {
	$map->{$y}->{$x}->{value} = 0;
	delete $map->{$y}->{$x}->{flashed};
      };
    };
  };
};


my @N=(0..9,'A'..'Z');
sub printMap {
  my $map = shift;

  for (my $y=min(keys %{$map}); $y<=max(keys %{$map}); $y++)  {
    for (my $x=min(keys %{$map->{$y}}); $x<=max(keys %{$map->{$y}}); $x++)  {
      my $o = $map->{$y}->{$x}->{value};
      print color('red') if ($o > 9);
      print color('green') if ($o == 0);
      print $N[$o];
      print color('reset');
    };
    print "\n";
  };
};

my $map;

my $y=0;
while (my $line=<>) {
  chomp($line);

  my $x=0;
  foreach my $o (split(//, $line)) {
    $map->{$y}->{$x++}->{value} = $o;
  };
  $y++;
};

my $flashes = 0;
for (my $step=1; $step<=1000; $step++) {
  addOne($map);
  my $f = flashMap($map);
  $flashes += $f;
  cleanMap($map);
  printMap($map);

  print "\t\tstep=$step; flashes = $f; total flashes=$flashes\n\n";

  exit(0) if ($f == 100);
};

