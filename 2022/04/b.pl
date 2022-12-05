#!/usr/bin/perl -w

use strict;
use Data::Dumper;

sub AinBorBinA {
    my $a = shift;
    my $b = shift;

    my $ret = (
	(($a->[0] >= $b->[0]) and ($a->[1] <= $b->[1])) or
	(($b->[0] >= $a->[0]) and ($b->[1] <= $a->[1]))
	);

    print join('-', @{$a}).'-'.join('-', @{$b}).' '.$ret."\n";

    return $ret;
};

sub overlap {
    my $a = shift;
    my $b = shift;

    my $ret = (
	($a->[0] >= $b->[0]) and ($a->[0] <= $b->[1]) or
	($a->[1] >= $b->[0]) and ($a->[1] <= $b->[1]) or
	($b->[0] >= $a->[0]) and ($b->[0] <= $a->[1]) or
	($b->[1] >= $a->[0]) and ($b->[1] <= $a->[1])
	);

    print join('-', @{$a}).'-'.join('-', @{$b}).' '.$ret."\n";

    return $ret;
};



my $in = 0;
while (my $line = <>) {
    chomp($line);
    print "$line\n";

    if ($line =~ /^(\d+)-(\d+),(\d+)-(\d+)$/) {
	$in += overlap([$1, $2], [$3, $4]);
    } else {
	die "Invalid input: $line";
    };
};

print "A in B or B in A: $in times\n";
