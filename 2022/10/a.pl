#!/usr/bin/perl

use strict;
use Data::Dumper;
use List::Util qw(min max sum);

$| = 1;


my @input = map { chomp($_); $_ } <>;

my $x = 1;
my $c = 0;
my @buf = ();
my @cycle = (20, 60, 100, 140, 180, 220);
my $signal = 0;

while ( (scalar(@input) > 0) or (scalar(@buf) > 0) or ($c < max(@cycle)) ) {
    printf "c=%3d, x=%3d, buf=%d ", $c, $x, scalar(@buf);

    if (@buf) {
	# jsme uprostřed předchozí operace addx
	my $addx = shift @buf;
	$x += $addx;
	printf '-'x14;
    } else {
	my $i = shift @input;
	printf '[%-12s]', $i;

	if ($i eq 'noop') {
	} elsif ($i =~ /^addx (-*\d+)$/) {
	    my $addx = $1;
	    push @buf, $addx;
	} elsif ($i =~ /.+/) {
	    die " neznama instrukce $i";
	} else {
	    die " no a tohle uz by vubec nemelo nastat";
	};
    };

    $c++;
    printf " c=%3d, x=%3d, input=%d, buf=%d\n",
	$c, $x, scalar(@input), scalar(@buf);

    if (grep { $_ == $c } @cycle) {
	my $s = $c * $x;
	$signal += $s;

	print ">> SIGNAL = $signal (c=$c, x=$x, added $s)\n";
    };
};


#  14760 too high
