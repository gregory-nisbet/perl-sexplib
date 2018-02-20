package Sexplib;
BEGIN {
    use Exporter qw[import];
    @EXPORT_OK = qw[parse_comment parse_string];
}
use strict;
use warnings;

our $comment = qr/;[^\n]*(?:\n|\z)/;
our $string  = qr/["](?:[^\\]|\\["\\])*["]/;

# parse_comment : str int -> maybe[str]
# starting at the given offset,
# get either the last position in a comment
# or produce undef
sub parse_comment {
    my ($str, $pos) = @_;
    pos($str) = $pos;
    if ($str =~ qr/\G$comment/) {
        return $+[0];
    } else {
        return undef;
    }
}

# parse_string : str int -> maybe[str]
# starting at the given offset,
# get either the last position of a string literal
# or produce undef
sub parse_string {
    my ($str, $pos) = @_;
    pos($str) = $pos;
    if ($str =~ qr/\G$string/) {
        return $+[0];
    } else {
        return undef;
    }
}


1;
