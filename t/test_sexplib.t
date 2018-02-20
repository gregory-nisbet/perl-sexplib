#!/usr/bin/env perl
use strict;
use warnings;
use Test;
use Sexplib qw[parse_comment parse_string];

BEGIN {
    plan(tests => 7);
}

# single character comment
ok(parse_comment(';', 0), 1);

# comment with newline
ok(parse_comment(";\n", 0), 2);

# empty string does not contain comment
ok(parse_comment('', 0), undef);

# string 'a' does not contain comment
ok(parse_comment('a', 0), undef);

# empty string is string
ok(parse_string(q[""], 0), 2);

# string with backslash is not string
ok(parse_string('"\"', 0), undef);

# string with escaped backslash is string
ok(parse_string('"\\"', 4), undef);
