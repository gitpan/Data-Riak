package Data::Riak::HTTP::Response;
{
  $Data::Riak::HTTP::Response::VERSION = '1.0';
}

use strict;
use warnings;

use Moose;

use overload '""' => 'as_string', fallback => 1;

my $_deconstruct_parts;

has 'parts' => (
    is => 'ro',
    isa => 'ArrayRef[HTTP::Message]',
    lazy => 1,
    default => sub {
        my $self = shift;
        my @parts = $_deconstruct_parts->( $self->http_response );
        return \@parts;
    }
);

has 'http_response' => (
    is => 'ro',
    isa => 'HTTP::Response',
    required => 1,
    handles => {
        code        => 'code',
        status_code => 'code',
        message     => 'content',
        value       => 'content',
        is_success  => 'is_success',
        is_error    => 'is_error',
        as_string   => 'as_string',
        header      => 'header',
        headers     => 'headers'
    }
);

$_deconstruct_parts = sub {
    my $message = shift;
    return () unless $message->content;
    my @parts = $message->parts;
    return $message unless @parts;
    return map { $_deconstruct_parts->( $_ ) } @parts;
};

__PACKAGE__->meta->make_immutable;
no Moose;

1;



=pod

=head1 NAME

Data::Riak::HTTP::Response

=head1 VERSION

version 1.0

=head1 AUTHOR

Andrew Nelson <anelson at cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Infinity Interactive.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
