#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use Term::ANSIColor;
use List::Util qw(min max sum);

# nacteni dat ze souboru
my %map;
my $inf = 100*100*10;

sub someOpen {
  my $a = shift;

  foreach my $b (values %{$a}) {
    return 1 if ($b->{stav} eq 'otevreny');
  };

  return 0;
};

sub getLowestOpen {
  my $a = shift;

  my $c;
  foreach my $b (grep {$_->{stav} eq 'otevreny'} values %{$a}) {
    if (defined($c)) {
      $c = $b if ($b->{h} < $c->{h});
    } else {
      $c = $b;
    };
  };

  return $c;
};

sub getNext {
  my $v = shift;

  my @next;

  my ($x, $y) = split('-', $v);
  foreach my $n (@{$map{$y}->{$x}->{neigh}}) {
    my $value = $map{$n->[1]}->{$n->[0]}->{value};
    my $name = $map{$n->[1]}->{$n->[0]}->{name};
    push @next, [$name, $value];
  };

  return @next;
};

my $y = 0;
while(my $line = <>) {
  chomp($line);
  my $x = 0;
  foreach my $c (split('', $line)) {
    $map{$y}->{$x}->{value} = $c;
    $map{$y}->{$x}->{name} = sprintf("%d-%d", $x, $y);
    $x++;
  };
  $map{maX} = $x-1;
  $y++;
};
$map{maY} = $y-1;

# doplneni informaci o tom kam se z kazdeho bodu da dostat
for(my $y=0; $y <= $map{maY}; $y++) {
  for(my $x=0; $x <= $map{maX}; $x++) {
    # lze jit doprava?
    push @{$map{$y}->{$x}->{neigh}}, [$x+1, $y] if ($x < $map{maX});
    # lze jit doleva?
    push @{$map{$y}->{$x}->{neigh}}, [$x-1, $y] if ($x > 0);
    # lze jit dolu?
    push @{$map{$y}->{$x}->{neigh}}, [$x, $y+1] if ($y < $map{maY});
    # lze jit nahoru?
    push @{$map{$y}->{$x}->{neigh}}, [$x, $y-1] if ($y > 0);
  };
};

# vytvoření 1D tabulky bodů
my %placka;
for(my $y=0; $y <= $map{maY}; $y++) {
  for(my $x=0; $x <= $map{maX}; $x++) {
    $placka{$map{$y}->{$x}->{name}} = {
				       name => $map{$y}->{$x}->{name},
				       stav => 'nenalezeny',
				       h => $inf,
				      };
  }
};

$placka{'0-0'}->{stav} = 'otevreny';
$placka{'0-0'}->{h} = 0;

while (someOpen(\%placka)) {
  my $open = getLowestOpen(\%placka);

  my @next = getNext($open->{name});
  foreach my $next (@next) {
    my ($n_name, $n_val) = @{$next};

    if ($placka{$n_name}->{h} > $open->{h} + $n_val) {
      $placka{$n_name}->{h} = $open->{h} + $n_val;
      $placka{$n_name}->{stav} = 'otevreny';
      $placka{$n_name}->{P} = $open->{name};
    };
  };

  $open->{stav} = 'uzavreny';
};

my $fin = $placka{$map{maX}.'-'.$map{maY}};
# zpetne ziskat trasu
my @path = ($fin->{name});
my $risk = 0;
while ($path[$#path] ne '0-0') {
  my $prev = $path[$#path];
  my ($x, $y) = split('-', $prev);
  $risk += $map{$y}->{$x}->{value};
  push @path, $placka{$prev}->{P};
};

print "KONEC $risk\n";
exit 0;
die Dumper($fin);
