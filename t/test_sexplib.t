#!/usr/bin/env perl
use strict;
use warnings;
use Test;
use Sexplib qw[parse_comment parse_string parse_identifier parse_sexp_token stringify parse_sexp];

BEGIN {
    plan(tests => 13);
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
ok(parse_string('"\\"', 0), undef);

# 'a' is identifier
ok(parse_identifier('a', 0), 1);

# 'a' is sexp token
ok(stringify(parse_sexp_token('a', 0)), 'ident 1');

# '(' is sexp token
ok(stringify(parse_sexp_token('(', 0)), '( 1');

# ')' is sexp token
ok(stringify(parse_sexp_token(')', 0)), ') 1');

# '; a' is sexp token
ok(stringify(parse_sexp_token('; a', 0)), 'comment 3');

# () is an s-expression
ok(parse_sexp('()', 0), 2);
