#!/usr/bin/perl -w

use strict;

#       1           2                3
# A for Rock, B for Paper, and C for Scissors
# X for Rock, Y for Paper, and Z for Scissors

sub play1 {
    my $a = shift;
    my $b = shift;

    return ($b + 3) if ($a == $b);
    # paper=2 beat rock=1
    return ($b + 6) if (($a == 1) and ($b == 2));
    return ($b + 0) if (($b == 1) and ($a == 2));
    # scizor=3 beat paper=2
    return ($b + 0) if (($a == 3) and ($b == 2));
    return ($b + 6) if (($a == 2) and ($b == 3));
    # rock=1 beat scizor=3
    return ($b + 0) if (($a == 1) and ($b == 3));
    return ($b + 6) if (($a == 3) and ($b == 1));

    die "Should not happen: $a $b";
};

my $tot = 0;
while (my $line = <>) {
    chomp($line);

    my $l = $line;
    $l =~ tr/ABCXYZ/123123/;
    my ($a, $b) = split(/ /, $l);
    my $score = play1($a, $b);
    $tot += $score;

    print "$line - $l - $score\n"
};

print "Total: $tot\n";
