#!/usr/bin/perl -w

use strict;
use Data::Dumper;

my %bits;

while (my $line = <>) {
  chomp($line);

  my $pos = 0;
  foreach my $bit (split(//, $line)) {
    $bits{$pos++}->{$bit}++;
  };
};

print Dumper(\%bits);

my $len = scalar(keys %bits);

my $gama = '';
my $epsilon = '';
for (my $pos=0; $pos<$len; $pos++) {
  $gama    .= sprintf('%d', $bits{$pos}->{'1'} > $bits{$pos}->{'0'});
  $epsilon .= sprintf('%d', $bits{$pos}->{'0'} > $bits{$pos}->{'1'});
};

my $dec_g = oct('0b'.$gama);
my $dec_e = oct('0b'.$epsilon);

print "gama: $gama $dec_g, epsilon: $epsilon $dec_e, ".($dec_g*$dec_e)."\n";
