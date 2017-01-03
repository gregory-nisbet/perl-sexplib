#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 2;
use Test::Deep;


use TokenReader qw[token_reader_new];

my $string = 'a';
my %pattern = (character => qr/./);
my $reader = token_reader_new(
    string => $string,
    patterns => \%pattern,
    offset => 0,
);

my @result = $reader->next();
is((scalar @result), 4);
cmp_deeply([@result], ['a', 'character', 0, 1]);
