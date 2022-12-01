#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use List::Util qw(min max sum);

my $vsum = 0;

sub hex2bin {
  my $hex = shift;

  my $res = '';
  foreach my $h (split('', $hex)) {
    $res .= unpack('B4', (pack('H1', $h)));
  };

  return $res;
};

sub getVersion {
  my $in = shift;

  my @version = splice(@{$in}, 0, 3);
  my $v = '0b'.join('', @version);
  print "version=$v\n";

  return oct($v);
};

sub getType {
  my $in = shift;

  my @type = splice(@{$in}, 0, 3);
  my $t = '0b'.join('', @type);
  print "type=$t\n";

  return oct($t);
};

sub parsePacket {
  my $inB = shift;

  print "parserIn: ".join('', @{$inB})."\n";

  my @packets;

  my $packet = {
		version => getVersion($inB),
		typeID  => getType($inB),
	       };

  $vsum += $packet->{version};

  if ($packet->{typeID} == 4) {
    my $cont = 1;
    my $literal = '0b';
    while (($cont == 1) and (scalar(@{$inB})>=1)) {
      $cont = splice(@{$inB}, 0, 1);
      print "cont=$cont ";
      my @v = splice(@{$inB}, 0, 4);
      my $v =join('', @v);
      $literal .= $v;
      print "$v\n";
    };
    print "literal=$literal\n";
    $packet->{value} = oct($literal);

    push @packets, $packet;

  } else { # jakykoli jiny packet typeID nez 4
    print "not4: ".join('', @{$inB})."\n";
    my $lengthTypeID = splice(@{$inB}, 0, 1);
    my @next;
    if ($lengthTypeID == 0) {
      # next 15 bits are a number that represents the total length in
      # bits of the sub-packets contained by this packet.
      @next = splice(@{$inB}, 0, 15);
      print "next sub packets bites: ".join('', @next)."=";
      my $b = oct('0b'.join('', @next));
      print "$b\n";
      my @subPacketBites = splice(@{$inB}, 0, $b);

      while(@subPacketBites) {
	my @subPackets = parsePacket(\@subPacketBites);
	push @{$packet->{subPackets}}, @subPackets;
      };

    } elsif ($lengthTypeID == 1) {
      @next = splice(@{$inB}, 0, 11);
      my $no_bin = join('', @next);
      my $no = oct("0b$no_bin");
      print "next sub packets no: $no_bin = $no\n";
      for (my $i=0; $i<$no; $i++) {
	my @subPackets = parsePacket($inB);
	push @{$packet->{subPackets}}, @subPackets;
      }
    } else {
      die "Binary $lengthTypeID is nonsense";
    };

    # vyhodnotit sub-pakety
    my @values = map { $_->{value} } @{$packet->{subPackets}};
    print "values = ".join(', ', @values)."\n";
    my $value;
    if ($packet->{typeID} == 0) { # 0 -> scitani
      $value = shift @values;
      foreach my $v (@values) {
	$value += $v;
      };
    } elsif ($packet->{typeID} == 1) { # 0 -> nasobeni
      $value = shift @values;
      foreach my $v (@values) {
	$value *= $v;
      };
    } elsif ($packet->{typeID} == 2) { # minimum
      $value = min(@values);
    } elsif ($packet->{typeID} == 3) { # maximum
      $value = max(@values);
    } elsif ($packet->{typeID} == 5) { # >
      $value = ($values[0] > $values[1])*1;
    } elsif ($packet->{typeID} == 6) { # <
      $value = ($values[0] < $values[1])*1;
    } elsif ($packet->{typeID} == 7) { # =
      $value = ($values[0] == $values[1])*1;
    }

    $packet->{value} = $value;

    push @packets, $packet;
  };

  print "konec\n";
  return @packets;
};

my $in = <>;
chomp($in);

my $inB = hex2bin($in);
my @inB = split('', $inB);

my @packets = parsePacket(\@inB);
warn Dumper(\@packets);
warn "Zbylo: ".Dumper(\@inB);

print "Version SUM=$vsum\n";

print "Vysledek = ".$packets[0]->{value}."\n";
