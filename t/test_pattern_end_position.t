#!/usr/bin/env perl
use strict;
use warnings;

use Libtoken qw[pattern_end_position];

use Test::LectroTest;

Property {
    ##[ x <- Int, y <- String, raw_pattern <- String ]##
    
    my $regex_good = 0;
    my $pattern = '';
    eval {
        # TODO: turn on just warnings related to regexes!
        use warnings FATAL => 'all';
        $pattern = qr/$raw_pattern/;
        $regex_good = 1;
    };

    my $result = pattern_end_position(
        string => $y,
        offset => $x,
        pattern => $raw_pattern,
    );

    $tcon->retry unless $regex_good;
    $tcon->retry if $x < 0;
    # the length should really be a valid offset
    $tcon->retry if $x >= length($y);

    my $result_success = ($result == -1) ? 1 : 0;

    # length augh!
    my $substr = substr($y, $x, ($result - $x));
    my $pattern_applies = scalar($substr =~ m/\A$pattern\z/) ? 1 : 0;

    $result_success eq $pattern_applies;
};
