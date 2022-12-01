#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use Term::ANSIColor;

sub isLowest {
  my $h = shift;
  my $hm = shift;
  my $x = shift;
  my $y = shift;
  my $maX = shift;
  my $maY = shift;

  # vlevo
  if (($x>=1) and ($h >= $hm->{$x-1}->{$y})) {
    return 0;
  };

  # vpravo
  if (($x<$maX) and ($h >= $hm->{$x+1}->{$y})) {
    return 0;
  };

  # nahore
  if (($y>=1) and ($h >= $hm->{$x}->{$y-1})) {
    return 0;
  };

  # dole
  if (($y<$maY) and ($h >= $hm->{$x}->{$y+1})) {
    return 0;
  };

  return 1;
};

sub flood {
  my ($hm, $low, $x, $y, $maX, $maY, $lowest) = @_;

  my $flood = 0;

  # vlevo
  if (($x>=1) and ($hm->{$x-1}->{$y} < 9) and (not exists $low->{$x-1}->{$y})) {
    $low->{$x-1}->{$y} = $lowest;
    $low->{$lowest->[0]}->{$lowest->[1]}++;
    $flood++;
  };

  # vpravo
  if (($x<$maX) and ($hm->{$x+1}->{$y} < 9) and (not exists $low->{$x+1}->{$y})) {
    $low->{$x+1}->{$y} = $lowest;
    $low->{$lowest->[0]}->{$lowest->[1]}++;
    $flood++;
  };

  # nahore
  if (($y>=1) and ($hm->{$x}->{$y-1} < 9) and (not exists $low->{$x}->{$y-1})) {
    $low->{$x}->{$y-1} = $lowest;
    $low->{$lowest->[0]}->{$lowest->[1]}++;
    $flood++;
  };

  # dole
  if (($y<$maY) and ($hm->{$x}->{$y+1} <9) and (not exists $low->{$x}->{$y+1})) {
    $low->{$x}->{$y+1} = $lowest;
    $low->{$lowest->[0]}->{$lowest->[1]}++;
    $flood++;
  };

  return $flood;
};


sub printMap {
  my ($hm, $low, $maX, $maY) = @_;

  for(my $y=0; $y<=$maY; $y++) {
    for(my $x=0; $x<=$maX; $x++) {
      if (exists $low->{$x}->{$y}) {
	if (ref $low->{$x}->{$y} eq 'ARRAY') {
	  print color('cyan')
	} else {
	  print color('red');
	};
      };
      print $hm->{$x}->{$y}.color('reset');
    };
    print "\n";
  };
  print "\n";
};

my $hm;

my $y = 0;
my $maX = 0;
my $maY = 0;
while(my $line = <>) {
  chomp($line);
  my $x = 0;
  foreach my $h (split(//, $line)) {
    $hm->{$x++}->{$y}=$h
  };
  $maX = $x-1;
  $y++;
};
$maY = $y-1;

# najit nejnizsi mista
my $low;
my $risk = 0;
for(my $y=0; $y<=$maY; $y++) {
  for(my $x=0; $x<=$maX; $x++) {
    my $h = $hm->{$x}->{$y};
    if (isLowest($h, $hm, $x, $y, $maX, $maY)) {
      $risk += $h+1;
      print "$x, $y: $h; $risk\n";
      $low->{$x}->{$y} = 1;
      # zaplavit nejblizsi okoli
      flood($hm, $low, $x, $y, $maX, $maY, [$x, $y]);
    };
  };
};

#zatopit ze zatopenych mist
my $floded = 1;
while ($floded) {
  print "floading\n";
  $floded = 0;

  for(my $y=0; $y<=$maY; $y++) {
    for(my $x=0; $x<=$maX; $x++) {
      if (exists $low->{$x}->{$y}) {
	my $lowest = [$x, $y];
	$lowest = $low->{$x}->{$y} if (ref $low->{$x}->{$y} eq 'ARRAY');
	$floded += flood($hm, $low, $x, $y, $maX, $maY, $lowest);
      };
    };
  };
};

printMap($hm, $low, $maX, $maY);

# zjistit velikosti oblasti
my @basin;
for(my $y=0; $y<=$maY; $y++) {
  for(my $x=0; $x<=$maX; $x++) {
    if ((exists $low->{$x}->{$y}) and (not (ref $low->{$x}->{$y} eq 'ARRAY')) ) {
      push @basin, $low->{$x}->{$y};
    };
  };
};

print "risk=$risk\n";

my @sortedBasin = sort {$b <=> $a} @basin;
#print Dumper(\@sortedBasin);

print $sortedBasin[0]*$sortedBasin[1]*$sortedBasin[2]."\n";
