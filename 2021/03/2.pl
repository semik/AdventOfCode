#!/usr/bin/perl -w

use strict;
use Data::Dumper;

sub countBits {
  my $in = shift;
  my $pos = shift;

  my $one = 0;
  my $zero = 0;

  foreach my $i (@{$in}) {
    my @i = split(//, $i);

    $one++ if ($i[$pos] == '1');
    $zero++ if ($i[$pos] == '0');
  };

  return ($zero, $one);
};

sub filterIn {
  my $in = shift;
  my $pos = shift;
  my $val = shift;

  print "pos=$pos, val=$val\n";

  my @out;

  foreach my $i (@{$in}) {
    my @i = split(//, $i);

    push @out, $i if ($i[$pos] == $val);
  };

  print Dumper(\@out);
  return \@out;
};

sub getRating {
  my $i = shift;
  my $bitCrit = shift;

  for(my $pos=0; $pos<length($i->[0]); $pos++) {

    my ($zero, $one) = countBits($i, $pos);
    print "zero=$zero, one=$one, bitCrit=$bitCrit\n";
    my $val;
    if ($bitCrit == '1') {
      print "bit criteria oxygen\n";
      if ($one >= $zero) {
	$val = '1';
      } else {
	$val = '0';
      };
    } else {
      print "bit criteria co2\n";
      if ($zero <= $one) {
	$val = '0';
      } else {
	$val = '1';
      };
    };

    if (($zero == $one) and (scalar(@{$i}) == 2)) {
      $val = $bitCrit;
    };

    $i = filterIn($i, $pos, $val);

    return $i->[0] if (scalar(@{$i}) == 1);
  };

  return $i->[0];
};

my @input = map {chomp($_); $_} <>;


my $oxygen = getRating(\@input, '1');
my $dec_o =oct("0b$oxygen");
print "oxygen=$oxygen dec=$dec_o\n";
print ">>>>>>>>>>>>>>>>>>>>>>\n";

my $co2 = getRating(\@input, '0');
my $dec_c = oct("0b$co2");
print "co2=$co2 dec=$dec_c\n";

print "oxygen=$oxygen dec=$dec_o co2=$co2 dec=$dec_c ".($dec_o*$dec_c)."\n";
