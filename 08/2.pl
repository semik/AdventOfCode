#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use Array::Utils qw(:all);
use List::Util qw(min max sum);

sub sortSegments {
  my $a = shift;

  return join('', sort split(//, $a));
};

sub get {
  my $digit = shift;
  my $digits = shift;

  foreach my $segment (keys %{$digits}) {
    return $segment if ($digits->{$segment} == $digit);
  };

  return;
};

sub isIn {
  my $segment = shift;
  my $segmentIn = shift;

  for my $s (split(//, $segment)) {
    my $pos = index($segmentIn, $s);
    return if ($pos < 0);
  };

  # byly nalezeny vsechny pismena z $segment v $segmentIn
  return 1;
};

sub is3 {
  my $segment = shift;
  my $digits = shift;

  # 3 pouziva 5 segmentu
  return unless (length($segment) == 5);

  # 3 obsahuje segmenty 1
  my $seg1 = get(1, $digits);
  # 3 obsahuje segmenty 7
  my $seg7 = get(7, $digits);

  return unless (defined($seg1) and defined($seg7));

  if (isIn($seg1, $segment) and isIn($seg7, $segment)) {
    return 1;
  };

  return ;
};

sub is5 {
  my $segment = shift;
  my $digits = shift;

  # 5 pouziva 5 segmentu, stejne jako 2, 3
  return unless (length($segment) == 5);

  # kdyz budeme odebirat segmenty 4 a 1 tak nam musi zbyt ten samy segment
  my @segment = split(//, $segment);
  my @s1 = split(//, get(1, $digits));
  my @s4 = split(//, get(4, $digits));

  my @d1 = array_minus(@s1, @segment);
  my @d4 = array_minus(@s4, @segment);

  my $d1 = join('', @d1);
  my $d2 = join('', @d4);

  return 1 if ($d1 eq $d2);

  return;
};

sub is2 {
  my $segment = shift;
  my $digits = shift;

  # 2 pouziva 5 segmentu, stejne jako 2, 3, 5
  return unless (length($segment) == 5);

  return if is5($segment, $digits);
  return if is3($segment, $digits);

  # no a pokud to neni ani 3 ani 5 tak je to 2
  return 1;
};

sub is9 {
  my $segment = shift;
  my $digits = shift;

  # 9 pouziva 6 segmentu, stejne jako 0, 6
  return unless (length($segment) == 6);

  # 9 obsahuje segmenty 3
  my $seg3 = get(1, $digits);
  # 9 obsahuje segmenty 7
  my $seg7 = get(7, $digits);
  # 9 obsahuje segmenty 4
  my $seg4 = get(4, $digits);

  return unless (defined($seg3) and defined($seg4) and defined($seg7));

  if (isIn($seg3, $segment) and isIn($seg4, $segment) and isIn($seg7, $segment)) {
    return 1;
  };

  return;
};

sub is6 {
  my $segment = shift;
  my $digits = shift;

  # 6 pouziva 6 segmentu, stejne jako 0, 6, 9
  return unless (length($segment) == 6);

  return if is0($segment, $digits);
  return if is9($segment, $digits);

  # no a pokud to neni ani 0 ani 9 tak je to 6
  return 1;
};

sub is0 {
  my $segment = shift;
  my $digits = shift;

  # 0 pouziva 6 segmentu, stejne jako 0, 6, 9
  return unless (length($segment) == 6);

  # kdyz je to 9 tak to nemuze byt 0 ;)
  return if is9($segment, $digits);

  # v 0 je obsazena 1 a 7, no a 1 segmenty 7, takze ta staci
  my $seg7 = get(7, $digits);

  return unless (defined($seg7));

  if (isIn($seg7, $segment)) {

    return 1;
  };

  return;
};


my $segments = {
		2 => 1,
		3 => 7,
	       #5 => 2,3,5
		4 => 4,
	       #6 => 0,6,9
		7 => 8,
	       };


my @res;

while (my $line = <>) {
  chomp($line);
  my %digits;

  # identifikovat cisla ktery jsou jasny
  my @output = split(/ /, $line);
  foreach my $segment (@output) {
    if (exists $segments->{length($segment)}) {
      my $digit = $segments->{length($segment)};
      $digits{sortSegments($segment)} = $segments->{length($segment)};
    };
  };

  # prebrat ten zbytek
  my @translated;
  foreach my $segment (@output) {
    next if ($segment eq '|');
    my $translated = '?';

    if (exists $digits{sortSegments($segment)}) {
      $translated = $digits{sortSegments($segment)};

    } elsif (is0($segment, \%digits)) {
      $digits{sortSegments($segment)} = 0;
      $translated = $digits{sortSegments($segment)};

    } elsif (is2($segment, \%digits)) {
      $digits{sortSegments($segment)} = 2;
      $translated = $digits{sortSegments($segment)};

    } elsif (is3($segment, \%digits)) {
      $digits{sortSegments($segment)} = 3;
      $translated = $digits{sortSegments($segment)};

    } elsif (is5($segment, \%digits)) {
      $digits{sortSegments($segment)} = 5;
      $translated = $digits{sortSegments($segment)};

    } elsif (is6($segment, \%digits)) {
      $digits{sortSegments($segment)} = 6;
      $translated = $digits{sortSegments($segment)};

    } elsif (is9($segment, \%digits)) {
      $digits{sortSegments($segment)} = 9;
      $translated = $digits{sortSegments($segment)};
    };

    print "$segment=$translated ";
    push @translated, $translated;
  };

  my $l = scalar(@translated);
  my $res = $translated[$l-4].$translated[$l-3].$translated[$l-2].$translated[$l-1];
  print "-- ".$res."\n";
  push @res, $res;
};

print sum(@res)."\n";
