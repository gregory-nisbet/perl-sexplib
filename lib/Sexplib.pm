package Sexplib;

use strict;
use warnings;
use Exporter qw[import];
use Carp;

our @EXPORT_OK =
  qw[parse_comment parse_string parse_identifier parse_sexp_token parse_sexp stringify];

our $VERSION = '0.0.0';

my $comment = qr/;[^\n]*(?:\n|\z)/smx;
my $string  = qr/["](?:[^\\]|\\["\\])*["]/smx;

# TODO: generalize this
my $identifier = qr/[[:alpha:]][[:alpha:]]*/smx;

# whitespace
my $whitespace = qr/\s*/smx;

# parse_comment : str int -> maybe[int]
# example: ; Some comment <newline>
sub parse_comment {
    my ( $str, $pos ) = @_;
    pos($str) = $pos;
    carp 'index out of bounds' unless pos($str) == $pos;
    if ( $str =~ qr/\G$comment/smx ) {
        return $+[0];
    }
    else {
        return undef;
    }
}

# parse_string : str int -> maybe[int]
# example: "hi there"
sub parse_string {
    my ( $str, $pos ) = @_;
    pos($str) = $pos;
    carp 'index out of bounds' unless pos($str) == $pos;
    if ( $str =~ qr/\G$string/smx ) {
        return $+[0];
    }
    else {
        return undef;
    }
}

# parse_identifier : str int -> maybe[int]
# example: Aaa-def
sub parse_identifier {
    my ( $str, $pos ) = @_;
    pos($str) = $pos;
    carp 'index out of bounds' unless pos($str) == $pos;
    if ( $str =~ qr/\G$identifier/smx ) {
        return $+[0];
    }
    else {
        return undef;
    }
}

# parse_sexp_token : str int -> maybe[array[enum, int]]
sub parse_sexp_token {
    my ( $str, $pos ) = @_;
    pos($str) = $pos;
    my $endpos;
    if ( $str =~ /\G[(]/smx ) {
        return [ '(', $+[0] ];
    }
    if ( $str =~ /\G[)]/smx ) {
        return [ ')', $+[0] ];
    }
    $endpos = parse_identifier( $str, $pos );
    return [ 'ident', $endpos ] if defined $endpos;
    $endpos = parse_string( $str, $pos );
    return [ 'str', $endpos ] if defined $endpos;
    $endpos = parse_comment( $str, $pos );
    return [ 'comment', $endpos ] if defined $endpos;
    return;
}

# stringify : maybe[array[enum, int]] -> maybe[str]
sub stringify {
    my ($x) = @_;
    if ( defined $x ) {
        carp 'undefined-first'  unless defined $x->[0];
        carp 'undefined-second' unless defined $x->[1];
        return "$x->[0] $x->[1]";
    }
    return;
}

# parse_sexp : str int -> maybe[str]
sub parse_sexp {
    my ( $str, $pos ) = @_;
    my $depth = 0;
    while (1) {
        my $res = parse_sexp_token( $str, $pos );
        return unless defined $res;
        if ( $res->[0] eq '(' ) { $depth++; }
        if ( $res->[0] eq ')' ) { $depth--; }
        $pos = $res->[1];
        return $pos if $depth == 0;
    }
    carp 'impossible';
}

1;
