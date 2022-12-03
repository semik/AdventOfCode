#!/bin/perl -w

use strict;
use Data::Dumper;
use List::Util qw(first);
use Array::Utils qw(:all);

my $c = 1;
my %scoreHash;
foreach my $a ('a'..'z','A'..'Z') {
    $scoreHash{$a} = $c++;
};

sub getScore {
    my @a = @_;
    my $s = 0;

    foreach my $a (@a) {
	$s += $scoreHash{$a} if (exists $scoreHash{$a});
    };

    return $s;
};

my $score = 0;
while (my $line = <>) {
    chomp($line);
    my @line = split(//, $line);

    my @a = splice(@line, 0, scalar(@line)/2);
    my @b = @line;
    my @shared = unique(intersect(@a, @b));
    my $s = getScore(@shared);
    $score += $s;


    printf("%s\n%s\n%s\n%s - %d\n\n",
	   $line,
	   join('', @a),
	   join('', @b),
	   join('', @shared), $s);
};

print "Total score: $score\n";
