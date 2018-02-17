package Libtoken;

# other issues:
# 
# 1) we should use references to strings to avoid issues in perls
#    that don't have copy on write


BEGIN {
    require Exporter;
    @ISA = qw[Exporter];
    @EXPORT_OK = qw[
        pattern_end_position
        many_pattern_end_position
    ];
};

use strict;
use warnings;
use Readonly;


# Issues:
# 1) all of the libraries set pos(...) inside the strings
# and don't clear them or set them to what they were before
# the method was invoked. Is this a problem?
# 
# these methods are not very convenient to use because they don't actually
# return the token, the return an offset.
# the sort of pretty api we want would be something like...
#
# my $reader = function($string, %patterns);
# 
# so we have an ->advance which ... advances one position
# and we have.
#
# while (my ($token, $class, $start, $stop) = $reader->next()) {
#
# }


Readonly my $no_matches => 10000;
Readonly my $multiple_matches => 10010;
Readonly my $read_from_broken_stream => 10020;


Readonly my $whitespace_pattern => qr/\s+/;


# error_no_matches
# construct error message for when there are no matches
sub error_no_matches {
    return {
        success => 0,
        errstring => "no matches",
        errcode => $no_matches,
    };
}


# error_multiple_matches
# error for when there are multiple matches
sub error_multiple_matches {
    my $data = shift;
    return {
        success => 0,
        errstring => "multiple matches",
        errcode => $multiple_matches,
        data => $data,
    };
}


sub error_read_from_broken_stream {
    return {
        success => 0,
        errstring => "attempted to read from broken token stream",
        errcode => $read_from_broken_stream,
    };
}


# pattern_end_position(string => ..., offset =>, pattern =>)
# returns index of end of pattern or undef if the pattern does not
# start at offset.
sub pattern_end_position {
    my %arg = @_;
    my $string = $arg{string};
    my $offset = $arg{offset};
    my $pattern = $arg{pattern};
    # set position to the offset
    pos($string) = $offset;
    # determine whether the match was successful
    my $match = scalar($string =~ m/\G$pattern/g);
    if ($match) {
        my $last = $+[0];
        return $last;
    } else {
        return undef;
    }
}


# many_pattern_end_position(string => ..., offset => ..., patterns => {...}, include_token => ...)
# include_token controls whether the token that is matched is included or not in the response
# returns {"success" => 1, "pattern_key" => ..., "end_pos" => ...}
# returns {"success" => 0, "failure" => msg, "errcode" => number}
sub many_pattern_end_position {
    my %arg = @_;
    my $string = $arg{string};
    my $offset = $arg{offset};
    my $include_token = $arg{include_token};
    my %pattern_inventory = %{ $arg{patterns} };

    pos($string) = $offset;

    # collect all the keys for the matches
    my @matches;
    while (my ($key, $pattern) = each %pattern_inventory) {
        my $last = pattern_end_position(
            string => $string,
            offset => $offset,
            pattern => $pattern,
        );
        if ($last == -1) {
            if ($include_token) {
                push @matches, [$key, $last];
            } else {
                my $token = substr($string, $offset, $last - $offset);
                push @matches, [$key, $last, $token];
            }
        }
    }

    if (@matches == 0) {
        return error_no_matches();
    } elsif (@matches == 1) {
        return {
            success => 1,
            pattern_key => $matches[0]->[0],
            end_pos => $matches[0]->[1],
            token => $matches[0]->[2],
        };
    } else {
        return error_multiple_matches(\@matches);
    }
}

1;
