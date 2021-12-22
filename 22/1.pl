#!/usr/bin/perl -w

use strict;
use Data::Dumper;

my @cmd;

while (my $line=<>) {
  chomp($line);

  if ($line =~ /^(on|off) x=([\-0-9]+)\.\.([\-0-9]+),y=([\-0-9]+)\.\.([\-0-9]+),z=([\-0-9]+)\.\.([\-0-9]+)$/) {
    my ($s, $x1, $x2, $y1, $y2, $z1, $z2) = ($1, $2, $3, $4, $5, $6, $7);
    $x1 = -51 if ($x1 < -50);
    $y1 = -51 if ($y1 < -50);
    $z1 = -51 if ($z1 < -50);
    $x2 =  51 if ($x2 > 50);
    $y2 =  51 if ($y2 > 50);
    $z2 =  51 if ($z2 > 50); # no ty horni meze nechodi poradne ale to je fuk vysledek to dalo
    push @cmd, [$s eq 'on' ? 1 : 0, $x1, $x2, $y1, $y2, $z1, $z2];
  } else {
    die "Nelatny vstup: $line\n";
  };
};

my $r;
foreach my $cmd (@cmd) {
  warn Dumper($cmd);
  for (my $x = $cmd->[1]; $x<=$cmd->[2]; $x++) {
    for (my $y = $cmd->[3]; $y<=$cmd->[4]; $y++) {
      for (my $z = $cmd->[5]; $z<=$cmd->[6]; $z++) {
	if (($x >= -50) and ($x <= 50) and
	    ($y >= -50) and ($y <= 50) and
	    ($z >= -50) and ($z <= 50)) {
	  $r->{$x}->{$y}->{$z} = $cmd->[0];
	};
      };
    };
  };
};


my $cnt = 0;
for (my $x = -50; $x<=50; $x++) {
  for (my $y = -50; $y<=50; $y++) {
    for (my $z = -50; $z<=50; $z++) {
      if ((exists $r->{$x}) and
	  (exists $r->{$x}->{$y}) and
	  (exists $r->{$x}->{$y}->{$z})) {
	$cnt += $r->{$x}->{$y}->{$z};
      };
    }
  };
};

print "on = $cnt\n";
