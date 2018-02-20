package Sexplib;
BEGIN {
    use Exporter qw[import];
    @EXPORT_OK = qw[parse_comment parse_string parse_identifier];
}
use strict;
use warnings;

our $comment = qr/;[^\n]*(?:\n|\z)/;
our $string = qr/["](?:[^\\]|\\["\\])*["]/;
our $identifier = qr/[a-zA-Z_\-][0-9a-zA-Z_\-]*/;

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

# parse_identifier : str int -> maybe[str]
sub parse_identifier {
    my ($str, $pos) = @_;
    pos($str) = $pos;
    if ($str =~ qr/\G$identifier/) {
        return $+[0];
    } else {
        return undef;
    }
}

1
