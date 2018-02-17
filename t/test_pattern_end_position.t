#!/usr/bin/env perl
use strict;
use warnings;

use Libtoken qw[pattern_end_position];

use Test::LectroTest;

# take a string, make it into a regex
# if it's a valid pattern.
# if it isn't return undef
sub make_regex {
    my $raw_pattern = shift;
    my $pattern;
    eval {
        no warnings;
        no strict;
        $pattern = qr/$raw_pattern/;
    };
    return $pattern;
}


Property {
    ##[ x <- Int, y <- String, raw_pattern <- String ]##

    no warnings;
    no strict;

    # check if we can proceed
    my $pattern = make_regex($raw_pattern);
    $tcon->retry unless defined $pattern;
    # reject negative x
    $tcon->retry if $x < 0;
    # reject x past end
    $tcon->retry if $x >= length($y);

    my $result = pattern_end_position(
        string => $y,
        offset => $x,
        pattern => $raw_pattern,
    );
    return 1;
    ##    if (not (defined $result)) {
    ##        $tcon->retry;
    ##    }
    ##
    ##    # length augh!
    ##    my $len = $result - $x;
    ##    my $substr = substr($y, $x, $len);
    ##    return $substr =~ m/\A$pattern\z/;
};
