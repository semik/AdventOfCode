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

my $risk = 0;
for(my $y=0; $y<=$maY; $y++) {
  for(my $x=0; $x<=$maX; $x++) {
    my $h = $hm->{$x}->{$y};
    if (isLowest($h, $hm, $x, $y, $maX, $maY)) {
      $risk += $h+1;
      #print "$x, $y: $h; $risk\n";
      print color('red');
    };
    print $h.color('reset');
  };
  print "\n";
};

print "risk=$risk\n";

