#!/usr/bin/perl -w

use strict;
use Data::Dumper;

sub enhancePixel {
  my $img = shift;
  my $algo = shift;
  my $x = shift;
  my $y = shift;

  my $out = '.';
  $out = $algo->[0] if (($img->{enhanceCounter} % 2) != 0);
  print "$out";
  my $bin = '';
  for(my $yy=$y-1; $yy<=$y+1; $yy++) {
    for(my $xx=$x-1; $xx<=$x+1; $xx++) {
      if (exists $img->{$yy}->{$xx}) {
	$bin .= $img->{$yy}->{$xx} || $out;
      } else {
	$bin .= $out;
      };
    };
  };
  $bin =~ s/\./0/g;
  $bin =~ s/#/1/g;

  my $index = oct('0b'.$bin);
#  die "$bin $index";

  return $algo->[$index];
};

sub enhanceImage {
  my $img = shift;
  my $algo = shift;

  my $ext = 1;

  my $e = { miX => $img->{miX}-$ext,
	    miY => $img->{miY}-$ext,
	    maX => $img->{maX}+$ext,
	    maY => $img->{maY}+$ext, };

  for(my $y=$e->{miY}; $y<=$e->{maY}; $y++) {
    for(my $x=$e->{miX}; $x<=$e->{maX}; $x++) {
      $e->{$y}->{$x} = enhancePixel($img, $algo, $x, $y);
    };
  };

  $e->{enhanceCounter} = $img->{enhanceCounter}+1;
  return $e;
};

sub printImage {
  my $img = shift;

  print "\n";
  my $cnt = 0;
  for(my $y=$img->{miY}; $y<=$img->{maY}; $y++) {
    for(my $x=$img->{miX}; $x<=$img->{maX}; $x++) {
      my $pix = $img->{$y}->{$x};
      $cnt++ if ($pix eq '#');
      print $pix;
    };
    print "\n";
  };
  print "pixels = $cnt\n";
  return $cnt;
};


my $algo = <>;
chomp($algo);
my @algo = split('', $algo);

my $img = { miX => 0, miY => 0, maX => 0 };
my $y = 0;
while (my $line=<>) {
  chomp($line);
  next if ($line eq '');

  my $x = 0;
  foreach my $pixel (split('', $line)) {
    $img->{maX} = $x if ($img->{maX} < $x);
    $img->{$y}->{$x++} = $pixel;
  };
  $img->{maY} = $y;
  $y++;
};
$img->{enhanceCounter} = 0;

for(my $i=1; $i<=50; $i++) {
  $img = enhanceImage($img, \@algo);
  print "step=$i\n";
  printImage($img);
};

# 5686 je furt moc a nebo jen spatne
# 5772 je taky spatne
# 6620 je taky spatne, kurnik!
