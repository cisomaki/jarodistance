#!/bin/env perl

use strict;
use List::Util qw(max);

my ($string1,$string2) = @ARGV;

print 'Jaro Distance: ' . jaro($string1,$string2) . "\n";

sub jaro {
  my $string1 = shift;
  my $string2 = shift;

  my $length1 = length($string1);
  my $length2 = length($string2);

  if ($length1 < 3 || $length2 < 3) {
    print "Minimum string length for comparison is 4\n";
    exit 1;
  }

  my $range = (max($length1,$length2)/2)-1;
  my $min = ($length1 < $length2 ? $length1 : $length2);

  my $matches = 0;
  my $transpositions = 0;

  for (my $i = 0; $i < $min; $i++) {
    my $char = substr($string1,$i,1);
    my $min = $i - $range;
    my $max = $i + $range;

    # set bounds
    $min = 0 if $min < 0;
    $max = $length2 if $max >= $length2;

    my $checkString = substr($string2,$min,($max-$min));

    $matches++ if ($checkString =~ $char);

    if (substr($string1,$i,1) ne substr($string2,$i,1)) {
      if (substr($string1,$i,1)   eq substr($string2,$i+1,1) &&
          substr($string1,$i+1,1) eq substr($string2,$i,1)) {
        $transpositions++;
      }
      if ($i >= 1) { # check back one character on $string2 if we are at the second position of $string1
        if (substr($string1,$i,1)   eq substr($string2,$i-1,1) &&
            substr($string1,$i-1,1) eq substr($string2,$i,1)) {
          $transpositions++;
        }
      }
    }
  }

  $matches = $matches * 1.0;

  my $distance = (1.0/3.0) * (
                 (($matches * 1.0)/$length1) +
                 (($matches * 1.0)/$length2) +
                 (($matches - $transpositions)/$matches)
               );
  return $distance;
}
