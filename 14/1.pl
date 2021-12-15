#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use List::Util qw(min max sum);

sub statPolymer {
  my $p = shift;

  my %s;
  foreach my $c (split('', $p)) {
    $s{$c}++;
  };

  my $min = min(values %s);
  my $max = max(values %s);

  return $max-$min;
};

sub stat2Polymer {
  my $p = shift;

  my %s;
  foreach my $c (split('', $p)) {
    $s{$c}++;
  };

  foreach my $c (sort { $s{$a} <=> $s{$b} } keys %s) {
    print $c.'='.$s{$c}.' ';
  };
  print "\n";
};

my $template = <>;
chomp($template);

my $pairs;
while (my $line = <>) {
  chomp($line);

  if ($line =~ /^([A-Z]+) -> ([A-Z])$/) {
    my ($a, $b) = ($1, $2);
    if (exists $pairs->{$a}) {
      die "Duplikovany vstup $line";
    };
    $pairs->{$a} = $b;
  } elsif ($line =~ /^$/) {
  };
};

print "Template: $template\n";
for (my $step = 1; $step<=10; $step++) {

  my @insert;
  foreach my $pair (keys %{$pairs}) {
    my $index = -1;
    do {
      $index = index($template, $pair, $index+1);
      if ($index >= 0) {
	push @{$insert[$index]}, $pairs->{$pair};
      };
    } while ($index != -1);
  };

  my @template = split('', $template);
  my @out;
  for (my $i=0; $i<scalar(@template); $i++) {
    push @out, $template[$i];
    if (defined($insert[$i])) {
      push @out, @{$insert[$i]};
    };
  };
  $template = join('', @out);

# tisknout tak dlouhy stringy uz nejde
  printf 'Step %2d: %s len=%d res=%d'."\n",
    $step, $template, length($template), statPolymer($template);
  stat2Polymer($template);
};
