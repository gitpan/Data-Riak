package Data::Riak::Request::Ping;
{
  $Data::Riak::Request::Ping::VERSION = '1.5';
}

use Moose;
use Data::Riak::Result::SingleValue;
use namespace::autoclean;

sub as_http_request_args {
    my ($self) = @_;

    return {
        method => 'GET',
        uri    => 'ping',
    };
}

sub _build_http_exception_classes {
    return {
        500 => undef,
    };
}

with 'Data::Riak::Request',
     'Data::Riak::Request::WithHTTPExceptionHandling';

has '+result_class' => (
    default => Data::Riak::Result::SingleValue::,
);

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

Data::Riak::Request::Ping

=head1 VERSION

version 1.5

=head1 AUTHORS

=over 4

=item *

Andrew Nelson <anelson at cpan.org>

=item *

Florian Ragwitz <rafl@debian.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Infinity Interactive.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
