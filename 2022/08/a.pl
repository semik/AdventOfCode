#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use Term::ANSIColor;

sub printGrid {
    my $g = shift;

    my $seen = 0;
    for(my $r = 0; $r < scalar(keys %{$g}); $r++) {
	for(my $c = 0; $c < scalar(keys %{$g->{$r}}); $c++) {
	    if ($g->{$r}->{$c}->{seen}) {
		print color('red');
		$seen++;
	    };
	    print $g->{$r}->{$c}->{height};
	    print color('reset');
	};
	print "\n";
    };
    print "visible=$seen\n";
};

my $g = {};

my $row = 0;
my $col = 0;
while (my $line = <>) {
    chomp($line);

    $col = 0;
    foreach my $t (split(//, $line)) {
	$g->{$row}->{$col++} = { height => $t,
				 seen => 0 };
    }

    $row++;
};

print "rows=$row, col=$col\n";

printGrid($g);

# ze zhora dolu
for (my $c=1; $c<$col-1; $c++) {
    my $last = 0;
    for (my $r=1; $r<$row-1; $r++) {
	printf "r=%d, c=%d, last=%d, curent=%d\n",
	    $r, $c, $g->{$last}->{$c}->{height}, $g->{$r}->{$c}->{height};
	if ($g->{$r}->{$c}->{height} > $g->{$last}->{$c}->{height}) {
	    $g->{$r}->{$c}->{seen} = 1;
	    $last = $r;
	};
    };
};

# ze zdola nahoru
for (my $c=1; $c<$col-1; $c++) {
    my $last = $row-1;
    for (my $r=$row-2; $r; $r--) {
	printf "r=%d, c=%d, last=%d, curent=%d\n",
	    $r, $c, $g->{$last}->{$c}->{height}, $g->{$r}->{$c}->{height};
	if ($g->{$r}->{$c}->{height} > $g->{$last}->{$c}->{height}) {
	    $g->{$r}->{$c}->{seen} = 1;
	    $last = $r;
	};
    };
};

# z leva do prava
for (my $r=1; $r<$row-1; $r++) {
    my $last = 0;
    for (my $c=1; $c<$col-1; $c++) {
	printf "r=%d, c=%d, last=%d, curent=%d\n",
	    $r, $c, $g->{$r}->{$last}->{height}, $g->{$r}->{$c}->{height};
	if ($g->{$r}->{$c}->{height} > $g->{$r}->{$last}->{height}) {
	    $g->{$r}->{$c}->{seen} = 1;
	    $last = $c;
	};
    };
};

# z prava do leva
for (my $r=1; $r<$row-1; $r++) {
    my $last = $col-1;
    for (my $c=$col-2; $c; $c--) {
	printf "r=%d, c=%d, last=%d, curent=%d\n",
	    $r, $c, $g->{$r}->{$last}->{height}, $g->{$r}->{$c}->{height};
	if ($g->{$r}->{$c}->{height} > $g->{$r}->{$last}->{height}) {
	    $g->{$r}->{$c}->{seen} = 1;
	    $last = $c;
	};
    };
};

# viditelne sloupce
for (my $r=0; $r<$row; $r++) {
    $g->{$r}->{0}->{seen} = 1;
    $g->{$r}->{$col-1}->{seen} = 1;
};

# viditelne radky
for (my $c=0; $c<$col; $c++) {
    $g->{0}->{$c}->{seen} = 1;
    $g->{$row-1}->{$c}->{seen} = 1;
};



printGrid($g);
