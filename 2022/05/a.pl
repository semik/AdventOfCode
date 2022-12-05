#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use List::Util qw( min max );

$| = 1;

#    [D]
#[N] [C]
#[Z] [M] [P]
#01234567890
# 1   5   9
#
# 1+n*4

sub parseCargo {
    my @cargo = @_;

    my $stack_line = pop @cargo;
    # line looks like ' 1   2   3  '
    my $max_stack = max(grep {/\d/} split(//, $stack_line));

    my $ret;
    do {
	my $c = pop @cargo;

	my @crow = split(//, $c);

	for (my $n=0; $n<$max_stack; $n++) {
	    my $i = 1+$n*4;

	    next if $crow[$i]=~ /^\s+$/;

	    push @{$ret->[$n]}, $crow[$i];
	};

    } while @cargo;

    return @{$ret};
};

sub printCargo {
    my @cargo = @_;


    my $i = 0;
    my $cont = 0;
    do {
	$cont = 0;
	for(my $pos=0; $pos < @cargo; $pos++) {
	    my $item = ' ';
	    if (defined($cargo[$pos]->[$i])) {
		$item = $cargo[$pos]->[$i];
		$cont++;
	    };
	    print $item;
	};
	$i++;
	print "\n";
    } while $cont;
};

sub moveCargo {
    my $amount = shift;
    my $from = shift;
    my $to = shift;
    my @cargo = @_;

    my @items;
    foreach (my $i=0; $i<$amount; $i++) {
	push @items, pop @{$cargo[$from-1]};
    };

    push @{$cargo[$to-1]}, @items;

    return @cargo;
};

my @cargo;
my @cmd;

my $cmd = 0;
while (my $line = <>) {
    chomp($line);
    if ($line =~ /^$/) {
	$cmd = 1;
	next;
    };

    unless ($cmd) {
	push @cargo, $line;
    } else {
	push @cmd, $line;
    };
};

@cargo = parseCargo(@cargo);

print "start:\n";
printCargo(@cargo);

foreach my $cmd (@cmd) {
    print "$cmd\n";
    if ($cmd =~ /^move (\d+) from (\d+) to (\d+)$/) {
	my $amount = $1;
	my $from = $2;
	my $to = $3;

	@cargo = moveCargo($amount, $from, $to, @cargo);
	printCargo(@cargo);
    }
};

print "result: ";
for (my $i = 0; $i<@cargo; $i++) {
    print ($cargo[$i]->[scalar(@{$cargo[$i]})-1]);
};
print "\n";
