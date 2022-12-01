#!/usr/bin/perl -w

use strict;
use Data::Dumper;

my @cmd;

while (my $line=<>) {
  chomp($line);

  if ($line =~ /^(on|off) x=([\-0-9]+)\.\.([\-0-9]+),y=([\-0-9]+)\.\.([\-0-9]+),z=([\-0-9]+)\.\.([\-0-9]+)$/) {
    my ($s, $x1, $x2, $y1, $y2, $z1, $z2) = ($1, $2, $3, $4, $5, $6, $7);
    push @cmd, [$s eq 'on' ? 1 : 0, $x1, $x2, $y1, $y2, $z1, $z2];
  } else {
    die "Nelatny vstup: $line\n";
  };
};

my $r;
foreach my $cmd (@cmd) {
  next if ($cmd->[0]); # zapnuty kosticky
  warn Dumper($cmd);

};
