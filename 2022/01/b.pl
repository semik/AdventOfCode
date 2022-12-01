#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use List::Util qw(max reduce);

my @elfs;
my $elf = 0;
my $c = 0;

while (my $line = <>) {
    warn $line;

    if ($line =~ /^\s*$/) {
	@elfs[$elf] = $c;
	$elf++;
	printf("%d elf no %d\n", $c, $elf);
	$c = 0;
    } else {
	$c += $line;
    };
};
$elfs[$elf] = $c;

my @selfs = sort {$b <=> $a} @elfs;

#die Dumper(\@selfs);

printf("3 top elfs are carying %d calories.\n", $selfs[0]+$selfs[1]+$selfs[2]);
