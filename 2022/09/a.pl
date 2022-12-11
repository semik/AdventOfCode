#!/usr/bin/perl -w

use strict;
use Data::Dumper;

my $diff = {
        'R' => [1, 0],
	'L' => [-1, 0],
	'U' => [0, 1],
	'D' => [0, -1] };

sub touching {
    my $h = shift;
    my $t = shift;

    my $touching = ( (abs($h->[0] - $t->[0]) <= 1) and (abs($h->[1] - $t->[1]) <= 1) );

    return $touching;
};

sub move {
    my $head = shift;
    my $tail = shift;
    my $diff = shift;

    $head->[0] += $diff->[0];
    $head->[1] += $diff->[1];

    if (not touching($head, $tail)) {
	my ($dx, $dy) = (0, 0);

	$dx = ($head->[0]-$tail->[0]) / abs($head->[0]-$tail->[0])
	    unless ($head->[0] == $tail->[0]);
	$dy = ($head->[1]-$tail->[1]) / abs($head->[1]-$tail->[1])
	    unless ($head->[1] == $tail->[1]);

	$tail->[0] += $dx;
	$tail->[1] += $dy;
    };
}

my $head = [0, 0];
my $tail = [0, 0];
my %visited;

my @input = map { chomp($_); $_ } <>;

while (my $input = shift(@input)) {
    my ($direction, $length) = split(/ /, $input);
    warn "$direction $length\n";
    for(my $i=0; $i < $length; $i++) {
	move($head, $tail, $diff->{$direction});
	$visited{sprintf("%d-%d", $tail->[0], $tail->[1])}++;
    };
};

print Dumper(\%visited);
print scalar(keys %visited)."\n";l
