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

sub intersect3 {
    my $a = shift @_;
    my $b = shift @_;
    my $c = shift @_;

    my @ab = unique(intersect(@{$a}, @{$b}));
    my @ac = unique(intersect(@{$a}, @{$c}));
    my @bc = unique(intersect(@{$b}, @{$c}));

    return unique(intersect(@ab, @{$c}));
};

my @lines = map { chomp($_); $_; } <>;

my $score = 0;
while (@lines) {
    my @a = split(//, shift @lines);
    my @b = split(//, shift @lines);
    my @c = split(//, shift @lines);

    my @common = intersect3(\@a, \@b, \@c);

    my $s = getScore(@common);
    $score += $s;
};

print "Final score: $score\n";
