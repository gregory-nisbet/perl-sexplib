package TokenReader;


BEGIN {
    require Exporter;
    @ISA = qw[Exporter];
    @EXPORT_OK = qw[
        token_reader_new
    ];
};


use strict;
use warnings;
use Libtoken qw[many_pattern_end_position];


sub token_reader_new {
    return __PACKAGE__->new(@_);
}


sub new {
    my ($class, %arg) = @_;
    my $string = $arg{string};
    my %patterns = %{ $arg{patterns} };

    my %obj = (
        string => $string,
        patterns => \%patterns,
        offset => 0,
        failure => undef,
    );

    bless \%obj, $class;
}


sub next {
    my ($self) = @_;
    my $result = many_pattern_end_position(
        include_token => 1,
        string => $self->{string},
        offset => $self->{offset},
        patterns => $self->{patterns},
    );
    
    if (defined $self->{failure}) {
        return;
    }

    if ($result->{success}) {
        $self->{offset} = $result->{end_pos};
        return (
            $result->{token},
            $result->{pattern_key},
            $result->{offset},
            $result->{end_pos},
        );
    } else {
        $self->{failure} = $result;
        return;
    }
}

1;
