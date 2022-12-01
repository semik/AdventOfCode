#!/bin/perl -w

use strict;

my $last = undef;
my $cnt = 0;
while (my $m = <>) {
    if (defined($last) and ($last <= $m)) {
	$cnt++;
    }
    
    $last = $m;
};

print "$cnt\n";
