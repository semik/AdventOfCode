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
	$elfs[$elf] = $c;
	$elf++;
	printf("%d elf no %d\n", $c, $elf);
	$c = 0;
    } else {
	$c += $line;
    };
};
$elfs[$elf] = $c;

my $maxElf = reduce { $elfs[$a] > $elfs[$b] ? $a : $b } 0..$#elfs;
my $max = max(@elfs);

#warn Dumper(\@elfs);

printf("Max calories %d is caried by elf no: %d.\n", $max, $maxElf+1);
