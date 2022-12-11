#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use POSIX;

sub parseMonkey {
    my $input = shift;
    my %monkey;

    # while skonci protoze opice jsou oddeleny prazdnym radkem ktery je false
    while (my $in = shift @{$input}) {
	if ($in =~ /Monkey (\d):$/) {
	    $monkey{id} = $1;
	} elsif ($in =~ /Starting items: (.*)$/) {
	    $monkey{items} = [split(/, /, $1)];
	    #$monkey{inspected} = scalar(@{$monkey{items}});
	} elsif ($in =~ /Operation: new = (.*)$/) {
	    my $op = $1;
	    $op =~ s/old/\$old/g;
	    $monkey{op} = $op;
	} elsif ($in =~ /Test: divisible by (\d+)$/) {
	    $monkey{div} = $1;
	} elsif ($in =~ /If true: throw to monkey (\d)$/) {
	    $monkey{true} = $1;
	} elsif ($in =~ /If false: throw to monkey (\d)$/) {
	    $monkey{false} = $1;
	} else {
	    die "tohle by se nemelo stat: $in";
	};
    };

    return \%monkey;
};

sub printMonkey {
    my $monkeys = shift;

    for(my $id=0; $id < @{$monkeys}; $id++) {
	printf "Monkey %d (%d): %s\n",
	    $id, $monkeys->[$id]->{inspected} || 0, join(', ', @{$monkeys->[$id]->{items}});
    };
};

my @input = map { chomp($_); $_ } <>;

my @monkeys;

while (@input) {
    push @monkeys, parseMonkey(\@input);
};

printMonkey(\@monkeys);
print "\n";

for(my $round=1; $round <= 20; $round++) {
    print "ROUND $round\n";
    for(my $id=0; $id < @monkeys; $id++) {
	my $m = $monkeys[$id];
	while (my $old = shift @{$m->{items}}) {
	    my $eq = $m->{op};
	    my $new = eval $eq;
	    $new = int($new / 3);

	    my $target = $m->{true};
	    $target = $m->{false} unless (($new % $m->{div}) == 0);

	    printf "monkey %d throwing item %d to monkey %d\n",
		$id, $new, $target;

	    push @{$monkeys[$target]->{items}}, $new;
	    $monkeys[$id]->{inspected}++;
	};
    };

    print "\n";
    printMonkey(\@monkeys);
    print "\n";
};

print "\n";
my @i = ();
for(my $id=0; $id < @monkeys; $id++) {
    printf "Monkey %d inspected items %d times.\n",
	$id, $monkeys[$id]->{inspected};
    push @i, $monkeys[$id]->{inspected};
};

@i = sort { $b <=> $a } @i;

print "\n".$i[0]*$i[1]."\n";
