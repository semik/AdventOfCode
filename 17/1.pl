#!/usr/bin/perl -w

use strict;
use Data::Dumper;

my $input = <>;
$input =~ /^target area: x=([\-0-9]+)..([\-0-9]+), y=([\-0-9]+)..([\-0-9]+)/;
my ($x1, $x2, $y1, $y2) = ($1, $2, $3, $4);

print "x1=$x1, x2=$x2, y1=$y1, y2=$y2\n";

# 290 prilis malo?
# 1162 prilis malo
# 2528 prilis malo
# 3186 pro muj vstup!
my %init;

for (my $_vx = -200; $_vx<=700; $_vx++) {
  print "init x=$_vx ".scalar(keys %init)."\n";
  for (my $_vy = -400; $_vy<=500; $_vy++) {
    my ($vx, $vy) = ($_vx, $_vy);
    my ($x, $y) = (0, 0);
    my $maY = 0;
    for (my $i=0; $i<1000; $i++) {
      $x += $vx;
      $y += $vy;

      $maY = $y if ($y > $maY);

      if ($vx > 0) { $vx--; } elsif ($vx < 0) { $vx++; };
      $vy--;

      if (($x>=$x1) and ($x<=$x2) and ($y>=$y1) and ($y<=$y2)) {
	print "Initial vector ($_vx, $_vy) maxY = $maY; step=$i!!!\n";
	push @{$init{"$_vx-$_vy"}}, [($_vx, $_vy, $maY, $i)];
	last;
      } else {
	#print "Probe position $x,$y ($vx,$vy); step=$i\n";
      };
    };
  };
};

print Dumper(\%init)."\n";
die scalar(keys %init);


