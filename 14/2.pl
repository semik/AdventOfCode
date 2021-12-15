#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use List::Util qw(min max sum);

my $template = <>;
chomp($template);

# nacist skupiny se kterymi budeme pracovat
my %pairs;
while (my $line = <>) {
  chomp($line);

  if ($line =~ /^([A-Z]+) -> ([A-Z])$/) {
    my ($a, $b) = ($1, $2);
    $pairs{$a} = $b;
  } elsif ($line =~ /^$/) {
  } else {
    die "spatny vstup";
  };
};

print "$template\n";
my %letters;
my %in;
my $len = length($template);
my @template = split('', $template);
my $a = shift @template;
$letters{$a}++;
foreach my $b (@template) {
  $letters{$b}++;
  $in{"$a$b"}++;
  $a=$b;
};

for (my $step=1; $step <= 40; $step++) {
  my %out;

  foreach my $pair (keys %in) {
    my $cnt = $in{$pair};
    my ($a, $b) = split('', $pair);
    my $c = $pairs{$pair};

    $out{"$a$c"} += $cnt;
    $out{"$c$b"} += $cnt;

    $len += $cnt;
    $letters{$c} += $cnt;
  };

  %in = %out;
  my $min = min(values %letters);
  my $max = max(values %letters);
  printf("Step %2d: len=%6d, res=%d, %s; %s\n",
	 $step,
	 $len,
	 $max-$min,
	 join(' ', map { "$_=".$letters{$_} } sort { $letters{$a} <=> $letters{$b} } keys %letters),
	 join(' ', map { "$_=".$in{$_} } keys %in)
	);
};
