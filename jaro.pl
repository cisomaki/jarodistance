#!/bin/env perl

use strict;
use List::Util qw(max);

my ($string1,$string2) = @ARGV;

my $matches = getM($string1,$string2);

print $matches . "\n";


sub getM {
  my ($string1,$string2) = @_;
  my $length1 = length($string1);
  my $length2 = length($string2);

  # calculate the distance to check for matches
  my $within = (max($length1,$length2)/2)-1;

  my $count = 0;

  for (my $pos = 0; $pos < $length1; $pos++) {
    my $char = substr($string1,$pos,1);
    my $min = $pos - $within;
    my $max = $pos + $within;

    # set bounds
    $min = 0 if $min < 0;
    $max = $length2 if $max >= $length2;

    my $checkString = substr($string2,$min,($max-$min));
    
    $count++ if ($checkString =~ $char);
  }

  return $count;
}

