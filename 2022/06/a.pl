#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use List::MoreUtils qw(uniq);

my $line = <>; chomp($line);
my @input = split(//, $line);

my $counter = 0;
my @buf = ();
do {
    my $c = shift @input;
    push @buf, $c;
    $counter++;

    if (@buf == 4) {
	if ((uniq @buf) == 4) {
	    printf "first marker after %d characters: %s (%s)\n",
		$counter, join('', @buf), $c;
	    exit 0;
	} else {
	    shift @buf;
	};
    };
} while @input;

die Dumper(\@input);
