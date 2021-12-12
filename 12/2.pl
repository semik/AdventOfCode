#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use List::Util qw(min max sum);

# global vars
my @paths;
my $caves;

sub isSmall {
  my $cave = shift;

  return if ($cave eq 'end');
  return if ($cave =~ /^[A-Z]+$/);

  return 1;
};

sub visited {
  my $cave = shift;
  my $path = shift;

  my $vis = scalar(grep { $cave eq $_ } @{$path});

  return $vis;
};

sub doubleSmall {
  my @path = @_;

  my %smallCaves;
  foreach my $cave (@path) {
    if (isSmall($cave)) {
      $smallCaves{$cave}++;
    };
  };

  my $visits = max(values %smallCaves);

  return $visits > 1;
};

sub go {
  my $step = shift @_;
  my @path = @_;

  my @out = ();
  if (defined $caves->{$path[$#path]}->{out}) {
    @out = @{$caves->{$path[$#path]}->{out}};
  };
  foreach my $next (@out) {
    my $ppath = join(',', @path, $next);

    if ($ppath eq 'start,HN,dc,HN') {
      my $a=5;
    };

    if ($next eq 'end') {
      push @paths, [@path, $next];
    } else {
      if (isSmall($next)) {
	if ((visited($next, \@path) == 0) or
	    ((visited($next, \@path) == 1) and (doubleSmall(@path)==0))) {
	  go($step+1, @path, $next);
	};
      } else {
	go($step+1, @path, $next);
      };
    };
  };
};

while (my $line=<>) {
  chomp($line);

  print "$line: ";

  my @path = split('-', $line);
  unless ($path[1] eq 'start') {
    push @{$caves->{$path[0]}->{out}}, $path[1];
    print "IN1 = $path[0]->$path[1] ";
  };
  unless (($path[1] eq 'end') or ($path[0] eq 'start')) {
    print "IN2 = $path[1]->$path[0] ";
    push @{$caves->{$path[1]}->{out}}, $path[0];
  };
  print "\n";
};

go(0, 'start');

my $p;

print "nalezene cesty:\n";
my $cnt = 0;
foreach my $path (@paths) {
  $cnt++;
  my $path = join(',', @{$path});
  print "$cnt. ".$path."\n";
};
