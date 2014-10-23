package Data::Riak::Async::Request::ListBuckets;
{
  $Data::Riak::Async::Request::ListBuckets::VERSION = '1.9';
}

use Moose;
use namespace::autoclean;

extends 'Data::Riak::Request::ListBuckets';
with 'Data::Riak::Async::Request';

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

Data::Riak::Async::Request::ListBuckets

=head1 VERSION

version 1.9

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
