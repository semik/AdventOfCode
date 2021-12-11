#!/usr/bin/perl -w

use strict;
use Data::Dumper;

my $oz = {
	  '(' => ')',
	  '[' => ']',
	  '{' => '}',
	  '<' => '>',
	 };

my $p = {
	 ')' => 3,
	 ']' => 57,
	 '}' => 1197,
	 '>' => 25137,
	};

my $p2 = {
	  ')' => 1,
	  ']' => 2,
	  '}' => 3,
	  '>' => 4,
	 };

my $points = 0;
my @out2;
while (my $line = <>) {
  chomp($line);

  my @line;
  foreach my $z (split(//, $line)) {
    if ($z =~ /^[\(\[\{\<]$/) {
      push @line, $z;
    } elsif ($z =~ /^[\)\]\}\>]$/) {
      my $openZ = pop @line;
      if ($oz->{$openZ} ne $z) {
	my $pp = $p->{$z};
	printf 'Ocekavano "%s" precteno "%s" (%d)'."\n", $oz->{$openZ}, $z, $pp;
	$points += $pp;
      };
    } else {
      die "Nedovoleny znak: '$z'\n";
    };
  };
  if (@line) {
    my @closing = reverse map {$oz->{$_}} @line;
    print join('', @line)." ".join('', @closing)." ";
    my $score = 0;
    foreach my $z (@closing) {
      $score = $score*5 + $p2->{$z};
    };
    push @out2, $score;
    print "$score\n";
  };
  print "-----\n";
};

print "celkem bodu: $points\n";

@out2 = sort {$a <=> $b} @out2;

print join(', ', @out2)."\n";
print $out2[scalar(@out2)/2-1]."\n";
