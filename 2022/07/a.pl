#!/usr/bin/perl -w

use strict;
use Data::Dumper;

sub parseInput {
    my $input = shift;
    my $tree = shift;

    while (my $line = shift @{$input}) {
	if ($line eq '$ ls') {
	} elsif ($line =~ /^\$ cd \.\.$/) {
	    return ;
	} elsif ($line =~ /^\$ cd (\S+)$/) {
	    my $dname = $1;
	    if (exists $tree->{$dname}) {
		parseInput($input, $tree->{$dname});
		$tree->{_size} += $tree->{$dname}->{_size};
	    } else {
		die "unable cd into $dname";
	    };
	} elsif ($line =~ /^(\d+)\s(\S+)$/) {
	    my ($size, $fname) = ($1, $2);
	    $tree->{$fname} = $size;
	    $tree->{_size} += $size;
	} elsif ($line =~ /^dir\s(\w+)$/) {
	    my $dname = $1;
	    $tree->{$dname} = { _size => 0 };
	} else {
	    die "unable to parse: $line";
	};
    };
};


sub printSizes {
    my $path = shift;
    my $tree = shift;
    my $sizes = shift;

    foreach my $k ( sort keys %{$tree} ) {
	if ($k eq '_size') {
	    push @{$sizes}, [$tree->{$k}, $path];
	    printf "%d $path\n", $tree->{$k}
	} elsif ( ref($tree->{$k}) eq 'HASH' ) {
	    printSizes("$path$k/", $tree->{$k}, $sizes);
	} else {
	    # printf "%d %s%s\n", $tree->{$k}, $path, $k;
	};
    };
};

my @input = map {chomp ($_); $_} <>;

my $first = shift @input;
die "incorect start sequence" unless ($first eq '$ cd /');

my $tree = { _size => 0 };
parseInput(\@input, $tree);

my @sizes = ();
printSizes("/", $tree, \@sizes);
print "\n";

my $total = 0;
foreach my $item (sort {$a->[0] <=> $b->[0]} @sizes) {
    next unless ($item->[0] < 100000);
    printf "%d %s\n", $item->[0], $item->[1];
    $total += $item->[0];
};

print "Total: $total\n";
