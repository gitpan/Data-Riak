package Data::Riak::Request::ListBuckets;
{
  $Data::Riak::Request::ListBuckets::VERSION = '1.4';
}

use Moose;
use Data::Riak::Result::SingleJSONValue;
use namespace::autoclean;

sub as_http_request_args {
    my ($self) = @_;

    return {
        method => 'GET',
        uri    => '/buckets',
        query  => { buckets => 'true' },
        accept => 'application/json',
    };
}

with 'Data::Riak::Request';

has '+result_class' => (
    default => Data::Riak::Result::SingleJSONValue::,
);

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

Data::Riak::Request::ListBuckets

=head1 VERSION

version 1.4

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
