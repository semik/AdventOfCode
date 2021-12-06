#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use List::Util qw(min max);

sub loadInput {

  my ($maxX, $maxY) = (0, 0);
  my $input;

  while (my $line = <>) {
    chomp($line);

    if ($line =~ /^(\d+),(\d+)\s*->\s*(\d+),(\d+)/) {
      my ($x1, $y1, $x2, $y2) = ($1, $2, $3, $4);

      $maxX = max($maxX, $x1, $x2);
      $maxY = max($maxY, $y1, $y2);

      push @{$input->{data}}, [int($x1), int($y1), int($x2), int($y2)];

      print "$line\n";;
    } else {
      die "Failed to parse: $line";
    };
  };

  $input->{maxX} = $maxX;
  $input->{maxY} = $maxY;

  print "area: 0,0 -> $maxX, $maxY\n";

  return $input;
};

sub drawInput {
  my $in = shift;

  my $c;
  $c->{maxX} = $in->{maxX};
  $c->{maxY} = $in->{maxY};

  foreach my $line (@{$in->{data}}) {
    my ($x1, $y1, $x2, $y2) = @{$line};

    if (($x1 == $x2) or ($y1 == $y2)) {
      # svisla nebo vodorovna cara
      for(my $x=min($x1, $x2); $x<=max($x1, $x2); $x++) {
	for(my $y=min($y1, $y2); $y<=max($y1, $y2); $y++) {
	  $c->{$x}->{$y}++;
	};
      };
    } else {
      # diagonala
      print "D: $x1, $y1 -> $x2, $y2\n";

      # mozna zkusit odecist od x1,x2 a y1,y2 - abs. hodnota by se
      # mela rovnat, jinak to neni diagonala

      my $x=$x1;
      my $y=$y1;

      my $xi = 1;
      $xi = -1 if ($x1 > $x2);

      my $yi = 1;
      $yi = -1 if ($y1 > $y2);

      print "D: $x, $y\n";
      $c->{$x}->{$y}++;
      do {
	$x += $xi;
	$y += $yi;
	$c->{$x}->{$y}++;
	print "D: $x, $y\n";
      } until (($x == $x2) and ($y == $y2));
      print "---\n";
    };
  };

  return $c;
};

sub evalCanvas {
  my $c = shift;

  my $i;

  foreach my $x (keys %{$c}) {
    next if ($x eq 'maxY') or ($x eq 'maxX');

    foreach my $y (keys %{$c->{$x}}) {
      $i++ if ($c->{$x}->{$y} > 1);
    };
  };

  return $i;
};

my $in = loadInput();
my $canvas = drawInput($in);
my $maxAreas = evalCanvas($canvas);

#print Dumper($canvas);

print "overlap = $maxAreas\n";
