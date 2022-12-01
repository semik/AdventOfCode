#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use List::Util qw(min max sum);

sub printO {
  my $o = shift;
  my $maX = shift;
  my $maY = shift;

  my $cnt = 0;
  for (my $y=0; $y<=$maY; $y++) {
    for (my $x=0; $x<=$maX; $x++) {
      if (exists $o->{$x}->{$y}) {
	print $o->{$x}->{$y};
	$cnt++;
      } else {
	print "."
      };
    };
    print "\n";
  };
  print "dots: $cnt\n";
};

sub foldY {
  my ($o, $maX, $maY, $n) = @_;

  for (my $y=$n+1; $y<=$maY; $y++) {
    my $yy = 2*$n-$y;
    for (my $x=0; $x<=$maX; $x++) {
      if (exists $o->{$x}->{$y}) {
	$o->{$x}->{$yy} = $o->{$x}->{$y};
      };
    };
  };
};

sub foldX {
  my ($o, $maX, $maY, $n) = @_;

  for (my $y=0; $y<=$maY; $y++) {
    for (my $x=$n+1; $x<=$maX; $x++) {
      my $xx = 2*$n-$x;
      if (exists $o->{$x}->{$y}) {
	$o->{$xx}->{$y} = $o->{$x}->{$y};
      };
    };
  };
};


my $o = {}; # origami
my $maX = 0;
my $maY = 0;

while (my $line = <>) {
  chomp($line);

  if ($line =~ /^(\d+),(\d+)$/) {
    my ($x, $y) = ($1, $2);
    $maX = max($x, $maX);
    $maY = max($y, $maY);
    $o->{$x}->{$y} = '#'
  } elsif ($line =~ /^$/) {
    print "vstup:\n";
    printO($o, $maX, $maY);
    print "\n";
  } elsif ($line =~ /^fold along (\S+)=(\d+)$/) {
    my ($xy, $n) = ($1, $2);

    print "$line:\n";

    if ($xy eq 'y') {
      foldY($o, $maX, $maY, $n);
      $maY = $n-1;
      printO($o, $maX, $maY);
    } elsif ($xy eq 'x') {
      foldX($o, $maX, $maY, $n);
      $maX = $n-1;
      printO($o, $maX, $maY);
    };
  };
};


__END__
 0 ...#..#..#.
 1 ....#......
 2 ...........
 3 #..........
 4 ...#....#.#
 5 ...........
 6 ...........
 7 ----------- n-(y-n) = 2n-y
 8 ........... 7-(8-7) = 1
 9 ........... 7-(9-7) = 2
10 .#....#.##.
11 ....#......
12 ......#...#
13 #..........
14 #.#........ 7-(14-7) = 0



              xx=2n-x
          1
01234567890
#.##.|#..#.
#...#|.....
.....|#...#
#...#|.....
.#.#.|#.###
.....|.....
.....|.....
