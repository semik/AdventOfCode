#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use Term::ANSIColor;
use List::Util qw/sum/;

sub loadRow {
  my $row = shift;

  return unless $row;

  $row =~ s/^\s+//;
  my @row = split(/\s+/, $row);

  return \@row;
};

sub buildBoard {
  my @in = @_;

  my $board;
  for(my $row=1; $row <= 5; $row++) {
    for(my $col=1; $col <= 5; $col++) {
      $board->{$row}->{$col}->{value} = $in[$row-1]->[$col-1];
    };
  };

  return $board;
};

sub printBoard {
  my $board = shift;

  for(my $row=1; $row <= 5; $row++) {
    for(my $col=1; $col <= 5; $col++) {
      my $r = '';
      $r = color("red") if (defined $board->{$row}->{$col}->{mark});
      printf($r.'%2d '.color("reset"), $board->{$row}->{$col}->{value});
    };
    print "\n";
  };
};

sub markBoard {
  my $board = shift;
  my $number = shift;

  for(my $row=1; $row <= 5; $row++) {
    for(my $col=1; $col <= 5; $col++) {
      if ($board->{$row}->{$col}->{value} == $number) {
	$board->{$row}->{$col}->{mark}++;
      };
    };
  };
};

sub evaluateBoard {
  my $board = shift;

  my @unmark;
  my $win = 0;

  # radky
  for(my $row=1; $row <= 5; $row++) {
    my $marks = 0;
    for(my $col=1; $col <= 5; $col++) {
      if (defined $board->{$row}->{$col}->{mark}) {
	$marks++
      } else {
	push @unmark, $board->{$row}->{$col}->{value};
      };
    };
    if ($marks >= 5) {
      $win = 1;
    };
  };

  # a nebo sloupce kurwa
  for(my $col=1; $col <= 5; $col++) {
    my $marks = 0;
    for(my $row=1; $row <= 5; $row++) {
      if (defined $board->{$row}->{$col}->{mark}) {
	$marks++
      };
    };
    if ($marks >= 5) {
      $win = 1;
    };
  };

  my $sum = sum(@unmark);

  return ($win, $sum);
};


my @input = <>;

my $line = shift @input;
chomp($line);
my @numbers = split(/,/, $line);
shift @input; # prazdna radka

my @boards;
while (my $row1 = loadRow(shift @input)) {
  my $row2 = loadRow(shift @input);
  my $row3 = loadRow(shift @input);
  my $row4 = loadRow(shift @input);
  my $row5 = loadRow(shift @input);
  shift @input; # prazdna radka

  my $board = buildBoard($row1, $row2, $row3, $row4, $row5);
  push @boards, $board;
};

foreach my $number (@numbers) {
  print "number=$number\n";

  my $boardNo = 0;
  foreach my $board (@boards) {
    $boardNo++;
    next if (defined $board->{finished});
    markBoard($board, $number);

    print "-----\n";
    print "board=$boardNo\n";
    if ($boardNo == 2) {
      printBoard($board);
      print "-----\n";
    };

    my ($win, $sum) = evaluateBoard($board);

    if ($win) {
      $board->{finished} = 1;

      printBoard($board);
      print "$boardNo: sum=$sum number=$number score=".$sum*$number."\n\n";
    };
  };
};
