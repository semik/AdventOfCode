#!/usr/bin/perl -w

use strict;

#       1           2                3
# A for Rock, B for Paper, and C for Scissors
# X for Rock, Y for Paper, and Z for Scissors

# 1                         2                                                3
# X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win.

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

sub decide {
    my $a = shift;
    my $b = shift;

    # draw
    return $a if ($b == 2);
    
    # lose
    if ($b == 1) {
	return 3 if ($a == 1);
	return 1 if ($a == 2);
	return 2 if ($a == 3);
	die "Should not happen 1: $a $b";
    };
    # win
    if ($b == 3) {
	return 2 if ($a == 1);
	return 3 if ($a == 2);
	return 1 if ($a == 3);
	die "Should not happen 1: $a $b";
    };

    die "Should not happen 3: $a $b";
};

my $tot = 0;
while (my $line = <>) {
    chomp($line);

    my $l = $line;
    $l =~ tr/ABCXYZ/123123/;
    my ($a, $b) = split(/ /, $l);

    my $B = decide($a, $b);

    my $score = play1($a, $B);
    $tot += $score;

    print "$line - $l; $B - $score\n"
};

print "Total: $tot\n";
